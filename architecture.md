# ARCHITECTURE

## High-level

Flutter
  ↓
PHP REST API
  ↓
Supabase/PostgreSQL

Supabase services may provide:

- Auth
- Storage
- Realtime
- PostgreSQL
- Edge Functions where justified

## Financial authority

The authoritative financial model must live server-side and in the database/ledger architecture.

Flutter is a client, not the accounting system.

## Repository concept

```text
wallet-platform/
├── mobile/
├── backend/
├── supabase/
├── packages/
├── docs/
├── assets/
├── al-najm-demo/
└── commercial/
```

Do not duplicate the entire codebase for each customer/package.

## Suggested Flutter modules

- core
- config
- theme
- localization
- routing
- network
- security
- auth
- home
- wallet
- transactions
- transfers
- beneficiaries
- exchange
- payments
- qr
- notifications
- kyc
- profile
- support

## Suggested PHP modules

- Auth
- Users
- Wallets
- Ledger
- Transactions
- Transfers
- Exchange
- Beneficiaries
- Payments
- KYC
- Notifications
- Security
- Support
- Admin
- Audit

## White-label

Company configuration controls:

- name
- legal name
- logo
- colors
- typography
- app icon
- splash
- currencies
- enabled features
- support contact
- legal links

## Commercial model

Core:
open source

Customer layer:
branding/configuration

Commercial:
advanced modules, integrations, deployment, customization and enterprise capabilities

Never place secrets or customer data in the public core.
