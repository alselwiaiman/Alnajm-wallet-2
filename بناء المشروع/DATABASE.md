# Al Najm Digital Wallet Platform — Database Architecture

The platform uses a relational PostgreSQL database powered by Supabase. All authoritative financial state, balances, and transaction ledgers are maintained server-side.

## Schema Location
The official DDL script is located in:
`06_COMMERCIAL_EDITIONS/database/supabase_schema.sql`

---

## 1. Core Tables

### `public.users`
Stores user profile information, authentication link, and KYC verification level.
- `id`: UUID (Primary Key)
- `auth_id`: UUID (Foreign key to `auth.users`)
- `phone_number`: VARCHAR(20) UNIQUE NOT NULL
- `full_name`: VARCHAR(100)
- `kyc_level`: VARCHAR(20) (`TIER_0`, `TIER_1`, `TIER_2`)
- `status`: VARCHAR(20) (`ACTIVE`, `SUSPENDED`, `BLOCKED`)
- `created_at` / `updated_at`: TIMESTAMPTZ

### `public.wallets`
Stores multi-currency wallets per user with strict uniqueness constraint per user and currency.
- `id`: UUID (Primary Key)
- `user_id`: UUID (References `public.users(id)` ON DELETE CASCADE)
- `currency`: VARCHAR(3) (`YER`, `SAR`, `USD`)
- `balance`: DECIMAL(15, 2) DEFAULT 0.00
- `status`: VARCHAR(20) (`ACTIVE`, `FROZEN`)
- Constraint: `UNIQUE(user_id, currency)`

### `public.transactions`
The immutable ledger for all financial events.
- `id`: UUID (Primary Key)
- `reference_id`: VARCHAR(50) UNIQUE NOT NULL
- `sender_wallet_id`: UUID (References `public.wallets(id)`)
- `receiver_wallet_id`: UUID (References `public.wallets(id)`)
- `type`: VARCHAR(20) (`DEPOSIT`, `WITHDRAWAL`, `TRANSFER`, `EXCHANGE`)
- `amount`: DECIMAL(15, 2) NOT NULL CHECK (amount > 0)
- `currency`: VARCHAR(3) NOT NULL
- `fee`: DECIMAL(15, 2) DEFAULT 0.00
- `status`: VARCHAR(20) (`PENDING`, `COMPLETED`, `FAILED`, `REJECTED`)
- `metadata`: JSONB (Exchange rates, IP, device identifiers)
- `created_at` / `completed_at`: TIMESTAMPTZ

### `public.kyc_verifications`
Audit trails and status tracking for identity verification.
- `id`: UUID (Primary Key)
- `user_id`: UUID (References `public.users(id)`)
- `document_type`: VARCHAR(50) (`NATIONAL_ID`, `PASSPORT`)
- `status`: VARCHAR(20) (`PENDING`, `APPROVED`, `REJECTED`)
- `extracted_data`: JSONB

---

## 2. Row Level Security (RLS) Policies
RLS is strictly enforced on all public tables:
- **Users Table:** Users can only view their own record (`auth_id = auth.uid()`).
- **Wallets Table:** Users can only read their own wallets.
- **Transactions Table:** Users can only view records where their wallet is either sender or receiver.
- **Financial Modifications:** All debit/credit balance mutations and transfers MUST be executed through server-side stored procedures (RPCs) or the PHP backend service, never directly from client SQL.
