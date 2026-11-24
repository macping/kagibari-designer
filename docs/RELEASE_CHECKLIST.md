# kagibari-designer Play 正式上架申请手册（执行底本）

> 2026-11-24 由 play-release 模板生成。配套台账=`store/RELEASE_KIT.md`（素材路径/预答速查）。
> 「⚠」=矩阵上架实录（noyaku/denki/amime-jiten/pan-shikomi 等）踩过的坑，不要删。
> Console 页面年年变，与本手册不符时**先查官方现行要求再操作**，不凭记忆。
> 素材/文案上传优先走 fastlane；手工步骤仅剩：建 app・内容问卷・IAP 商品・点发布。

## 0. 出发前（代码侧，全部完成 ✓）

- [x] AAB: `build\app\outputs\bundle\release\app-release.aab`（1.0.0 / versionCode 3，56.5MB，
  upload keystore 签名指纹 4586702E… 验讫）
  ⚠ 若 build\ 被清理需重编：重编必须持 `D:\JAJAMBO\.build-lock` 原子锁 + no-daemon
- [x] analyze 0 / 36 件测试全绿；真机检点（吸附・横扫・纵拖・隐私入口）2026-11-18 PASS
- [x] 素材全套三语（§4）；隐私页已上线并实开验证
- [x] IAP 三语文案 50〜200 字逐语言校验通过（`store/iap_product.md`）
- [x] Release notes 粘贴块（`store/release_notes_1.0.0.md`，每语言≤500字）

## 1. 建应用（一次性・不可逆项全在这一步）

- [ ] Play Console →「アプリを作成」
  - 名称: `編み図デザイナー：かぎ針・あみぐるみの編み図作成`（24字）
  - **既定言語 = 日本語（ja-JP）** ⚠ 一经设定不可改
  - **「無料」** ⚠ 免费/付费发布后永久锁死——本案已拍板：免费+IAP 买断
  - 类型: アプリ（非游戏）
- [ ] ⚠ 建完先看「正式版」轨道是否直接显示「新しいリリースを作成」——
  macping 账号若已有正式版 app 则可能**豁免 12 人×14 天封测**（豁免则整体提前约 3 周，
  §5/§6 跳过直接走 §7 前置审核）

## 2. アプリのコンテンツ（政策问卷逐项答案）

- [ ] 隐私政策 URL: `https://macping.github.io/kagibari-designer/privacy.html`
  （已上线；**填 Console 前再实际打开验一次**）
- [ ] データセーフティ: **収集なし・共有なし**；传输加密=不适用（零传输）；删除=不适用
  - 声明口径: 无广告 SDK；升级检查=对 Play 的只读查询（零上传）；IAP 经 Play 计费
- [ ] 広告: **なし**（与 manifest 实况一致——这是卖点级一致性，审查零风险）
- [ ] ⚠ 目标受众（ターゲットユーザー）: **18歳以上**（矩阵标准：避开儿童政策附加审查。
  与下面 IARC 内容分级「全年龄」是两个问卷、互不矛盾）
- [ ] 内容分级问卷（IARC）: 实用工具类；无暴力/色情/赌博/UGC/位置共享 → 全年龄
- [ ] ⚠「デジタル商品の販売」→ **「はい」** → 保存后**返回 re-check 一次**（实录：曾悄悄回滚成「いいえ」）
- [ ] 新闻 app=否 / COVID 相关=否 / 政府信息 app=否（无官方来源 URL 强制要件）
- [ ] 开发者网站栏: `https://macping.github.io`（包名前缀 com.jajambo.* 对应仓；
  本案无广告 → app-ads.txt 不适用）

## 3. IAP 商品（pro_unlock・¥800 买断）

⚠ 新版 Console 界面（2026）与旧教程不同：

- [ ] 商户账号未开通的话**最早启动开通**（收款前置条件，审核数日）
- [ ] 収益化 →「一次性商品」（旧称アプリ内商品）→ 商品作成
  - 商品ID: `pro_unlock` ⚠ 代码写死，**永不可改**
- [ ] ⚠ 商品下再建「**購入オプション**」层（ID 随意如 `buy`，与代码无关）
  - 类型: **購入**（非レンタル）・**非消耗型**
- [ ] 名称/说明三语=照 `store/iap_product.md` 逐字贴（ja 既定→「管理翻译」加 en-US/zh-CN；
  说明已全部满足 50〜200 字硬区间）
- [ ] ⚠ 定价用右上「**Set prices**」JPY 800 → 一次应用到所有国家（别逐国填）
- [ ] ⚠ 最后点「**有効化**」——不是存草稿
- [ ] 图标备用: `store/assets/iap_pro_1024.png`（现行一次性商品页无图标栏；若页面出现则用它。
  1:1、无文字无促销元素，合规）

## 4. 商店信息（三语）

- [ ] 首选 fastlane 自动传（文案+截图+feature 一把）：
  `node pipeline/tools/sync_store_metadata.mjs .` → `fastlane validate` → `fastlane metadata`
  （失败再手贴 `store/store_listing_{ja,en,zh}.md`）
