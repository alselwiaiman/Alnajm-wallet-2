# THINGS TO AVOID

## Never do these

- Do not turn the project into a Jib clone.
- Do not use the Jib logo.
- Do not use Jib brand names in the final product.
- Do not copy Jib source code.
- Do not copy proprietary screenshots into production UI unless explicitly licensed/approved.
- Do not use Firebase.
- Do not put Supabase service-role credentials in Flutter.
- Do not use client-side balances as financial truth.
- Do not use floating point for authoritative money.
- Do not create fake production integrations.
- Do not hard-code real exchange rates.
- Do not hard-code fees or financial limits.
- Do not fabricate compliance requirements.
- Do not fabricate customer data.
- Do not put Al Najm-specific code in the generic open-source core.
- Do not create three separate duplicated codebases for the packages.
- Do not add unapproved modules because they are common in fintech apps.
- Do not remove requested modules because they are difficult.
- Do not hide errors.
- Do not claim tests passed when they were not run.
- Do not claim deployment succeeded when it was not verified.
- Do not expose secrets in screenshots, logs, commits, docs, or sample files.
- Do not overwrite user-provided assets.
- Do not alter the official Al Najm logo.
- Do not change the approved UI direction without documenting the reason.
- Do not leave TODOs for work that was explicitly required and implementable.
- Do not use real money or production customer data in demo mode.

## If something is missing

If the missing item is non-critical:
- use a neutral placeholder
- document it
- continue

If the missing item affects money, security, compliance, or production integration:
- do not invent it
- create a clearly documented decision/TODO
- continue unrelated safe work
