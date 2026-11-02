# kagibari-promo 再生成手册（防重复制作）

**原则：视频=冻结的动效模板 + 三个参数层。任何界面/源码/文案改动都只触碰参数层，动效与结构永不重做。**

| 改动类型 | 要动的东西 | 不要动的东西 |
|---|---|---|
| 文案・价格（¥800 等） | `scripts/localize.mjs` 对应字串 → 重渲染 | frames 的 HTML/动效 |
| **app 界面外观变更** | 重截 9 张真机图 → `python scripts/crop_ui.py` → 重渲染 | frames・localize |
| 配色（seed 换色等） | `palette_map.json` 改映射值 → 对 frames 跑 `node D:/JAJAMBO/jajambo-mobile/pipeline/tools/codemods/palette_swap.mjs` | 动效 |
| 记号数量（现 32） | `03-expiry.html` 的 `COUNT_TO` + localize 文案「32」处 | 其余幕 |
| 动效・幕结构 | **永不重做**（模板=kasuhara→bobari 世代验证过的六幕） | — |

## 1. 重截真机图（界面变更时唯一的体力活，约10分钟）

截图源与**商店截图共用**：`store/assets/src/{home,editor,export}_{ja,en,zh}.png`（1080×2400 原图）。
⚠ 模拟器由「模拟器功能队列管理」会话统一调度——先登记排队再上机。

```bash
# 1) 模拟器 + release 包 + 样例数据（样例=flutter test test/sample_backup_gen_test.dart 生成，界面改动后无需重做）
adb install -r build/app/outputs/flutter-apk/app-release.apk
adb push store/assets/src/sample-backup.json /sdcard/Download/   # 設定→バックアップを読み込む 导入3样例

# 2) 逐语言（設定→言語切换）各截3屏: 作品一覧 / くまのあたま編集器 / 書き出しシート
adb shell screencap -p /sdcard/cap.png && adb pull /sdcard/cap.png store/assets/src/home_ja.png
#  …editor_ja / export_ja / home_en / … 共9张（命名见 crop_ui.py）

# 3) 裁切进视频素材
python scripts/crop_ui.py
```

## 2. 渲染（三语一轮约10分钟）

```bash
cd videos/kagibari-promo
for lang in ja en zh; do node scripts/localize.mjs $lang && npm run render \
  && mv renders/*.mp4 renders/kagibari-promo-$lang.mp4; done
```

渲染前改过 frames 的话先 `npm run check`（必须 0 error）。

## 3. QC（每次重渲后）

```bash
ffmpeg -i renders/kagibari-promo-ja.mp4 -vf "select='eq(n\,60)+eq(n\,180)+eq(n\,420)+eq(n\,660)+eq(n\,810)'" -vsync 0 qc_%d.png
```

目检: 数值（32種/¥800/段数無制限）・断行・配色（teal/terracotta）・竖屏截图完整性（02/03/04 幕手机框内不被裁切）。

## 4. 数值一致性锚

| 画面数字 | 源 | 同步点 |
|---|---|---|
| 記号32種（03幕カウント） | `lib/.../symbol_registry.dart` | `03-expiry.html` COUNT_TO + localize 文案 + 商店 listing「32」 |
| ¥800 | IAP pro_unlock 实价 | localize 05幕 + RELEASE_KIT 第4节 |
| 段数無制限 / 6段免费 | `editor_screen.dart` kFreeMaxRounds | localize 05幕 + listing |
