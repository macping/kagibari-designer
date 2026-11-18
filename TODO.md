# TODO

> 状态台账（2026-11-01 由「APP构建方法」会话建立；本项目当时无在册会话，工单在此落档）

## 📥 待办工单（2026-11-18 追加，与已下发的 Draggable 核查同车执行）

- [x] **隐私政策菜单补装（用户 11-18 新标配，接替 11-14「先不补」裁决；§6 d9cec29，bobari 首装范式）**：
  2026-11-18 实装（994b3c6）——设置页免責 tile 上方 ListTile（privacy_tip_outlined +
  l10n.privacyPolicy + open_in_new 18），onTap=`launchUrl(kPrivacyPolicyUrl,
  externalApplication)` 失败静默；URL 不明示 UI；常量位置=**app_links.dart**
  （app_info.dart 的等价实现，bobari 范式对照用）；ARB 三语 privacyPolicy 键；
  断言=设置页 textContaining('http') 与 ('@') 双 findsNothing（update_banner_test）。
- [x] 与 Draggable affinity 修复一并实装、测试、重出双包——2026-11-18 完成：
  `_SymbolTile` Draggable 加 `affinity: Axis.vertical`（994b3c6）；回归测试定式
  =test/palette_scroll_test.dart（360宽 drag(-400,0) 断言末尾「中長2度」
  findsOneWidget，摘掉 fix 实测必红 ✓，另纵拖启动 Draggable 断言）；
  **版本=1.0.0+3**（vc 冻结被用户本会话 11-18 直接裁决 vc3 接替；
  vc2 已被 fix-kagibari 顶栏修复包占用）；构建走 v3 排队锁；两项已合并复命。

## 设置页三菜单 + 升级提示工单（2026-11-01 用户新规，未进封测件必装——见 mobile-day1 skill §6）

- [x] 设置页「応援・連絡」分组（2026-11-01 实装；**同日改订为二菜单**）：
  - ~~評価する tile~~（11-01 改订撤去——评价一本化为成功时刻触发，见下）
  - 友達に教える：`share_plus`，三语文案=app名+一句价值+Play链接（ARB `shareAppText`）
  - フィードバック：`url_launcher` mailto（**UI 不显示邮箱地址**，只进 mailto 宛先），件名「[app名 vX.Y] ご意見」+环境行（版本build/OS/locale，`package_info_plus`）
- [x] 评价=成功时刻触发（11-01 改订，`lib/core/review/review_prompter.dart`）：
  - **本案成功时刻＝編み図书き出し（共有）成功**；同一安装第 **N=3** 次成功时调一次 `InAppReview.requestReview()`
  - 配额/显示由 Google 管理，静默=正常；无前置提问/星级文案/奖励/诱导 UI（红线）
  - 单测：第3次才触发/跨实例持久/异常静默；widget 测试不触实通道（注入 mock）
- [x] 启动后非强制升级提示（11-01 二次改订＝be-dagontvangsten 标准模式，§6 8462454）：
  `UpdateChecker.checkForUpdate()→UpdateOffer{storeUri, availableVersion}`（Android in_app_update 仅检测/iOS iTunes lookup）；
  **紧凑单行 modal bottom sheet**（dragHandle+丸底图标+「あとで/更新する」）；
  **版本记忆 `update.dismissedVersion`**——同版任何关法后不再案内、仅更新版本再弹；
  首启引导互斥（引导起动本次不弹）；market: 打不开回落 https Play 链接
- [x] widget 测试：`test/update_banner_test.dart` 条出现/关闭/不阻断（出条时可切设置tab）/版本比较/三菜单在位
- [x] 评分弹窗键盘遮挡修复（11-02 工单，§6 1405e7a）：manifest 对
  `PlayCoreDialogWrapperActivity` 以 `tools:node="merge"` 注入
  `windowSoftInputMode="adjustResize"`（IME 不再盖住送信/キャンセル）；
  merged_manifest 核验后重出 AAB+APK（versionCode 不动）
- [x] 其余红线核对：首启引导可跳过✓（test/onboarding_test）／PageView滑动切换✓／截断逐语言扫描✓（10-21 三语真机走查+短名修复）／NumRangeInputFormatter：本案无自由数值输入框（目数/行列=步进器，改名框 maxLength=60 非数值）→不适用，记录在案
