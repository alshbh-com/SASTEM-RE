ALTER TABLE public.delivery_agents
  ADD COLUMN IF NOT EXISTS serial_number TEXT,
  ADD COLUMN IF NOT EXISTS total_owed NUMERIC DEFAULT 0,
  ADD COLUMN IF NOT EXISTS total_paid NUMERIC DEFAULT 0;

CREATE OR REPLACE FUNCTION public.delete_old_activity_logs()
RETURNS void LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  DELETE FROM public.activity_logs WHERE created_at < now() - INTERVAL '90 days';
END; $$;

CREATE OR REPLACE FUNCTION public.reset_order_sequence()
RETURNS void LANGUAGE plpgsql SET search_path = public AS $$
BEGIN
  PERFORM setval('public.orders_order_number_seq', 1000, false);
END; $$;