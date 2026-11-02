# 真机截图(1080x2400) -> 视频 ui 素材(1080x2280) 裁切。
# 源 = store/assets/src/{home,editor,export}_{ja,en,zh}.png（商店截图与视频共用同一批真机图）
# 用法: python scripts/crop_ui.py
from PIL import Image
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT.parents[1] / "store" / "assets" / "src"
OUT = ROOT / "assets"

# ui_{lang}_N: 2=ホーム 3=エディタ 4=書き出しシート（BRIEF.md 六幕表）
SCREENS = {2: "home", 3: "editor", 4: "export"}

for lang in ("ja", "en", "zh"):
    for n, name in SCREENS.items():
        src = SRC / f"{name}_{lang}.png"
        dst = OUT / f"ui_{lang}_{n}.png"
        im = Image.open(src)
        if im.size != (1080, 2400):
            raise SystemExit(f"{src}: 期待 1080x2400, 实际 {im.size}")
        im.crop((0, 60, 1080, 2340)).save(dst)  # -> 1080x2280（02幕容器纵横比）
        print(f"ok {dst.name}")
