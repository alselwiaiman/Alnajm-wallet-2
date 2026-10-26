# Contributing to Al Najm Wallet Platform

We welcome contributions to the Al Najm Digital Wallet Open Source Core. Please follow these guidelines before submitting issues or pull requests.

## Code Standards
- **Clean Architecture:** Maintain separation of concerns (Data, Domain, Presentation).
- **Security First:** Never hardcode secrets, tokens, API keys, or private certificates.
- **Financial Safety:** Never perform authoritative financial arithmetic on the client. Always use server-validated atomic operations and precise numeric types.
- **RTL & Localization:** Ensure all screens properly support Right-to-Left (Arabic) and Left-to-Right (English) layouts.
- **Testing:** Add unit tests for all domain entities and repository implementations.

## Pull Request Workflow
1. Fork the repository and create a feature branch (`git checkout -b feature/my-feature`).
2. Implement your changes following the Clean Architecture principles.
3. Run `flutter test` or equivalent analysis to ensure all existing tests pass.
4. Commit your changes with clear messages (`git commit -m 'feat: add multi-currency exchange rate widget'`).
5. Push to the branch and submit a Pull Request.
