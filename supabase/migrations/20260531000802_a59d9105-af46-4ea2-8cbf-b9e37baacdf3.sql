INSERT INTO public.admin_users (username, password, is_active) VALUES ('owner', '01278006248', true) RETURNING id;

INSERT INTO public.admin_user_permissions (user_id, permission, permission_type)
SELECT id, p.permission, 'edit' FROM public.admin_users, (VALUES 
  ('dashboard'),('orders'),('products'),('categories'),('customers'),('agents'),
  ('agent_orders'),('invoices'),('cashbox'),('treasury'),('returns'),('scan'),
  ('governorates'),('offices'),('appearance'),('user_management'),('activity_logs'),
  ('statistics'),('settings')
) AS p(permission)
WHERE username='owner';