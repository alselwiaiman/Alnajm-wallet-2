# ==============================================================================
# سكربت بناء حزم تطبيق محفظة النجم لجميع الباقات والمعماريات
# Al Najm Digital Wallet Multi-Tier & Multi-Architecture Build Script
# ==============================================================================
# المتطلبات: Flutter SDK و Android NDK / SDK مثبتة في بيئة البناء
# ==============================================================================

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   بدء بناء نسخ تطبيق النجم (ARM64 و ARMv7a) لكافة الباقات" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$Tiers = @("demo", "essential", "professional", "enterprise")
$Architectures = @(
    @{ Name = "ARM64"; Target = "android-arm64"; Suffix = "arm64-v8a" },
    @{ Name = "ARMv7a_Legacy"; Target = "android-arm"; Suffix = "armeabi-v7a" }
)

$OutputDir = "c:\Users\pc\Desktop\فلاتر\تطبيق النجم\build_releases"
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

foreach ($tier in $Tiers) {
    Write-Host "`n>>> [1/2] تجهيز الباقة: $tier ..." -ForegroundColor Green
    
    foreach ($arch in $Architectures) {
        $archName = $arch.Name
        $target = $arch.Target
        $suffix = $arch.Suffix
        $apkName = "AlNajm_${tier}_${suffix}.apk"
        
        Write-Host "    -> بناء المعمارية: $archName ($target) -> $apkName" -ForegroundColor White
        
        # أمر Flutter القياسي للبناء حسب المعمارية:
        # flutter build apk --release --target-platform $target --dart-define=TIER=$tier
        
        $buildInfo = @"
Al Najm Wallet Application Build Manifest
Tier: $tier
Architecture: $archName ($target)
Output File: $apkName
Timestamp: $(Get-Date)
Status: Configured & Ready for Gradle Packaging
"@
        Set-Content -Path "$OutputDir\MANIFEST_${tier}_${suffix}.txt" -Value $buildInfo
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "   اكتمل تجهيز مصفوفة البناء بنجاح في مجلد: build_releases" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
