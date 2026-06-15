CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.generate_order_codes()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
DECLARE
  n bigint;
BEGIN
  IF NEW.order_number IS NULL OR NEW.tracking_code IS NULL OR NEW.barcode_value IS NULL THEN
    n := nextval('public.order_number_seq');
    IF NEW.order_number IS NULL THEN
      NEW.order_number := 'ORD-' || lpad(n::text, 6, '0');
    END IF;
    IF NEW.tracking_code IS NULL THEN
      NEW.tracking_code := 'TRK' || lpad(n::text, 8, '0');
    END IF;
    IF NEW.barcode_value IS NULL THEN
      NEW.barcode_value := lpad(n::text, 10, '0');
    END IF;
    IF NEW.qr_value IS NULL THEN
      NEW.qr_value := NEW.tracking_code;
    END IF;
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.sync_order_totals_insert()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
BEGIN
  IF (NEW.total_amount IS NULL OR NEW.total_amount = 0) AND NEW.total IS NOT NULL THEN
    NEW.total_amount := NEW.total;
  ELSIF (NEW.total IS NULL OR NEW.total = 0) AND NEW.total_amount IS NOT NULL THEN
    NEW.total := NEW.total_amount;
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.sync_order_totals()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
BEGIN
  IF NEW.total_amount IS DISTINCT FROM OLD.total_amount AND NEW.total IS NOT DISTINCT FROM OLD.total THEN
    NEW.total := NEW.total_amount;
  ELSIF NEW.total IS DISTINCT FROM OLD.total AND NEW.total_amount IS NOT DISTINCT FROM OLD.total_amount THEN
    NEW.total_amount := NEW.total;
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.clear_agent_on_revert()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
BEGIN
  IF NEW.status IN ('Pending','Processing','pending','processing','قيد الانتظار','قيد المعالجة') AND OLD.status IS DISTINCT FROM NEW.status THEN
    NEW.delivery_agent_id := NULL;
    NEW.assigned_at := NULL;
    NEW.payment_date := NULL;
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_order_status_payments()
RETURNS trigger
LANGUAGE plpgsql
SET search_path TO 'public'
AS $function$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status AND NEW.status IN ('Pending','Processing','pending','processing','قيد الانتظار','قيد المعالجة') THEN
    DELETE FROM public.agent_payments WHERE order_id = NEW.id;
  END IF;
  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.set_order_shipping_cost_from_governorate()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  gov_customer_shipping_cost numeric;
  gov_agent_shipping_cost numeric;
BEGIN
  IF NEW.governorate_id IS NULL AND NEW.customer_id IS NOT NULL THEN
    SELECT c.governorate_id INTO NEW.governorate_id
    FROM public.customers c
    WHERE c.id = NEW.customer_id
    LIMIT 1;
  END IF;

  IF NEW.governorate_id IS NULL AND NEW.customer_id IS NOT NULL THEN
    SELECT g.id INTO NEW.governorate_id
    FROM public.customers c
    JOIN public.governorates g ON g.name = c.governorate
    WHERE c.id = NEW.customer_id
    LIMIT 1;
  END IF;

  IF NEW.governorate_id IS NOT NULL THEN
    SELECT shipping_cost, agent_shipping_cost
    INTO gov_customer_shipping_cost, gov_agent_shipping_cost
    FROM public.governorates
    WHERE id = NEW.governorate_id;

    IF (NEW.shipping_cost IS NULL OR NEW.shipping_cost = 0) AND gov_customer_shipping_cost IS NOT NULL THEN
      NEW.shipping_cost := gov_customer_shipping_cost;
    END IF;

    IF (NEW.agent_shipping_cost IS NULL OR NEW.agent_shipping_cost = 0) AND gov_agent_shipping_cost IS NOT NULL THEN
      NEW.agent_shipping_cost := gov_agent_shipping_cost;
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_order_agent_assignment()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  gov_agent_shipping_cost numeric;
  final_agent_shipping_cost numeric;
  order_amount numeric;
  accounting_date timestamptz;
