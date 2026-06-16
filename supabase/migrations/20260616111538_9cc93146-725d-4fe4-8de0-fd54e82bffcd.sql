
-- Products indexes
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON public.products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON public.products(created_at DESC);

-- Product images
CREATE INDEX IF NOT EXISTS idx_product_images_product_id ON public.product_images(product_id);

-- Categories
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON public.categories(is_active);
CREATE INDEX IF NOT EXISTS idx_categories_display_order ON public.categories(display_order);

-- Orders
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON public.orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_delivery_agent_id ON public.orders(delivery_agent_id);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON public.orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_assigned_at ON public.orders(assigned_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_payment_date ON public.orders(payment_date DESC);
CREATE INDEX IF NOT EXISTS idx_orders_order_number ON public.orders(order_number);
CREATE INDEX IF NOT EXISTS idx_orders_tracking_code ON public.orders(tracking_code);
CREATE INDEX IF NOT EXISTS idx_orders_barcode_value ON public.orders(barcode_value);
CREATE INDEX IF NOT EXISTS idx_orders_governorate_id ON public.orders(governorate_id);

-- Order items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON public.order_items(product_id);

-- Customers
CREATE INDEX IF NOT EXISTS idx_customers_phone ON public.customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_governorate_id ON public.customers(governorate_id);
CREATE INDEX IF NOT EXISTS idx_customers_created_at ON public.customers(created_at DESC);

-- Agent payments
CREATE INDEX IF NOT EXISTS idx_agent_payments_agent_id ON public.agent_payments(delivery_agent_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_order_id ON public.agent_payments(order_id);
CREATE INDEX IF NOT EXISTS idx_agent_payments_payment_date ON public.agent_payments(payment_date DESC);
CREATE INDEX IF NOT EXISTS idx_agent_payments_type ON public.agent_payments(payment_type);

-- Returns
CREATE INDEX IF NOT EXISTS idx_returns_order_id ON public.returns(order_id);
CREATE INDEX IF NOT EXISTS idx_returns_agent_id ON public.returns(delivery_agent_id);

-- Activity logs
CREATE INDEX IF NOT EXISTS idx_activity_logs_created_at ON public.activity_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_logs_section ON public.activity_logs(section);

-- Scan
CREATE INDEX IF NOT EXISTS idx_scan_session_items_session ON public.scan_session_items(session_id);
CREATE INDEX IF NOT EXISTS idx_scan_logs_session ON public.scan_logs(session_id);

-- Cashbox
CREATE INDEX IF NOT EXISTS idx_cashbox_transactions_cashbox ON public.cashbox_transactions(cashbox_id);
CREATE INDEX IF NOT EXISTS idx_cashbox_transactions_created ON public.cashbox_transactions(created_at DESC);

ANALYZE public.products;
ANALYZE public.orders;
ANALYZE public.customers;
ANALYZE public.order_items;
ANALYZE public.agent_payments;
