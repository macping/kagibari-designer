// paid_app_core 原生侧补丁（幂等，可重复运行）。
// 在 flutter create + mason make 之后运行一次: node tool/apply_core.mjs
// 处理 mason 无法安全覆盖的「既存文件修改」: pubspec / manifest / gradle / Info.plist。
// ⚠ Windows の flutter create は CRLF を吐くため、行末は正規化→復元する。
import { readFileSync, writeFileSync, existsSync, appendFileSync, unlinkSync } from "node:fs";

let changed = 0;
function patch(path, fn) {
  const raw = readFileSync(path, "utf8");
  const crlf = raw.includes("\r\n");
  const src = raw.replace(/\r\n/g, "\n");
  let out = fn(src);
  if (out !== src) {
    if (crlf) out = out.replace(/\n/g, "\r\n");
    writeFileSync(path, out);
    changed++;
    console.log(`✓ ${path}`);
  } else {
    console.log(`= ${path} (already applied)`);
  }
}

// 0) flutter create の既定テストは MyApp 参照で必ず壊れる → 削除
if (existsSync("test/widget_test.dart")) {
  const t = readFileSync("test/widget_test.dart", "utf8");
  if (t.includes("MyApp")) {
    unlinkSync("test/widget_test.dart");
    console.log("✓ test/widget_test.dart (default removed)");
    changed++;
  }
}

// 1) pubspec: 依赖 + generate:true（版本=denki 验证过的组合）
patch("pubspec.yaml", (s) => {
  if (!s.includes("flutter_localizations")) {
    s = s.replace(
      /dependencies:\n  flutter:\n    sdk: flutter\n/,
      "dependencies:\n  flutter:\n    sdk: flutter\n  flutter_localizations:\n    sdk: flutter\n  in_app_purchase: ^3.3.0\n  shared_preferences: ^2.5.5\n",
    );
  }
  if (!s.includes("flutter_launcher_icons")) {
    s = s.replace(/(  flutter_lints: [^\n]+\n)/, "$1  flutter_launcher_icons: ^0.14.0\n");
  }
  if (!/^flutter:\n  generate: true/m.test(s)) {
    s = s.replace(/^flutter:\n/m, "flutter:\n  generate: true\n");
  }
  return s;
});

// 2) manifest: launcher label → @string/app_name（三语 strings.xml は brick が設置済み）
patch("android/app/src/main/AndroidManifest.xml", (s) =>
  s.replace(/android:label="[^"]*"/, 'android:label="@string/app_name"'),
);

// 3) gradle.properties: 跨盘符 Kotlin 增量编译 bug
patch("android/gradle.properties", (s) =>
  s.includes("kotlin.incremental=false")
    ? s
    : s.trimEnd() +
      "\n# pubキャッシュ(C:)とプロジェクト(D:)のドライブが異なると\n# Kotlinインクリメンタルコンパイルが \"different roots\" で失敗するため無効化\nkotlin.incremental=false\n",
);

// 4) build.gradle.kts: key.properties 回落签名
patch("android/app/build.gradle.kts", (s) => {
  if (s.includes("keystoreProperties")) return s;
  s = s.replace(
    /^plugins \{/m,
    'import java.util.Properties\nimport java.io.FileInputStream\n\nplugins {',
  );
  s = s.replace(
    /^android \{/m,
    `// リリース署名: android/key.properties から読む（リポジトリ外の keystore を参照）。
// ファイルが無い環境では debug 署名にフォールバックする。
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {`,
  );
  s = s.replace(
    /    buildTypes \{\n        release \{[\s\S]*?\n        \}\n    \}/,
    `    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }`,
  );
  return s;
});

// 5) android/.gitignore: .kotlin/
const agi = "android/.gitignore";
if (existsSync(agi) && !readFileSync(agi, "utf8").includes(".kotlin/")) {
  appendFileSync(agi, ".kotlin/\n");
  console.log(`✓ ${agi}`);
  changed++;
}

// 6) iOS 表示名 = 主战场国家语言的正式名（语言方针）
patch("ios/Runner/Info.plist", (s) =>
  s.replace(
    /(<key>CFBundleDisplayName<\/key>\s*<string>)[^<]*(<\/string>)/,
    "$1編み図デザイナー$2",
  ),
);

// 7) 事后验证（补丁最怕静默失效——denki 复盘教训）
const checks = [
  ["pubspec.yaml", "flutter_localizations"],
  ["pubspec.yaml", "generate: true"],
  ["android/app/src/main/AndroidManifest.xml", '@string/app_name'],
  ["android/gradle.properties", "kotlin.incremental=false"],
  ["android/app/build.gradle.kts", "keystoreProperties"],
];
let ok = true;
for (const [f, needle] of checks) {
  if (!readFileSync(f, "utf8").includes(needle)) {
    console.error(`✗ VERIFY FAILED: ${f} missing "${needle}"`);
    ok = false;
  }
}
if (!ok) process.exit(1);

console.log(`\ndone (${changed} patched, verify OK).`);
console.log("残り手动步骤:");
console.log("  1. keystore 生成（mobile-day1 skill 第4节，密码存 D:\\JAJAMBO\\keys\\）");
console.log("     → android/key.properties を作成（gitignore 済を確認）");
console.log("  2. flutter pub get && flutter gen-l10n && flutter test");
