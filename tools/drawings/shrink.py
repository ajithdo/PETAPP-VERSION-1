"""Makes the drawn demo pictures small: flat drawings need few colours.

  python3 tools/drawings/shrink.py   (needs Pillow)
"""
import glob
import os

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
total = 0
for f in sorted(glob.glob(os.path.join(ROOT, 'assets/images/demo/*/*.png'))):
    im = Image.open(f).convert('RGB').quantize(colors=128, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    im.save(f, optimize=True)
    total += os.path.getsize(f)
print(f'{total // 1024} KB in assets/images/demo')
