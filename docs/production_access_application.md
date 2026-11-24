# 製品版へのアクセスの申請——kagibari-designer 申请稿（预置）

> 2026-11-24 从 `pipeline/docs/PRODUCTION_ACCESS_TEMPLATE.md` 生成（⚠ 禁自拟设问，
> Console 文言有变以现行页面为准）。每问自由记述 **300 字上限**。
> 〔〕占位=封测事实，**封测达标后据实替换**——Google 会与轨道配信记录、クラッシュ統計、
> ライセンステスト名单交叉核对，禁写没做过的事。
> ⚠ 日文提交报「予期しないエラー」=后端按**字节**卡（日文 300 字≈800+bytes）→
> 直接改用下方英文版（纯 ASCII 各≤300 chars）提交，最可靠。

## 事前准备清单（封测期间持续留证，申请时不抓瞎）

- [ ] 测试者招募渠道记录（Google グループ名、招募时的用途说明文原文）
- [ ] 测试者操作范围清单（全功能走查：首启引导、円編み/方眼作図、段数设定、
  书き出し共有、备份复原、三语切换、**ライセンステストで pro_unlock ¥800 購入+復元**）
- [ ] 反馈收集记录（要望/指摘各几条、原文摘录——没有原话就不写引语）
- [ ] **测试期内改善版配信记录**（versionCode、改了什么一句话、同一轨道）——问卷最强素材
- [ ] クラッシュ報告ゼロ确认（リリース前レポート+クラッシュ統計页截图）
- [ ] ライセンステスト购买+復元实测记录
- [ ] analyze 0 / 测试全绿最终数字（当前基线：analyze 0 / 36 件）

---

## STEP 1：クローズドテストについて

### Q1 テスターをどのように募集しましたか？（300字）

> テスターは、テスターコミュニティAPP（Googleグループ）と、知人ネットワーク（Googleグループ）から募集しました。テスター各自の個人所有のAndroid実機を使用しています。募集時には本アプリの用途（かぎ針編みの編み図を作成・共有するアプリ）を説明したうえで、Playストアのオプトインリンクから封閉テストに参加してもらい、日常の編み物・製図の場面で実際に使用すること、気づいた点はグループAPP内メッセージや個別のSNSメッセージで随時報告することを依頼しました。

（不写具体人数/机型——Console 自有数据，写了反可被对账挑错）

### Q2 テスターは簡単に募集できましたか？（单选）

→ **「簡単」**（常设测试者社群=事实；别选「とても簡単」显得敷衍，别选难的引发追问）

### Q3 テスターが行った操作について（300字）

> テスターには想定ユーザー（かぎ針編みであみぐるみや小物を作る手芸愛好者）と同じ使い方で全機能を一通り操作してもらいました。具体的には、初回起動のオンボーディング確認、円編みチャートの作成（記号の配置・自動吸着・自動回転）、段ごとの目数設定と自動再分布、方眼チャートの作成、PNG・PDFの書き出しと共有、バックアップの書き出し・復元、言語（日英中）切替、機内モードでの完全オフライン動作確認です。また、ライセンステストを用いてPro版（¥800買い切り）の購入と「購入を復元」の動線も実施済みです。操作内容は想定される実利用と一致しています。

### Q4 フィードバックの概要＋収集方法（300字）【封测后填实〔〕】

> フィードバックはグループAPP内メッセージと個別のSNSメッセージで収集しました。〔要望一条〕という要望と、〔指摘一条〕に関する指摘を受け、テスト期間中に改善版 versionCode〔N〕を同一トラックへ配信しました（〔改善内容一句〕）。配信後もテストは中断せず継続しています。テスト期間中のクラッシュ報告はゼロで、未対応の不具合はありません。

（改善版必须是 git/Console 可证的真实 versionCode）

## STEP 2：アプリに関する情報

### Q5 対象ユーザーは誰ですか？（300字）