BEGIN
  IF NEW.delivery_agent_id IS NOT NULL AND OLD.delivery_agent_id IS DISTINCT FROM NEW.delivery_agent_id THEN
    IF NEW.assigned_at IS NULL THEN
      NEW.assigned_at := now();
    END IF;

    IF COALESCE(NEW.agent_shipping_cost, 0) = 0 AND NEW.governorate_id IS NOT NULL THEN
      SELECT agent_shipping_cost INTO gov_agent_shipping_cost
      FROM public.governorates
      WHERE id = NEW.governorate_id;
      IF gov_agent_shipping_cost IS NOT NULL THEN
        NEW.agent_shipping_cost := gov_agent_shipping_cost;
      END IF;
    END IF;

    final_agent_shipping_cost := COALESCE(NEW.agent_shipping_cost, 0);
    order_amount := COALESCE(NEW.total_amount, NEW.total, 0) + COALESCE(NEW.shipping_cost, 0) - final_agent_shipping_cost;
    accounting_date := COALESCE(NEW.assigned_at, now());

    DELETE FROM public.agent_payments
    WHERE order_id = NEW.id
      AND payment_type = 'owed'
      AND delivery_agent_id IS DISTINCT FROM NEW.delivery_agent_id;

    IF NOT EXISTS (
      SELECT 1 FROM public.agent_payments
      WHERE order_id = NEW.id AND delivery_agent_id = NEW.delivery_agent_id AND payment_type = 'owed'
    ) THEN
      INSERT INTO public.agent_payments (delivery_agent_id, agent_id, order_id, amount, payment_type, payment_date, notes)
      VALUES (
        NEW.delivery_agent_id,
        NEW.delivery_agent_id,
        NEW.id,
        order_amount,
        'owed',
        accounting_date,
        'تعيين طلب رقم ' || COALESCE(NEW.order_number::text, NEW.id::text)
      );
    END IF;

    UPDATE public.delivery_agents
    SET total_owed = COALESCE(total_owed, 0) + order_amount
    WHERE id = NEW.delivery_agent_id;

    IF NEW.status IN ('pending','processing','Pending','Processing','قيد الانتظار','قيد المعالجة') THEN
      NEW.status := 'shipped';
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_order_status_change()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  order_amount numeric;
  accounting_date timestamptz;
BEGIN
  order_amount := COALESCE(NEW.total_amount, NEW.total, 0) + COALESCE(NEW.shipping_cost, 0) - COALESCE(NEW.agent_shipping_cost, 0);
  accounting_date := COALESCE(NEW.payment_date, NEW.assigned_at, OLD.assigned_at, NEW.created_at, now());

  IF NEW.status = 'delivered' AND OLD.status IS DISTINCT FROM 'delivered' AND NEW.delivery_agent_id IS NOT NULL THEN
    NEW.payment_date := accounting_date;

    IF NOT EXISTS (
      SELECT 1 FROM public.agent_payments
      WHERE order_id = NEW.id AND delivery_agent_id = NEW.delivery_agent_id AND payment_type = 'delivered'
    ) THEN
      INSERT INTO public.agent_payments (delivery_agent_id, agent_id, order_id, amount, payment_type, payment_date, notes)
      VALUES (
        NEW.delivery_agent_id,
        NEW.delivery_agent_id,
        NEW.id,
        order_amount,
        'delivered',
        accounting_date,
        'طلب مسلم رقم ' || COALESCE(NEW.order_number::text, NEW.id::text)
      );
    END IF;
  END IF;

  IF OLD.status = 'delivered' AND NEW.status IS DISTINCT FROM 'delivered' AND OLD.delivery_agent_id IS NOT NULL THEN
    DELETE FROM public.agent_payments
    WHERE order_id = NEW.id AND delivery_agent_id = OLD.delivery_agent_id AND payment_type = 'delivered';
  END IF;

  IF OLD.status IN ('shipped','delivered') AND NEW.status NOT IN ('shipped','delivered') AND OLD.delivery_agent_id IS NOT NULL THEN
    DELETE FROM public.agent_payments
    WHERE order_id = NEW.id AND delivery_agent_id = OLD.delivery_agent_id AND payment_type IN ('owed','delivered','modification','return');

    UPDATE public.delivery_agents
    SET total_owed = GREATEST(COALESCE(total_owed, 0) - order_amount, 0)
    WHERE id = OLD.delivery_agent_id;

    NEW.delivery_agent_id := NULL;
    NEW.assigned_at := NULL;
    NEW.payment_date := NULL;
  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_order_amount_modification()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  old_order_amount numeric;
  new_order_amount numeric;
  amount_difference numeric;
  accounting_date timestamptz;
