# IAP 商品定义（kagibari-designer）

- 商品ID: `pro_unlock`（非消耗型买断・已写死不可改）
- **暂定价: ¥800**（App 内 fallback 表示同值；ROADMAP 区间 ¥600-980）
- Set prices: JPY 800
- 最终拍板: Play Console 建商品时（W5），若有竞品 Premium 实价情报则对标微调（区间内）
- 解锁内容: 円編み段数无限制（免费6段）/ 全32記号（免费11基本）/ 高解像度・透かしなし書き出し
- 商品图标素材: `store/assets/iap_pro_1024.png`（Console 一次性商品无图标字段，
  该图用于 app 内 paywall 顶部视觉与未来促销素材；源=test/icon_gen_test.dart）

## Console 建品三语文案（名称≤55字符 / 说明≤200字符）

### 日本語（既定言語 ja-JP）

- 商品名（13字）: `Pro版（買い切り）`
- 説明（76字）:
  `円編みの段数無制限、全32種のかぎ針記号、高解像度・透かしなしの書き出しを解放します。一度の購入でずっと使えます。サブスクではありません。`

### English（en-US）

- Name（19字）: `Pro (one-time)`
- Description（158字）:
  `Unlocks unlimited rounds on round charts, all 32 crochet symbols, and high-resolution watermark-free export. Pay once, keep forever — not a subscription.`

### 简体中文（zh-CN）

- 名称（9字）: `Pro版（买断制）`
- 说明（67字）:
  `解锁环形编织图不限段数、全部32种钩针记号、高分辨率无水印导出。一次购买永久使用，非订阅。`

## 建品步骤备忘（Console → 收益化 → 应用内商品）

1. 商品ID `pro_unlock`（创建后不可改）→ 名称/说明填上表 ja（既定言語）
2. 「管理翻译」→ 添加 en-US / zh-CN，分别填上表
3. 价格 ¥800（JPY 固定，其他币种用 Console 汇率自动换算即可）
4. 状态=有效，保存——**勿改商品ID**；价格后续可调，ID 永不可改
