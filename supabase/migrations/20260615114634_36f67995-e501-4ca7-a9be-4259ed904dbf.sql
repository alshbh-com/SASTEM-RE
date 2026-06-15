
-- =========================================================
-- DROP old CSV-imported tables
-- =========================================================
DROP TABLE IF EXISTS public."activity_logs_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."admin_user_permissions_rows.csv" CASCADE;
DROP TABLE IF EXISTS public.admin_users_rows CASCADE;
DROP TABLE IF EXISTS public."app_settings_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."cashbox_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."categories_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."customers_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."governorates_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."meta_settings_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."order_items_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."orders_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."products_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."scan_sessions_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."statistics_rows.csv" CASCADE;
DROP TABLE IF EXISTS public."system_passwords_rows.csv" CASCADE;

-- =========================================================
-- Helper function
-- =========================================================
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- =========================================================
-- 1. system_passwords
-- =========================================================
CREATE TABLE public.system_passwords (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  key TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.system_passwords TO anon, authenticated;
GRANT ALL ON public.system_passwords TO service_role;
ALTER TABLE public.system_passwords ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.system_passwords FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 2. admin_users
-- =========================================================
CREATE TABLE public.admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.admin_users TO anon, authenticated;
GRANT ALL ON public.admin_users TO service_role;
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.admin_users FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_admin_users_uat BEFORE UPDATE ON public.admin_users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 3. admin_user_permissions
-- =========================================================
CREATE TABLE public.admin_user_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.admin_users(id) ON DELETE CASCADE,
  permission TEXT NOT NULL,
  permission_type TEXT NOT NULL DEFAULT 'view',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, permission)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.admin_user_permissions TO anon, authenticated;
GRANT ALL ON public.admin_user_permissions TO service_role;
ALTER TABLE public.admin_user_permissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.admin_user_permissions FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_admin_user_permissions_user_id ON public.admin_user_permissions(user_id);

-- =========================================================
-- 4. app_settings (singleton)
-- =========================================================
CREATE TABLE public.app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  platform_name TEXT NOT NULL DEFAULT 'Reflect',
  invoice_name TEXT DEFAULT 'Reflect',
  logo_url TEXT,
  watermark_name TEXT DEFAULT 'Reflect',
  active_theme TEXT DEFAULT 'default',
  active_template TEXT DEFAULT 'grid-4',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.app_settings TO anon, authenticated;
GRANT ALL ON public.app_settings TO service_role;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.app_settings FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_app_settings_uat BEFORE UPDATE ON public.app_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 5. activity_logs
-- =========================================================
CREATE TABLE public.activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  username TEXT,
  action TEXT NOT NULL,
  section TEXT,
  details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.activity_logs TO anon, authenticated;
GRANT ALL ON public.activity_logs TO service_role;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.activity_logs FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_activity_logs_created_at ON public.activity_logs(created_at DESC);

-- =========================================================
-- 6. analytics_events
-- =========================================================
CREATE TABLE public.analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  data JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.analytics_events TO anon, authenticated;
GRANT ALL ON public.analytics_events TO service_role;
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.analytics_events FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 7. statistics
-- =========================================================
CREATE TABLE public.statistics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  period TEXT,
  metric TEXT,
  value NUMERIC DEFAULT 0,
  data JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.statistics TO anon, authenticated;
GRANT ALL ON public.statistics TO service_role;
ALTER TABLE public.statistics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.statistics FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 8. governorates
-- =========================================================
CREATE TABLE public.governorates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  shipping_cost NUMERIC NOT NULL DEFAULT 0,
  agent_shipping_cost NUMERIC NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.governorates TO anon, authenticated;
GRANT ALL ON public.governorates TO service_role;
ALTER TABLE public.governorates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.governorates FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_governorates_uat BEFORE UPDATE ON public.governorates FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 9. offices
-- =========================================================
CREATE TABLE public.offices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  logo_url TEXT,
  watermark_url TEXT,
  address TEXT,
  phone TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_default BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.offices TO anon, authenticated;
