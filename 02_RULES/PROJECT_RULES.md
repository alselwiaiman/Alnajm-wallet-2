# PROJECT RULES

## A. Scope rules

1. Do not leave the approved project scope.
2. Do not invent business rules.
3. Do not implement optional features automatically.
4. If something is useful but not approved, put it in `docs/BACKLOG.md`.
5. Do not remove existing functionality without explicit approval.
6. Do not rewrite stable modules unnecessarily.

## B. File-first rule

Before changing anything:

1. Read the relevant instruction files.
2. Inspect the existing implementation.
3. Search for existing components/services/models.
4. Reuse before creating.
5. Document significant architectural changes.

## C. Reference rules

1. Supplied files are authoritative for their stated purpose.
2. The Al Najm logo is an official asset.
3. Jib screenshots are reference-only.
4. Never copy proprietary Jib assets/code/branding.
5. Do not generate replacement logos when an official logo exists.

## D. Architecture rules

1. Generic core must remain brand-neutral.
2. Customer-specific configuration belongs in the customer layer/configuration.
3. Commercial features must be modular.
4. Do not maintain three duplicated applications.
5. Keep APIs versioned.
6. Keep database migrations reproducible.

## E. Financial rules

1. Server/database is authoritative.
2. Never trust client-side balances.
3. Never trust client-side exchange rates.
4. Never trust client-side fees or limits.
5. Never mark a transaction successful without server confirmation.
6. Use numeric/decimal types for money.
7. Use atomic transactions.
8. Use idempotency for money-moving operations.
9. Maintain audit trails.
10. Use explicit transaction states.

## F. Security rules

Never expose:

- service-role credentials
- database credentials
- private keys
- PINs
- passwords
- OTPs
- access tokens
- sensitive identity documents

Do not log secrets or financial credentials.

## G. UI rules

1. Arabic-first.
2. RTL-first.
3. English/LTR supported.
4. Use centralized design tokens.
5. Reuse components.
6. Provide loading, empty, error, retry and success states.
7. Maintain accessibility.
8. Do not sacrifice usability for visual imitation.

## H. AI-agent rules

Anti Gravity must not:

- claim an integration works if it was not tested
- fabricate API responses as production behavior
- invent exchange rates
- invent regulatory requirements
- silently change architecture
- silently delete files
- silently change scope
- replace official assets
- add libraries without documenting why
- create duplicate abstractions

If uncertain about a critical financial/business decision, stop that part, document the question, and continue safe non-dependent work.

## I. Completion rule

A task is complete only when:

- code is implemented
- tests/checks are run
- documentation is updated
- scope is respected
- no secrets are exposed
- no unintended files/features were added
