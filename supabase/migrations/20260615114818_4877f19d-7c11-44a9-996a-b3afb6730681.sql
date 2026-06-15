
-- scan_sessions
ALTER TABLE public.scan_sessions
  ADD COLUMN IF NOT EXISTS user_id UUID,
  ADD COLUMN IF NOT EXISTS username TEXT;

-- cashbox_transactions
ALTER TABLE public.cashbox_transactions
  ADD COLUMN IF NOT EXISTS user_id UUID,
  ADD COLUMN IF NOT EXISTS username TEXT,
  ADD COLUMN IF NOT EXISTS reason TEXT;

-- orders
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS order_details TEXT;

-- returns
ALTER TABLE public.returns
  ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS notes TEXT;

-- offices
ALTER TABLE public.offices ADD COLUMN IF NOT EXISTS watermark_name TEXT;
UPDATE public.offices SET watermark_name = name WHERE watermark_name IS NULL;

-- analytics_events
ALTER TABLE public.analytics_events
  ADD COLUMN IF NOT EXISTS product_id UUID,
  ADD COLUMN IF NOT EXISTS quantity INTEGER;

-- statistics
ALTER TABLE public.statistics
  ADD COLUMN IF NOT EXISTS total_sales NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_orders INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_reset TIMESTAMPTZ;

-- treasury as transactions log
ALTER TABLE public.treasury
  ADD COLUMN IF NOT EXISTS type TEXT,
  ADD COLUMN IF NOT EXISTS amount NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS description TEXT,
  ADD COLUMN IF NOT EXISTS user_id UUID,
  ADD COLUMN IF NOT EXISTS username TEXT;

-- agent_daily_closings
ALTER TABLE public.agent_daily_closings
  ADD COLUMN IF NOT EXISTS closed_by TEXT;

-- agent_payments extras
ALTER TABLE public.agent_payments
  ADD COLUMN IF NOT EXISTS user_id UUID,
  ADD COLUMN IF NOT EXISTS username TEXT;

-- order_number: ensure text column is used as text everywhere (already text)
-- Fix orders.order_number to handle both int and string lookups
-- Allow order_number to be numeric or text in queries via index
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders(order_number);

-- RPC: reset_order_sequence
CREATE OR REPLACE FUNCTION public.reset_order_sequence()
RETURNS void LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  PERFORM setval('public.order_number_seq', 1000, false);
END; $$;
GRANT EXECUTE ON FUNCTION public.reset_order_sequence() TO anon, authenticated, service_role;
