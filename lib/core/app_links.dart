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

/// iOS App Store ID。iOS 配信解凍時に採番されたら記入する
/// （空の間、iOS の評価導線は静黙フォールバック）。
const kAppStoreId = '';
