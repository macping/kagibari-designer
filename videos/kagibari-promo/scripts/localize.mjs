// 各フレームの STRINGS / UI_SRC をロケール別に差し替える。
// 使い方: node scripts/localize.mjs ja|en|zh → npm run render
// 数値紀律: 記号32種=SymbolRegistry 実数、¥800=IAP 実価、
// 無料=円編み6段（kFreeMaxRounds）・Pro=段数無制限。それ以外の数字は画面に出さない。
import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const framesDir = join(root, "compositions", "frames");

const BRAND = "KAGIBARI — CROCHET CHART";

const L = {
  ja: {
    "01-hook.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "01 / 06",
        line1: "頭の中に、編みたいあみぐるみ。",
        line2Head: "編み図、どうする",
        line2Mark: "？",
        line3: "……紙に手描きの円編みは、増し目のたびに描き直し。",
      };`,
    "02-intro.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "02",
        headline: "編み図デザイナー",
        sub: ["記号を置くだけ、", "円編みも方眼も——", "ぜんぶ端末の中。"],
      };`,
    "03-expiry.html": `const STRINGS = {
        topbarLeft: "円編みエディタ",
        topbarRight: "03 / 06",
        headlineA: "あみぐるみの増し目も——",
        headlineB1: "タップで、",
        headlineB2: "図に。",
        kpiTag: "細編み・長編み・玉編み・シェル・引き上げ",
        counterPrefix: "かぎ針記号 ",
        counterUnit: "種",
        notifyWords: ["記号は自動で吸着。", "向きも段に沿って、", "自動回転。"],
      };`,
    "04-auto.html": `const STRINGS = {
        topbarLabel: "書き出し",
        topbarCounter: "04",
        headlineLines: [
          [
            { text: "できた編み図は、", accent: false },
          ],
          [{ text: "そのままPNG/PDF。", accent: true }],
        ],
        subChunks: [
          "高解像度PNG、",
          "A4のPDF、",
          "そのまま共有",
        ],
        subHighlightIndex: 1,
        note: "印刷にもSNS投稿にも。バックアップで機種変更も安心。",
      };`,
    "05-value.html": `const STRINGS = {
        topbarLeft: "${BRAND}",
        topbarRight: "05",
        monoLabel: "OFFLINE · NO ADS",
        values: ["完全オフライン", "編み図は端末の中だけ", "アカウント不要", "データ送信なし"],
        proSegments: [
          { t: "広告なし（買い切り ", kind: "lead" },
          { t: "¥800", kind: "price" },
          { t: "）", kind: "lead" },
          { t: "—", kind: "dash" },
          { t: "サブスクなし · ", kind: "feature" },
          { t: "円編み段数無制限 · ", kind: "feature" },
          { t: "全32記号", kind: "feature" },
        ],
      };`,
    "06-outro.html": `const STRINGS = {
          topbarLabel: "${BRAND}",
          topbarCounter: "06",
          wordmark: "編み図デザイナー",
          cta: "無料でためす",
          stores: "Google Play",
        };`,
  },
  en: {
    "01-hook.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "01 / 06",
        line1: "An amigurumi in your head.",
        line2Head: "How to chart it",
        line2Mark: "?",
        line3: "…hand-drawn round charts collapse at every increase.",
      };`,
    "02-intro.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "02",
        headline: "Crochet Chart Designer",
        sub: ["Tap symbols into place —", "rounds and filet grids —", "all on-device."],
      };`,
    "03-expiry.html": `const STRINGS = {
        topbarLeft: "ROUND EDITOR",
        topbarRight: "03 / 06",
        headlineA: "That amigurumi idea —",
        headlineB1: "tap — ",
        headlineB2: "charted.",
        kpiTag: "SC · DC · BOBBLE · SHELL · POST",
        counterPrefix: "",
        counterUnit: " symbols",
        notifyWords: ["Symbols snap to the grid.", "They rotate", "with every round."],
      };`,
    "04-auto.html": `const STRINGS = {
        topbarLabel: "EXPORT",
        topbarCounter: "04",
        headlineLines: [
          [
            { text: "Your chart becomes", accent: false },
          ],
          [{ text: "PNG or PDF.", accent: true }],
        ],
        subChunks: [
          "High-res PNG,",
          "A4 PDF,",
          "share anywhere",
        ],
        subHighlightIndex: 1,
        note: "Print it or post it. Backup covers device changes too.",
      };`,
    "05-value.html": `const STRINGS = {
        topbarLeft: "${BRAND}",
        topbarRight: "05",
        monoLabel: "OFFLINE · NO ADS",
        values: ["Fully offline", "Charts stay on your device", "No account needed", "No data upload"],
        proSegments: [
          { t: "No ads (one-time ", kind: "lead" },
          { t: "¥800", kind: "price" },
          { t: ")", kind: "lead" },
          { t: "—", kind: "dash" },
          { t: "no subscription · ", kind: "feature" },
          { t: "unlimited rounds · ", kind: "feature" },
          { t: "all 32 symbols", kind: "feature" },
        ],
      };`,
    "06-outro.html": `const STRINGS = {
          topbarLabel: "${BRAND}",
          topbarCounter: "06",
          wordmark: "Crochet Chart Designer",
          cta: "Try it free",
          stores: "Google Play",
        };`,
  },
  zh: {
    "01-hook.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "01 / 06",
        line1: "脑子里有个想钩的玩偶。",
        line2Head: "编织图怎么画",
        line2Mark: "？",
        line3: "……纸上手画环形图，每次加针都得重来。",
      };`,
    "02-intro.html": `const STRINGS = {
        topbarLabel: "${BRAND}",
        topbarCounter: "02",
        headline: "钩针编织图设计",
        sub: ["放上记号就成图，", "环形与方格——", "全部在设备里。"],
      };`,
    "03-expiry.html": `const STRINGS = {
        topbarLeft: "环形编辑",
        topbarRight: "03 / 06",
        headlineA: "想钩的玩偶——",
        headlineB1: "点一点，",
        headlineB2: "成图。",
        kpiTag: "短针·长针·玉编·扇形·内外钩",
        counterPrefix: "钩针记号 ",
        counterUnit: "种",
        notifyWords: ["记号自动吸附。", "方向沿着段，", "自动旋转。"],
      };`,
    "04-auto.html": `const STRINGS = {
        topbarLabel: "导出",
        topbarCounter: "04",
        headlineLines: [
          [
            { text: "画好的编织图，", accent: false },
          ],
          [{ text: "直接PNG/PDF。", accent: true }],
        ],
        subChunks: [
          "高清PNG、",
          "A4 PDF、",
          "随手分享",
        ],
        subHighlightIndex: 1,
        note: "可打印可分享。备份换机也安心。",
      };`,
    "05-value.html": `const STRINGS = {
        topbarLeft: "${BRAND}",
        topbarRight: "05",
        monoLabel: "OFFLINE · NO ADS",
        values: ["完全离线", "编织图只在设备里", "无需账号", "不上传任何数据"],
        proSegments: [
          { t: "无广告（买断 ", kind: "lead" },
          { t: "¥800", kind: "price" },
          { t: "）", kind: "lead" },
          { t: "—", kind: "dash" },
          { t: "非订阅 · ", kind: "feature" },
          { t: "环形不限段数 · ", kind: "feature" },
          { t: "全部32种记号", kind: "feature" },
        ],
      };`,
    "06-outro.html": `const STRINGS = {
          topbarLabel: "${BRAND}",
          topbarCounter: "06",
          wordmark: "钩针编织图设计",
          cta: "免费试用",
          stores: "Google Play",
        };`,
  },
};

// アプリ画面の言語連動（UI_SRC 差し替え）
const UI = {
  "02-intro.html": (lang) => `const UI_SRC = "assets/ui_${lang}_2.png"`,
  "03-expiry.html": (lang) => `const UI_SRC = "assets/ui_${lang}_3.png"`,
  "04-auto.html": (lang) => `const UI_SRC = "assets/ui_${lang}_4.png"`,
};

const lang = process.argv[2];
if (!L[lang]) {
  console.error("usage: node scripts/localize.mjs ja|en|zh");
  process.exit(1);
}
for (const [file, block] of Object.entries(L[lang])) {
  const p = join(framesDir, file);
  const src = readFileSync(p, "utf8");
  let out = src.replace(/const STRINGS = \{[\s\S]*?\};/, block);
  if (out === src && !src.includes(block)) {
    console.error(`✗ ${file}: STRINGS block not found`);
    process.exit(1);
  }
  if (UI[file]) {
    out = out.replace(/const UI_SRC = "assets\/ui_(?:ja|en|zh|de)_(\d)\.png"/, UI[file](lang));
  }
  writeFileSync(p, out);
  console.log(`✓ ${file} → ${lang}`);
}
