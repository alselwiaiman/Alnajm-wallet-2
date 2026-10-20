# Al Najm Digital Wallet Platform — Deployment Guide

This guide covers deploying the Flutter client application, the PHP REST API backend, and the Supabase PostgreSQL database.

---

## 1. Supabase Database Deployment
1. Create a project in [Supabase](https://supabase.com).
2. Open the **SQL Editor** in your Supabase dashboard.
3. Paste the contents of `06_COMMERCIAL_EDITIONS/database/supabase_schema.sql` and run the script.
4. Verify that tables (`users`, `wallets`, `transactions`, `kyc_verifications`) are created with Row Level Security (RLS) enabled.
5. In **Project Settings -> API**, obtain:
   - Project URL
   - Public `anon` key
   - Server-only `service_role` key (store strictly on backend servers).

---

## 2. PHP REST API Backend Deployment
1. Provision a web server (Apache/Nginx with PHP 8.1+ and `pdo_pgsql` extension enabled).
2. Upload the contents of `06_COMMERCIAL_EDITIONS/backend_api/` to your web root (e.g. `/var/www/alnajm-api`).
3. Copy `.env.example` to `.env` in the backend root and configure your database credentials:
   ```env
   DB_HOST=db.your-supabase-project.supabase.co
   DB_PORT=5432
   DB_NAME=postgres
   DB_USER=postgres
   DB_PASSWORD=your_secure_db_password
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_secret
   ```
4. Configure URL rewriting (e.g., via `.htaccess` or Nginx `try_files $uri $uri/ /index.php?$query_string;`).

---

## 3. Flutter Application Build & Deployment

### Android APK Build
```bash
# Navigate to either 04_OPEN_SOURCE_CORE or 05_AL_NAJM_DEMO
cd 05_AL_NAJM_DEMO

# Install packages
flutter pub get

# Build Release APK for ARM64
flutter build apk --release --target-platform android-arm64

# Or build split APKs for all architectures
flutter build apk --release --split-per-abi
```

### Multi-Tier Automated Build Script
Use the PowerShell script `build_all_tiers_archs.ps1` at the repository root to automatically generate manifests and builds across all 4 tiers (`demo`, `essential`, `professional`, `enterprise`) and architectures (`arm64-v8a`, `armeabi-v7a`).
