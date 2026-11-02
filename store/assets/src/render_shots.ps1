# Store asset renderer: phone shots x6 x3 langs + tab10 x3 x3 langs + feature x3 + play icon 512.
# NOTE: ASCII-only comments on purpose. PowerShell 5.1 reads BOM-less .ps1 as ANSI/GBK,
#       and multibyte comment bytes can swallow the following line (2026-11-01 incident:
#       a CJK comment ate the $assets assignment -> chrome wrote to "\phone_ja_1.png").
# Prereq: flutter test test/render_preview_test.dart (refreshes build/preview/*.png engine renders).
$ErrorActionPreference = 'Stop'
$root = "D:\JAJAMBO\kagibari-designer"
$src = "$root\store\assets\src"
$shotTool = "D:\JAJAMBO\jajambo-mobile\pipeline\tools\chrome_shot.ps1"
$assets = "$root\store\assets"

Copy-Item "$root\build\preview\round.png" "$src\round.png" -Force
Copy-Item "$root\build\preview\grid.png" "$src\grid.png" -Force

$langs = @('ja', 'en', 'zh')

foreach ($lang in $langs) {
  foreach ($n in 1..6) {
    & $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/shots.html?lang=$lang&shot=$n&dev=phone" `
      -Out "$assets\phone_${lang}_$n.png" -Width 1080 -Height 1920 -AllowFileAccess -VirtualTimeBudgetMs 6000
    Write-Output "shot $lang phone $n ok"
  }
  foreach ($n in 1..3) {
    & $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/shots.html?lang=$lang&shot=$n&dev=tab10" `
      -Out "$assets\tab10_${lang}_$n.png" -Width 1600 -Height 2560 -AllowFileAccess -VirtualTimeBudgetMs 6000
    Write-Output "shot $lang tab10 $n ok"
  }
  foreach ($n in 1..3) {
    & $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/shots.html?lang=$lang&shot=$n&dev=tab7" `
      -Out "$assets\tab7_${lang}_$n.png" -Width 1200 -Height 1920 -AllowFileAccess -VirtualTimeBudgetMs 6000
    Write-Output "shot $lang tab7 $n ok"
  }
  & $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/feature.html?lang=$lang" `
    -Out "$assets\feature_$lang.png" -Width 1024 -Height 500 -AllowFileAccess -VirtualTimeBudgetMs 6000
  Write-Output "feature $lang ok"
}

# Play store icon 512 (downscale of icon_full 1024)
$iconHtml = "$src\icon512.html"
@'
<!doctype html><meta charset="utf-8"><style>*{margin:0}html,body{width:512px;height:512px;overflow:hidden}</style><img src="../../../assets/icon/icon_full.png" style="width:512px;height:512px">
'@ | Out-File -Encoding ascii $iconHtml
& $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/icon512.html" `
  -Out "$assets\icon_512_play.png" -Width 512 -Height 512 -AllowFileAccess -VirtualTimeBudgetMs 2000
Write-Output "RENDER-ALL-OK"
