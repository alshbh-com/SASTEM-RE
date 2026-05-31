-- =====================================================
-- Reflect — Full Schema Bootstrap
-- =====================================================

-- helper: updated_at trigger
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;

-- =====================================================
-- 1. APP SETTINGS
-- =====================================================
CREATE TABLE public.app_settings (
  id TEXT PRIMARY KEY,
  platform_name TEXT DEFAULT 'Reflect',
  invoice_name TEXT DEFAULT 'Reflect',
  logo_url TEXT,
  watermark_name TEXT DEFAULT 'Reflect',
  active_theme TEXT DEFAULT 'classic-gold',
  active_template TEXT DEFAULT 'modern',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.app_settings TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.app_settings TO authenticated;
GRANT ALL ON public.app_settings TO service_role;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "app_settings_all_anon" ON public.app_settings FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "app_settings_all_auth" ON public.app_settings FOR ALL TO authenticated USING (true) WITH CHECK (true);

INSERT INTO public.app_settings (id, platform_name, invoice_name, watermark_name)
VALUES ('main', 'Reflect', 'Reflect', 'Reflect')
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- 2. SYSTEM PASSWORDS
-- =====================================================
CREATE TABLE public.system_passwords (
  id TEXT PRIMARY KEY,
  password TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.system_passwords TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.system_passwords TO authenticated;
GRANT ALL ON public.system_passwords TO service_role;
ALTER TABLE public.system_passwords ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sp_all_anon" ON public.system_passwords FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "sp_all_auth" ON public.system_passwords FOR ALL TO authenticated USING (true) WITH CHECK (true);

INSERT INTO public.system_passwords (id, password) VALUES
  ('master', '01278006248'),
  ('payment', '01278006248'),
  ('admin_delete', '01278006248');

-- =====================================================
-- 3. ADMIN USERS & PERMISSIONS
-- =====================================================
CREATE TABLE public.admin_users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.admin_users TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.admin_users TO authenticated;
GRANT ALL ON public.admin_users TO service_role;
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "au_all_anon" ON public.admin_users FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "au_all_auth" ON public.admin_users FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE TRIGGER trg_admin_users_updated BEFORE UPDATE ON public.admin_users
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.admin_user_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.admin_users(id) ON DELETE CASCADE,
  permission TEXT NOT NULL,
  permission_type TEXT NOT NULL DEFAULT 'view',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, permission)
);
GRANT SELECT ON public.admin_user_permissions TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.admin_user_permissions TO authenticated;
GRANT ALL ON public.admin_user_permissions TO service_role;
ALTER TABLE public.admin_user_permissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "aup_all_anon" ON public.admin_user_permissions FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "aup_all_auth" ON public.admin_user_permissions FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 4. ACTIVITY LOGS
-- =====================================================
CREATE TABLE public.activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  username TEXT,
  action TEXT NOT NULL,
  section TEXT,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.activity_logs TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.activity_logs TO authenticated;
GRANT ALL ON public.activity_logs TO service_role;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "al_all_anon" ON public.activity_logs FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "al_all_auth" ON public.activity_logs FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 5. GOVERNORATES & OFFICES
-- =====================================================
CREATE TABLE public.governorates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  shipping_cost NUMERIC NOT NULL DEFAULT 0,
  agent_shipping_cost NUMERIC DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.governorates TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.governorates TO authenticated;
GRANT ALL ON public.governorates TO service_role;
ALTER TABLE public.governorates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "g_all_anon" ON public.governorates FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "g_all_auth" ON public.governorates FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.offices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  logo_url TEXT,
  watermark_name TEXT,
  address TEXT,
  phone TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.offices TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.offices TO authenticated;
GRANT ALL ON public.offices TO service_role;
ALTER TABLE public.offices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "of_all_anon" ON public.offices FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "of_all_auth" ON public.offices FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 6. CATEGORIES
-- =====================================================
CREATE TABLE public.categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.categories TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.categories TO authenticated;
GRANT ALL ON public.categories TO service_role;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "c_all_anon" ON public.categories FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "c_all_auth" ON public.categories FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 7. PRODUCTS
-- =====================================================
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
  size_options JSONB,
  color_options JSONB,
  quantity_pricing JSONB,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.products TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.products TO authenticated;
