
-- products
ALTER TABLE public.products
  ADD COLUMN IF NOT EXISTS quantity_pricing JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS size_options JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS color_options JSONB DEFAULT '[]'::jsonb;

-- order_items
ALTER TABLE public.order_items
  ADD COLUMN IF NOT EXISTS product_details TEXT;

-- orders: add total_amount synced with total
ALTER TABLE public.orders
  ADD COLUMN IF NOT EXISTS total_amount NUMERIC NOT NULL DEFAULT 0;

CREATE OR REPLACE FUNCTION public.sync_order_totals()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF NEW.total_amount IS DISTINCT FROM OLD.total_amount AND NEW.total IS NOT DISTINCT FROM OLD.total THEN
    NEW.total := NEW.total_amount;
  ELSIF NEW.total IS DISTINCT FROM OLD.total AND NEW.total_amount IS NOT DISTINCT FROM OLD.total_amount THEN
    NEW.total_amount := NEW.total;
  END IF;
  RETURN NEW;
END; $$;

CREATE OR REPLACE FUNCTION public.sync_order_totals_insert()
RETURNS TRIGGER LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  IF (NEW.total_amount IS NULL OR NEW.total_amount = 0) AND NEW.total IS NOT NULL THEN
    NEW.total_amount := NEW.total;
  ELSIF (NEW.total IS NULL OR NEW.total = 0) AND NEW.total_amount IS NOT NULL THEN
    NEW.total := NEW.total_amount;
  END IF;
  RETURN NEW;
END; $$;

DROP TRIGGER IF EXISTS trg_orders_sync_totals_ins ON public.orders;
CREATE TRIGGER trg_orders_sync_totals_ins BEFORE INSERT ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.sync_order_totals_insert();

DROP TRIGGER IF EXISTS trg_orders_sync_totals_upd ON public.orders;
CREATE TRIGGER trg_orders_sync_totals_upd BEFORE UPDATE ON public.orders
  FOR EACH ROW EXECUTE FUNCTION public.sync_order_totals();

-- returns
ALTER TABLE public.returns
  ADD COLUMN IF NOT EXISTS delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS return_amount NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS returned_items JSONB DEFAULT '[]'::jsonb;

-- backfill returns.delivery_agent_id from agent_id
UPDATE public.returns SET delivery_agent_id = agent_id WHERE delivery_agent_id IS NULL AND agent_id IS NOT NULL;

-- agent_payments
ALTER TABLE public.agent_payments
  ADD COLUMN IF NOT EXISTS delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS payment_type TEXT DEFAULT 'payment';

UPDATE public.agent_payments SET delivery_agent_id = agent_id WHERE delivery_agent_id IS NULL AND agent_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_agent_payments_delivery_agent_id ON public.agent_payments(delivery_agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_payment_type ON public.agent_payments(payment_type);

-- agent_daily_closings
ALTER TABLE public.agent_daily_closings
  ADD COLUMN IF NOT EXISTS delivery_agent_id UUID REFERENCES public.delivery_agents(id) ON DELETE CASCADE;
UPDATE public.agent_daily_closings SET delivery_agent_id = agent_id WHERE delivery_agent_id IS NULL AND agent_id IS NOT NULL;

-- RPC for old logs cleanup
CREATE OR REPLACE FUNCTION public.delete_old_activity_logs()
RETURNS INTEGER LANGUAGE plpgsql SET search_path = public AS $$
DECLARE deleted_count INTEGER;
BEGIN
  DELETE FROM public.activity_logs WHERE created_at < now() - INTERVAL '30 days';
  GET DIAGNOSTICS deleted_count = ROW_COUNT;
  RETURN deleted_count;
END; $$;
GRANT EXECUTE ON FUNCTION public.delete_old_activity_logs() TO anon, authenticated, service_role;