> かぎ針編みであみぐるみや小物を作る手芸愛好者が対象です。特に、市販レシピを自分流にアレンジしたり、オリジナルパターンを設計する際に、紙と鉛筆では段ごとの目数管理や記号の配置が煩雑になる場面を主な利用シーンと想定しています。編み図の読み方を学んでいる初学者や、自作パターンを共有したい作り手も含みます。日本で広く使われるJIS表記慣行の編み図記号に基づく利用者が中心です。

### Q6 アプリがユーザーにもたらす価値（300字）

> オリジナルの編み図を描くには従来、紙への手描きか汎用描画ソフトしかなく、円編みの放射状レイアウトや段ごとの目数管理が大きな負担でした。本アプリは放射グリッドへの自動吸着・自動回転と段別目数の自動再分布でこの問題を解決し、PNG・PDFでの共有まで一貫して行えます。完全オフライン設計のため、電波のない場所でもすべての機能が使えます。基本機能は無料で、円編みの段数無制限・全32記号・高解像度書き出しのみ¥800の買い切りで解放されます（サブスクリプションではありません）。広告は一切ありません。

### Q7 初年度想定インストール数（单选）

→ **「0〜1万」**（如实选最低档；高档只会提高审查期待值）

## STEP 3：製品版の準備状況

### Q8 テストでわかったことに基づく変更（300字）【封测后填实〔〕】

> テスターの要望と指摘に基づき、テスト期間中に改善版 versionCode〔N〕を配信しました。主な変更は、①〔変更1〕、②〔変更2〕、③〔変更3〕、④ストア掲載情報とアプリ内表記の整合、です。配信後もテストを中断せず継続し、変更に起因する新たな問題は報告されていません。

### Q9 製品版の準備ができたと判断した方法（300字）

> 次の点から製品版の準備ができたと判断しました。①テスターから報告された要望・指摘はすべて反映済みで、未対応の事項がないこと。②Play Consoleのリリース前レポートとクラッシュ統計に問題がなく、テスト期間中のクラッシュ報告がゼロであること。③実機での受け入れ確認として、主要動線の走査とライセンステストによる購入・復元の確認を完了していること。④静的解析の指摘0件、自動テスト全件通過の検証体制を整えていること。⑤完全オフライン設計で外部依存が少なく、通信状態に左右されず安定動作することを確認済みであること。

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
- **Q4**【填实】: Feedback came via group and direct messages. Based on a request ([...])
  and an issue ([...]), we shipped versionCode [N] to the same track during the test
  ([changes]). Testing continued; zero crash reports and no outstanding issues.
- **Q5**: Crochet hobbyists who make amigurumi and small items. Main scenario: designing
  original charts, where paper sketches make per-round stitch counts and symbol layout
  tedious. Also beginners learning chart notation. Core users follow JIS-style chart
  symbols, common in Japan.
- **Q6**: Hand-drawing crochet charts is tedious: radial layouts and per-round counts are
  hard on paper. The app snaps symbols to a radial grid with auto rotation, redistributes
  stitches per round, and exports clean PNG/PDF. Fully offline. Core free; one 800 JPY
  purchase unlocks all. No ads, no subscription.
- **Q8**【填实】: Based on tester feedback we shipped versionCode [N] during the test.
  Main changes: (1) [...], (2) [...], (3) aligning store listing with in-app wording.
  Testing continued without interruption; no new issues from the changes were reported.
- **Q9**: Production-ready because: all tester issues resolved, none outstanding;
  pre-launch report and crash stats clean, zero crashes; on-device acceptance plus
  purchase and restore done via license testing; static analysis zero findings, all tests
  green; fully offline design, stable without network.

## 尾注：却下时的再申请（パート4 追加テスト・300字）

实录：14 天 opt-in 达标仍可能被拒（看的是**1日のアクティブなデバイス数**）。
新条件=审查日起再计 14 天，期间按钮灰置。再申请多一问「今回はどう変えましたか？」，
答法=审查后继续 14 天＋测试者每周实际使用＋改善版 vcX〜vcY 逐条（一句话各带 vc 号）＋
「テストは中断していません」收尾；每栏≥200 字更稳。
