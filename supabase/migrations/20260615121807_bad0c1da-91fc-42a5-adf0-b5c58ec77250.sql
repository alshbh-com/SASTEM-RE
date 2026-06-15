DROP TRIGGER IF EXISTS update_admin_users_updated_at ON public.admin_users;
DROP TRIGGER IF EXISTS update_app_settings_updated_at ON public.app_settings;
DROP TRIGGER IF EXISTS update_cashbox_updated_at ON public.cashbox;
DROP TRIGGER IF EXISTS update_categories_updated_at ON public.categories;
DROP TRIGGER IF EXISTS update_customers_updated_at ON public.customers;
DROP TRIGGER IF EXISTS update_delivery_agents_updated_at ON public.delivery_agents;
DROP TRIGGER IF EXISTS update_governorates_updated_at ON public.governorates;
DROP TRIGGER IF EXISTS update_offices_updated_at ON public.offices;
DROP TRIGGER IF EXISTS update_orders_updated_at ON public.orders;
DROP TRIGGER IF EXISTS update_products_updated_at ON public.products;
DROP TRIGGER IF EXISTS update_scan_sessions_updated_at ON public.scan_sessions;

DROP TRIGGER IF EXISTS trg_orders_generate_codes ON public.orders;
DROP TRIGGER IF EXISTS trg_orders_sync_totals_insert ON public.orders;
DROP TRIGGER IF EXISTS trg_orders_sync_totals_update ON public.orders;
DROP TRIGGER IF EXISTS trg_clear_agent_on_revert ON public.orders;
DROP TRIGGER IF EXISTS trg_order_status_payments ON public.orders;