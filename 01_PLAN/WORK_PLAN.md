# WORK PLAN

## Phase 0 — Intake and scope lock

- Read every instruction file.
- Inspect every supplied image.
- Identify official Al Najm assets.
- Identify reference-only assets.
- Build a requirements inventory.
- Create a missing-items list.
- Create `SCOPE_LOCK.md`.
- Do not code until the inventory is understood.

## Phase 1 — Design specification

Create:

- DESIGN_SPEC.md
- Design tokens
- Typography
- Spacing
- Radius
- Shadows
- Component inventory
- Navigation map
- Screen map
- Arabic/English localization strategy
- Light/dark mode strategy

The Al Najm reference image is the primary branded visual direction.
Jib images are secondary UX references.

## Phase 2 — Open Source Core

Build generic, brand-neutral:

- Flutter app
- Authentication abstraction
- Wallet
- Ledger/transactions
- Transfers
- Receive
- Exchange
- QR architecture
- Beneficiaries
- Notifications
- Profile/security
- KYC architecture
- Support architecture
- Admin architecture
- Feature flags
- Branding configuration
- Localization
- Tests

Do not insert Al Najm branding into the core.

## Phase 3 — Supabase

Implement:

- PostgreSQL schema
- migrations
- seed data
- Auth
- RLS policies
- Storage policies
- Realtime where needed
- Edge Functions only where justified

Keep the service-role key server-side.

## Phase 4 — PHP API

Build:

- REST API v1
- validation
- authorization
- services/repositories
- transaction handling
- idempotency
- audit logging
- consistent JSON responses
- automated tests

## Phase 5 — Core release

Run:

- Flutter analyze
- Flutter tests
- PHP tests
- database migration checks
- security checks
- build checks

Create:

`wallet-platform-core-v1.0.0`

Freeze this baseline.

## Phase 6 — Al Najm Demo

Clone/derive from the frozen core.

Apply:

- official Al Najm logo
- supplied Al Najm UI reference
- Al Najm colors/branding
- supplied approved images
- Supabase demo environment
- demo/test data

Do not use real customer or production financial data.

## Phase 7 — Commercial editions

Define, from the same core:

### Essential — $10,000
Core wallet, branding, authentication, wallet/balances, transactions, transfers, receive, basic exchange, QR, notifications, basic admin, deployment/configuration.

### Professional — $15,000
Essential plus advanced multi-currency, fees/limits, advanced KYC, roles, audit logs, promotions, payment/recharge architecture, reports, security hardening, deeper white-label configuration.

### Enterprise — $20,000
Professional plus enterprise white-label, multi-tenant capability, advanced RBAC, advanced ledger/reconciliation architecture, multiple provider integrations, enterprise reporting/security, deployment architecture and advanced customization.

Prices are package definitions, not application constants.

## Phase 8 — Final audit

Verify:

- no Firebase
- no Jib branding
- no hard-coded Al Najm in generic core
- no secrets
- no fake financial success
- no unapproved features
- no duplicated commercial codebases
- all supplied files were respected
- all important decisions are documented
