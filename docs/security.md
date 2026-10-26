# Security Rules

هذا Demo وليس نظاماً مالياً حقيقياً.

## يجب
- استخدام mock/demo identities.
- إبقاء secrets خارج source code.
- استخدام secure storage فقط عندما توجد حاجة فعلية لتخزين بيانات حساسة.
- التحقق من المدخلات.
- عدم الثقة في قيم العميل عند إضافة backend حقيقي.
- عند الانتقال إلى backend حقيقي: authentication وauthorization وserver-side validation وaudit logs مطلوبة.

## لا يجب
- حفظ رقم بطاقة حقيقية.
- حفظ CVV.
- حفظ كلمات مرور المستخدم.
- وضع API secret في Flutter.
- اعتبار إخفاء عنصر UI حماية أمنية.
- اعتبار client-side validation كافية للعمليات المالية.
- تنفيذ transfer حقيقي من التطبيق مباشرة إلى مزود مالي بدون backend موثوق.

## ملاحظة
أي نظام مالي حقيقي يحتاج مراجعة أمنية واختبارات متخصصة قبل الإنتاج.
