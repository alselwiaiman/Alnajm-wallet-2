# OPEN SOURCE CORE RELEASE

## Release name

wallet-platform-core-v1.0.0

## Definition

A generic, brand-neutral wallet platform.

## Must include

- Flutter application
- PHP API
- Supabase schema/migrations
- Authentication
- Wallet
- Ledger/transactions
- Transfers
- Receive
- Exchange architecture
- Beneficiaries
- QR architecture
- Notifications
- KYC architecture
- Security architecture
- Admin architecture
- Localization
- RTL
- Branding abstraction
- Feature flags
- Documentation
- Tests

## Must NOT include

- Al Najm production data
- Al Najm private credentials
- Al Najm-specific business rules
- Jib branding
- Jib logo
- Firebase

## Release gate

Do not freeze the release until:

- code checks pass
- tests pass or failures are documented
- migrations are reproducible
- docs are updated
- secrets scan is clean
- scope audit is complete
