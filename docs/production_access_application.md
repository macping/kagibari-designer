# 製品版へのアクセスの申請——kagibari-designer 正式申请稿

> 2026-11-24 从 `pipeline/docs/PRODUCTION_ACCESS_TEMPLATE.md` 生成；同日用户确认
> **封测已完成**，Q4/Q8 已用 git 可证的真实改善版（vc2/vc3）填实，全问即贴即交。
> 每问自由记述 **300 字上限**（字数已脚本校验）。Console 文言有变以现行页面为准。
> ⚠ 日文提交报「予期しないエラー」=后端按**字节**卡（日文 300 字≈800+bytes）→
> 直接改用下方英文版（纯 ASCII 各≤300 chars）提交，最可靠。
> **提交语言=日文（报错切英文）；每问下方的「中文对照」仅供你核对内容，不用于提交。**

## 提交前确认清单（答案与 Console 数据必须对得上，Google 会交叉核对）

- [ ] 改善版 **versionCode 2 和 3 确实都配信到了封测轨道**（Console→封閉テスト→
  リリース履歴可见）——若实际只配了其中一个，把 Q4/Q8 里的版本号改成实况
- [ ] クラッシュ統計与リリース前レポート为零/无问题（答案里写了「ゼロ」）
- [ ] 测试者招募确实走的 testers-community 群组+熟人群组（Q1 口径）
- [ ] **ライセンステストの購入+復元是否实际走过**——没走过就把 Q3 末尾那句
  （ライセンステストを用いて…実施済みです）连同英文版/中文对照一并删掉，禁写没做过的事
- [ ] 代码基线：analyze 0 / 36 件测试全绿（已核 2026-11-18）

---

## STEP 1：クローズドテストについて

### Q1 テスターをどのように募集しましたか？（300字）

> テスターは、テスターコミュニティAPP（Googleグループ）と、知人ネットワーク（Googleグループ）から募集しました。テスター各自の個人所有のAndroid実機を使用しています。募集時には本アプリの用途（かぎ針編みの編み図を作成・共有するアプリ）を説明したうえで、Playストアのオプトインリンクから封閉テストに参加してもらい、日常の編み物・製図の場面で実際に使用すること、気づいた点はグループAPP内メッセージや個別のSNSメッセージで随時報告することを依頼しました。

**中文对照**：测试者从我们的测试者社区APP（Google群组）和熟人网络（Google群组）招募，
各自使用个人持有的 Android 真机。招募时说明了本应用的用途（制作·分享钩针编织图的应用），
请他们通过 Play 商店的 opt-in 链接加入封闭测试，在日常编织·制图场景中实际使用，
发现问题随时通过群组APP内消息或个人 SNS 消息反馈。

（不写具体人数/机型——Console 自有数据，写了反可被对账挑错）

### Q2 テスターは簡単に募集できましたか？（单选）

→ **「簡単」**（常设测试者社群=事实；别选「とても簡単」显得敷衍，别选难的引发追问）

### Q3 テスターが行った操作について（300字）

> テスターには想定ユーザー（かぎ針編みであみぐるみや小物を作る手芸愛好者）と同じ使い方で全機能を一通り操作してもらいました。具体的には、初回起動のオンボーディング確認、円編みチャートの作成（記号の配置・自動吸着・自動回転）、段ごとの目数設定と自動再分布、方眼チャートの作成、PNG・PDFの書き出しと共有、バックアップの書き出し・復元、言語（日英中）切替、機内モードでの完全オフライン動作確認です。また、ライセンステストを用いてPro版（¥800買い切り）の購入と「購入を復元」の動線も実施済みです。操作内容は想定される実利用と一致しています。

**中文对照**：测试者以目标用户（用钩针编玩偶和小物的手工爱好者）相同的用法走查了全部功能。
具体包括：首启引导确认、环形编织图制作（记号放置·自动吸附·自动旋转）、每段针数设定与
自动重排、方格编织图制作、PNG·PDF 导出与分享、备份导出·恢复、语言（日英中）切换、
飞行模式下完全离线运行确认。另外通过许可测试完成了 Pro 版（¥800 买断）的购买与
「恢复购买」动线。操作内容与预期的实际使用一致。

