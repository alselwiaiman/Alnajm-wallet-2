-- ==============================================================================
-- SUPABASE POSTGRESQL SCHEMA FOR "AL-NAJM" DIGITAL WALLET PLATFORM
-- ==============================================================================

-- 1. USERS TABLE (Extends Supabase Auth if used, or standalone)
CREATE TABLE public.users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    auth_id UUID UNIQUE, -- Link to Supabase Auth table if used
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    kyc_level VARCHAR(20) DEFAULT 'TIER_0', -- TIER_0, TIER_1, TIER_2
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, SUSPENDED, BLOCKED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. WALLETS TABLE
CREATE TABLE public.wallets (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    currency VARCHAR(3) DEFAULT 'USD',
    balance DECIMAL(15, 2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, FROZEN
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, currency) -- One wallet per currency per user
);

-- 3. TRANSACTIONS TABLE
CREATE TABLE public.transactions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    reference_id VARCHAR(50) UNIQUE NOT NULL, -- For external tracking
    sender_wallet_id UUID REFERENCES public.wallets(id),
    receiver_wallet_id UUID REFERENCES public.wallets(id),
    type VARCHAR(20) NOT NULL, -- DEPOSIT, WITHDRAWAL, TRANSFER, EXCHANGE
    amount DECIMAL(15, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL,
    fee DECIMAL(15, 2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, COMPLETED, FAILED, REJECTED
    metadata JSONB, -- For extra data like exchange rates, IP, device info
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE
);

-- 4. KYC VERIFICATIONS TABLE
CREATE TABLE public.kyc_verifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    document_type VARCHAR(50), -- NATIONAL_ID, PASSPORT
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    tracking_id VARCHAR(100), -- ID from third-party AI provider (e.g., Sumsub)
    extracted_data JSONB, -- OCR data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. COMMERCIAL API KEYS (For B2B Integrations - Medium/Large Packages)
CREATE TABLE public.commercial_api_keys (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    api_key VARCHAR(100) UNIQUE NOT NULL,
    api_secret VARCHAR(255) NOT NULL, -- Hashed in production
    environment VARCHAR(20) DEFAULT 'SANDBOX', -- SANDBOX, PRODUCTION
    status VARCHAR(20) DEFAULT 'ACTIVE',
    webhook_url TEXT, -- For real-time notifications
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_used_at TIMESTAMP WITH TIME ZONE
);

-- ==============================================================================
-- SECURITY: ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================

-- Enable RLS on tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Users can only read their own profile
CREATE POLICY "Users can view own profile" 
ON public.users FOR SELECT 
USING (auth_id = auth.uid());

-- Users can only view their own wallets
CREATE POLICY "Users can view own wallets" 
ON public.wallets FOR SELECT 
USING (user_id IN (SELECT id FROM public.users WHERE auth_id = auth.uid()));

-- Users can only view transactions where they are sender or receiver
CREATE POLICY "Users can view own transactions" 
ON public.transactions FOR SELECT 
USING (
    sender_wallet_id IN (SELECT id FROM public.wallets WHERE user_id = (SELECT id FROM public.users WHERE auth_id = auth.uid()))
    OR 
    receiver_wallet_id IN (SELECT id FROM public.wallets WHERE user_id = (SELECT id FROM public.users WHERE auth_id = auth.uid()))
);

-- Note: INSERTS and UPDATES for transactions should be handled strictly via secure backend functions (RPCs or PHP API), NOT directly from the client application.
