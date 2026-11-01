# TODO

> 状态台账（2026-11-01 由「APP构建方法」会话建立；本项目当时无在册会话，工单在此落档）

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
- [x] 其余红线核对：首启引导可跳过✓（test/onboarding_test）／PageView滑动切换✓／截断逐语言扫描✓（10-21 三语真机走查+短名修复）／NumRangeInputFormatter：本案无自由数值输入框（目数/行列=步进器，改名框 maxLength=60 非数值）→不适用，记录在案