### Q4 フィードバックの概要＋収集方法（300字）

> フィードバックはグループAPP内メッセージと個別のSNSメッセージで収集しました。狭い画面で下部の記号パレットが横にスクロールできず後方の記号が選べないという指摘と、編集画面のタイトルが省略表示されるという指摘を受け、テスト期間中に改善版（versionCode 2・3）を同一トラックへ配信しました（タイトル表示の修正、パレット横スクロールの修正、設定画面へのプライバシーポリシー導線の追加）。配信後もテストは中断せず継続しています。テスト期間中のクラッシュ報告はゼロで、未対応の不具合はありません。

**中文对照**：反馈通过群组APP内消息与个人 SNS 消息收集。收到「窄屏下底部记号调色板
无法横向滚动、后方记号选不到」和「编辑页标题被省略显示」两条指摘，测试期间向**同一轨道**
配信了改善版（versionCode 2、3），内容为标题显示修正、调色板横向滚动修复、设置页新增
隐私政策入口。配信后测试未中断。测试期间崩溃报告为零，无未处理问题。

（vc2=顶栏截断修复、vc3=横扫修复+隐私入口，均 git 可证；配信实况见顶部确认清单）

## STEP 2：アプリに関する情報

### Q5 対象ユーザーは誰ですか？（300字）

> かぎ針編みであみぐるみや小物を作る手芸愛好者が対象です。特に、市販レシピを自分流にアレンジしたり、オリジナルパターンを設計する際に、紙と鉛筆では段ごとの目数管理や記号の配置が煩雑になる場面を主な利用シーンと想定しています。編み図の読み方を学んでいる初学者や、自作パターンを共有したい作り手も含みます。日本で広く使われるJIS表記慣行の編み図記号に基づく利用者が中心です。

**中文对照**：对象是用钩针编织玩偶和小物的手工爱好者。主要使用场景设想为：把市售图解
改成自己的版本、或设计原创花样时，用纸笔管理每段针数和记号排布过于繁琐的场合。
也包括正在学习看编织图的初学者、想分享自作花样的创作者。核心用户为基于日本广泛使用的
JIS 表记惯例编织记号的人群。

### Q6 アプリがユーザーにもたらす価値（300字）

> オリジナルの編み図を描くには従来、紙への手描きか汎用描画ソフトしかなく、円編みの放射状レイアウトや段ごとの目数管理が大きな負担でした。本アプリは放射グリッドへの自動吸着・自動回転と段別目数の自動再分布でこの問題を解決し、PNG・PDFでの共有まで一貫して行えます。完全オフライン設計のため、電波のない場所でもすべての機能が使えます。基本機能は無料で、円編みの段数無制限・全32記号・高解像度書き出しのみ¥800の買い切りで解放されます（サブスクリプションではありません）。広告は一切ありません。

**中文对照**：要绘制原创编织图，以往只有纸上手绘或通用绘图软件，环形编织的放射状排版
和每段针数管理负担很大。本应用通过放射网格自动吸附·自动旋转和段别针数自动重排解决此
问题，并一站式完成 PNG·PDF 导出分享。完全离线设计，没有信号的地方也能使用全部功能。
基础功能免费，仅环形编织段数无限制·全 32 记号·高分辨率导出通过 ¥800 买断解锁（非订阅）。
完全无广告。

### Q7 初年度想定インストール数（单选）

→ **「0〜1万」**（如实选最低档；高档只会提高审查期待值）

## STEP 3：製品版の準備状況

### Q8 テストでわかったことに基づく変更（300字）

> テスターの要望と指摘に基づき、テスト期間中に改善版 versionCode 2 および 3 を配信しました。主な変更は、①狭い画面で編集画面のタイトルが省略表示される問題の修正、②下部の記号パレットが横にスクロールできない問題の修正、③設定画面へのプライバシーポリシー導線の追加、④ストア掲載情報とアプリ内表記の整合、です。配信後もテストを中断せず継続し、変更に起因する新たな問題は報告されていません。

