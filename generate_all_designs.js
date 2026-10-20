const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const projectDir = __dirname;
const outputDir = path.join(projectDir, 'تصاميم النجم');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// Read logo assets as base64
function getBase64Asset(relPath) {
  const fullPath = path.join(projectDir, relPath);
  if (fs.existsSync(fullPath)) {
    const ext = path.extname(fullPath).replace('.', '');
    const data = fs.readFileSync(fullPath).toString('base64');
    const mime = ext === 'svg' ? 'image/svg+xml' : `image/${ext}`;
    return `data:${mime};base64,${data}`;
  }
  return '';
}

const logoColor = getBase64Asset('04_OPEN_SOURCE_CORE/assets/images/alnajm_plus_logo.png') ||
                  getBase64Asset('النجم/alnajm_plus_logo_hd.png');
const logoWhite = getBase64Asset('04_OPEN_SOURCE_CORE/assets/images/alnajm_plus_logo_white.png') ||
                  getBase64Asset('النجم/شعار_النجم_ابيض_للخلفيات_الداكنة.png');
const appIcon = getBase64Asset('04_OPEN_SOURCE_CORE/assets/images/app_icon.png') ||
                getBase64Asset('النجم/ايقونة_التطبيق_الفاخرة.png');

const mascotYemeni = getBase64Asset('تصاميم النجم/شخصية_النجم_اليمنية_الرسمية_HD.jpg') ||
                     getBase64Asset('النجم/alnajm_mascot_yemeni_hd.jpg') ||
                     getBase64Asset('05_AL_NAJM_DEMO/assets/images/alnajm_mascot_yemeni.jpg') ||
                     getBase64Asset('04_OPEN_SOURCE_CORE/assets/images/alnajm_mascot_yemeni.jpg');

const mascotStar = getBase64Asset('تصاميم النجم/شخصية_نجم_الكرتونية_Star_HD.png') ||
                   getBase64Asset('05_AL_NAJM_DEMO/assets/images/alnajm_mascot.png') ||
                   getBase64Asset('04_OPEN_SOURCE_CORE/assets/images/alnajm_mascot.png');

console.log('Logo loaded:', !!logoColor, 'White logo loaded:', !!logoWhite, 'Icon loaded:', !!appIcon, 'Mascot Yemeni loaded:', !!mascotYemeni);

// Base HTML template styling for realistic smartphone frame
function wrapScreen(title, bodyContent, isDark = false, activeNav = 0) {
  return `<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<title>${title}</title>
<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@400;500;700;800;900&family=Cairo:wght@400;600;700;800;900&display=swap" rel="stylesheet">
<style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Tajawal', 'Cairo', sans-serif;
    -webkit-font-smoothing: antialiased;
  }
  :root {
    --primary: #9E1B21;
    --primary-dark: #7A1015;
    --primary-light: #B8282E;
    --star-gold: #F59E0B;
    --star-gold-light: #FBBF24;
    --bg: ${isDark ? '#121212' : '#F8F9FA'};
    --card-bg: ${isDark ? '#1E1E1E' : '#FFFFFF'};
    --text-primary: ${isDark ? '#F9FAFB' : '#111827'};
    --text-secondary: ${isDark ? '#9CA3AF' : '#6B7280'};
    --border: ${isDark ? '#2D3748' : '#E5E7EB'};
    --divider: ${isDark ? '#262626' : '#F3F4F6'};
  }
  body {
    background: #0f1117;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
  }
  /* Realistic Mobile Frame */
  .phone-frame {
    width: 412px;
    height: 890px;
    background: var(--bg);
    border-radius: 46px;
    overflow: hidden;
    position: relative;
    box-shadow: 0 25px 60px rgba(0,0,0,0.5), 0 0 0 10px #242730, 0 0 0 12px #3a3f4d;
    display: flex;
    flex-direction: column;
  }
  /* Status Bar */
  .status-bar {
    height: 44px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 24px;
    font-size: 13px;
    font-weight: 700;
    color: ${isDark ? '#FFFFFF' : '#111827'};
    z-index: 50;
    background: transparent;
  }
  .dynamic-island {
    width: 110px;
    height: 26px;
    background: #000;
    border-radius: 20px;
    position: absolute;
    top: 10px;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    align-items: center;
    justify-content: flex-end;
    padding: 0 10px;
  }
  .camera-dot {
    width: 10px;
    height: 10px;
    background: #111a2e;
    border-radius: 50%;
    border: 1px solid #1a2744;
  }
  .content-area {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    position: relative;
    scrollbar-width: none;
  }
  .content-area::-webkit-scrollbar { display: none; }

  /* Navigation Bar */
  .bottom-nav {
    height: 72px;
    background: var(--card-bg);
    border-top: 1px solid var(--border);
    display: flex;
    justify-content: space-around;
    align-items: center;
    padding-bottom: 8px;
    z-index: 40;
  }
  .nav-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 4px;
    color: var(--text-secondary);
    font-size: 11px;
    font-weight: 600;
    cursor: pointer;
    flex: 1;
  }
  .nav-item.active {
    color: var(--primary);
  }
  .nav-item svg {
    width: 22px;
    height: 22px;
    fill: currentColor;
  }
  .nav-home-indicator {
    width: 120px;
    height: 4px;
    background: ${isDark ? '#4A4A4A' : '#D1D5DB'};
    border-radius: 4px;
    position: absolute;
    bottom: 6px;
    left: 50%;
    transform: translateX(-50%);
  }

  /* Utility badges and buttons */
  .btn-primary {
    background: linear-gradient(135deg, var(--primary-light) 0%, var(--primary) 60%, var(--primary-dark) 100%);
    color: white;
    border: none;
    border-radius: 14px;
    font-weight: 700;
    font-size: 15px;
    padding: 14px 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    box-shadow: 0 6px 18px rgba(158, 27, 33, 0.35);
    cursor: pointer;
    width: 100%;
  }
  .badge-gold {
    background: linear-gradient(135deg, #FBBF24 0%, #F59E0B 100%);
    color: #451A03;
    font-weight: 800;
    font-size: 11px;
    padding: 3px 10px;
    border-radius: 20px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
  }
</style>
</head>
<body>
<div class="phone-frame">
  <div class="dynamic-island"><div class="camera-dot"></div></div>
  <div class="status-bar">
    <span>09:41</span>
    <div style="display:flex;gap:6px;align-items:center;">
      <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><path d="M12 3c-4.97 0-9 4.03-9 9 0 2.12.74 4.07 1.97 5.61L12 22l7.03-4.39C20.26 16.07 21 14.12 21 12c0-4.97-4.03-9-9-9zm0 13c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4z"/></svg>
      <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98C20.93 5.9 16.69 4 12 4z"/></svg>
      <svg width="20" height="12" viewBox="0 0 24 14" fill="currentColor"><rect x="1" y="1" width="19" height="12" rx="3" fill="none" stroke="currentColor" stroke-width="2"/><rect x="3" y="3" width="13" height="8" rx="1.5"/><path d="M22 5v4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
    </div>
  </div>

  <div class="content-area">
    ${bodyContent}
  </div>

  ${activeNav >= 0 ? `
  <div class="bottom-nav">
    <div class="nav-item ${activeNav === 0 ? 'active' : ''}">
      <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
      <span>الرئيسية</span>
    </div>
    <div class="nav-item ${activeNav === 1 ? 'active' : ''}">
      <svg viewBox="0 0 24 24"><path d="M21 18v1c0 1.1-.9 2-2 2H5c-1.11 0-2-.9-2-2V5c0-1.1.89-2 2-2h14c1.1 0 2 .9 2 2v1h-9c-1.11 0-2 .9-2 2v8c0 1.1.89 2 2 2h9zm-9-2h10V8H12v8zm4-2.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/></svg>
      <span>المحفظة</span>
    </div>
    <div class="nav-item ${activeNav === 2 ? 'active' : ''}">
      <svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
      <span>العمليات</span>
    </div>
    <div class="nav-item ${activeNav === 3 ? 'active' : ''}">
      <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
      <span>حسابي</span>
    </div>
  </div>
  <div class="nav-home-indicator"></div>
  ` : '<div class="nav-home-indicator"></div>'}
</div>
</body>
</html>`;
}

