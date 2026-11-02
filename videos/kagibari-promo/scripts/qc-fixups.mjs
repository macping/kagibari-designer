// フレーム横断のQC修正: @font-face local() 統一 / overshoot排除 / ルートdata-duration補完
import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const dir = join(root, "compositions", "frames");

const FONTFACE = `
      @font-face {
        font-family: "Yu Mincho";
        font-weight: 500;
        src: local("Yu Mincho Demibold"), local("YuMincho-Demibold"),
          local("Yu Mincho"), local("YuMincho");
      }
      @font-face {
        font-family: "Yu Gothic UI";
        font-weight: 500;
        src: local("Yu Gothic UI Semibold"), local("Yu Gothic UI"),
          local("YuGothicUI");
      }
      @font-face {
        font-family: "JetBrains Mono";
        font-weight: 500;
        src: local("JetBrains Mono Medium"), local("JetBrains Mono"),
          local("JetBrainsMono-Medium"), local("Consolas");
      }
`;

const edits = {
  "01-hook.html": (s) => s,
  "02-intro.html": (s) =>
    s
      .replaceAll("font-family: monospace;", 'font-family: "JetBrains Mono", "Consolas", monospace;')
      .replaceAll("font-family: serif;", 'font-family: "Yu Mincho", "YuMincho", serif;')
      .replaceAll("font-family: sans-serif;", 'font-family: "Yu Gothic UI", "Yu Gothic", sans-serif;'),
  "03-expiry.html": (s) =>
    s
      .replace(/^\s*@import url\("https:\/\/fonts\.googleapis\.com[^\n]*\n/m, "")
      .replaceAll('"Shippori Mincho", "Yu Mincho", serif', '"Yu Mincho", "YuMincho", serif')
      .replaceAll('"Noto Sans JP", "Yu Gothic UI", sans-serif', '"Yu Gothic UI", "Yu Gothic", sans-serif')
      .replaceAll('ease: "back.out(1.7)"', 'ease: "power3.out"')
      .replaceAll('ease: "back.out(1.2)"', 'ease: "power3.out"'),
  "04-auto.html": (s) =>
    s
      .replaceAll('ease: "back.out(1.6)"', 'ease: "power3.out"')
      .replaceAll('ease: "back.out(1.25)"', 'ease: "power3.out"')
      .replace('<div id="root" data-composition-id="04-auto">',
        '<div id="root" data-composition-id="04-auto" data-duration="5">'),
  "05-value.html": (s) =>
    s.replace('data-composition-id="05-value" data-width="1920" data-height="1080">',
      'data-composition-id="05-value" data-width="1920" data-height="1080" data-duration="5.5">'),
  "06-outro.html": (s) =>
    s
      .replaceAll("font-family: monospace;", 'font-family: "JetBrains Mono", "Consolas", monospace;')
      .replaceAll("font-family: serif;", 'font-family: "Yu Mincho", "YuMincho", serif;')
      .replace('<div id="root" data-composition-id="06-outro">',
        '<div id="root" data-composition-id="06-outro" data-duration="4.5">'),
};

for (const [file, fn] of Object.entries(edits)) {
  const p = join(dir, file);
  let s = readFileSync(p, "utf8");
  s = fn(s);
  if (!s.includes("@font-face")) {
    const i = s.indexOf("<style>");
    if (i === -1) throw new Error(`${file}: <style> not found`);
    s = s.slice(0, i + 7) + FONTFACE + s.slice(i + 7);
  }
  writeFileSync(p, s);
  console.log(`✓ ${file}`);
}
console.log("qc-fixups done");