**中文对照**：基于测试者的指摘，测试期间配信了改善版 versionCode 2 和 3。主要变更：
①窄屏下编辑页标题省略显示问题修正；②底部记号调色板无法横向滚动问题修复；
③设置页新增隐私政策入口；④商店信息与应用内表述一致化。配信后测试未中断，
无因变更引发的新问题报告。

### Q9 製品版の準備ができたと判断した方法（300字）

> 次の点から製品版の準備ができたと判断しました。①テスターから報告された要望・指摘はすべて反映済みで、未対応の事項がないこと。②Play Consoleのリリース前レポートとクラッシュ統計に問題がなく、テスト期間中のクラッシュ報告がゼロであること。③実機での受け入れ確認として、主要動線の走査とライセンステストによる購入・復元の確認を完了していること。④静的解析の指摘0件、自動テスト全件通過の検証体制を整えていること。⑤完全オフライン設計で外部依存が少なく、通信状態に左右されず安定動作することを確認済みであること。

**中文对照**：基于以下几点判断已具备正式版条件：①测试者报告的需求·指摘已全部落实，
无未处理事项；②Play Console 发布前报告与崩溃统计无问题，测试期间崩溃报告为零；
③作为真机验收，已完成主要动线走查及许可测试的购买·恢复确认；④静态分析 0 指摘、
自动测试全数通过的验证体制已就绪；⑤完全离线设计外部依赖少，已确认不受网络状态
影响稳定运行。

---

## 英文版（纯 ASCII・各≤300 chars——日文报错时的提交稿）

- **Q1**: Testers came from our tester community (Google Group) and a personal network
  (Google Group), each on their own Android phone. We explained the app (a crochet chart
  maker), had them opt in via the Play link, use it for real chart making, and report
  findings via group or direct messages.
- **Q3**: Testers used all features as real users would: onboarding, round charts (symbol
  snapping and rotation), per-round stitch counts, filet grids, PNG/PDF export, backup
  restore, JA/EN/ZH switching, offline mode. License testing covered the 800 JPY one-time
  Pro purchase and restore.
- **Q4**: Feedback came via group and direct messages. Testers reported the symbol
  palette would not scroll sideways on narrow screens and a truncated editor title.
  We shipped versionCode 2 and 3 to the same track with fixes plus a privacy policy
  link. Testing continued; zero crashes, no open issues.
- **Q5**: Crochet hobbyists who make amigurumi and small items. Main scenario: designing
  original charts, where paper sketches make per-round stitch counts and symbol layout
  tedious. Also beginners learning chart notation. Core users follow JIS-style chart
  symbols, common in Japan.
- **Q6**: Hand-drawing crochet charts is tedious: radial layouts and per-round counts are
  hard on paper. The app snaps symbols to a radial grid with auto rotation, redistributes
  stitches per round, and exports clean PNG/PDF. Fully offline. Core free; one 800 JPY
  purchase unlocks all. No ads, no subscription.
- **Q8**: Based on tester feedback we shipped versionCode 2 and 3 during the test.
  Changes: (1) fixed truncated editor title on narrow screens; (2) fixed the palette
  not scrolling sideways; (3) added a settings privacy policy link; (4) aligned store
  listing with in-app wording. No new issues reported.
- **Q9**: Production-ready because: all tester issues resolved, none outstanding;
  pre-launch report and crash stats clean, zero crashes; on-device acceptance plus
  purchase and restore done via license testing; static analysis zero findings, all tests
  green; fully offline design, stable without network.

## 尾注：却下时的再申请（パート4 追加テスト・300字）

实录：14 天 opt-in 达标仍可能被拒（看的是**1日のアクティブなデバイス数**）。
新条件=审查日起再计 14 天，期间按钮灰置。再申请多一问「今回はどう変えましたか？」，
答法=审查后继续 14 天＋测试者每周实际使用＋改善版 vcX〜vcY 逐条（一句话各带 vc 号）＋
「テストは中断していません」收尾；每栏≥200 字更稳。