// -------------------------------------------------------------
// Screen 1: Login Screen (تسجيل الدخول)
// -------------------------------------------------------------
const screenLoginHtml = wrapScreen('تسجيل الدخول - النجم بلس', `
  <div style="padding: 24px 20px; display: flex; flex-direction: column; min-height: 100%; justify-content: space-between;">
    <div>
      <div style="text-align: center; margin-top: 15px; margin-bottom: 25px;">
        <img src="${logoColor}" alt="النجم بلس" style="max-height: 75px; max-width: 240px; object-fit: contain; filter: drop-shadow(0 4px 10px rgba(158,27,33,0.15));">
        <h2 style="font-size: 20px; font-weight: 800; color: #111827; margin-top: 15px;">مرحباً بك مجدداً</h2>
        <p style="font-size: 13px; color: #6B7280; margin-top: 4px;">سجل الدخول لإدارة محفظتك وحوالاتك بأمان فائق</p>
      </div>

      <div style="display: flex; flex-direction: column; gap: 16px;">
        <!-- Phone Input -->
        <div>
          <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 6px;">رقم الهاتف أو المعرّف</label>
          <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 14px; padding: 0 14px; height: 52px; box-shadow: 0 2px 6px rgba(0,0,0,0.02);">
            <span style="font-size: 13px; font-weight: 700; color: var(--primary); padding-left: 10px; border-left: 1px solid #E5E7EB; direction: ltr;">+967</span>
            <input type="text" value="777 123 456" style="border: none; outline: none; flex: 1; padding: 0 10px; font-size: 15px; font-weight: 600; color: #111827;" readonly>
            <svg width="20" height="20" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>
          </div>
        </div>

        <!-- Password Input -->
        <div>
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
            <label style="font-size: 12px; font-weight: 700; color: #374151;">كلمة المرور / الرمز السري</label>
            <a href="#" style="font-size: 12px; font-weight: 700; color: var(--primary); text-decoration: none;">نسيت الرمز؟</a>
          </div>
          <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 14px; padding: 0 14px; height: 52px; box-shadow: 0 2px 6px rgba(0,0,0,0.02);">
            <input type="password" value="••••••••" style="border: none; outline: none; flex: 1; font-size: 18px; color: #111827; letter-spacing: 2px;" readonly>
            <svg width="20" height="20" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
          </div>
        </div>

        <!-- Login Button -->
        <button class="btn-primary" style="margin-top: 10px;">
          <span>تسجيل الدخول</span>
          <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
        </button>

        <!-- Biometrics Option -->
        <div style="display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 6px; padding: 12px; background: #FFF5F5; border-radius: 12px; border: 1px solid #FFE4E6; cursor: pointer;">
          <svg width="22" height="22" fill="var(--primary)" viewBox="0 0 24 24"><path d="M17.81 4.47c-.08 0-.16-.02-.23-.06C15.66 3.42 14 3 12.01 3c-1.98 0-3.86.47-5.57 1.41-.24.13-.54.04-.68-.2-.13-.24-.04-.55.2-.68C7.82 2.52 9.86 2 12.01 2c2.13 0 3.99.47 5.92 1.54.24.13.32.43.19.67-.09.16-.25.26-.41.26zm2.81 3.59c-.07 0-.15-.02-.22-.05-1.92-.99-4.54-1.52-8.39-1.52-3.86 0-6.49.53-8.41 1.53-.24.12-.54.03-.66-.2-.12-.24-.03-.54.2-.67 2.06-1.07 4.88-1.65 8.87-1.65 3.98 0 6.79.57 8.85 1.63.24.12.33.42.21.66-.09.18-.27.27-.45.27zM20.78 12c-.28 0-.5-.22-.5-.5 0-.16-.02-.32-.06-.47-.53-2.12-2.38-3.77-4.58-4.08-.27-.04-.46-.29-.42-.56.04-.27.29-.46.56-.42 2.65.38 4.87 2.37 5.51 4.93.05.18.07.37.07.56 0 .28-.22.54-.58.54z"/></svg>
          <span style="font-size: 13px; font-weight: 700; color: var(--primary);">الدخول السريع عبر بصمة الإصبع / الوجه</span>
        </div>
      </div>
    </div>

    <!-- Footer Register Prompt -->
    <div style="text-align: center; margin-top: 30px;">
      <div style="font-size: 13px; color: #6B7280; margin-bottom: 12px;">
        ليس لديك حساب في النجم بلس؟
        <span style="color: var(--primary); font-weight: 800; cursor: pointer;">إنشاء حساب جديد</span>
      </div>
      <div style="display: flex; align-items: center; justify-content: center; gap: 8px; color: #9CA3AF; font-size: 11px;">
        <svg width="14" height="14" fill="#10B981" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/></svg>
        <span>حماية مشفرة 256-Bit — مرخص ومعتمد من البنك المركزي</span>
      </div>
    </div>
  </div>
`, false, -1);

// -------------------------------------------------------------
// Screen 2: Register Screen (إنشاء حساب)
// -------------------------------------------------------------
const screenRegisterHtml = wrapScreen('إنشاء حساب - النجم بلس', `
  <div style="padding: 20px;">
    <!-- Header -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
      <div style="width: 36px; height: 36px; border-radius: 10px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center;">
        <svg width="18" height="18" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>
      <h3 style="font-size: 17px; font-weight: 800; color: #111827;">فتح حساب جديد</h3>
      <div style="width: 36px;"></div>
    </div>

    <!-- Steps Progress -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; padding: 0 10px;">
      <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
        <div style="width: 32px; height: 32px; border-radius: 50%; background: var(--primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px;">1</div>
        <span style="font-size: 11px; font-weight: 700; color: var(--primary);">البيانات</span>
      </div>
      <div style="flex: 1; height: 3px; background: var(--primary); margin: -16px 8px 0 8px; border-radius: 2px;"></div>
      <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
        <div style="width: 32px; height: 32px; border-radius: 50%; background: #E5E7EB; color: #6B7280; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px;">2</div>
        <span style="font-size: 11px; font-weight: 600; color: #6B7280;">التحقق OTP</span>
      </div>
      <div style="flex: 1; height: 3px; background: #E5E7EB; margin: -16px 8px 0 8px; border-radius: 2px;"></div>
      <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
        <div style="width: 32px; height: 32px; border-radius: 50%; background: #E5E7EB; color: #6B7280; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px;">3</div>
        <span style="font-size: 11px; font-weight: 600; color: #6B7280;">التوثيق KYC</span>
      </div>
    </div>

    <!-- Form Fields -->
    <div style="display: flex; flex-direction: column; gap: 14px;">
      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">الاسم الرباعي كاملاً (حسب الهوية)</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <input type="text" value="محمد أحمد عبد الله النجم" style="border: none; outline: none; flex: 1; font-size: 14px; font-weight: 600;" readonly>
        </div>
      </div>

      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">رقم الهاتف المحمول</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <span style="font-size: 12px; font-weight: 700; color: var(--primary); padding-left: 8px; border-left: 1px solid #E5E7EB; direction: ltr;">+967</span>
          <input type="text" value="778 990 011" style="border: none; outline: none; flex: 1; padding: 0 8px; font-size: 14px; font-weight: 600;" readonly>
        </div>
      </div>

      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">رقم البطاقة الشخصية / جواز السفر</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <input type="text" value="01010045892" style="border: none; outline: none; flex: 1; font-size: 14px; font-weight: 600;" readonly>
        </div>
      </div>

      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">تعيين كلمة المرور (6 خانات أو أكثر)</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <input type="password" value="••••••••" style="border: none; outline: none; flex: 1; font-size: 16px;" readonly>
        </div>
      </div>

      <!-- Agreement -->
      <div style="display: flex; align-items: flex-start; gap: 10px; margin-top: 6px;">
        <input type="checkbox" checked style="accent-color: var(--primary); width: 18px; height: 18px; margin-top: 2px;">
        <span style="font-size: 12px; color: #4B5563; line-height: 1.5;">أوافق على <span style="color: var(--primary); font-weight: 700;">الشروط والأحكام</span> وسياسة الخصوصية الخاصة بشبكة النجم بلس للحوالات المالية.</span>
      </div>

      <button class="btn-primary" style="margin-top: 14px;">
        <span>متابعة والتحقق</span>
        <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
      </button>
    </div>
  </div>
`, false, -1);

