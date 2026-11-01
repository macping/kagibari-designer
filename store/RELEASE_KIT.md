# kagibari-designer RELEASE_KIT（上架总台账）

## 0. 默认语言（既定言語）——Console 建 app 第一步，一经设定不可改

- **既定言語: 日本語（ja-JP）**
- **默认语言的应用名称: 編み図デザイナー：かぎ針・あみぐるみの編み図作成**（24字）
- 各翻译语言应用名:
  - en-US: Crochet Chart Designer
  - zh-CN: 钩针编织图设计：环形·方格制图
- 一致性锚: iOS 表示名=編み図デザイナー（ja）＝素材第一优先语言＝direction.md 主战场语言 ✓

## 1. 包与产物

- applicationId: `com.jajambo.kagibari`／versionName 1.0.0 / versionCode 1
- AAB: `build\app\outputs\bundle\release\app-release.aab`（upload keystore 签名，
  指纹 4586702E…；keystore=D:\JAJAMBO\keys\kagibari-upload-keystore.jks）
- 测试: analyze 0 / 25+ 件全绿；模拟器全量验收 2026-10-21 通过（crash区零条目）

## 2. 素材路径

- 图标: `assets/icon/icon_full.png`(1024) / `icon_foreground.png`(adaptive+monochrome)
  ——v2 纸底teal网格+陶土V（2026-11-01 矩阵42图标对照目检通过；源=test/icon_gen_test.dart）
- 截图: `store/assets/shots/`（phone 1080×1920 ×6 ×3语；渲染源=store/assets/src/shots.html）
- feature graphic: `store/assets/feature/feature_{ja,en,zh}.png`（1024×500）
- 美术方向书: `store/assets/src/direction.md`
- 宣传视频: **未制作**（可选项；需要时按 store-kit §4 复制上代 HyperFrames 工程）

## 3. 文案

- `store/store_listing_{ja,en,zh}.md`（名称/短说明/说明文/ASO关键词/截图方案）
- 隐私政策: `store/privacy_policy.md` → 托管 URL（com.jajambo 前缀→macping.github.io，仓库惯例路径）:
  **https://macping.github.io/kagibari-designer/privacy.html**（2026-11-01 已推送）

## 4. IAP（建商品三语文案）

- 商品ID: `pro_unlock`（非消耗型・写死）／价格: **¥800**（暂定，区间¥600-980）
- 商品名: ja「Pro版（買い切り）」/ en "Pro (one-time)" / zh「Pro 版（买断制）」
- 说明: ja「円編み段数無制限・全32記号・高解像度透かしなし書き出し」
  / en "Unlimited rounds, all 32 symbols, high-res watermark-free export"
  / zh「环形编织不限段数・全部32记号・高分辨率无水印导出」

## 5. 版本说明（Release notes，每语言≤500字符，追加保留历史）

### 1.0.0 (versionCode 1)

```
<ja-JP>
かぎ針編みの編み図デザイナー、初回リリースです。
・円編み（あみぐるみ）：放射グリッドに記号が自動吸着・自動回転
・段ごとの目数設定と自動再分布
・方眼編み対応／JIS準拠の自作記号32種
・PNG・PDF書き出しと共有／1ファイルバックアップ
・広告なし・完全オフライン
</ja-JP>
<en-US>
First release of Crochet Chart Designer.
- Round charts (amigurumi): symbols snap & auto-rotate on a radial grid
- Per-round stitch counts with automatic redistribution
- Filet grid mode / 32 original JIS-style symbols
- PNG & PDF export and sharing / one-file backup
- No ads, fully offline
</en-US>
<zh-CN>
钩针编织图设计首个版本。
・环形编织图（玩偶）：记号自动吸附、自动旋转
・每段针数独立设定并自动重排
・方格编织图模式／32种原创JIS风格记号
・PNG·PDF导出与分享／单文件备份
・无广告、完全离线
</zh-CN>
```

## 6. Data Safety / 分级预答

- 数据收集: **无**；数据共享: **无**；数据加密传输: 不适用（无传输）；可删除: 不适用
- 声明注意: 不含广告SDK；更新检查=Play/iTunes 只读查询（零上传）；IAP 经 Play 计费
- 广告: 无 ／ 目标受众: 全年龄（非儿童向设计，选「全年龄但非主要面向儿童」口径）
- 内容分级问卷: 工具类、无暴力/色情/赌博/UGC → IARC 全年龄

## 7. 审查敏感点

- 命名红线: 无政府/机构实体词 ✓；无竞品品牌词（Hookchart/あみまる不出现在任何素材/文案）✓
- 记号法务: 全自绘 SVG、JIS=記述性使用、不转载説明文（免責事項已写进 app 设置页）✓
- 「広告なし」宣传与 manifest 实况一致（无广告SDK）✓——对照竞品「広告が表示されます」
  标签，这是信任差异点，文案已突出

## 8. 上架 TODO（按序）

1. [ ] Play Console 建 app：既定言語=日本語、名称=第0节、免费+含IAP
2. [ ] 内容问卷（Data safety/分级/目标受众，按第6节预答）
3. [ ] 隐私政策 URL 填入（第3节链接，先确认 Pages 已生效）
4. [ ] IAP 商品 pro_unlock 建品（第4节三语文案、¥800）
5. [ ] 上传 AAB 至**封闭测试轨道**、Release notes=第5节
6. [ ] 招 12 测试者（封测需连续 14 天）→ 轨道开跑
7. [ ] 商店素材上传：图标512（Play 自动取 AAB 内 icon 亦可）、截图、feature graphic
   （fastlane: `node pipeline/tools/sync_store_metadata.mjs .` → `fastlane validate` → `fastlane metadata`）
8. [ ] 14天后转正式轨提审（目标 12 月上中旬，ROADMAP W5-6）
9. [ ] 上架后: 目录会话同步最终价（如非¥800）；amime-jiten 互推位接线
