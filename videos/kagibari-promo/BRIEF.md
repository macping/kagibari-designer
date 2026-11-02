# kagibari-promo — 商店宣传视频 Brief

- 产品: 編み図デザイナー（日本・かぎ針編み図デザイナー、Android）
- 目标: Play 商店页视频（16:9 1920×1080, 29s, 无声=矩阵品牌选择）
- 三语: `node scripts/localize.mjs ja|en|zh && npm run render`
- 配色: teal/terracotta（store/assets/src/direction.md 与 palette_map.json；源模板=bobari-promo←kasuhara 世代）

## 六幕

| # | frame | 内容 | 素材 |
|---|---|---|---|
| 01 | hook | 问句钩子: 編み図、どうする？ | 纯文字 kinetic |
| 02 | intro | 品牌登场 + 主画面 | ui_{lang}_2.png（作品一覧） |
| 03 | expiry→editor | 卖点1: タップで図に + 記号32種カウント + 吸着/自動回転 | ui_{lang}_3.png（円編みエディタ） |
| 04 | auto→export | 卖点2: PNG/PDF書き出し | ui_{lang}_4.png（書き出しシート） |
| 05 | value | 価値+価格: オフライン/広告なし/買い切り¥800 | 纯文字 |
| 06 | outro | 图标 + wordmark + CTA | icon_1024.png |

## 数值纪律（画面上数字=实测源）

- 記号 **32**種 = `lib/features/charts/domain/symbol_registry.dart` 实数（改记号数→改 03 的 COUNT_TO + 05/listing 文案）
- **¥800** = IAP pro_unlock 实价 / **段数無制限** = Pro / **6段** = kFreeMaxRounds（`editor_screen.dart`；05幕不出"6"，只说無制限）

## 再生成（界面/源码改动后防重制 → 见 REGEN.md）

视频=模板（动效/结构）+ 三个可替换参数层：STRINGS（scripts/localize.mjs）/ 配色（palette_map.json）/ UI截图（assets/ui_*.png）。
界面改动只需重截 ui_*.png 再渲染；文案价格改动只改 localize.mjs；动效永不重做。
