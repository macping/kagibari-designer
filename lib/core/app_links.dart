/// アプリの対外リンク・連絡先の一元定義。
library;

/// 隐私页/Console と同じ連絡先（開工時にユーザー確認済み）。
const kContactEmail = 'macping@gmail.com';

const kAndroidPackageId = 'com.jajambo.kagibari';

/// 共有文言・ストア誘導用（Play 公開後に有効になる恒久URL）。
const kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=$kAndroidPackageId';

/// Android の「更新」ボタン遷移先（Play アプリ直開き）。
const kPlayMarketUri = 'market://details?id=$kAndroidPackageId';

/// プライバシーポリシー（托管页。設定から外部ブラウザで開く——
/// URL 自体は UI に表示しない: 宛先非表示口径はフィードバック邮箱と同じ）。
const kPrivacyPolicyUrl =
    'https://macping.github.io/kagibari-designer/privacy.html';
