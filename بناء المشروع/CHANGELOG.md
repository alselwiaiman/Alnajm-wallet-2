# Changelog

All notable changes to the Al Najm Digital Wallet Platform are documented in this file.

## [v1.0.0] - 2026-10-13

### Added
- **Core Architecture:** Clean Architecture implementation with core configuration, themes, routing, and localization.
- **White-Label Configuration:** Multi-tier support (`WalletTier.demo`, `WalletTier.essential`, `WalletTier.professional`, `WalletTier.enterprise`).
- **Al-Najm Plus Demonstration (`05_AL_NAJM_DEMO`):** Standalone demo application featuring official Al Najm branding, crimson colors, mascots, multi-currency wallets (YER, SAR, USD), and demo transactions.
- **Commercial Editions (`06_COMMERCIAL_EDITIONS`):**
  - Essential ($10,000), Professional ($15,000), Enterprise ($20,000) feature matrices and specifications.
  - Centralized Admin Dashboard with session & device management.
  - Modular PHP REST API backend (`/api/v1/auth`, `/api/v1/wallet`, `/api/v1/transactions`, `/api/v1/exchange`, `/api/v1/kyc`, `/api/v1/webhooks`).
  - Production-ready Supabase PostgreSQL schema with Row Level Security (RLS).
- **Security Enhancements:** Max concurrent device limits (3 active, 10 cumulative lifetime), contextual merchant recognition, and client-side balance hiding.
- **Repository Optimization:** Elimination of duplicate asset files, removal of redundant extraction archives, and structured folder layout.
