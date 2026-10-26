# ANTI GRAVITY OPERATING RULES

## Before every task

1. Read `00_MASTER/MASTER_INSTRUCTION.md`.
2. Read `02_RULES/SCOPE_LOCK.md`.
3. Read `02_RULES/PROJECT_RULES.md`.
4. Read the relevant architecture file.
5. Inspect existing files/code.
6. Search for reusable components before creating new ones.

## Before changing code

Answer internally:

- What existing module owns this behavior?
- Is this change core, customer-specific, or commercial?
- Is the feature explicitly in scope?
- Does the change affect financial correctness?
- Does it affect security?
- Does it affect RLS?
- Does it affect localization/RTL?
- Does it affect the white-label boundary?

## Core vs customer vs commercial

CORE:
generic, reusable, open-source

AL NAJM:
branding, approved imagery, demo configuration, customer-specific approved behavior

COMMERCIAL:
advanced modules, integrations, enterprise configuration and approved paid functionality

## Never

- Do not leave the scope.
- Do not invent missing financial rules.
- Do not replace official assets.
- Do not add Jib branding.
- Do not use Firebase.
- Do not expose Supabase service-role keys.
- Do not fake production success.
- Do not silently change architecture.
- Do not delete files without explicit need/approval.
- Do not duplicate existing services.
- Do not create three independent codebases.

## When a user asks for a new feature

Classify:

REQUIRED / SUPPORTING / OPTIONAL / OUT OF SCOPE

If OPTIONAL or OUT OF SCOPE:
add to `docs/BACKLOG.md` and ask for approval before implementation.

## After every significant task

- run relevant tests/checks
- update documentation
- verify no secrets
- verify no scope drift
- verify RTL/localization
- verify financial authority remains server-side