// -------------------------------------------------------------
// Screen 3: Dashboard Screen (الشاشة الرئيسية ورصيد الحساب)
// -------------------------------------------------------------
const screenDashboardHtml = wrapScreen('الرئيسية - النجم بلس', `
  <div style="padding: 16px;">
    <!-- Top Header -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
      <div style="display: flex; align-items: center; gap: 12px;">
        <div style="width: 44px; height: 44px; border-radius: 14px; background: #fff; border: 1.5px solid #E5E7EB; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(0,0,0,0.04); overflow: hidden;">
          <img src="${logoColor}" alt="النجم بلس" style="max-height: 32px; max-width: 38px; object-fit: contain;">
        </div>
        <div>
          <div style="font-size: 11px; color: #6B7280; font-weight: 600;">أهلاً بك</div>
          <div style="font-size: 16px; font-weight: 800; color: #111827; display: flex; align-items: center; gap: 6px;">
            <span>محمد أحمد</span>
            <span style="color: #10B981; font-size: 14px;" title="موثق">✓</span>
          </div>
        </div>
      </div>
      <div style="display: flex; gap: 8px;">
        <!-- Notification Button -->
        <div style="width: 40px; height: 40px; border-radius: 12px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center; position: relative;">
          <svg width="20" height="20" fill="var(--primary)" viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.63-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.64 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
          <div style="width: 8px; height: 8px; background: #DC2626; border-radius: 50%; position: absolute; top: 8px; right: 8px; border: 1.5px solid #fff;"></div>
        </div>
        <!-- QR Scan Button -->
        <div style="width: 40px; height: 40px; border-radius: 12px; background: linear-gradient(135deg, #FBBF24 0%, #F59E0B 100%); display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(245,158,11,0.3);">
          <svg width="20" height="20" fill="#451A03" viewBox="0 0 24 24"><path d="M4 4h6v6H4zm2 2v2h2V6zm8-2h6v6h-6zm2 2v2h2V6zM4 14h6v6H4zm2 2v2h2v-2zm10 0h2v2h-2zm-2-2h2v2h-2zm4 4h2v2h-2zm-2 2h2v2h-2zm2-4h2v2h-2zm-4-2h2v2h-2z"/></svg>
        </div>
      </div>
    </div>

    <!-- Main Gradient Balance Card -->
    <div style="background: linear-gradient(135deg, #B8282E 0%, #9E1B21 50%, #7A1015 100%); border-radius: 22px; padding: 22px 20px; color: white; position: relative; overflow: hidden; box-shadow: 0 14px 32px rgba(158,27,33,0.38);">
      <!-- Background Star Pattern / Watermark -->
      <div style="position: absolute; left: -25px; bottom: -35px; opacity: 0.08;">
        <svg width="180" height="180" viewBox="0 0 24 24" fill="white"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
      </div>

      <!-- Top Row: Balance Label + Eye Icon + Account Status Badge -->
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <div style="display: flex; align-items: center; gap: 8px;">
          <span style="font-size: 13px; color: rgba(255,255,255,0.85); font-weight: 600;">الرصيد المتاح</span>
          <!-- Eye Toggle Button (إخفاء / إظهار الرصيد) -->
          <div style="width: 28px; height: 28px; border-radius: 8px; background: rgba(255,255,255,0.18); display: flex; align-items: center; justify-content: center; cursor: pointer; transition: background 0.2s;" title="إخفاء / إظهار الرصيد">
            <svg width="16" height="16" fill="white" viewBox="0 0 24 24"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
          </div>
        </div>
        <div style="display: flex; align-items: center; gap: 6px; background: rgba(255,255,255,0.18); backdrop-filter: blur(8px); border-radius: 10px; padding: 4px 10px; font-size: 11px; font-weight: 700; color: #FFF;">
          <span style="width: 6px; height: 6px; background: #34D399; border-radius: 50%; display: inline-block;"></span>
          <span>حساب نشط</span>
        </div>
      </div>

      <!-- Center: Formatted Harmonious Amount & Currency Badge -->
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
        <div style="display: flex; align-items: baseline; gap: 10px;">
          <span style="font-size: 34px; font-weight: 900; letter-spacing: -0.5px; font-family: 'Cairo', sans-serif;">2,850,400.00</span>
        </div>
        <span class="badge-gold" style="font-size: 12px; padding: 5px 12px; box-shadow: 0 4px 12px rgba(245,158,11,0.3);">
          YER ريال يمني
        </span>
      </div>

      <!-- Bottom Row: Account Number + Quick Mini Actions (تحويل سريع وكشف حساب) -->
      <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 14px; border-top: 1px solid rgba(255,255,255,0.18);">
        <div style="display: flex; align-items: center; gap: 6px;">
          <span style="font-size: 12px; color: rgba(255,255,255,0.75);">رقم الحساب:</span>
          <span style="font-size: 13px; color: #FFFFFF; font-family: monospace; font-weight: 700; letter-spacing: 0.5px;">967-8841-2094</span>
        </div>
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="display: flex; align-items: center; gap: 4px; font-size: 12px; color: #FDE047; font-weight: 700; cursor: pointer;">
            <span>كشف حساب</span>
            <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M10 17l5-5-5-5v10z"/></svg>
          </div>
        </div>
      </div>
    </div>

    <!-- Interactive Al-Najm Mascot Banner (شخصية النجم الرسمية بالزي اليمني) -->
    <div style="margin-top: 14px; background: linear-gradient(135deg, #FFFFFF 0%, #FFFBEB 100%); border-radius: 18px; padding: 12px 14px; border: 1.5px solid #FDE68A; box-shadow: 0 4px 15px rgba(245,158,11,0.12); display: flex; align-items: center; gap: 14px; position: relative; overflow: hidden;">
      <div style="position: absolute; left: -10px; top: -10px; width: 60px; height: 60px; background: radial-gradient(circle, rgba(245,158,11,0.15) 0%, transparent 70%);"></div>
      <div style="width: 58px; height: 58px; border-radius: 14px; overflow: hidden; border: 2px solid #F59E0B; flex-shrink: 0; box-shadow: 0 4px 10px rgba(0,0,0,0.1); background: #fff;">
        <img src="${mascotYemeni}" alt="شخصية النجم" style="width: 100%; height: 100%; object-fit: cover;">
      </div>
      <div style="flex: 1;">
        <div style="display: flex; align-items: center; gap: 6px; margin-bottom: 2px;">
          <span style="font-size: 13px; font-weight: 800; color: #9E1B21;">شخصية النجم ترحب بك!</span>
          <span style="background: #DCFCE7; color: #166534; font-size: 9px; font-weight: 800; padding: 2px 6px; border-radius: 6px;">تم التحويل ✓</span>
        </div>
        <div style="font-size: 11px; color: #4B5563; font-weight: 600; line-height: 1.4;">
          مع محفظة النجم.. حوالتك تصل بلمح البصر وبأمان تام إلى كل أنحاء اليمن!
        </div>
      </div>
    </div>

    <!-- Quick Services Grid (شبيه بجيب وأفضل التطبيقات المصرفية) -->
    <div style="margin-top: 20px;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <h4 style="font-size: 15px; font-weight: 800; color: #111827;">الخدمات والمعاملات</h4>
        <span style="font-size: 12px; font-weight: 700; color: var(--primary); cursor: pointer;">عرض الكل</span>
      </div>

      <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px;">
        <!-- Service 1: Send Money -->
        <div style="background: #fff; border-radius: 16px; padding: 14px 6px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1px solid #E5E7EB; box-shadow: 0 2px 6px rgba(0,0,0,0.02); cursor: pointer;">
          <div style="width: 44px; height: 44px; border-radius: 12px; background: #FEE2E2; display: flex; align-items: center; justify-content: center;">
            <svg width="22" height="22" fill="var(--primary)" viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
          </div>
          <span style="font-size: 11px; font-weight: 700; color: #374151;">إرسال حوالة</span>
        </div>

        <!-- Service 2: Receive Money -->
        <div style="background: #fff; border-radius: 16px; padding: 14px 6px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1px solid #E5E7EB; box-shadow: 0 2px 6px rgba(0,0,0,0.02); cursor: pointer;">
          <div style="width: 44px; height: 44px; border-radius: 12px; background: #FEF3C7; display: flex; align-items: center; justify-content: center;">
            <svg width="22" height="22" fill="#D97706" viewBox="0 0 24 24"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>
          </div>
          <span style="font-size: 11px; font-weight: 700; color: #374151;">استلام حوالة</span>
        </div>

        <!-- Service 3: Recharge & Pay -->
        <div style="background: #fff; border-radius: 16px; padding: 14px 6px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1px solid #E5E7EB; box-shadow: 0 2px 6px rgba(0,0,0,0.02); cursor: pointer;">
          <div style="width: 44px; height: 44px; border-radius: 12px; background: #DCFCE7; display: flex; align-items: center; justify-content: center;">
            <svg width="22" height="22" fill="#15803D" viewBox="0 0 24 24"><path d="M11 17h2v-1h1c.55 0 1-.45 1-1v-3c0-.55-.45-1-1-1h-3v-1h4V8h-2V7h-2v1h-1c-.55 0-1 .45-1 1v3c0 .55.45 1 1 1h3v1H9v2h2v1zm9-13H4c-1.11 0-1.99.89-1.99 2L2 18c0 1.11.89 2 2 2h16c1.1 0 2-.89 2-2V6c0-1.11-.9-2-2-2zm0 14H4V6h16v12z"/></svg>
          </div>
          <span style="font-size: 11px; font-weight: 700; color: #374151;">شحن وسداد</span>
        </div>

        <!-- Service 4: Currency Exchange (زر تحويل العملات المطور) -->
        <div style="background: #fff; border-radius: 16px; padding: 14px 6px; display: flex; flex-direction: column; align-items: center; gap: 8px; border: 1.5px solid #BFDBFE; box-shadow: 0 4px 10px rgba(37,99,235,0.06); cursor: pointer; position: relative;">
          <div style="position: absolute; top: -6px; left: 50%; transform: translateX(-50%); background: #2563EB; color: white; font-size: 8px; font-weight: 800; padding: 1px 6px; border-radius: 6px; white-space: nowrap;">
            لحظي
          </div>
          <div style="width: 44px; height: 44px; border-radius: 12px; background: linear-gradient(135deg, #DBEAFE 0%, #BFDBFE 100%); display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(37,99,235,0.15);">
            <svg width="24" height="24" fill="#1D4ED8" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9v-2h2v2zm0-4H9V7h2v5zm4 4h-2v-5h2v5zm0-7h-2V7h2v2z"/><path d="M6.99 11L3 15l3.99 4v-3H14v-2H6.99v-3zM21 9l-3.99-4v3H10v2h7.01v3L21 9z" fill="#2563EB"/></svg>
          </div>
          <span style="font-size: 11px; font-weight: 800; color: #1E40AF;">تحويل العملات</span>
        </div>
      </div>
    </div>

    <!-- Recent Transactions List -->
    <div style="margin-top: 22px;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <h4 style="font-size: 15px; font-weight: 800; color: #111827;">آخر العمليات</h4>
        <span style="font-size: 12px; font-weight: 700; color: var(--primary); cursor: pointer;">عرض السجل</span>
      </div>

      <div style="display: flex; flex-direction: column; gap: 10px;">
        <!-- Tx 1: Deposit -->
        <div style="background: #fff; border-radius: 14px; padding: 12px 14px; display: flex; align-items: center; justify-content: space-between; border: 1px solid #E5E7EB;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <div style="width: 40px; height: 40px; border-radius: 10px; background: #DCFCE7; display: flex; align-items: center; justify-content: center;">
              <svg width="20" height="20" fill="#15803D" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
            </div>
            <div>
              <div style="font-size: 13px; font-weight: 800; color: #111827;">إيداع نقدي عبر فرع النجم</div>
              <div style="font-size: 11px; color: #9CA3AF;">اليوم، 09:15 ص — سند #449102</div>
            </div>
          </div>
          <div style="text-align: left;">
            <div style="font-size: 14px; font-weight: 800; color: #10B981;">+150,000 YER</div>
            <div style="font-size: 10px; color: #10B981; font-weight: 700;">مكتملة ✓</div>
          </div>
        </div>

        <!-- Tx 2: Outgoing Transfer -->
        <div style="background: #fff; border-radius: 14px; padding: 12px 14px; display: flex; align-items: center; justify-content: space-between; border: 1px solid #E5E7EB;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <div style="width: 40px; height: 40px; border-radius: 10px; background: #FEE2E2; display: flex; align-items: center; justify-content: center;">
              <svg width="20" height="20" fill="var(--primary)" viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
            </div>
            <div>
              <div style="font-size: 13px; font-weight: 800; color: #111827;">حوالة صادرة إلى سالم سالم</div>
              <div style="font-size: 11px; color: #9CA3AF;">أمس، 05:40 م — حوالة بلس</div>
            </div>
          </div>
          <div style="text-align: left;">
            <div style="font-size: 14px; font-weight: 800; color: #DC2626;">-45,000 YER</div>
            <div style="font-size: 10px; color: #6B7280; font-weight: 700;">مستلمة ✓</div>
          </div>
        </div>

        <!-- Tx 3: Bill Pay -->
        <div style="background: #fff; border-radius: 14px; padding: 12px 14px; display: flex; align-items: center; justify-content: space-between; border: 1px solid #E5E7EB;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <div style="width: 40px; height: 40px; border-radius: 10px; background: #FEF3C7; display: flex; align-items: center; justify-content: center;">
              <svg width="20" height="20" fill="#D97706" viewBox="0 0 24 24"><path d="M12 2c-5.52 0-10 4.48-10 10s4.48 10 10 10 10-4.48 10-10-4.48-10-10-10zm1 14h-2v-2h2v2zm0-4h-2V7h2v5z"/></svg>
            </div>
            <div>
              <div style="font-size: 13px; font-weight: 800; color: #111827;">سداد باقة يمن موبايل 4G</div>
              <div style="font-size: 11px; color: #9CA3AF;">08 أكتوبر، 02:10 م</div>
            </div>
          </div>
          <div style="text-align: left;">
            <div style="font-size: 14px; font-weight: 800; color: #111827;">-8,500 YER</div>
            <div style="font-size: 10px; color: #10B981; font-weight: 700;">ناجحة ✓</div>
          </div>
        </div>
      </div>
    </div>
  </div>
`, false, 0);

