## الخطة الشاملة

المشروع يحتاج بناء كامل لقاعدة البيانات من الصفر (Supabase فارغ حالياً) + تعديلات على الكود. سأنفذها على 3 مراحل:

---

### المرحلة 1: قاعدة البيانات (Migration كبيرة واحدة)

سأنشئ كل الجداول التي يستخدمها الكود حالياً، مع GRANTs و RLS و Triggers:

**جداول الإدارة والصلاحيات:**
- `admin_users` (username, password, is_active)
- `admin_user_permissions` (user_id, permission, permission_type)
- `system_passwords` (id, password) — مع إدراج أولي: master/payment/admin_delete = `01278006248`
- `app_settings` (platform_name, invoice_name, logo, watermark, theme... إلخ) — مع `Reflect` افتراضي
- `activity_logs`
- `analytics_events`, `statistics`

**الجغرافيا والمكاتب:**
- `governorates` (name, shipping_cost, agent_shipping_cost)
- `offices` (name, logo, watermark, address, phone)

**المنتجات:**
- `categories`
- `products` (name, price, tier prices, category_id...)
- `product_images`, `product_color_variants`

**العملاء والطلبات:**
- `customers` (phone فريد، name، address، governorate_id)
- `orders` (order_number، tracking_code، barcode_value، qr_value، status، total، delivery_agent_id، assigned_at، payment_date، office_id...)
- `order_items` (snapshot للأسعار والمنتجات، nullable product_id لحفظ التاريخ)
- `returns`

**المندوبين والمالية:**
- `delivery_agents` (name, phone, is_active)
- `agent_payments` (agent_id, order_id, amount, type, payment_date)
- `agent_daily_closings`
- `cashbox` + `cashbox_transactions`
- `treasury`

**نظام الباركود (من plan.md):**
- `scan_sessions`, `scan_session_items`, `scan_logs`
- `order_status_history`

**Triggers رئيسية:**
- توليد `order_number` و `tracking_code` تلقائياً
- عند تغيير `orders.status` → تسجيل في `order_status_history` + إنشاء/حذف `agent_payments` تلقائياً (لمنع الازدواج)
- عند رجوع الطلب لـ Pending/Processing → تفريغ `delivery_agent_id`
- إنشاء خزنة يومية صفرية تلقائياً
- `update_updated_at_column` للجداول

**RLS:** كل الجداول قابلة للقراءة/الكتابة بدون auth (المشروع يستخدم نظام admin خاص عبر `system_passwords`).

---

### المرحلة 2: تغيير الاسم Family Fashion → Reflect

- `src/contexts/ThemeContext.tsx`: defaults → `Reflect`
- `src/pages/admin/Dashboard.tsx`: النص الظاهر
- `src/pages/admin/Appearance.tsx`: placeholders
- `src/pages/admin/Orders.tsx`: شعار الفاتورة في الـ print template
- إدراج `Reflect` كقيمة افتراضية في `app_settings`

---

### المرحلة 3: كلمة المرور الرئيسية + شكل الفاتورة

**كلمة المرور:**
- `src/lib/adminAuth.ts`: تغيير `01013701405` → `01278006248`
- إدراج `01278006248` لكل من master/payment/admin_delete في `system_passwords`
- بحيث يمكن تغييرها لاحقاً من واجهة UserManagement

**شكل الفاتورة الجديد:**
تصميم احترافي جديد لـ `Invoices.tsx` (وقالب الطباعة في `Orders.tsx`):
- Header مع لوجو Reflect + معلومات المكتب
- Barcode + QR + Tracking code بارزين
- تصميم نظيف بألوان متناسقة (ذهبي/أسود أو حسب الـ theme)
- جدول منتجات منسق
- ملخص مالي واضح في الأسفل
- ملاحظات وشروط
- مناسب لطباعة A4 وأيضاً للحرارية

---

### ملاحظات

1. الـ Migration ضخمة (≈ 25 جدول). سأرسلها كاملة في خطوة واحدة وتحتاج موافقتك.
2. بعد تنفيذ الـ Migration، `types.ts` يتحدث تلقائياً ثم أكمل تعديلات الكود.
3. لن ألمس البيانات الموجودة (لا توجد بيانات حالياً).

هل أبدأ بإرسال الـ Migration؟