GRANT ALL ON public.offices TO service_role;
ALTER TABLE public.offices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.offices FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_offices_uat BEFORE UPDATE ON public.offices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 10. categories
-- =========================================================
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.categories TO anon, authenticated;
GRANT ALL ON public.categories TO service_role;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.categories FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_categories_uat BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 11. products
-- =========================================================
CREATE TABLE public.products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  details TEXT,
  price NUMERIC NOT NULL DEFAULT 0,
  offer_price NUMERIC,
  is_offer BOOLEAN NOT NULL DEFAULT false,
  stock INTEGER NOT NULL DEFAULT 0,
  image_url TEXT,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
  price_2 NUMERIC, price_3 NUMERIC, price_4 NUMERIC, price_5 NUMERIC,
  price_6 NUMERIC, price_7 NUMERIC, price_8 NUMERIC, price_9 NUMERIC,
  price_10 NUMERIC, price_11 NUMERIC, price_12 NUMERIC,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.products TO anon, authenticated;
GRANT ALL ON public.products TO service_role;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.products FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_products_uat BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_products_category_id ON public.products(category_id);

-- =========================================================
-- 12. product_images
-- =========================================================
CREATE TABLE public.product_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_images TO anon, authenticated;
GRANT ALL ON public.product_images TO service_role;
ALTER TABLE public.product_images ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.product_images FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_product_images_product_id ON public.product_images(product_id);

-- =========================================================
-- 13. product_color_variants
-- =========================================================
CREATE TABLE public.product_color_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  color TEXT NOT NULL,
  color_hex TEXT,
  image_url TEXT,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_color_variants TO anon, authenticated;
GRANT ALL ON public.product_color_variants TO service_role;
ALTER TABLE public.product_color_variants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.product_color_variants FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_pcv_product_id ON public.product_color_variants(product_id);

-- =========================================================
-- 14. customers
-- =========================================================
CREATE TABLE public.customers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  phone TEXT NOT NULL UNIQUE,
  phone2 TEXT,
  address TEXT,
  governorate TEXT,
  governorate_id UUID REFERENCES public.governorates(id) ON DELETE SET NULL,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customers TO anon, authenticated;
GRANT ALL ON public.customers TO service_role;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.customers FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_customers_uat BEFORE UPDATE ON public.customers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 15. delivery_agents
-- =========================================================
CREATE TABLE public.delivery_agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  phone TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.delivery_agents TO anon, authenticated;
GRANT ALL ON public.delivery_agents TO service_role;
ALTER TABLE public.delivery_agents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.delivery_agents FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_delivery_agents_uat BEFORE UPDATE ON public.delivery_agents FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 16. orders
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS public.order_number_seq START 1000;

CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number TEXT UNIQUE,
  tracking_code TEXT UNIQUE,
  barcode_value TEXT UNIQUE,
  qr_value TEXT,
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  customer_name TEXT,
  customer_phone TEXT,
  customer_phone2 TEXT,
  customer_address TEXT,
  customer_governorate TEXT,
  governorate_id UUID REFERENCES public.governorates(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'Pending',
  subtotal NUMERIC NOT NULL DEFAULT 0,
  shipping_cost NUMERIC NOT NULL DEFAULT 0,
  agent_shipping_cost NUMERIC NOT NULL DEFAULT 0,
  total NUMERIC NOT NULL DEFAULT 0,
  delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  assigned_at TIMESTAMPTZ,
  payment_date TIMESTAMPTZ,
  office_id UUID REFERENCES public.offices(id) ON DELETE SET NULL,
  notes TEXT,
  agent_deleted BOOLEAN NOT NULL DEFAULT false,
  payment_method TEXT DEFAULT 'cash',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.orders TO anon, authenticated;
GRANT ALL ON public.orders TO service_role;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.orders FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_orders_uat BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE INDEX idx_orders_status ON public.orders(status);
CREATE INDEX idx_orders_agent_id ON public.orders(delivery_agent_id);
CREATE INDEX idx_orders_customer_id ON public.orders(customer_id);
CREATE INDEX idx_orders_assigned_at ON public.orders(assigned_at);

-- Auto-generate order_number/tracking/barcode
CREATE OR REPLACE FUNCTION public.generate_order_codes()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
DECLARE n BIGINT;
BEGIN
  IF NEW.order_number IS NULL OR NEW.tracking_code IS NULL OR NEW.barcode_value IS NULL THEN
    n := nextval('public.order_number_seq');
    IF NEW.order_number IS NULL THEN NEW.order_number := 'ORD-' || lpad(n::text, 6, '0'); END IF;
    IF NEW.tracking_code IS NULL THEN NEW.tracking_code := 'TRK' || lpad(n::text, 8, '0'); END IF;
    IF NEW.barcode_value IS NULL THEN NEW.barcode_value := lpad(n::text, 10, '0'); END IF;
    IF NEW.qr_value IS NULL THEN NEW.qr_value := NEW.tracking_code; END IF;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_codes BEFORE INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.generate_order_codes();

-- Auto-clear delivery_agent on revert to Pending/Processing
CREATE OR REPLACE FUNCTION public.clear_agent_on_revert()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF NEW.status IN ('Pending','Processing','قيد الانتظار','قيد المعالجة') AND OLD.status <> NEW.status THEN
    NEW.delivery_agent_id := NULL;
    NEW.assigned_at := NULL;
    NEW.payment_date := NULL;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_clear_agent BEFORE UPDATE OF status ON public.orders FOR EACH ROW EXECUTE FUNCTION public.clear_agent_on_revert();

-- =========================================================
-- 17. order_items
-- =========================================================
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
  product_name TEXT NOT NULL,
  price NUMERIC NOT NULL DEFAULT 0,
  quantity INTEGER NOT NULL DEFAULT 1,
  size TEXT,
  color TEXT,
  variant_id UUID,
  image_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.order_items TO anon, authenticated;
GRANT ALL ON public.order_items TO service_role;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.order_items FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);

-- =========================================================
-- 18. returns
-- =========================================================
CREATE TABLE public.returns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  reason TEXT,
  amount NUMERIC DEFAULT 0,
  returned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.returns TO anon, authenticated;
GRANT ALL ON public.returns TO service_role;
ALTER TABLE public.returns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.returns FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 19. agent_payments
-- =========================================================
CREATE TABLE public.agent_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL DEFAULT 0,
  agent_shipping_cost NUMERIC DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'cash',
  status TEXT DEFAULT 'pending',
  payment_date TIMESTAMPTZ DEFAULT now(),
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_payments TO anon, authenticated;
GRANT ALL ON public.agent_payments TO service_role;
ALTER TABLE public.agent_payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.agent_payments FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_agent_payments_agent_id ON public.agent_payments(agent_id);
CREATE INDEX idx_agent_payments_order_id ON public.agent_payments(order_id);

-- Auto-delete agent_payments when order status reverts
CREATE OR REPLACE FUNCTION public.handle_order_status_payments()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF OLD.status <> NEW.status AND NEW.status IN ('Pending','Processing','قيد الانتظار','قيد المعالجة') THEN
    DELETE FROM public.agent_payments WHERE order_id = NEW.id;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_handle_payments AFTER UPDATE OF status ON public.orders FOR EACH ROW EXECUTE FUNCTION public.handle_order_status_payments();

-- =========================================================
-- 20. agent_daily_closings
-- =========================================================
CREATE TABLE public.agent_daily_closings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agent_id UUID NOT NULL REFERENCES public.delivery_agents(id) ON DELETE CASCADE,
  closing_date DATE NOT NULL DEFAULT CURRENT_DATE,
  total_collected NUMERIC DEFAULT 0,
  total_paid NUMERIC DEFAULT 0,
  balance NUMERIC DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(agent_id, closing_date)
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_daily_closings TO anon, authenticated;
GRANT ALL ON public.agent_daily_closings TO service_role;
ALTER TABLE public.agent_daily_closings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.agent_daily_closings FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 21. cashbox
-- =========================================================
CREATE TABLE public.cashbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  opening_balance NUMERIC NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by TEXT,
  cashbox_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cashbox TO anon, authenticated;