GRANT ALL ON public.products TO service_role;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "p_all_anon" ON public.products FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "p_all_auth" ON public.products FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.product_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  image_url TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.product_images TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_images TO authenticated;
GRANT ALL ON public.product_images TO service_role;
ALTER TABLE public.product_images ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pi_all_anon" ON public.product_images FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "pi_all_auth" ON public.product_images FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.product_color_variants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id UUID NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
  color TEXT NOT NULL,
  image_url TEXT,
  stock INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.product_color_variants TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.product_color_variants TO authenticated;
GRANT ALL ON public.product_color_variants TO service_role;
ALTER TABLE public.product_color_variants ENABLE ROW LEVEL SECURITY;
CREATE POLICY "pcv_all_anon" ON public.product_color_variants FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "pcv_all_auth" ON public.product_color_variants FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 8. CUSTOMERS
-- =====================================================
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
GRANT SELECT ON public.customers TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.customers TO authenticated;
GRANT ALL ON public.customers TO service_role;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cu_all_anon" ON public.customers FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "cu_all_auth" ON public.customers FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 9. DELIVERY AGENTS
-- =====================================================
CREATE TABLE public.delivery_agents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  phone TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.delivery_agents TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.delivery_agents TO authenticated;
GRANT ALL ON public.delivery_agents TO service_role;
ALTER TABLE public.delivery_agents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "da_all_anon" ON public.delivery_agents FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "da_all_auth" ON public.delivery_agents FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 10. ORDERS
-- =====================================================
CREATE SEQUENCE IF NOT EXISTS public.orders_order_number_seq START 1000;

CREATE TABLE public.orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number BIGINT NOT NULL UNIQUE DEFAULT nextval('public.orders_order_number_seq'),
  tracking_code TEXT UNIQUE,
  barcode_value TEXT,
  qr_value TEXT,
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  governorate_id UUID REFERENCES public.governorates(id) ON DELETE SET NULL,
  office_id UUID REFERENCES public.offices(id) ON DELETE SET NULL,
  delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  total_amount NUMERIC NOT NULL DEFAULT 0,
  shipping_cost NUMERIC NOT NULL DEFAULT 0,
  agent_shipping_cost NUMERIC DEFAULT 0,
  discount NUMERIC DEFAULT 0,
  modified_amount NUMERIC DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'pending',
  notes TEXT,
  order_details TEXT,
  assigned_at TIMESTAMPTZ,
  payment_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.orders TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.orders TO authenticated;
GRANT ALL ON public.orders TO service_role;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "o_all_anon" ON public.orders FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "o_all_auth" ON public.orders FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Auto-generate tracking_code / barcode / qr
CREATE OR REPLACE FUNCTION public.fill_order_tracking()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF NEW.tracking_code IS NULL THEN
    NEW.tracking_code := 'TRK-' || lpad(NEW.order_number::TEXT, 6, '0');
  END IF;
  IF NEW.barcode_value IS NULL THEN
    NEW.barcode_value := NEW.tracking_code;
  END IF;
  IF NEW.qr_value IS NULL THEN
    NEW.qr_value := NEW.tracking_code;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_fill_tracking BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.fill_order_tracking();
CREATE TRIGGER trg_orders_updated BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- Auto-clear delivery_agent_id on revert to pending/processing
CREATE OR REPLACE FUNCTION public.orders_clear_agent_on_revert()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF NEW.status IN ('pending','processing') AND OLD.status NOT IN ('pending','processing') THEN
    NEW.delivery_agent_id := NULL;
    NEW.assigned_at := NULL;
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_revert_agent BEFORE UPDATE OF status ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.orders_clear_agent_on_revert();

-- =====================================================
-- 11. ORDER ITEMS
-- =====================================================
CREATE TABLE public.order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  price NUMERIC NOT NULL DEFAULT 0,
  size TEXT,
  color TEXT,
  product_details TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.order_items TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.order_items TO authenticated;
GRANT ALL ON public.order_items TO service_role;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "oi_all_anon" ON public.order_items FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "oi_all_auth" ON public.order_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 12. RETURNS
-- =====================================================
CREATE TABLE public.returns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  return_amount NUMERIC NOT NULL DEFAULT 0,
  returned_items JSONB,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.returns TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.returns TO authenticated;
GRANT ALL ON public.returns TO service_role;
ALTER TABLE public.returns ENABLE ROW LEVEL SECURITY;
CREATE POLICY "r_all_anon" ON public.returns FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "r_all_auth" ON public.returns FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 13. AGENT PAYMENTS & DAILY CLOSINGS
-- =====================================================
CREATE TABLE public.agent_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  amount NUMERIC NOT NULL DEFAULT 0,
  payment_type TEXT NOT NULL DEFAULT 'owed',
  payment_date DATE,
  payment_method TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.agent_payments TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_payments TO authenticated;
