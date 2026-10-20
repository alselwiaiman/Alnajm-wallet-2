# Al Najm Digital Wallet Platform — API Documentation

This document describes the REST API endpoints provided by the backend service located in `06_COMMERCIAL_EDITIONS/backend_api`.

## Base URL
`/api/v1`

## Authentication
All secured requests require an HTTP Authorization Bearer token header:
```http
Authorization: Bearer <API_TOKEN_OR_SESSION_JWT>
```

---

## 1. Authentication (`/api/v1/auth`)

### Register New User / OTP Request
- **Endpoint:** `POST /api/v1/auth/register`
- **Body:**
  ```json
  {
    "phone_number": "+967770000000",
    "full_name": "محمد علي النهمي",
    "password": "<hashed_secret>"
  }
  ```
- **Response:**
  ```json
  {
    "status": "success",
    "message": "User registered. OTP sent.",
    "tracking_id": "auth_otp_9824"
  }
  ```

### Login
- **Endpoint:** `POST /api/v1/auth/login`
- **Body:**
  ```json
  {
    "phone_number": "+967770000000",
    "password": "<secret>",
    "device_info": {
      "device_id": "dev_s24_ultra",
      "model": "Samsung Galaxy S24 Ultra",
      "os": "Android 14"
    }
  }
  ```
- **Response:**
  ```json
  {
    "token": "eyJhbGciOi...",
    "user_id": "usr_99812",
    "kyc_level": "TIER_1"
  }
  ```

---

## 2. Wallet & Balances (`/api/v1/wallet`)

### Get Wallets & Balances
- **Endpoint:** `GET /api/v1/wallet/balance`
- **Response:**
  ```json
  {
    "wallets": [
      { "currency": "YER", "balance": 1250000.00, "status": "ACTIVE" },
      { "currency": "SAR", "balance": 4500.00, "status": "ACTIVE" },
      { "currency": "USD", "balance": 1200.00, "status": "ACTIVE" }
    ]
  }
  ```

---

## 3. Transactions & Transfers (`/api/v1/transactions`)

### List Recent Transactions
- **Endpoint:** `GET /api/v1/transactions/list?limit=20`
- **Response:**
  ```json
  {
    "transactions": [
      {
        "reference_id": "TX-2026-9021",
        "type": "TRANSFER",
        "amount": 25000.00,
        "currency": "YER",
        "fee": 0.00,
        "status": "COMPLETED",
        "recipient": "صالح أحمد الوصابي",
        "created_at": "2026-10-13T20:30:00Z"
      }
    ]
  }
  ```

### Create Transfer / Payment
- **Endpoint:** `POST /api/v1/transactions/create`
- **Body:**
  ```json
  {
    "type": "TRANSFER",
    "recipient_identifier": "+967771234567",
    "amount": 15000.00,
    "currency": "YER",
    "idempotency_key": "idem_uuid_84920"
  }
  ```

---

## 4. Currency Exchange (`/api/v1/exchange`)

### Get Exchange Rates
- **Endpoint:** `GET /api/v1/exchange/rates`
- **Response:**
  ```json
  {
    "base": "USD",
    "rates": {
      "YER": 535.0,
      "SAR": 3.75
    },
    "timestamp": "2026-10-13T22:00:00Z"
  }
  ```

---

## 5. Webhooks & Integrations (`/api/v1/webhooks`)
Used for merchant notifications and external banking reconciliation.
- **Endpoint:** `POST /api/v1/webhooks/listener`
