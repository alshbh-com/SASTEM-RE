
ALTER TABLE public.scan_sessions ADD COLUMN IF NOT EXISTS ended_at TIMESTAMPTZ;
ALTER TABLE public.agent_daily_closings ADD COLUMN IF NOT EXISTS closed_by_username TEXT;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS modified_amount NUMERIC DEFAULT 0;
ALTER TABLE public.treasury
  ADD COLUMN IF NOT EXISTS category TEXT,
  ADD COLUMN IF NOT EXISTS created_by UUID;