// -------------------------------------------------------------
// Screen 4: Wallet Screen (المحفظة وتعدد العملات)
// -------------------------------------------------------------
const screenWalletHtml = wrapScreen('المحفظة - النجم بلس', `
  <div style="padding: 16px;">
    <!-- Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
      <h3 style="font-size: 18px; font-weight: 800; color: #111827;">المحفظة والحسابات</h3>
      <div class="badge-gold">
        <svg width="14" height="14" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
        <span>متعدد العملات</span>
      </div>
    </div>

    <!-- Currency Cards Carousel / Stack -->
    <div style="display: flex; flex-direction: column; gap: 12px;">
      <!-- Card 1: YER -->
      <div style="background: linear-gradient(135deg, #B8282E 0%, #9E1B21 60%, #7A1015 100%); border-radius: 18px; padding: 18px; color: white; box-shadow: 0 8px 20px rgba(158,27,33,0.3);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 20px;">🇾🇪</span>
            <span style="font-weight: 800; font-size: 15px;">الريال اليمني (YER)</span>
          </div>
          <span style="font-size: 11px; background: rgba(255,255,255,0.2); padding: 3px 8px; border-radius: 6px; font-weight: 700;">أساسي</span>
        </div>
        <div style="font-size: 26px; font-weight: 900; margin: 12px 0 6px 0;">2,850,400.00 YER</div>
        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: rgba(255,255,255,0.8);">
          <span>IBAN: YE96 7001 8841 2094</span>
          <span style="color: #FDE047; font-weight: 700; cursor: pointer;">نسخ</span>
        </div>
      </div>

      <!-- Card 2: SAR -->
      <div style="background: linear-gradient(135deg, #D97706 0%, #B45309 60%, #78350F 100%); border-radius: 18px; padding: 18px; color: white; box-shadow: 0 8px 20px rgba(180,83,9,0.25);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 20px;">🇸🇦</span>
            <span style="font-weight: 800; font-size: 15px;">الريال السعودي (SAR)</span>
          </div>
          <span style="font-size: 11px; background: rgba(255,255,255,0.2); padding: 3px 8px; border-radius: 6px; font-weight: 700;">مفعل</span>
        </div>
        <div style="font-size: 26px; font-weight: 900; margin: 12px 0 6px 0;">5,420.00 SAR</div>
        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: rgba(255,255,255,0.8);">
          <span>IBAN: SA44 8000 9921 5420</span>
          <span style="color: #FDE047; font-weight: 700; cursor: pointer;">نسخ</span>
        </div>
      </div>

      <!-- Card 3: USD -->
      <div style="background: linear-gradient(135deg, #059669 0%, #047857 60%, #064E3B 100%); border-radius: 18px; padding: 18px; color: white; box-shadow: 0 8px 20px rgba(5,150,105,0.25);">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="display: flex; align-items: center; gap: 8px;">
            <span style="font-size: 20px;">🇺🇸</span>
            <span style="font-weight: 800; font-size: 15px;">الدولار الأمريكي (USD)</span>
          </div>
          <span style="font-size: 11px; background: rgba(255,255,255,0.2); padding: 3px 8px; border-radius: 6px; font-weight: 700;">مفعل</span>
        </div>
        <div style="font-size: 26px; font-weight: 900; margin: 12px 0 6px 0;">1,250.00 USD</div>
        <div style="display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: rgba(255,255,255,0.8);">
          <span>ACC: US89 1250 4402 1109</span>
          <span style="color: #A7F3D0; font-weight: 700; cursor: pointer;">نسخ</span>
        </div>
      </div>
    </div>

    <!-- Live Exchange Rates Table -->
    <div style="background: #fff; border-radius: 16px; padding: 16px; margin-top: 18px; border: 1px solid #E5E7EB;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <h4 style="font-size: 14px; font-weight: 800; color: #111827;">أسعار الصرف الرسمية — النجم للصرافة</h4>
        <span style="font-size: 10px; color: #10B981; font-weight: 700;">محدث لحظياً ●</span>
      </div>
      <div style="display: flex; justify-content: space-between; font-size: 12px; padding: 8px 0; border-bottom: 1px solid #F3F4F6;">
        <span style="font-weight: 700; color: #374151;">1 ريال سعودي (SAR)</span>
        <span style="font-weight: 800; color: var(--primary);">شراء: 535 | بيع: 537 YER</span>
      </div>
      <div style="display: flex; justify-content: space-between; font-size: 12px; padding: 8px 0;">
        <span style="font-weight: 700; color: #374151;">1 دولار أمريكي (USD)</span>
        <span style="font-weight: 800; color: var(--primary);">شراء: 2,040 | بيع: 2,048 YER</span>
      </div>
    </div>
  </div>
`, false, 1);

// -------------------------------------------------------------
// Screen 5: Transfer / Send Money (إرسال حوالة مالية)
// -------------------------------------------------------------
const screenTransferHtml = wrapScreen('إرسال حوالة - النجم بلس', `
  <div style="padding: 18px;">
    <!-- Header -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px;">
      <div style="width: 36px; height: 36px; border-radius: 10px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center;">
        <svg width="18" height="18" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>
      <h3 style="font-size: 17px; font-weight: 800; color: #111827;">إرسال حوالة جديدة</h3>
      <div style="width: 36px;"></div>
    </div>

    <!-- Transfer Method Tabs -->
    <div style="display: flex; background: #E5E7EB; padding: 4px; border-radius: 12px; margin-bottom: 18px;">
      <div style="flex: 1; text-align: center; padding: 8px; border-radius: 10px; background: #fff; font-size: 12px; font-weight: 800; color: var(--primary); box-shadow: 0 2px 4px rgba(0,0,0,0.06);">
        حوالة شبكة النجم
      </div>
      <div style="flex: 1; text-align: center; padding: 8px; border-radius: 10px; font-size: 12px; font-weight: 700; color: #6B7280;">
        إلى محفظة جوال
      </div>
      <div style="flex: 1; text-align: center; padding: 8px; border-radius: 10px; font-size: 12px; font-weight: 700; color: #6B7280;">
        حساب بنكي
      </div>
    </div>

    <!-- Transfer Form -->
    <div style="display: flex; flex-direction: column; gap: 14px;">
      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">اسم المستلم الرباعي</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <input type="text" value="أحمد عبد العزيز قاسم اليماني" style="border: none; outline: none; flex: 1; font-size: 14px; font-weight: 600;" readonly>
        </div>
      </div>

      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">رقم هاتف المستلم</label>
        <div style="display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
          <span style="font-size: 12px; font-weight: 700; color: var(--primary); padding-left: 8px; border-left: 1px solid #E5E7EB; direction: ltr;">+967</span>
          <input type="text" value="733 456 789" style="border: none; outline: none; flex: 1; padding: 0 8px; font-size: 14px; font-weight: 600;" readonly>
        </div>
      </div>

      <!-- Currency & Amount -->
      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 5px;">المبلغ والعملة</label>
        <div style="display: flex; gap: 8px;">
          <div style="flex: 2; display: flex; align-items: center; background: #fff; border: 1.5px solid #E5E7EB; border-radius: 12px; padding: 0 14px; height: 48px;">
            <input type="text" value="50,000" style="border: none; outline: none; flex: 1; font-size: 18px; font-weight: 800; color: var(--primary);" readonly>
          </div>
          <div style="flex: 1; display: flex; align-items: center; justify-content: center; background: #FFF5F5; border: 1.5px solid #FFE4E6; border-radius: 12px; font-weight: 800; font-size: 13px; color: var(--primary);">
            YER يمني
          </div>
        </div>
      </div>

      <!-- Summary Box -->
      <div style="background: #F8FAFC; border: 1px solid #E2E8F0; border-radius: 14px; padding: 14px; margin-top: 6px;">
        <div style="display: flex; justify-content: space-between; font-size: 12px; color: #64748B; margin-bottom: 6px;">
          <span>المبلغ المرسل:</span>
          <span style="font-weight: 700; color: #1E293B;">50,000 YER</span>
        </div>
        <div style="display: flex; justify-content: space-between; font-size: 12px; color: #64748B; margin-bottom: 6px;">
          <span>رسوم التحويل:</span>
          <span style="font-weight: 700; color: #10B981;">مجاناً (عرض ترويجي)</span>
        </div>
        <div style="display: flex; justify-content: space-between; font-size: 13px; color: #1E293B; font-weight: 800; padding-top: 8px; border-top: 1px dashed #CBD5E1;">
          <span>الإجمالي المخصوم:</span>
          <span style="color: var(--primary); font-size: 15px;">50,000 YER</span>
        </div>
      </div>

      <button class="btn-primary" style="margin-top: 8px;">
        <span>تأكيد وإرسال الحوالة فوراً</span>
        <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
      </button>
    </div>
  </div>
`, false, 0);

// -------------------------------------------------------------
// Screen 6: Transactions History (سجل الحوالات)
// -------------------------------------------------------------
const screenTransactionsHtml = wrapScreen('العمليات - النجم بلس', `
  <div style="padding: 16px;">
    <!-- Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
      <h3 style="font-size: 18px; font-weight: 800; color: #111827;">سجل العمليات والحوالات</h3>
      <div style="width: 36px; height: 36px; border-radius: 10px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center;">
        <svg width="18" height="18" fill="#374151" viewBox="0 0 24 24"><path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/></svg>
      </div>
    </div>

    <!-- Filter Chips -->
    <div style="display: flex; gap: 8px; overflow-x: auto; padding-bottom: 8px; margin-bottom: 12px; scrollbar-width: none;">
      <div style="background: var(--primary); color: white; padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 700; white-space: nowrap;">الكل (24)</div>
      <div style="background: #fff; color: #4B5563; border: 1px solid #E5E7EB; padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; white-space: nowrap;">حوالات صادرة</div>
      <div style="background: #fff; color: #4B5563; border: 1px solid #E5E7EB; padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; white-space: nowrap;">حوالات واردة</div>
      <div style="background: #fff; color: #4B5563; border: 1px solid #E5E7EB; padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; white-space: nowrap;">إيداع وسحب</div>
    </div>

    <!-- Transactions List -->
    <div style="display: flex; flex-direction: column; gap: 10px;">
      <!-- Item 1 -->
      <div style="background: #fff; border-radius: 14px; padding: 14px; border: 1px solid #E5E7EB; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
          <div>
            <div style="font-size: 14px; font-weight: 800; color: #111827;">إرسال حوالة — أحمد اليماني</div>
            <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">رقم السند: <span style="font-family: monospace; font-weight: 700; color: #111827;">TRX-994012</span></div>
          </div>
          <span style="font-size: 15px; font-weight: 900; color: #DC2626;">-50,000 YER</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 8px; border-top: 1px solid #F3F4F6; font-size: 11px;">
          <span style="color: #9CA3AF;">اليوم، 10:45 ص</span>
          <span style="color: #10B981; font-weight: 700; background: #DCFCE7; padding: 2px 8px; border-radius: 6px;">مكتملة ✓</span>
        </div>
      </div>

      <!-- Item 2 -->
      <div style="background: #fff; border-radius: 14px; padding: 14px; border: 1px solid #E5E7EB; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
          <div>
            <div style="font-size: 14px; font-weight: 800; color: #111827;">استلام حوالة خارجية — الرياض</div>
            <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">رقم السند: <span style="font-family: monospace; font-weight: 700; color: #111827;">SAR-882041</span></div>
          </div>
          <span style="font-size: 15px; font-weight: 900; color: #10B981;">+1,500 SAR</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 8px; border-top: 1px solid #F3F4F6; font-size: 11px;">
          <span style="color: #9CA3AF;">أمس، 04:20 م</span>
          <span style="color: #10B981; font-weight: 700; background: #DCFCE7; padding: 2px 8px; border-radius: 6px;">في المحفظة ✓</span>
        </div>
      </div>

      <!-- Item 3 -->
      <div style="background: #fff; border-radius: 14px; padding: 14px; border: 1px solid #E5E7EB; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
          <div>
            <div style="font-size: 14px; font-weight: 800; color: #111827;">إيداع نقدي — فرع الزبيري</div>
            <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">رقم السند: <span style="font-family: monospace; font-weight: 700; color: #111827;">DEP-102938</span></div>
          </div>
          <span style="font-size: 15px; font-weight: 900; color: #10B981;">+300,000 YER</span>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 8px; border-top: 1px solid #F3F4F6; font-size: 11px;">
          <span style="color: #9CA3AF;">09 أكتوبر، 11:00 ص</span>
          <span style="color: #10B981; font-weight: 700; background: #DCFCE7; padding: 2px 8px; border-radius: 6px;">مكتملة ✓</span>
        </div>
      </div>
    </div>
  </div>
`, false, 2);