GRANT ALL ON public.agent_payments TO service_role;
ALTER TABLE public.agent_payments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ap_all_anon" ON public.agent_payments FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "ap_all_auth" ON public.agent_payments FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.agent_daily_closings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE CASCADE,
  closing_date DATE NOT NULL,
  net_amount NUMERIC NOT NULL DEFAULT 0,
  closed_by UUID,
  closed_by_username TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.agent_daily_closings TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.agent_daily_closings TO authenticated;
GRANT ALL ON public.agent_daily_closings TO service_role;
ALTER TABLE public.agent_daily_closings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "adc_all_anon" ON public.agent_daily_closings FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "adc_all_auth" ON public.agent_daily_closings FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Status-based auto agent payment management
CREATE OR REPLACE FUNCTION public.orders_sync_agent_payment()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
DECLARE
  v_owed NUMERIC;
BEGIN
  -- When transitioning OUT of delivered states, remove auto payments tied to this order
  IF (TG_OP = 'UPDATE') AND OLD.status IN ('delivered','delivered_with_modification')
     AND NEW.status NOT IN ('delivered','delivered_with_modification') THEN
    DELETE FROM public.agent_payments
     WHERE order_id = NEW.id AND payment_type IN ('owed','delivered','modification');
  END IF;

  -- When transitioning INTO delivered, insert owed payment if not exists
  IF NEW.delivery_agent_id IS NOT NULL
     AND NEW.status IN ('delivered','delivered_with_modification')
     AND (TG_OP = 'INSERT' OR OLD.status IS DISTINCT FROM NEW.status) THEN
    v_owed := COALESCE(NEW.total_amount,0) + COALESCE(NEW.shipping_cost,0) - COALESCE(NEW.agent_shipping_cost,0);
    IF NOT EXISTS (
      SELECT 1 FROM public.agent_payments
       WHERE order_id = NEW.id AND payment_type = 'owed'
    ) THEN
      INSERT INTO public.agent_payments (delivery_agent_id, order_id, amount, payment_type, payment_date)
      VALUES (NEW.delivery_agent_id, NEW.id, v_owed, 'owed', COALESCE(NEW.payment_date, CURRENT_DATE));
    END IF;
  END IF;

  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_sync_agent_payment
  AFTER INSERT OR UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.orders_sync_agent_payment();

-- =====================================================
-- 14. CASHBOX & TREASURY
-- =====================================================
CREATE TABLE public.cashbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  opening_balance NUMERIC NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.cashbox TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cashbox TO authenticated;
GRANT ALL ON public.cashbox TO service_role;
ALTER TABLE public.cashbox ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cb_all_anon" ON public.cashbox FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "cb_all_auth" ON public.cashbox FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.cashbox_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cashbox_id UUID NOT NULL REFERENCES public.cashbox(id) ON DELETE CASCADE,
  type TEXT NOT NULL,
  amount NUMERIC NOT NULL DEFAULT 0,
  reason TEXT,
  description TEXT,
  user_id UUID,
  username TEXT,
  payment_method TEXT DEFAULT 'cash',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.cashbox_transactions TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.cashbox_transactions TO authenticated;
GRANT ALL ON public.cashbox_transactions TO service_role;
ALTER TABLE public.cashbox_transactions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "cbt_all_anon" ON public.cashbox_transactions FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "cbt_all_auth" ON public.cashbox_transactions FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Auto-create daily zero-balance cashbox
CREATE OR REPLACE FUNCTION public.ensure_daily_cashbox()
RETURNS void LANGUAGE plpgsql SET search_path = public AS $$
DECLARE v_name TEXT;
BEGIN
  v_name := 'خزنة ' || to_char(CURRENT_DATE, 'YYYY-MM-DD');
  IF NOT EXISTS (SELECT 1 FROM public.cashbox WHERE name = v_name) THEN
    INSERT INTO public.cashbox (name, opening_balance) VALUES (v_name, 0);
  END IF;
END; $$;

