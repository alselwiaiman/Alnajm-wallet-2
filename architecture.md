# Architecture

## الهدف
Architecture بسيطة وقابلة للتوسع لـ Flutter Wallet Demo.

## الطبقات

lib/
  core/
    constants/
    errors/
    routing/
    theme/
    localization/
    utils/
  features/
    auth/
      data/
      domain/
      presentation/
    wallet/
      data/
      domain/
      presentation/
    transactions/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
  shared/
    widgets/
    models/

## قاعدة dependency
Presentation -> Domain -> Data abstractions

لا تجعل Presentation تعتمد مباشرة على implementation خاص بمصدر البيانات.

## Repository
مثال:
- WalletRepository
- TransactionRepository
- AuthRepository

الـ Demo يستخدم Mock implementations.
لاحقاً يمكن إضافة Remote API implementation دون إعادة بناء الواجهة.

## State
استخدم state management واحداً متسقاً مع المشروع. إذا لم يتم اختيار package، ابدأ بحل Flutter بسيط أو pattern خفيف ولا تضف package لمجرد الإضافة.

## Routing
كل شاشة لها route واضح. تعامل مع unauthorized state وunknown routes.

## Data
Mock data يجب أن تكون في data layer وليست موزعة داخل Widgets.
