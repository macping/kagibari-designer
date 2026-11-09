# 既知の問題 / Known Issues

## [修复指示 2026-11-09] 本版即修——可开始修改
- 本 app 非上架申请中,**本版即修**。
- 修:编辑器顶栏标题截断(日「無題の…」)→ memory `title-overflow-rule`:顶栏 `AutoSizeText` 或缩短默认名。

## [已修 2026-11-09] 编辑器顶栏标题「無題の…」被「…」截断(日文,系统性单行省略号)
- **修复**: `editor_screen.dart` 顶栏标题改 `AutoSizeText(maxLines:1, minFontSize:15, ellipsis)`(基准 titleLarge 22sp 自动缩),并 `titleSpacing: 0`。
  - **为什么还要 titleSpacing:0**: 编辑器是 push 进来的,有返回键(56)+右侧 4 图标(192),360dp 机上标题只剩 **80dp**,而「無題の編み図」在 15sp 下就要 90dp——光 AutoSize 缩到 15 仍会「無題の編…」。去掉左右默认 16dp 边距后得 112dp,实测 360dp 缩到 18sp 单行全显。
  - **回归测试**: `test/editor_title_overflow_test.dart`(带返回键的真实布局;360dp / 360dp×字体1.15 / 340dp,日文默认名不 ellipsis;revert 修复后 3 例全红)。
  - **仍会省略号的边界**(AutoSize 缩到 15sp 底才触发,符合规则「几乎不触发」): <340dp 窄屏,或系统字体放大 ≥1.2 倍。要连这些也兜住只能再减右侧图标(如把方眼尺寸/书き出し收进溢出菜单,bobari-designer 的做法),本次未动布局。
  - 版本号未动(version 1.0.0+1 原样)。
- **发现**: 2026-11-09 真机全语言 QA(OPPO ce6b7a4a 窄屏手机),3 语言(跟随系统/日本語/English/简体中文)
- **严重度**: 中(踩「…截断」红线)
- **位置**: 日本語 编辑器顶栏「無題の…」(全文「無題の編み図」)——英文「Untitled」短故不截,日文默认名长→截;home/设置/列表全语言无截断
- **根因**: 编辑器顶栏标题 maxLines=1(与全 app 同一**系统性根因**)
- **修法**: 顶栏标题允许两行 / 缩短默认名
- **输入框**: 作品名 maxLength=60 输入期拦截正常;网格尺寸(Filet Columns/Rows、Round Stitches)纯步进器无文本框、天然不越界
