/// 編み図記号レジストリ（amime-jiten と共有する自作SVG資産・かぎ針32記号）。
/// 記号名は辞典アプリと同じく三语をデータとして持つ（UI文言ではなく領域データ）。
/// 法務: 全記号は JIS L0201 を参考にした自社制作 SVG（原図トレースなし）。
library;

enum SymbolCategory { basic, incDec, fancy }

class ChartSymbol {
  const ChartSymbol({
    required this.id,
    required this.category,
    required this.nameJa,
    required this.nameEn,
    required this.nameZh,
    required this.isFree,
  });

  final String id;
  final SymbolCategory category;
  final String nameJa;
  final String nameEn;
  final String nameZh;

  /// false = Pro 解錠が必要（無料層=基本記号のみ）。
  final bool isFree;

  String get asset => 'assets/symbols/$id.svg';

  String nameFor(String languageCode) => switch (languageCode) {
        'ja' => nameJa,
        'zh' => nameZh,
        _ => nameEn,
      };
}

abstract final class SymbolRegistry {
  static const List<ChartSymbol> all = [
    // ---- 基本 ----
    ChartSymbol(
      id: 'kusari',
      category: SymbolCategory.basic,
      nameJa: '鎖編み',
      nameEn: 'Chain (ch)',
      nameZh: '锁针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'hikinuki',
      category: SymbolCategory.basic,
      nameJa: '引き抜き編み',
      nameEn: 'Slip stitch (sl st)',
      nameZh: '引拔针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'koma',
      category: SymbolCategory.basic,
      nameJa: '細編み',
      nameEn: 'Single crochet (sc)',
      nameZh: '短针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'chunaga',
      category: SymbolCategory.basic,
      nameJa: '中長編み',
      nameEn: 'Half double crochet (hdc)',
      nameZh: '中长针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'naga',
      category: SymbolCategory.basic,
      nameJa: '長編み',
      nameEn: 'Double crochet (dc)',
      nameZh: '长针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'naganaga',
      category: SymbolCategory.basic,
      nameJa: '長々編み',
      nameEn: 'Treble crochet (tr)',
      nameZh: '长长针',
      isFree: true,
    ),
    ChartSymbol(
      id: 'mitsumaki',
      category: SymbolCategory.basic,
      nameJa: '三つ巻き長編み',
      nameEn: 'Double treble (dtr)',
      nameZh: '三卷长针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'wanotsukurime',
      category: SymbolCategory.basic,
      nameJa: '輪の作り目',
      nameEn: 'Magic ring',
      nameZh: '环形起针（魔术环）',
      isFree: true,
    ),
    ChartSymbol(
      id: 'picot',
      category: SymbolCategory.basic,
      nameJa: 'くさり3目のピコット',
      nameEn: 'Chain-3 picot',
      nameZh: '3锁针的狗牙针',
      isFree: false,
    ),

    // ---- 増し目・減らし目 ----
    ChartSymbol(
      id: 'koma2in',
      category: SymbolCategory.incDec,
      nameJa: '細編み2目編み入れ',
      nameEn: 'Sc 2 in one stitch (inc)',
      nameZh: '短针1针放2针（加针）',
      isFree: true,
    ),
    ChartSymbol(
      id: 'koma3in',
      category: SymbolCategory.incDec,
      nameJa: '細編み3目編み入れ',
      nameEn: 'Sc 3 in one stitch',
      nameZh: '短针1针放3针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'koma2tog',
      category: SymbolCategory.incDec,
      nameJa: '細編み2目一度',
      nameEn: 'Sc 2 together (sc2tog)',
      nameZh: '短针2针并1针（减针）',
      isFree: true,
    ),
    ChartSymbol(
      id: 'koma3tog',
      category: SymbolCategory.incDec,
      nameJa: '細編み3目一度',
      nameEn: 'Sc 3 together (sc3tog)',
      nameZh: '短针3针并1针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'naga2in',
      category: SymbolCategory.incDec,
      nameJa: '長編み2目編み入れ',
      nameEn: 'Dc 2 in one stitch (inc)',
      nameZh: '长针1针放2针（加针）',
      isFree: true,
    ),
    ChartSymbol(
      id: 'naga3in',
      category: SymbolCategory.incDec,
      nameJa: '長編み3目編み入れ',
      nameEn: 'Dc 3 in one stitch',
      nameZh: '长针1针放3针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'naga5in',
      category: SymbolCategory.incDec,
      nameJa: '長編み5目編み入れ（シェル）',
      nameEn: '5-dc shell',
      nameZh: '长针1针放5针（扇形针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'naga2tog',
      category: SymbolCategory.incDec,
      nameJa: '長編み2目一度',
      nameEn: 'Dc 2 together (dc2tog)',
      nameZh: '长针2针并1针（减针）',
      isFree: true,
    ),
    ChartSymbol(
      id: 'naga3tog',
      category: SymbolCategory.incDec,
      nameJa: '長編み3目一度',
      nameEn: 'Dc 3 together (dc3tog)',
      nameZh: '长针3针并1针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'chunaga2in',
      category: SymbolCategory.incDec,
      nameJa: '中長編み2目編み入れ',
      nameEn: 'Hdc 2 in one stitch',
      nameZh: '中长针1针放2针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'chunaga2tog',
      category: SymbolCategory.incDec,
      nameJa: '中長編み2目一度',
      nameEn: 'Hdc 2 together (hdc2tog)',
      nameZh: '中长针2针并1针',
      isFree: false,
    ),

    // ---- 玉編み・模様 ----
    ChartSymbol(
      id: 'tama',
      category: SymbolCategory.fancy,
      nameJa: '中長編み3目の玉編み',
      nameEn: 'Hdc 3 bobble',
      nameZh: '中长针3针的玉编',
      isFree: false,
    ),
    ChartSymbol(
      id: 'nagatama',
      category: SymbolCategory.fancy,
      nameJa: '長編み3目の玉編み',
      nameEn: 'Dc 3 bobble',
      nameZh: '长针3针的玉编',
      isFree: false,
    ),
    ChartSymbol(
      id: 'papukon',
      category: SymbolCategory.fancy,
      nameJa: 'パプコーン編み（長編み5目）',
      nameEn: '5-dc popcorn',
      nameZh: '爆米花针（5长针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'nagakosa',
      category: SymbolCategory.fancy,
      nameJa: '長編み交差',
      nameEn: 'Crossed double crochet',
      nameZh: '长针交叉',
      isFree: false,
    ),
    ChartSymbol(
      id: 'komasuji',
      category: SymbolCategory.fancy,
      nameJa: '細編みのすじ編み',
      nameEn: 'Sc in back loop only (blo)',
      nameZh: '短针的条纹针（后半针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'sakasakoma',
      category: SymbolCategory.fancy,
      nameJa: '逆さ細編み（バック細編み）',
      nameEn: 'Reverse single crochet (crab stitch)',
      nameZh: '逆短针（蟹步针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'omotehikiage',
      category: SymbolCategory.fancy,
      nameJa: '表引き上げ編み（長編み）',
      nameEn: 'Front post double crochet (FPdc)',
      nameZh: '外钩长针（正拉针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'urahikiage',
      category: SymbolCategory.fancy,
      nameJa: '裏引き上げ編み（長編み）',
      nameEn: 'Back post double crochet (BPdc)',
      nameZh: '内钩长针（反拉针）',
      isFree: false,
    ),
    ChartSymbol(
      id: 'komaomotehikiage',
      category: SymbolCategory.fancy,
      nameJa: '細編みの表引き上げ編み',
      nameEn: 'Front post single crochet (FPsc)',
      nameZh: '外钩短针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'komaurahikiage',
      category: SymbolCategory.fancy,
      nameJa: '細編みの裏引き上げ編み',
      nameEn: 'Back post single crochet (BPsc)',
      nameZh: '内钩短针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'yji',
      category: SymbolCategory.fancy,
      nameJa: 'Y字編み',
      nameEn: 'Y-stitch',
      nameZh: 'Y字针',
      isFree: false,
    ),
    ChartSymbol(
      id: 'gyakuyji',
      category: SymbolCategory.fancy,
      nameJa: '逆Y字編み',
      nameEn: 'Inverted Y-stitch',
      nameZh: '倒Y字针',
      isFree: false,
    ),
  ];

  static final Map<String, ChartSymbol> _byId = {
    for (final s in all) s.id: s,
  };

  static ChartSymbol? byId(String id) => _byId[id];

  static List<ChartSymbol> byCategory(SymbolCategory category) =>
      all.where((s) => s.category == category).toList(growable: false);

  static List<ChartSymbol> get freeSymbols =>
      all.where((s) => s.isFree).toList(growable: false);
}
