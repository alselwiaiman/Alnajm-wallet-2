# BACKLOG

Only add items here that are not explicitly approved for the current scope.

Each item should contain:

- ID
- requested feature
- reason
- dependencies
- security impact
- financial impact
- status
- approval

No backlog item should be implemented automatically.

## BKL-001: Advanced AI KYC Verification (Commercial Editions)
- **Requested Feature**: 360-degree face liveness detection, ID OCR data extraction and matching, and Selfie-with-ID verification.
- **Reason**: Required for Large and Medium commercial editions to comply with AML/KYC strict requirements.
- **Dependencies**: Third-party KYC Provider API (e.g., Sumsub, Onfido, Veriff, or AWS Rekognition) for OCR and Liveness AI models.
- **Security Impact**: High. Handles sensitive PII and biometrics. Must ensure secure transmission and zero local-storage of biometric data.
- **Financial Impact**: Cost per verification API call depending on the chosen provider.
- **Status**: UI/Architecture Stub created. Waiting for third-party provider selection and API keys.
- **Approval**: Approved for Architecture/UI implementation. Blocked for production logic pending provider contract.
