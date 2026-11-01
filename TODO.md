# TODO

> 状态台账（2026-11-01 由「APP构建方法」会话建立；本项目当时无在册会话，工单在此落档）

## 设置页三菜单 + 升级提示工单（2026-11-01 用户新规，未进封测件必装——见 mobile-day1 skill §6）

- [ ] 设置页「応援・連絡」分组三菜单（文案全进 ARB，多语按既有语言集）：
  - 評価する：`in_app_review` → `openStoreListing()`
  - 友達に教える：`share_plus`，文案=app名+一句价值+商店链接
  - フィードバック：`url_launcher` mailto 本项目联系邮箱，件名预填「[app名 vX.Y] ご意見」+正文环境行（版本/OS/locale）
- [ ] 启动后非强制升级提示：`in_app_update.checkForUpdate()` **仅检测** → 底部非模态提示条（可关闭，不阻断操作）→「更新」跳 `market://details?id=<包名>`；关后本次启动不再弹、每次启动检出即再弹；无网静默；iOS 分支 iTunes lookup 写全。⚠ 画布编辑器注意提示条勿遮挡工具栏
- [ ] widget 测试：提示条出现/关闭/不阻断主画面
- [ ] 同时核对其余红线实装状态：首启引导（可跳过）/滑动切换/截断逐语言扫描/输入框场景限界（NumRangeInputFormatter）