GRANT ALL ON public.cashbox TO service_role;
ALTER TABLE public.cashbox ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.cashbox FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_cashbox_uat BEFORE UPDATE ON public.cashbox FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 22. cashbox_transactions
-- =========================================================
CREATE TABLE public.cashbox_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cashbox_id UUID REFERENCES public.cashbox(id) ON DELETE CASCADE,
  amount NUMERIC NOT NULL DEFAULT 0,
  type TEXT NOT NULL DEFAULT 'income',
  payment_method TEXT NOT NULL DEFAULT 'cash',
  description TEXT,
  reference_type TEXT,
  reference_id UUID,
  created_by TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cashbox_transactions TO anon, authenticated;
GRANT ALL ON public.cashbox_transactions TO service_role;
ALTER TABLE public.cashbox_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.cashbox_transactions FOR ALL USING (true) WITH CHECK (true);
CREATE INDEX idx_cashbox_tx_cashbox_id ON public.cashbox_transactions(cashbox_id);

-- =========================================================
-- 23. treasury
-- =========================================================
CREATE TABLE public.treasury (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL DEFAULT 'الخزينة الرئيسية',
  balance NUMERIC NOT NULL DEFAULT 0,
  office_id UUID REFERENCES public.offices(id) ON DELETE SET NULL,
  last_updated TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.treasury TO anon, authenticated;
GRANT ALL ON public.treasury TO service_role;
ALTER TABLE public.treasury ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.treasury FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_treasury_uat BEFORE UPDATE ON public.treasury FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 24. scan_sessions
-- =========================================================
CREATE TABLE public.scan_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_name TEXT,
  created_by TEXT,
  total_scanned INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_sessions TO anon, authenticated;
GRANT ALL ON public.scan_sessions TO service_role;
ALTER TABLE public.scan_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.scan_sessions FOR ALL USING (true) WITH CHECK (true);
CREATE TRIGGER trg_scan_sessions_uat BEFORE UPDATE ON public.scan_sessions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =========================================================
-- 25. scan_session_items
-- =========================================================
CREATE TABLE public.scan_session_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.scan_sessions(id) ON DELETE CASCADE,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  barcode_value TEXT,
  scanned_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_session_items TO anon, authenticated;
GRANT ALL ON public.scan_session_items TO service_role;
ALTER TABLE public.scan_session_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.scan_session_items FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- 26. scan_logs
-- =========================================================
CREATE TABLE public.scan_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES public.scan_sessions(id) ON DELETE SET NULL,
  user_id UUID,
  username TEXT,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  barcode_value TEXT,
  action TEXT,
  new_value TEXT,
  result TEXT,
  scanned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_logs TO anon, authenticated;
GRANT ALL ON public.scan_logs TO service_role;
ALTER TABLE public.scan_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_all" ON public.scan_logs FOR ALL USING (true) WITH CHECK (true);

-- =========================================================
-- SEED initial data
-- =========================================================
INSERT INTO public.system_passwords (key, password) VALUES
  ('master','01278006248'),
  ('payment','01278006248'),
  ('admin_delete','01278006248')
ON CONFLICT (key) DO NOTHING;

INSERT INTO public.app_settings (platform_name, invoice_name, watermark_name, active_theme, active_template)
VALUES ('Reflect','Reflect','Reflect','default','grid-4');

INSERT INTO public.offices (name, is_default, is_active) VALUES ('Reflect المكتب الرئيسي', true, true);

INSERT INTO public.treasury (name, balance) VALUES ('الخزينة الرئيسية', 0);

-- Master admin user (password 01278006248) with full permissions
DO $$
DECLARE master_id UUID;
DECLARE perm TEXT;
BEGIN
  INSERT INTO public.admin_users (username, password, is_active)
  VALUES ('admin','01278006248', true)
  RETURNING id INTO master_id;

  FOREACH perm IN ARRAY ARRAY[
    'orders','products','categories','customers','agents','agent_orders','agent_payments',
    'governorates','statistics','invoices','all_orders','settings','reset_data',
    'user_management','cashbox','treasury','barcode_scanner','offices','appearance','activity_logs'
  ] LOOP
    INSERT INTO public.admin_user_permissions (user_id, permission, permission_type)
    VALUES (master_id, perm, 'edit');
  END LOOP;
END $$;