// -------------------------------------------------------------
// Screen 7: Profile Screen (الملف الشخصي والإعدادات)
// -------------------------------------------------------------
const screenProfileHtml = wrapScreen('حسابي - النجم بلس', `
  <div style="padding: 16px;">
    <!-- Profile Card -->
    <div style="background: #fff; border-radius: 20px; padding: 20px; text-align: center; border: 1px solid #E5E7EB; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 16px;">
      <div style="width: 76px; height: 76px; border-radius: 50%; background: linear-gradient(135deg, #B8282E 0%, #9E1B21 100%); margin: 0 auto 12px auto; display: flex; align-items: center; justify-content: center; color: white; font-size: 28px; font-weight: 900; border: 3px solid #FFF; box-shadow: 0 6px 14px rgba(158,27,33,0.3);">
        م
      </div>
      <h3 style="font-size: 17px; font-weight: 800; color: #111827;">محمد أحمد عبد الله النجم</h3>
      <div style="font-size: 12px; color: #6B7280; margin-top: 2px;">+967 777 123 456</div>
      <div style="display: inline-flex; align-items: center; gap: 6px; background: #ECFDF5; border: 1px solid #A7F3D0; color: #065F46; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 800; margin-top: 10px;">
        <span>حساب موثق بالهوية (Tier 2)</span>
        <span>✓</span>
      </div>
    </div>

    <!-- Settings List -->
    <div style="background: #fff; border-radius: 18px; border: 1px solid #E5E7EB; overflow: hidden;">
      <!-- Item 1 -->
      <div style="display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid #F3F4F6;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 36px; height: 36px; border-radius: 10px; background: #FEE2E2; display: flex; align-items: center; justify-content: center;">
            <svg width="18" height="18" fill="var(--primary)" viewBox="0 0 24 24"><path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/></svg>
          </div>
          <div>
            <div style="font-size: 13px; font-weight: 700; color: #111827;">الأمان وكلمة المرور</div>
            <div style="font-size: 11px; color: #9CA3AF;">تغيير PIN، تفعيل البصمة</div>
          </div>
        </div>
        <svg width="16" height="16" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>

      <!-- Item 2 -->
      <div style="display: flex; align-items: center; justify-content: space-between; padding: 14px 16px; border-bottom: 1px solid #F3F4F6;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 36px; height: 36px; border-radius: 10px; background: #FEF3C7; display: flex; align-items: center; justify-content: center;">
            <svg width="18" height="18" fill="#D97706" viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
          </div>
          <div>
            <div style="font-size: 13px; font-weight: 700; color: #111827;">خدمة العملاء والدعم الفني</div>
            <div style="font-size: 11px; color: #9CA3AF;">الرقم المجاني: 8000004</div>
          </div>
        </div>
        <svg width="16" height="16" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>

      <!-- Item 3 -->
      <div style="display: flex; align-items: center; justify-content: space-between; padding: 14px 16px;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 36px; height: 36px; border-radius: 10px; background: #F3F4F6; display: flex; align-items: center; justify-content: center;">
            <svg width="18" height="18" fill="#4B5563" viewBox="0 0 24 24"><path d="M13 3h-2v10h2V3zm4.83 2.17l-1.42 1.42C17.99 7.86 19 9.81 19 12c0 3.87-3.13 7-7 7s-7-3.13-7-7c0-2.19 1.01-4.14 2.58-5.42L6.17 5.17C4.23 6.82 3 9.26 3 12c0 4.97 4.03 9 9 9s9-4.03 9-9c0-2.74-1.23-5.18-3.17-6.83z"/></svg>
          </div>
          <div style="font-size: 13px; font-weight: 700; color: #DC2626;">تسجيل الخروج</div>
        </div>
        <svg width="16" height="16" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>
    </div>

    <!-- App Version & Info -->
    <div style="text-align: center; margin-top: 24px; color: #9CA3AF; font-size: 11px;">
      <div>تطبيق النجم بلس — الإصدار 1.0.0 (بناء 24)</div>
      <div style="margin-top: 4px;">شركة النجم للحوالات والصرافة © 2026</div>
    </div>
  </div>
`, false, 3);

// -------------------------------------------------------------
// Screen 8: QR Scanner Screen (مسح رمز الاستجابة السريعة)
// -------------------------------------------------------------
const screenQrHtml = wrapScreen('مسح رمز QR - النجم بلس', `
  <div style="padding: 20px; display: flex; flex-direction: column; justify-content: space-between; height: 100%; color: white;">
    <!-- Top Controls -->
    <div style="display: flex; align-items: center; justify-content: space-between;">
      <div style="width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center;">
        <svg width="20" height="20" fill="white" viewBox="0 0 24 24"><path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/></svg>
      </div>
      <h3 style="font-size: 17px; font-weight: 800;">مسح رمز QR للدفع الفوري</h3>
      <div style="width: 40px; height: 40px; border-radius: 12px; background: rgba(255,255,255,0.15); display: flex; align-items: center; justify-content: center;">
        <svg width="20" height="20" fill="white" viewBox="0 0 24 24"><path d="M7 2v11h3v9l7-12h-4l4-8z"/></svg>
      </div>
    </div>

    <!-- Scanner Target Box -->
    <div style="display: flex; flex-direction: column; align-items: center;">
      <div style="width: 250px; height: 250px; border-radius: 28px; position: relative; border: 2px dashed rgba(255,255,255,0.4); display: flex; align-items: center; justify-content: center; box-shadow: 0 0 35px rgba(245,158,11,0.25);">
        <!-- Glowing Corners -->
        <div style="position: absolute; top: -2px; right: -2px; width: 35px; height: 35px; border-top: 5px solid #F59E0B; border-right: 5px solid #F59E0B; border-top-right-radius: 24px;"></div>
        <div style="position: absolute; top: -2px; left: -2px; width: 35px; height: 35px; border-top: 5px solid #F59E0B; border-left: 5px solid #F59E0B; border-top-left-radius: 24px;"></div>
        <div style="position: absolute; bottom: -2px; right: -2px; width: 35px; height: 35px; border-bottom: 5px solid #F59E0B; border-right: 5px solid #F59E0B; border-bottom-right-radius: 24px;"></div>
        <div style="position: absolute; bottom: -2px; left: -2px; width: 35px; height: 35px; border-bottom: 5px solid #F59E0B; border-left: 5px solid #F59E0B; border-bottom-left-radius: 24px;"></div>

        <!-- Laser Scanner Bar -->
        <div style="position: absolute; top: 45%; left: 15px; right: 15px; height: 3px; background: linear-gradient(90deg, transparent, #F59E0B, #FFF, #F59E0B, transparent); box-shadow: 0 0 12px #F59E0B;"></div>

        <svg width="60" height="60" fill="rgba(255,255,255,0.3)" viewBox="0 0 24 24"><path d="M4 4h6v6H4zm2 2v2h2V6zm8-2h6v6h-6zm2 2v2h2V6zM4 14h6v6H4zm2 2v2h2v-2zm10 0h2v2h-2zm-2-2h2v2h-2zm4 4h2v2h-2zm-2 2h2v2h-2zm2-4h2v2h-2zm-4-2h2v2h-2z"/></svg>
      </div>

      <p style="font-size: 13px; color: #E5E7EB; margin-top: 24px; text-align: center; max-width: 240px; line-height: 1.5;">
        وجّه الكاميرا نحو رمز QR الخاص بالتاجر أو المحفظة للتحويل والدفع الفوري
      </p>
    </div>

    <!-- Bottom Actions -->
    <div style="display: flex; justify-content: center; gap: 16px; margin-bottom: 10px;">
      <div style="background: rgba(255,255,255,0.15); backdrop-filter: blur(8px); padding: 10px 18px; border-radius: 14px; display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 700; cursor: pointer;">
        <svg width="18" height="18" fill="white" viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
        <span>تحميل من الاستوديو</span>
      </div>
      <div style="background: linear-gradient(135deg, #FBBF24 0%, #F59E0B 100%); color: #451A03; padding: 10px 18px; border-radius: 14px; display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 800; cursor: pointer;">
        <span>رمزي الخاص</span>
      </div>
    </div>
  </div>
`, true, 0);

