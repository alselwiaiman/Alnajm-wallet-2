# AL NAJM WALLET PLATFORM — MASTER INSTRUCTION FOR ANTI GRAVITY

## Mission

Build a reusable, open-source, white-label digital wallet platform for financial/exchange companies.

The first branded demonstration is:

**شركة النجم للصرافة — AL NAJM EXCHANGE**

The platform must be built as a generic core first, then released/frozen, then used to produce the Al Najm Demo and three commercial editions.

## Technology

- Flutter / Dart — mobile application
- PHP / Laravel-style REST API — backend
- Supabase — PostgreSQL, Auth, Storage, Realtime and Edge Functions where appropriate
- No Firebase
- Arabic-first and RTL-first
- English/LTR supported
- Clean Architecture / modular architecture
- Riverpod OR Bloc/Cubit, choose one and use it consistently

## Mandatory sequence

1. Inspect ALL supplied files and reference images.
2. Read every project instruction file before coding.
3. Create `DESIGN_SPEC.md`.
4. Build the generic Open Source Core.
5. Integrate Supabase.
6. Build PHP REST API.
7. Build tests and documentation.
8. Run quality/security checks.
9. Export/freeze `wallet-platform-core-v1.0.0`.
10. Create `al-najm-wallet-demo` from the frozen core.
11. Apply the official Al Najm logo and supplied Al Najm UI reference.
12. Add demo data only; clearly mark demo/test mode.
13. Create Essential ($10,000), Professional ($15,000), Enterprise ($20,000) product definitions.
14. Do not create three duplicated codebases; use modular features/configuration.

## Scope hierarchy

Priority order:

1. Explicit user instructions.
2. Files in this package.
3. Official Al Najm assets supplied by the user.
4. Al Najm UI reference supplied by the user.
5. Jib screenshots as UX references only.
6. General engineering best practices.

If two instructions conflict, follow the higher priority item and document the conflict.

## Hard scope boundary

Do not add a feature merely because it seems useful.

Before implementing any feature, classify it as:

- REQUIRED — explicitly requested or required by an existing file.
- SUPPORTING — necessary to implement a REQUIRED feature safely.
- OPTIONAL — useful but not approved.
- OUT OF SCOPE — not part of the current project.

Only REQUIRED and necessary SUPPORTING work may be implemented automatically.

OPTIONAL or OUT OF SCOPE work must be documented in `docs/BACKLOG.md` and not implemented without approval.

## Reference-image rule

Jib images are visual/UX references only. Never copy Jib source code, logo, proprietary branding, or proprietary assets.

The official Al Najm logo supplied by the user is mandatory for the Al Najm Demo. Never redraw, distort, replace, or invent a substitute for it.

## Financial safety

The client must never be the authority for:

- wallet balances
- transaction success
- exchange rates
- fees
- limits
- permissions
- transaction status

Financial authority belongs to the server/database/ledger architecture.

Use decimal/numeric types, never floating-point arithmetic for authoritative money calculations.

Use atomic transactions, idempotency, audit logs, state machines, server-side authorization, and RLS where appropriate.

## Secrets

Never put secrets in Flutter or Git.

Never expose:

- Supabase service-role key
- database passwords
- private keys
- production API secrets
- OTP/PIN/password values
- access tokens in logs

Use `.env.example` and secure deployment secrets.

## Final deliverables

The repository must contain at least:

- README.md
- LICENSE
- CONTRIBUTING.md
- SECURITY.md
- CHANGELOG.md
- DESIGN_SPEC.md
- ARCHITECTURE.md
- API.md
- DATABASE.md
- DEPLOYMENT.md
- WHITE_LABEL.md
- COMMERCIAL_EDITIONS.md
- ANTI_GRAVITY.md
- SCOPE_LOCK.md
- docs/BACKLOG.md
- `.env.example`

The project is not considered complete if it is only a UI mockup or a collection of fake buttons.
