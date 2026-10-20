# Quality Gates

قبل تسليم أي Feature:

## Code
- [ ] dart format
- [ ] flutter analyze بدون أخطاء
- [ ] flutter test ناجح
- [ ] لا يوجد debug print غير ضروري
- [ ] لا يوجد TODO حرج غير موضح

## Architecture
- [ ] business logic خارج UI
- [ ] repository abstraction مستخدم
- [ ] لا يوجد coupling غير ضروري

## UI
- [ ] Loading
- [ ] Empty
- [ ] Error
- [ ] Success
- [ ] RTL/LTR
- [ ] Responsive

## Security
- [ ] لا secrets
- [ ] لا بيانات مالية حقيقية
- [ ] لا تعطيل SSL
- [ ] لا credentials داخل Git

## Portfolio
- [ ] README واضح
- [ ] Screenshots اختيارية
- [ ] Demo credentials واضحة
- [ ] طريقة التشغيل واضحة