// -------------------------------------------------------------
// Screen 9: KYC Verification Screen (التحقق من الهوية الرقمية)
// -------------------------------------------------------------
const screenKycHtml = wrapScreen('التحقق من الهوية - النجم بلس', `
  <div style="padding: 16px; display: flex; flex-direction: column; min-height: 100%; justify-content: space-between;">
    <div>
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
        <div style="width: 40px; height: 40px; border-radius: 12px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center; cursor: pointer;">
          <svg width="20" height="20" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
        </div>
        <h3 style="font-size: 17px; font-weight: 800; color: #111827;">توثيق الهوية (KYC)</h3>
        <div style="width: 40px;"></div>
      </div>

      <div style="background: #FFF; border-radius: 16px; padding: 14px 16px; border: 1px solid #E5E7EB; margin-bottom: 16px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
          <span style="font-size: 13px; font-weight: 800; color: #111827;">الخطوة 2 من 3: مسح بطاقة الهوية</span>
          <span style="font-size: 12px; font-weight: 700; color: var(--primary);">66% مكتمل</span>
        </div>
        <div style="height: 6px; background: #F3F4F6; border-radius: 6px; overflow: hidden;">
          <div style="width: 66%; height: 100%; background: linear-gradient(90deg, #F59E0B, #9E1B21); border-radius: 6px;"></div>
        </div>
      </div>

      <div style="background: #111827; border-radius: 22px; padding: 20px; position: relative; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.2); margin-bottom: 16px;">
        <div style="height: 180px; border: 2px dashed rgba(245,158,11,0.6); border-radius: 18px; position: relative; display: flex; flex-direction: column; align-items: center; justify-content: center; background: rgba(255,255,255,0.03);">
          <div style="position: absolute; top: -2px; right: -2px; width: 28px; height: 28px; border-top: 4px solid #F59E0B; border-right: 4px solid #F59E0B; border-top-right-radius: 14px;"></div>
          <div style="position: absolute; top: -2px; left: -2px; width: 28px; height: 28px; border-top: 4px solid #F59E0B; border-left: 4px solid #F59E0B; border-top-left-radius: 14px;"></div>
          <div style="position: absolute; bottom: -2px; right: -2px; width: 28px; height: 28px; border-bottom: 4px solid #F59E0B; border-right: 4px solid #F59E0B; border-bottom-right-radius: 14px;"></div>
          <div style="position: absolute; bottom: -2px; left: -2px; width: 28px; height: 28px; border-bottom: 4px solid #F59E0B; border-left: 4px solid #F59E0B; border-bottom-left-radius: 14px;"></div>

          <svg width="48" height="48" fill="#F59E0B" viewBox="0 0 24 24" style="opacity: 0.9; margin-bottom: 8px;"><path d="M20 4H4c-1.11 0-2 .89-2 2v12c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V6c0-1.11-.89-2-2-2zm0 14H4V6h16v12zm-6-2h4v-2h-4v2zm0-4h4V8h-4v4zm-8 4h6v-2H6v2zm0-4h6V8H6v4z"/></svg>
          <span style="font-size: 12px; color: #E5E7EB; font-weight: 700;">ضع الوجه الأمامي للبطاقة الذكية هنا</span>
        </div>

        <div style="display: flex; align-items: center; justify-content: center; gap: 8px; margin-top: 14px; color: #34D399; font-size: 12px; font-weight: 700;">
          <span style="width: 8px; height: 8px; background: #34D399; border-radius: 50%;"></span>
          <span>تم ضبط الإضاءة والمحاذاة بنجاح (AI OCR Ready)</span>
        </div>
      </div>

      <div style="background: #FEF2F2; border-radius: 16px; padding: 14px; border: 1px solid #FECACA; display: flex; gap: 12px; align-items: flex-start;">
        <svg width="22" height="22" fill="var(--primary)" viewBox="0 0 24 24" style="flex-shrink: 0;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>
        <div style="font-size: 12px; color: #991B1B; line-height: 1.5; font-weight: 600;">
          تأكد من وضوح الصورة وتجنب انعكاس الضوء على بطاقة الهوية أو الجواز لضمان قبول التوثيق الفوري.
        </div>
      </div>
    </div>

    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 20px;">
      <button style="background: linear-gradient(135deg, #B8282E 0%, #9E1B21 100%); color: white; border: none; border-radius: 16px; height: 52px; font-size: 15px; font-weight: 800; cursor: pointer; box-shadow: 0 6px 16px rgba(158,27,33,0.35);">
        التقاط صورة الهوية وتأكيد
      </button>
      <button style="background: #fff; color: #374151; border: 1.5px solid #E5E7EB; border-radius: 16px; height: 48px; font-size: 14px; font-weight: 700; cursor: pointer;">
        تحميل صورة واضحة من الهاتف
      </button>
    </div>
  </div>
`, false, -1);

// -------------------------------------------------------------
// Screen 10: Bill Payments & Recharge Screen (شحن وسداد الفواتير)
// -------------------------------------------------------------
const screenBillsHtml = wrapScreen('شحن وسداد الفواتير - النجم بلس', `
  <div style="padding: 16px; display: flex; flex-direction: column; min-height: 100%;">
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
      <div style="width: 40px; height: 40px; border-radius: 12px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center; cursor: pointer;">
        <svg width="20" height="20" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>
      <h3 style="font-size: 17px; font-weight: 800; color: #111827;">سداد الفواتير وشحن الرصيد</h3>
      <div style="width: 40px;"></div>
    </div>

    <div style="margin-bottom: 18px;">
      <h4 style="font-size: 13px; font-weight: 800; color: #6B7280; margin-bottom: 10px;">شركات الاتصالات والإنترنت</h4>
      <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px;">
        <div style="background: #FFF; border: 2px solid var(--primary); border-radius: 16px; padding: 12px 6px; text-align: center; box-shadow: 0 4px 10px rgba(158,27,33,0.1); cursor: pointer;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: #DC2626; color: white; display: flex; align-items: center; justify-content: center; margin: 0 auto 6px auto; font-weight: 900; font-size: 13px;">YM</div>
          <span style="font-size: 11px; font-weight: 800; color: #111827;">يمن موبايل</span>
        </div>
        <div style="background: #FFF; border: 1px solid #E5E7EB; border-radius: 16px; padding: 12px 6px; text-align: center; cursor: pointer;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: #16A34A; color: white; display: flex; align-items: center; justify-content: center; margin: 0 auto 6px auto; font-weight: 900; font-size: 13px;">SB</div>
          <span style="font-size: 11px; font-weight: 700; color: #4B5563;">سبأفون</span>
        </div>
        <div style="background: #FFF; border: 1px solid #E5E7EB; border-radius: 16px; padding: 12px 6px; text-align: center; cursor: pointer;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: #EAB308; color: #451A03; display: flex; align-items: center; justify-content: center; margin: 0 auto 6px auto; font-weight: 900; font-size: 13px;">YOU</div>
          <span style="font-size: 11px; font-weight: 700; color: #4B5563;">يو (YOU)</span>
        </div>
        <div style="background: #FFF; border: 1px solid #E5E7EB; border-radius: 16px; padding: 12px 6px; text-align: center; cursor: pointer;">
          <div style="width: 38px; height: 38px; border-radius: 10px; background: #0284C7; color: white; display: flex; align-items: center; justify-content: center; margin: 0 auto 6px auto; font-weight: 900; font-size: 13px;">NET</div>
          <span style="font-size: 11px; font-weight: 700; color: #4B5563;">يمن نت</span>
        </div>
      </div>
    </div>

    <div style="background: #FFF; border-radius: 20px; padding: 18px; border: 1px solid #E5E7EB; box-shadow: 0 4px 12px rgba(0,0,0,0.03); margin-bottom: 16px;">
      <div style="margin-bottom: 14px;">
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 6px;">نوع الباقة / الخدمة</label>
        <div style="display: flex; gap: 8px;">
          <button style="flex: 1; height: 38px; background: #FEE2E2; border: 1px solid #FCA5A5; color: var(--primary); font-size: 12px; font-weight: 800; border-radius: 10px;">رصيد مباشر</button>
          <button style="flex: 1; height: 38px; background: #F9FAFB; border: 1px solid #E5E7EB; color: #4B5563; font-size: 12px; font-weight: 700; border-radius: 10px;">باقات 4G مزايا</button>
          <button style="flex: 1; height: 38px; background: #F9FAFB; border: 1px solid #E5E7EB; color: #4B5563; font-size: 12px; font-weight: 700; border-radius: 10px;">سداد الفاتورة</button>
        </div>
      </div>

      <div style="margin-bottom: 14px;">
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 6px;">رقم الهاتف المراد شحنه</label>
        <div style="display: flex; align-items: center; background: #F9FAFB; border: 1.5px solid #E5E7EB; border-radius: 14px; padding: 0 14px; height: 48px;">
          <input type="text" value="777 982 410" style="border: none; background: transparent; outline: none; flex: 1; font-size: 15px; font-weight: 700; color: #111827;" readonly>
          <svg width="20" height="20" fill="var(--primary)" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
        </div>
      </div>

      <div>
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 6px;">مبلغ الشحن</label>
        <div style="display: flex; align-items: center; background: #F9FAFB; border: 1.5px solid #E5E7EB; border-radius: 14px; padding: 0 14px; height: 48px;">
          <input type="text" value="5,000" style="border: none; background: transparent; outline: none; flex: 1; font-size: 18px; font-weight: 800; color: var(--primary);" readonly>
          <span style="font-size: 13px; font-weight: 700; color: #6B7280;">ريال يمني</span>
        </div>
      </div>
    </div>

    <div style="background: #FFF; border-radius: 18px; padding: 14px 16px; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: space-between;">
      <div style="display: flex; align-items: center; gap: 12px;">
        <div style="width: 40px; height: 40px; border-radius: 12px; background: #DBEAFE; display: flex; align-items: center; justify-content: center;">
          <svg width="22" height="22" fill="#1D4ED8" viewBox="0 0 24 24"><path d="M12 2l-5.5 9h11zM12 22l5.5-9h-11z"/></svg>
        </div>
        <div>
          <div style="font-size: 13px; font-weight: 800; color: #111827;">فواتير الكهرباء والماء</div>
          <div style="font-size: 11px; color: #6B7280;">سداد عدادات الكهرباء والمياه الحكومية والتجارية</div>
        </div>
      </div>
      <svg width="18" height="18" fill="#9CA3AF" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
    </div>

    <div style="margin-top: auto; padding-top: 16px;">
      <button style="width: 100%; background: linear-gradient(135deg, #B8282E 0%, #9E1B21 100%); color: white; border: none; border-radius: 16px; height: 52px; font-size: 15px; font-weight: 800; cursor: pointer; box-shadow: 0 6px 16px rgba(158,27,33,0.35);">
        تأكيد الشحن الفوري (0 عمولة)
      </button>
    </div>
  </div>
`, false, 0);

