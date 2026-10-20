# SECURITY POLICY

This is financial software architecture.

Never commit secrets.

Report security issues privately rather than publishing exploit details.

Minimum security principles:

- server-side authorization
- RLS
- least privilege
- audit logs
- secure sessions
- idempotency
- atomic transactions
- secure storage
- no secrets in client builds
- no sensitive data in logs
- no client authority over financial state
