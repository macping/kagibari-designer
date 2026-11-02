# Render tab7 store shots only (3 shots x 3 langs). ASCII-only comments.
$ErrorActionPreference = 'Stop'
$assets = "D:\JAJAMBO\kagibari-designer\store\assets"
$shotTool = "D:\JAJAMBO\jajambo-mobile\pipeline\tools\chrome_shot.ps1"
foreach ($lang in @('ja', 'en', 'zh')) {
  foreach ($n in 1..3) {
    & $shotTool -Url "file:///D:/JAJAMBO/kagibari-designer/store/assets/src/shots.html?lang=$lang&shot=$n&dev=tab7" `
      -Out "$assets\tab7_${lang}_$n.png" -Width 1200 -Height 1920 -AllowFileAccess -VirtualTimeBudgetMs 6000
    Write-Output "tab7 $lang $n ok"
  }
}
Write-Output 'TAB7-DONE'