// -------------------------------------------------------------
// Screen 11: Merchant Payment Screen (دفع مشتريات للمتاجر الذكية)
// -------------------------------------------------------------
const screenMerchantPayHtml = wrapScreen('دفع مشتريات - النجم بلس', `
  <div style="padding: 16px; display: flex; flex-direction: column; min-height: 100%; justify-content: space-between;">
    <div>
      <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
        <div style="width: 40px; height: 40px; border-radius: 12px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center; cursor: pointer;">
          <svg width="20" height="20" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
        </div>
        <h3 style="font-size: 17px; font-weight: 800; color: #111827;">دفع مشتريات لنقاط البيع</h3>
        <div style="width: 40px;"></div>
      </div>

      <div style="background: #FFF; border-radius: 20px; padding: 20px; border: 1.5px solid #FCA5A5; box-shadow: 0 6px 16px rgba(158,27,33,0.06); margin-bottom: 16px;">
        <div style="display: flex; align-items: center; gap: 14px;">
          <div style="width: 52px; height: 52px; border-radius: 14px; background: #FEE2E2; display: flex; align-items: center; justify-content: center; color: var(--primary);">
            <svg width="28" height="28" fill="currentColor" viewBox="0 0 24 24"><path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5h15c.83 0 1.5-.67 1.5-1.5s-.67-1.5-1.5-1.5h-15zM10.5 4.5C10.5 3.67 11.17 3 12 3s1.5.67 1.5 1.5v15c0 .83-.67 1.5-1.5 1.5s-1.5-.67-1.5-1.5v-15z"/></svg>
          </div>
          <div>
            <div style="font-size: 11px; color: #16A34A; font-weight: 800; background: #DCFCE7; padding: 2px 8px; border-radius: 6px; display: inline-block;">متجر معتمد ✓</div>
            <h3 style="font-size: 17px; font-weight: 900; color: #111827; margin-top: 4px;">صيدلية الأمل الحديثة</h3>
            <div style="font-size: 12px; color: #6B7280;">معرّف التاجر: #POS-98104 — شارع حدة، صنعاء</div>
          </div>
        </div>

        <div style="margin-top: 14px; padding-top: 12px; border-top: 1px dashed #E5E7EB; display: flex; align-items: center; gap: 8px; color: #059669; font-size: 12px; font-weight: 700;">
          <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
          <span>نتمنى لكم موفور الصحة والعافية وشفاءً عاجلاً 💊</span>
        </div>
      </div>

      <div style="background: #FFF; border-radius: 20px; padding: 20px; border: 1px solid #E5E7EB; box-shadow: 0 4px 12px rgba(0,0,0,0.02); margin-bottom: 16px;">
        <label style="display: block; font-size: 12px; font-weight: 700; color: #374151; margin-bottom: 8px;">مبلغ الفاتورة المطلوب دفعها</label>
        <div style="display: flex; align-items: baseline; justify-content: space-between; border-bottom: 2px solid var(--primary); padding-bottom: 8px;">
          <span style="font-size: 32px; font-weight: 900; color: #111827;">14,500</span>
          <span style="font-size: 14px; font-weight: 800; color: var(--primary);">ريال يمني (YER)</span>
        </div>
        <div style="display: flex; justify-content: space-between; margin-top: 10px; font-size: 12px; color: #6B7280;">
          <span>الرصيد المتاح: 2,850,400 ر.ي</span>
          <span style="color: #16A34A; font-weight: 700;">الرسوم: مجانية (0%)</span>
        </div>
      </div>
    </div>

    <div style="margin-top: 20px;">
      <button style="width: 100%; background: linear-gradient(135deg, #B8282E 0%, #9E1B21 100%); color: white; border: none; border-radius: 16px; height: 52px; font-size: 15px; font-weight: 800; cursor: pointer; box-shadow: 0 6px 16px rgba(158,27,33,0.35);">
        تأكيد الدفع الفوري للصيدلية
      </button>
    </div>
  </div>
`, false, 0);

// -------------------------------------------------------------
// Screen 12: Device & Session Security (إدارة الأجهزة والجلسات)
// -------------------------------------------------------------
const screenDeviceSecurityHtml = wrapScreen('إدارة الأجهزة - النجم بلس', `
  <div style="padding: 16px; display: flex; flex-direction: column; min-height: 100%;">
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
      <div style="width: 40px; height: 40px; border-radius: 12px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center; cursor: pointer;">
        <svg width="20" height="20" fill="#374151" viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
      </div>
      <h3 style="font-size: 17px; font-weight: 800; color: #111827;">الأجهزة والجلسات النشطة</h3>
      <div style="width: 40px;"></div>
    </div>

    <div style="background: linear-gradient(135deg, #1E293B 0%, #0F172A 100%); color: white; border-radius: 20px; padding: 20px; margin-bottom: 16px; box-shadow: 0 10px 24px rgba(0,0,0,0.15);">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
        <span style="font-size: 13px; color: #94A3B8; font-weight: 700;">حالة الأمان وضوابط الأجهزة</span>
        <span style="background: #10B981; color: white; font-size: 10px; font-weight: 800; padding: 3px 8px; border-radius: 6px;">حماية قصوى 🛡️</span>
      </div>
      <div style="font-size: 26px; font-weight: 900; margin-bottom: 4px;">2 / 3 أجهزة نشطة</div>
      <p style="font-size: 12px; color: #CBD5E1; line-height: 1.5;">
        مسموح بـ 3 أجهزة متزامنة كحد أقصى لحماية أموالك من الاختراق. (السجل التراكمي: 5 من أصل 10).
      </p>
    </div>

    <div style="display: flex; flex-direction: column; gap: 10px; margin-bottom: 16px;">
      <div style="background: #FFF; border-radius: 16px; padding: 14px 16px; border: 1.5px solid #10B981; display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 42px; height: 42px; border-radius: 12px; background: #DCFCE7; color: #15803D; display: flex; align-items: center; justify-content: center;">
            <svg width="22" height="22" fill="currentColor" viewBox="0 0 24 24"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>
          </div>
          <div>
            <div style="display: flex; align-items: center; gap: 6px;">
              <span style="font-size: 13px; font-weight: 800; color: #111827;">Samsung Galaxy S24 Ultra</span>
              <span style="font-size: 10px; background: #DCFCE7; color: #15803D; font-weight: 800; padding: 1px 6px; border-radius: 4px;">الجهاز الحالي</span>
            </div>
            <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">صنعاء، اليمن • نشط الآن • Android 14</div>
          </div>
        </div>
      </div>

      <div style="background: #FFF; border-radius: 16px; padding: 14px 16px; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center; gap: 12px;">
          <div style="width: 42px; height: 42px; border-radius: 12px; background: #F3F4F6; color: #4B5563; display: flex; align-items: center; justify-content: center;">
            <svg width="22" height="22" fill="currentColor" viewBox="0 0 24 24"><path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/></svg>
          </div>
          <div>
            <span style="font-size: 13px; font-weight: 800; color: #111827;">iPhone 15 Pro Max</span>
            <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">عدن، اليمن • آخر دخول: منذ ساعتين</div>
          </div>
        </div>
        <button style="background: #FEE2E2; color: #DC2626; border: none; padding: 6px 12px; border-radius: 8px; font-size: 11px; font-weight: 800; cursor: pointer;">
          إنهاء الجلسة
        </button>
      </div>
    </div>

    <div style="margin-top: auto; padding-top: 14px;">
      <button style="width: 100%; background: #FEE2E2; color: #DC2626; border: 1.5px solid #FCA5A5; border-radius: 16px; height: 50px; font-size: 14px; font-weight: 800; cursor: pointer;">
        🔒 تسجيل الخروج من كافة الأجهزة الأخرى فوراً
      </button>
    </div>
  </div>
`, false, 3);