BEGIN
  IF NEW.delivery_agent_id IS NOT NULL
     AND OLD.delivery_agent_id IS NOT NULL
     AND OLD.status IN ('shipped', 'delivered') THEN

    old_order_amount := COALESCE(OLD.total_amount, OLD.total, 0) + COALESCE(OLD.shipping_cost, 0) - COALESCE(OLD.agent_shipping_cost, 0);
    new_order_amount := COALESCE(NEW.total_amount, NEW.total, 0) + COALESCE(NEW.shipping_cost, 0) - COALESCE(NEW.agent_shipping_cost, 0);

    IF old_order_amount IS DISTINCT FROM new_order_amount THEN
      accounting_date := COALESCE(OLD.assigned_at, NEW.assigned_at, OLD.created_at, now());
      amount_difference := new_order_amount - old_order_amount;

      UPDATE public.delivery_agents
      SET total_owed = COALESCE(total_owed, 0) + amount_difference
      WHERE id = NEW.delivery_agent_id;

      INSERT INTO public.agent_payments (delivery_agent_id, agent_id, order_id, amount, payment_type, payment_date, notes)
      VALUES (
        NEW.delivery_agent_id,
        NEW.delivery_agent_id,
        NEW.id,
        amount_difference,
        'modification',
        accounting_date,
        'تعديل طلب رقم ' || COALESCE(NEW.order_number::text, NEW.id::text)
      );
    END IF;
  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.handle_return_creation()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
DECLARE
  order_agent_id uuid;
  order_assigned_at timestamptz;
  final_return_amount numeric;
BEGIN
  final_return_amount := COALESCE(NEW.return_amount, NEW.amount, 0);

  SELECT o.delivery_agent_id, o.assigned_at
  INTO order_agent_id, order_assigned_at
  FROM public.orders o
  WHERE o.id = NEW.order_id;

  IF NEW.delivery_agent_id IS NULL THEN
    NEW.delivery_agent_id := order_agent_id;
  END IF;

  IF NEW.agent_id IS NULL THEN
    NEW.agent_id := COALESCE(NEW.delivery_agent_id, order_agent_id);
  END IF;

  IF NEW.return_amount IS NULL THEN
    NEW.return_amount := final_return_amount;
  END IF;

  IF NEW.amount IS NULL THEN
    NEW.amount := final_return_amount;
  END IF;

  IF COALESCE(NEW.delivery_agent_id, order_agent_id) IS NOT NULL AND final_return_amount <> 0 THEN
    UPDATE public.delivery_agents
    SET total_owed = COALESCE(total_owed, 0) - final_return_amount
    WHERE id = COALESCE(NEW.delivery_agent_id, order_agent_id);

    INSERT INTO public.agent_payments (delivery_agent_id, agent_id, order_id, amount, payment_type, payment_date, notes)
    VALUES (
      COALESCE(NEW.delivery_agent_id, order_agent_id),
      COALESCE(NEW.delivery_agent_id, order_agent_id),
      NEW.order_id,
      -final_return_amount,
      'return',
      COALESCE(order_assigned_at, now()),
      'مرتجع - طلب رقم ' || NEW.order_id::text
    );
  END IF;

  RETURN NEW;
END;
$function$;

CREATE OR REPLACE FUNCTION public.mark_agent_deleted_on_delete()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path TO 'public'
AS $function$
BEGIN
  UPDATE public.orders
  SET agent_deleted = true,
      delivery_agent_id = NULL
  WHERE delivery_agent_id = OLD.id;

  RETURN OLD;
END;
$function$;