CREATE TABLE public.treasury (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  type TEXT NOT NULL,
  amount NUMERIC NOT NULL DEFAULT 0,
  description TEXT,
  category TEXT,
  created_by UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.treasury TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.treasury TO authenticated;
GRANT ALL ON public.treasury TO service_role;
ALTER TABLE public.treasury ENABLE ROW LEVEL SECURITY;
CREATE POLICY "tr_all_anon" ON public.treasury FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "tr_all_auth" ON public.treasury FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 15. STATISTICS & ANALYTICS
-- =====================================================
CREATE TABLE public.statistics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  total_sales NUMERIC DEFAULT 0,
  total_orders INTEGER DEFAULT 0,
  last_reset TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.statistics TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.statistics TO authenticated;
GRANT ALL ON public.statistics TO service_role;
ALTER TABLE public.statistics ENABLE ROW LEVEL SECURITY;
CREATE POLICY "st_all_anon" ON public.statistics FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "st_all_auth" ON public.statistics FOR ALL TO authenticated USING (true) WITH CHECK (true);

INSERT INTO public.statistics (total_sales, total_orders) VALUES (0, 0);

CREATE TABLE public.analytics_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  event_type TEXT NOT NULL,
  product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
  metadata JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.analytics_events TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.analytics_events TO authenticated;
GRANT ALL ON public.analytics_events TO service_role;
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ae_all_anon" ON public.analytics_events FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "ae_all_auth" ON public.analytics_events FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 16. SCANNER (Barcode)
-- =====================================================
CREATE TABLE public.scan_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  username TEXT,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  ended_at TIMESTAMPTZ,
  total_scanned INTEGER DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'active'
);
GRANT SELECT ON public.scan_sessions TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_sessions TO authenticated;
GRANT ALL ON public.scan_sessions TO service_role;
ALTER TABLE public.scan_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ss_all_anon" ON public.scan_sessions FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "ss_all_auth" ON public.scan_sessions FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.scan_session_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.scan_sessions(id) ON DELETE CASCADE,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  scanned_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.scan_session_items TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_session_items TO authenticated;
GRANT ALL ON public.scan_session_items TO service_role;
ALTER TABLE public.scan_session_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "ssi_all_anon" ON public.scan_session_items FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "ssi_all_auth" ON public.scan_session_items FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE TABLE public.scan_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  username TEXT,
  session_id UUID REFERENCES public.scan_sessions(id) ON DELETE SET NULL,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  old_value TEXT,
  new_value TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.scan_logs TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.scan_logs TO authenticated;
GRANT ALL ON public.scan_logs TO service_role;
ALTER TABLE public.scan_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sl_all_anon" ON public.scan_logs FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "sl_all_auth" ON public.scan_logs FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- =====================================================
-- 17. ORDER STATUS HISTORY
-- =====================================================
CREATE TABLE public.order_status_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES public.orders(id) ON DELETE CASCADE,
  old_status TEXT,
  new_status TEXT NOT NULL,
  changed_by UUID,
  changed_by_username TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
GRANT SELECT ON public.order_status_history TO anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.order_status_history TO authenticated;
GRANT ALL ON public.order_status_history TO service_role;
ALTER TABLE public.order_status_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "osh_all_anon" ON public.order_status_history FOR ALL TO anon USING (true) WITH CHECK (true);
CREATE POLICY "osh_all_auth" ON public.order_status_history FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE OR REPLACE FUNCTION public.log_order_status_change()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF TG_OP = 'UPDATE' AND OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO public.order_status_history (order_id, old_status, new_status)
    VALUES (NEW.id, OLD.status, NEW.status);
  END IF;
  RETURN NEW;
END; $$;
CREATE TRIGGER trg_orders_status_history
  AFTER UPDATE OF status ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.log_order_status_change();

-- =====================================================
-- 18. STORAGE BUCKETS
-- =====================================================
INSERT INTO storage.buckets (id, name, public) VALUES
  ('products', 'products', true),
  ('logos', 'logos', true),
  ('categories', 'categories', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public_read_buckets" ON storage.objects FOR SELECT
  USING (bucket_id IN ('products','logos','categories'));
CREATE POLICY "anon_write_buckets" ON storage.objects FOR INSERT TO anon
  WITH CHECK (bucket_id IN ('products','logos','categories'));
CREATE POLICY "auth_write_buckets" ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (bucket_id IN ('products','logos','categories'));
CREATE POLICY "anon_update_buckets" ON storage.objects FOR UPDATE TO anon
  USING (bucket_id IN ('products','logos','categories'));
CREATE POLICY "auth_update_buckets" ON storage.objects FOR UPDATE TO authenticated
  USING (bucket_id IN ('products','logos','categories'));
CREATE POLICY "anon_delete_buckets" ON storage.objects FOR DELETE TO anon
  USING (bucket_id IN ('products','logos','categories'));
CREATE POLICY "auth_delete_buckets" ON storage.objects FOR DELETE TO authenticated
  USING (bucket_id IN ('products','logos','categories'));