- 应用名速查: ja=`編み図デザイナー：かぎ針・あみぐるみの編み図作成` /
  en=`Crochet Chart Designer` / zh=`钩针编织图设计：环形·方格制图`
- [ ] 图标: `store/assets/icon_512_play.png`（512×512，与装机图标占比一致 11-10 验收）
- [ ] feature graphic: `store/assets/feature_{ja,en,zh}.png`（1024×500）
- [ ] 截图: `phone_{lang}_1..6.png`（1080×1920）/ `tab7_{lang}_1..3.png`（1200×1920）/
  `tab10_{lang}_1..3.png`（1600×2560）——lang=ja/en/zh 三套全有
- [ ] 视频（可选）: `videos/kagibari-promo/renders/` 三语 mp4 → 先传 YouTube（限定公開可）→
  各语言商店信息里填对应链接（renders 不入库，缺了用 `scripts/render_all.ps1` 重出）
- ⚠ 文案红线: Hookchart/あみまる等竞品品牌词全素材禁入（已自查 ✓，新增文案时同样遵守）

## 5. 封闭测试（若 §1 确认未豁免）

- [ ] テストと公開 → 封閉テスト → 新リリース → 上传 AAB（1.0.0+3）
- [ ] Release notes: 整块粘贴 `store/release_notes_1.0.0.md` 的语言块（<ja-JP><en-US><zh-CN>）
- [ ] 测试者名单: Google 群组 `testers-community@googlegroups.com`
  ⚠ 名单/群组是**账号级设置**，动它影响账号下其他 app；名单填测试手机的 Play 登录邮箱
- [ ] 许可测试（License Testing）同为账号级：
  - ⚠ 正式版发布后名单内的人**依然免费拿 Pro** → 测试结束把测试者移出（自己可留作回归）
  - ⚠ 测试购买自动退款 → Pro 解锁过阵子消失=**预期行为**，让测试者点「購入を復元」
- [ ] ⚠ versionCode 同码拒收——重传前 pubspec `+N` 必须递增（当前=3），让 Claude 出新包
- [ ] ⚠ **达标看实使用，不是 opt-in 数**（統計→1日のアクティブなデバイス数）：
  - 让测试者每周实际用几次（放置安装不算）；同一 IP 多人倾向算 1 人 → 用移动网络分散
  - 期间据实配信 2〜3 个改善版（versionCode 递增、同一轨道、14 天计时**不重置**）——
    这是製品版问卷最强加分素材
- [ ] 封测期间**持续留证**（照 `docs/production_access_application.md` 顶部清单，申请时不抓瞎）

## 6. 製品版へのアクセスの申請（封测达标后）

- [ ] ⚠ 禁自拟设问——一律以 `docs/production_access_application.md`（已从 pipeline 模板预置）
  填实提交；〔〕占位必须替换为封测真实事实（Google 与轨道配信记录/クラッシュ統計/
  ライセンステスト名单交叉核对，**禁写没做过的事**）
- [ ] ⚠ 日文提交报「予期しないエラー」=**字节超限** → 切预置的英文版（纯 ASCII 各≤300 chars）
- [ ] 初年度 DL 想定 → 选 **0〜1万**（过大申告只有坏处）
- [ ] 最终按钮=「適用」；若「公開の概要」出现「変更を送信」也要按
- [ ] ⚠ 却下实录（14 天 opt-in 达标仍可能被拒）：新条件=审查日起再计 14 天+实活跃设备数；
  再申请多一栏「パート4: 追加テスト」——答法见预置稿尾注
- [ ] 问卷通过后：建正式版リリース → 提审（约 7 天）

## 7. 正式版发布当天

- [ ] 测试者移出许可测试名单（自己可留）
- [ ] 开发者主页收录: `macping.github.io` 根 `index.html` 加一行
  「編み図デザイナー＋Play 链接」（⚠ 根页保持中性作品集形态，单 app 内容只住子目录）
- [ ] amime-jiten 互推位接线（ROADMAP 预留）；最终价若非 ¥800 → 同步目录会话
- [ ] ASO 词面确认（`D:\JAJAMBO\aso-scanner\scan.py`，此后月度跑）

## 8. 上架后例程

- [ ] 差评=需求文档，逐条进 backlog；评论区叙事=「広告なし・完全オフライン」信任差异点
- [ ] 正式版满 30 天：跑 Store listing experiments 图标/首图 A/B（Console 内置免费），
  胜出版本反哺 store-kit direction.md
- [ ] 止损盯守照 CLAUDE.md（Hookchart 评价/あみまる Android/iOS 爬升者，月度+专项）

## 9. 提交前最后自查（审查敏感点）

- [ ] 名称/素材/文案无竞品品牌词（Hookchart/あみまる）、无政府机构实体词
- [ ] 记号=全自绘 SVG、JIS 为记述性使用、免责声明在设置页（app 内可达 ✓）
- [ ] 「広告なし」宣传与 manifest 实况一致（无广告 SDK ✓）
- [ ] 隐私政策 app 内可达（设置页 tile 外开 Pages URL，11-18 真机验证 ✓）
- [ ] 截图与真机画面一致（渲染源=引擎实渲染 ✓）
