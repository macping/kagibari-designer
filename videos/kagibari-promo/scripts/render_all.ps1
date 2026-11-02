# Render all three locales sequentially. ASCII-only comments (PS 5.1 GBK pitfall).
# Usage: powershell -ExecutionPolicy Bypass -File scripts/render_all.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

node scripts/localize.mjs ja
if (-not $?) { throw 'localize ja failed' }
npm run check
if (-not $?) { throw 'check failed' }

foreach ($lang in @('ja', 'en', 'zh')) {
  node scripts/localize.mjs $lang
  if (-not $?) { throw "localize $lang failed" }
  if (Test-Path renders) { Get-ChildItem renders -Filter *.mp4 | Where-Object { $_.Name -notmatch 'kagibari-promo-(ja|en|zh)' } | Remove-Item -Force }
  npm run render
  if (-not $?) { throw "render $lang failed" }
  $out = Get-ChildItem renders -Filter *.mp4 | Where-Object { $_.Name -notmatch 'kagibari-promo-(ja|en|zh)' } | Select-Object -First 1
  if (-not $out) { throw "render $lang produced no mp4" }
  Move-Item $out.FullName "renders/kagibari-promo-$lang.mp4" -Force
  Write-Output "RENDERED $lang"
}
Write-Output 'RENDER-ALL-DONE'