// -------------------------------------------------------------
// Screen 13: Official Mascot Showcase (شخصية النجم الرسمية بالزي اليمني)
// -------------------------------------------------------------
const screenMascotShowcaseHtml = wrapScreen('شخصية النجم الرسمية - الهوية البصرية', `
  <div style="padding: 16px;">
    <!-- Top Bar -->
    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
      <div style="display: flex; align-items: center; gap: 8px;">
        <div style="width: 36px; height: 36px; border-radius: 10px; background: #fff; border: 1px solid #E5E7EB; display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" fill="var(--primary)" viewBox="0 0 24 24"><path d="M15.41 16.59L10.83 12l4.58-4.59L14 6l-6 6 6 6 1.41-1.41z"/></svg>
        </div>
        <h3 style="font-size: 16px; font-weight: 800; color: #111827;">شخصية النجم الرسمية</h3>
      </div>
      <span class="badge-gold" style="font-size: 11px; padding: 4px 10px;">التميمة المعتمدة</span>
    </div>

    <!-- Main Character Hero Card -->
    <div style="background: linear-gradient(135deg, #FFFDF8 0%, #FEF3C7 100%); border-radius: 24px; padding: 18px; border: 2px solid #F59E0B; box-shadow: 0 10px 25px rgba(245,158,11,0.15); text-align: center; position: relative; overflow: hidden; margin-bottom: 16px;">
      <div style="position: absolute; top: -20px; right: -20px; width: 90px; height: 90px; background: radial-gradient(circle, rgba(158,27,33,0.12) 0%, transparent 70%);"></div>
      
      <!-- Character Image Frame -->
      <div style="width: 200px; height: 200px; margin: 0 auto 14px auto; border-radius: 24px; overflow: hidden; box-shadow: 0 12px 30px rgba(0,0,0,0.15); border: 3px solid #FFFFFF;">
        <img src="${mascotYemeni}" alt="شخصية النجم بالزي اليمني" style="width: 100%; height: 100%; object-fit: cover;">
      </div>

      <div style="display: inline-block; background: #9E1B21; color: #FFFFFF; font-size: 11px; font-weight: 800; padding: 3px 12px; border-radius: 20px; margin-bottom: 6px;">
        التميمة الرسمية لمحفظة النجم
      </div>
      <h4 style="font-size: 17px; font-weight: 900; color: #111827; margin-bottom: 4px;">
        شاب يمني أصيل بالزي التراثي الفاخر
      </h4>
      <p style="font-size: 12px; color: #4B5563; line-height: 1.5; font-weight: 600; max-width: 320px; margin: 0 auto;">
        يرتدي الثوب والشال اليمني الأصيل والجنبية التراثية مع كوت كحلي أنيق، يحمل هاتفاً حديثاً يؤكد: <strong style="color: #059669;">«تم التحويل بواسطة محفظة النجم»</strong>
      </p>
    </div>

    <!-- Costume & Identity Attributes -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 16px;">
      <div style="background: #fff; border-radius: 14px; padding: 12px; border: 1px solid #E5E7EB;">
        <div style="font-size: 10px; font-weight: 700; color: #9CA3AF; margin-bottom: 3px;">الزي المعتمد</div>
        <div style="font-size: 12px; font-weight: 800; color: #111827;">ثوب وشال وجنبية يمنية</div>
      </div>
      <div style="background: #fff; border-radius: 14px; padding: 12px; border: 1px solid #E5E7EB;">
        <div style="font-size: 10px; font-weight: 700; color: #9CA3AF; margin-bottom: 3px;">الرسالة البصرية</div>
        <div style="font-size: 12px; font-weight: 800; color: #059669;">تم التحويل بضمان النجم</div>
      </div>
      <div style="background: #fff; border-radius: 14px; padding: 12px; border: 1px solid #E5E7EB;">
        <div style="font-size: 10px; font-weight: 700; color: #9CA3AF; margin-bottom: 3px;">قيم الشخصية</div>
        <div style="font-size: 12px; font-weight: 800; color: #9E1B21;">الأصالة، الثقة، والسرعة</div>
      </div>
      <div style="background: #fff; border-radius: 14px; padding: 12px; border: 1px solid #E5E7EB;">
        <div style="font-size: 10px; font-weight: 700; color: #9CA3AF; margin-bottom: 3px;">نمط التصميم</div>
        <div style="font-size: 12px; font-weight: 800; color: #D97706;">ثلاثي الأبعاد (3D Pixar)</div>
      </div>
    </div>

    <!-- Secondary Star Mascot Card -->
    <div style="background: #FFFFFF; border-radius: 18px; padding: 14px; border: 1px solid #E5E7EB; display: flex; align-items: center; gap: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.03);">
      <div style="width: 54px; height: 54px; border-radius: 14px; overflow: hidden; background: #FEF3C7; border: 1.5px solid #F59E0B; flex-shrink: 0;">
        <img src="${mascotStar}" alt="شخصية النجم الكرتونية" style="width: 100%; height: 100%; object-fit: cover;">
      </div>
      <div>
        <div style="font-size: 13px; font-weight: 800; color: #111827;">تميمة النجم الكرتونية الذهبية</div>
        <div style="font-size: 11px; color: #6B7280; margin-top: 2px;">تستخدم في إشعارات المكافآت ونقاط الولاء الترويجية</div>
      </div>
    </div>
  </div>
`, false, 0);

// -------------------------------------------------------------
// Screen 14: Transfer Success with Mascot (إشعار نجاح الحوالة مع الشخصية)
// -------------------------------------------------------------
const screenTransferSuccessHtml = wrapScreen('تم التحويل بنجاح - النجم بلس', `
  <div style="padding: 16px; text-align: center;">
    <!-- Mascot Celebration Card -->
    <div style="background: linear-gradient(135deg, #FFFFFF 0%, #F0FDF4 100%); border-radius: 24px; padding: 20px 18px; border: 2px solid #86EFAC; box-shadow: 0 12px 30px rgba(16,185,129,0.12); margin-top: 6px; margin-bottom: 16px; position: relative; overflow: hidden;">
      
      <!-- Mascot Image -->
      <div style="width: 110px; height: 110px; margin: 0 auto 10px auto; border-radius: 50%; overflow: hidden; border: 3px solid #10B981; box-shadow: 0 8px 20px rgba(16,185,129,0.25);">
        <img src="${mascotYemeni}" alt="شخصية النجم" style="width: 100%; height: 100%; object-fit: cover;">
      </div>

      <!-- Success Badge -->
      <div style="width: 38px; height: 38px; border-radius: 50%; background: #10B981; color: white; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: 900; margin: -26px auto 6px auto; border: 3px solid #fff; box-shadow: 0 4px 10px rgba(16,185,129,0.4);">
        ✓
      </div>

      <h3 style="font-size: 18px; font-weight: 900; color: #065F46; margin-bottom: 2px;">
        تم التحويل بنجاح!
      </h3>
      <div style="font-size: 12px; font-weight: 700; color: #047857; margin-bottom: 12px;">
        بواسطة محفظة النجم الفورية
      </div>

      <!-- Transfer Amount Display -->
      <div style="background: #FFFFFF; border-radius: 16px; padding: 12px; border: 1.5px solid #BBF7D0; margin-bottom: 12px;">
        <div style="font-size: 11px; color: #6B7280; font-weight: 700; margin-bottom: 2px;">المبلغ المحول</div>
        <div style="font-size: 26px; font-weight: 900; color: #9E1B21; font-family: 'Cairo', sans-serif;">
          150,000 <span style="font-size: 14px; font-weight: 800; color: #111827;">ريال يمني</span>
        </div>
      </div>

      <!-- Receipt Breakdown -->
      <div style="background: rgba(255,255,255,0.85); border-radius: 14px; padding: 12px; font-size: 11px; border: 1px solid #E5E7EB; text-align: right; display: flex; flex-direction: column; gap: 7px;">
        <div style="display: flex; justify-content: space-between;">
          <span style="color: #6B7280;">المستفيد:</span>
          <span style="font-weight: 800; color: #111827;">فؤاد صالح العولقي</span>
        </div>
        <div style="display: flex; justify-content: space-between;">
          <span style="color: #6B7280;">رقم الهاتف / الحساب:</span>
          <span style="font-weight: 700; color: #111827; font-family: monospace;">771-490-281</span>
        </div>
        <div style="display: flex; justify-content: space-between;">
          <span style="color: #6B7280;">رقم العملية (السند):</span>
          <span style="font-weight: 700; color: #9E1B21; font-family: monospace;">#TRX-948201-YER</span>
        </div>
        <div style="display: flex; justify-content: space-between;">
          <span style="color: #6B7280;">رسوم التحويل:</span>
          <span style="font-weight: 800; color: #059669;">مجاناً (عرض النجم)</span>
        </div>
        <div style="display: flex; justify-content: space-between;">
          <span style="color: #6B7280;">التاريخ والوقت:</span>
          <span style="font-weight: 600; color: #4B5563;">اليوم 03:45 مساءً</span>
        </div>
      </div>
    </div>

    <!-- Action Buttons -->
    <div style="display: flex; flex-direction: column; gap: 8px;">
      <button style="width: 100%; height: 46px; background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white; border: none; border-radius: 14px; font-size: 13.5px; font-weight: 800; display: flex; align-items: center; justify-content: center; gap: 8px; box-shadow: 0 4px 14px rgba(16,185,129,0.35); cursor: pointer;">
        <svg width="18" height="18" fill="white" viewBox="0 0 24 24"><path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92c0-1.61-1.31-2.92-2.92-2.92z"/></svg>
        <span>مشاركة إشعار الحوالة (واتساب)</span>
      </button>

      <button style="width: 100%; height: 44px; background: #FFFFFF; color: #9E1B21; border: 1.5px solid #9E1B21; border-radius: 14px; font-size: 13.5px; font-weight: 800; display: flex; align-items: center; justify-content: center; gap: 8px; cursor: pointer;">
        <span>العودة إلى الشاشة الرئيسية</span>
      </button>
    </div>
  </div>
`, false, 0);

// Write HTML files and take high-resolution screenshots
const screens = [
  { name: '01_تسجيل_الدخول_Login', html: screenLoginHtml },
  { name: '02_انشاء_حساب_Register', html: screenRegisterHtml },
  { name: '03_الرئيسية_والرصيد_Dashboard', html: screenDashboardHtml },
  { name: '04_المحفظة_والعملات_Wallet', html: screenWalletHtml },
  { name: '05_ارسال_حوالة_Transfer', html: screenTransferHtml },
  { name: '06_سجل_الحوالات_Transactions', html: screenTransactionsHtml },
  { name: '07_الملف_الشخصي_Profile', html: screenProfileHtml },
  { name: '08_مسح_كود_QR_Scan', html: screenQrHtml },
  { name: '09_التحقق_من_الهوية_KYC', html: screenKycHtml },
  { name: '10_سداد_الفواتير_شحن_الرصيد_Bills', html: screenBillsHtml },
  { name: '11_دفع_المشتريات_للمتاجر_MerchantPay', html: screenMerchantPayHtml },
  { name: '12_ادارة_الاجهزة_والجلسات_DeviceSecurity', html: screenDeviceSecurityHtml },
  { name: '13_شخصية_النجم_اليمنية_الرسمية_Mascot', html: screenMascotShowcaseHtml },
  { name: '14_اشعار_نجاح_الحوالة_مع_الشخصية_TransferSuccess', html: screenTransferSuccessHtml }
];

const tempHtmlDir = path.join(projectDir, '.temp_designs');
if (!fs.existsSync(tempHtmlDir)) fs.mkdirSync(tempHtmlDir, { recursive: true });

const edgeExe = path.join('C:', 'Program Files (x86)', 'Microsoft', 'Edge', 'Application', 'msedge.exe');

console.log('Rendering all 12 screens to Ultra HD PNG (Retina 2.5x Scale Factor)...');

for (const screen of screens) {
  const htmlFile = path.join(tempHtmlDir, `${screen.name}.html`);
  fs.writeFileSync(htmlFile, screen.html, 'utf8');

  const pngFile = path.join(outputDir, `${screen.name}.png`);
  console.log(`Generating High-Res: ${screen.name}.png`);

  try {
    const cmd = `"${edgeExe}" --headless=new --disable-gpu --force-device-scale-factor=2.5 --window-size=480,980 --screenshot="${pngFile}" "file:///${htmlFile.replace(/\\/g, '/')}"`;
    execSync(cmd, { stdio: 'ignore' });
    if (fs.existsSync(pngFile)) {
      console.log(`✓ Saved HD ${screen.name}.png (${fs.statSync(pngFile).size} bytes)`);
    } else {
      console.error(`✗ Failed to create ${screen.name}.png`);
    }
  } catch (err) {
    console.error(`Error rendering ${screen.name}:`, err.message);
  }
}

// Clean temp html dir
try {
  fs.rmSync(tempHtmlDir, { recursive: true, force: true });
} catch (e) {}

console.log('\nAll 12 Ultra-HD screens generated successfully in:', outputDir);

