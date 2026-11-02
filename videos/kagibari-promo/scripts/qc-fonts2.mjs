// フォントスタックを「@font-face宣言済みファミリ + 総称族」のみに正規化（lint対策）
import { readFileSync, writeFileSync, readdirSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const dir = join(dirname(fileURLToPath(import.meta.url)), "..", "compositions", "frames");
const pairs = [
  [/"Yu Mincho"(?:,\s*"[^"]+")*\s*,\s*serif/g, '"Yu Mincho", serif'],
  [/"Yu Gothic UI"(?:,\s*"[^"]+")*\s*,\s*sans-serif/g, '"Yu Gothic UI", sans-serif'],
  [/"JetBrains Mono"(?:,\s*"[^"]+")*\s*,\s*monospace/g, '"JetBrains Mono", monospace'],
];
for (const file of readdirSync(dir).filter((f) => f.endsWith(".html"))) {
  const p = join(dir, file);
  let s = readFileSync(p, "utf8");
  for (const [re, to] of pairs) s = s.replace(re, to);
  writeFileSync(p, s);
  console.log(`✓ ${file}`);
}
