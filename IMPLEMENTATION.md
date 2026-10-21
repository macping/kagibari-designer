# kagibari-designer 实现路径（2026-10-21定稿·双止损闸驱动）

**时钟**：窗口按月计（iOS侧90天≥5新进场在試探編み物域）；目标12月上中旬上架。总工期4-6周，但**D1止损闸可能让本案零成本终止——先闸后投入**。

## 开工输入（问用户）
1. 包名（约定 `com.jajambo.kagibari`，无下划线）＋联系邮箱
2. 变现拍板：免费+**広告なし**+買い切りPro ¥600-980（非消耗型IAP，商品ID写死不可改）——本案无广告SDK=无R8广告坑

### 开工决定记录（2026-10-21 已拍板）
- D1①止损闸：用户真机实测后裁决**继续**；店面复核=Hookchart 仍零评分但 9/21 活跃更新中
- 包名 `com.jajambo.kagibari`／联系邮箱（隐私页/Console）**macping@gmail.com**
- 仓库 https://github.com/macping/kagibari-designer（用户预建，public）；git user=macping/gaku@inculead.co.jp
- 应用名：ja=編み図デザイナー／en兜底=Crochet Chart／zh=钩针编织图设计／iOS表示名=編み図デザイナー
- seed色 `00695C` 深青碧（amime-jiten=8E4162 莓红，互异）
- IAP：`pro_unlock` 非消耗型（已写死），价格 fallback ¥800（Console 实价待 Hookchart Premium 情报再定）
- keystore：`D:\JAJAMBO\keys\kagibari-upload-keystore.jks`（alias=upload，密码在同目录 txt）

### 进度快照（2026-10-21 当日）
- **D1②+W1-W4 功能全量当日完成**（commit 0f262c6/764a9a4）：双网格画布/吸附+切向旋转/段别目数/32记号/玉編み扇形/PNG·PDF导出/水印/Pro门控(6段上限+记号锁+分辨率锁)/作品一覧/onboarding/L1备份/自绘图标
- 新坑回写：shared_preferences_android ≥2.5.x jnigen 被 R8 剥方法→卡splash（已修+回写 mobile-day1 skill+提brick修复任务卡）
- W1 验收：吸附几何单测往返全绿+导出实渲染目视通过；**60fps Profile 实测待真机**（模拟器不作数）
- **模拟器全量验收通过（10-21，33轮机位）**：冷启动/onboarding三页/円編み新建/拖拽吸附+切向旋转/段数编辑重分布/6段Pro闸→¥800 paywall/长按删除/undo/自动保存持久化/三语切换/桌面名三语(aapt实锤)——crash区零条目
- R8/jnigen 坑三层全记录：①SharedPreferencesApiRegistrar.getAll ②CoroutineSingletons ③kotlin.Result（终极处方=kotlin.** 全保，已回写 skill+brick 任务卡）
- 三语截断走查对应（e6fd4ff）：记号短名三语/AppBar字号/默认标题缩短/painter缓存就绪重绘
- 剩余：Play Console 建app+IAP商品（pro_unlock ¥800暂定）+封测轨道12测试者（/play-release，手工）→ 商店素材（/store-kit）→ W2-4 增量（PDF和文标题字体、玉編み扇形跨格渲染增强）

## D1（双动作，顺序执行）
1. **D1①止损闸：真机装Hookchart实测30-60分**——逐项打分：円編み放射网格可用性/段别目数设定/記号回転吸着/导出质量。**体验达4★级→当场杀本案**（它只是没有评价，不代表烂），零沉没成本；体验确实≤3★级→记录具体缺陷清单=我方差异化任务书
2. D1②：mobile-day1全清单+壳包AAB+12测试者封测启动
3. 11/19例程：复查Hookchart满7个月评价是否仍为零（确认无评价护城河）

## W1：画布spike止损闸（不达标即停）
- 技术验收三条：**放射网格吸附准确**（记号落点自动吸附到段×目交点+切向自动旋转）／**60fps**（Profile模式实测，20段×densest不掉帧）／**円編み6段样例零手动微调**完成一张标准あみぐるみ图
- 实现要点：
  - `CustomPainter`画极坐标网格：段=同心圆、目=角度等分（每段目数独立可设，增目段自动重分布）
  - 记号=SVG资产实例（见下），持 `(round, index)` 逻辑坐标而非像素坐标——缩放/重分布时自动重排
  - 手势：拖拽放置（吸附）、双指缩放平移、长按删除/替换；Undo栈（命令模式，≥50步）
- spike不达标→止损回报，整案终止

## 资产复用（边际成本核心）
- **amime-jiten JIS记号SVG全套直接复用**（已在code资产）：细编み/長編み/鎖/引き抜き/玉編み/扇形…——复制资产+法务红线一并继承（全自绘SVG、不描JIS原图、不转载説明文、JIS=記述性使用）
- 数据模型：
```
chart { mode: round|grid, rounds:[{stitchCount, cells:[{symbolId, angleIdx}]}], palette:[symbolId] }
```
- 文件存本地（drift或json文件），L1不必配

## 周里程碑
- W2-3：记号调色板（分类抽屉+常用栏）、段别目数编辑、玉編み/扇形复合记号、方眼モード（棒針不做——那是あみまる触发器管的SKU2）
- W4：导出：PNG（分辨率选择）+PDF（printing包）；免费层=方眼+基础记号+带水印导出，Pro解锁=円編み完整+全记号+高清无水印
- W5-6：Pro IAP接线+商店素材ja（store-kit）+提审（封测早已满14天）

## UI/红线
- 主页=「作品一覧」画廊形态（新建+最近编辑），与矩阵其他app布局互异；领域母题=毛线质感+记号美学
- 画布内横向手势与页面swipe冲突：画布页为单画面全屏（手势红线不适用于画布本身），一覧⇄设置用PageView
- onboarding≤3页：①一张成品編み図展示 ②拖拽记号演示GIF式页 ③Pro差异点——スキップ常驻
- ASO：主词「かぎ針 編み図」「あみぐるみ 編み図 作り方」侧翼进入；**Hookchart/あみまる品牌词禁入**

## 止损/KPI
- 开发期三止损：Hookchart获可见评分≥4.3★(N≥20)→重评／あみまる出Android→棒針SKU2永久放弃（不伤本案）／iOS爬升者（AMUU/Sheepas）登Play装机>10K→窗口关闭评估
- 预期管理：万円级/月小案，价值=amime-jiten⇄设计器交叉导流矩阵；不单独背营收目标
- KPI 90日：DL 1,500+（Hookchart速度锚≈1.1K/月）、Pro转化2-3%（広告なし人群付费意愿高）