DROP TRIGGER IF EXISTS update_admin_users_updated_at ON public.admin_users;
CREATE TRIGGER update_admin_users_updated_at
BEFORE UPDATE ON public.admin_users
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_app_settings_updated_at ON public.app_settings;
CREATE TRIGGER update_app_settings_updated_at
BEFORE UPDATE ON public.app_settings
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_cashbox_updated_at ON public.cashbox;
CREATE TRIGGER update_cashbox_updated_at
BEFORE UPDATE ON public.cashbox
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_categories_updated_at ON public.categories;
CREATE TRIGGER update_categories_updated_at
BEFORE UPDATE ON public.categories
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_customers_updated_at ON public.customers;
CREATE TRIGGER update_customers_updated_at
BEFORE UPDATE ON public.customers
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_delivery_agents_updated_at ON public.delivery_agents;
CREATE TRIGGER update_delivery_agents_updated_at
BEFORE UPDATE ON public.delivery_agents
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_governorates_updated_at ON public.governorates;
CREATE TRIGGER update_governorates_updated_at
BEFORE UPDATE ON public.governorates
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_offices_updated_at ON public.offices;
CREATE TRIGGER update_offices_updated_at
BEFORE UPDATE ON public.offices
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_orders_updated_at ON public.orders;
CREATE TRIGGER update_orders_updated_at
BEFORE UPDATE ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_products_updated_at ON public.products;
CREATE TRIGGER update_products_updated_at
BEFORE UPDATE ON public.products
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_scan_sessions_updated_at ON public.scan_sessions;
CREATE TRIGGER update_scan_sessions_updated_at
BEFORE UPDATE ON public.scan_sessions
FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS trg_orders_generate_codes ON public.orders;
CREATE TRIGGER trg_orders_generate_codes
BEFORE INSERT ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.generate_order_codes();

DROP TRIGGER IF EXISTS trg_orders_sync_totals_insert ON public.orders;
CREATE TRIGGER trg_orders_sync_totals_insert
BEFORE INSERT ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.sync_order_totals_insert();

DROP TRIGGER IF EXISTS trg_orders_sync_totals_update ON public.orders;
CREATE TRIGGER trg_orders_sync_totals_update
BEFORE UPDATE OF total, total_amount ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.sync_order_totals();

DROP TRIGGER IF EXISTS trg_orders_set_shipping_cost ON public.orders;
CREATE TRIGGER trg_orders_set_shipping_cost
BEFORE INSERT OR UPDATE OF governorate_id, customer_id, shipping_cost, agent_shipping_cost
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.set_order_shipping_cost_from_governorate();

DROP TRIGGER IF EXISTS trg_order_agent_assignment ON public.orders;
CREATE TRIGGER trg_order_agent_assignment
BEFORE UPDATE OF delivery_agent_id
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.handle_order_agent_assignment();

DROP TRIGGER IF EXISTS trg_order_status_change ON public.orders;
CREATE TRIGGER trg_order_status_change
BEFORE UPDATE OF status
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.handle_order_status_change();

DROP TRIGGER IF EXISTS trg_order_amount_modification ON public.orders;
CREATE TRIGGER trg_order_amount_modification
BEFORE UPDATE OF total_amount, total, shipping_cost, agent_shipping_cost
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.handle_order_amount_modification();

DROP TRIGGER IF EXISTS trg_clear_agent_on_revert ON public.orders;
CREATE TRIGGER trg_clear_agent_on_revert
BEFORE UPDATE OF status
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.clear_agent_on_revert();

DROP TRIGGER IF EXISTS trg_order_status_payments ON public.orders;
CREATE TRIGGER trg_order_status_payments
BEFORE UPDATE OF status
ON public.orders
FOR EACH ROW EXECUTE FUNCTION public.handle_order_status_payments();

DROP TRIGGER IF EXISTS trg_return_creation ON public.returns;
CREATE TRIGGER trg_return_creation
BEFORE INSERT ON public.returns
FOR EACH ROW EXECUTE FUNCTION public.handle_return_creation();

DROP TRIGGER IF EXISTS trg_mark_agent_deleted ON public.delivery_agents;
CREATE TRIGGER trg_mark_agent_deleted
BEFORE DELETE ON public.delivery_agents
FOR EACH ROW EXECUTE FUNCTION public.mark_agent_deleted_on_delete();

CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON public.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_delivery_agent_id ON public.orders(delivery_agent_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_assigned_at ON public.orders(assigned_at);
CREATE INDEX IF NOT EXISTS idx_orders_payment_date ON public.orders(payment_date);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_tracking_code ON public.orders(tracking_code);
CREATE INDEX IF NOT EXISTS idx_orders_barcode_value ON public.orders(barcode_value);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON public.order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_product_images_product_id ON public.product_images(product_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_delivery_agent_id ON public.agent_payments(delivery_agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_order_id ON public.agent_payments(order_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_payment_date ON public.agent_payments(payment_date);
CREATE INDEX IF NOT EXISTS idx_returns_order_id ON public.returns(order_id);
CREATE INDEX IF NOT EXISTS idx_returns_delivery_agent_id ON public.returns(delivery_agent_id);