"""Draws the PawSetu app icon (same mark as lib/core/widgets/logo.dart) and
writes the Android, iOS and web icon files. Run: python3 tools/make_icons.py"""
import json, math, os
from PIL import Image, ImageDraw

TEAL = (15, 118, 110, 255)
APRICOT = (244, 162, 97, 255)
WHITE = (255, 255, 255, 255)
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SS = 4  # supersampling


def mark(size, *, tile='rounded', scale=1.0):
    """tile: 'rounded' (legacy icons), 'square' (iOS, maskable), None (adaptive foreground)."""
    S = size * SS
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    if tile == 'rounded':
        d.rounded_rectangle([0, 0, S - 1, S - 1], radius=int(S * 0.28), fill=TEAL)
    elif tile == 'square':
        d.rectangle([0, 0, S, S], fill=TEAL)
    # Content box scaled around the centre (scale < 1 keeps it in safe zones).
    s = S * scale
    ox = (S - s) / 2
    oy = (S - s) / 2
    def P(x, y):
        return (ox + x * s, oy + y * s)
    w = s * 0.08
    x0, y0 = P(0.16, 0.2)
    x1, y1 = P(0.84, 0.7)
    d.arc([x0, y0, x1, y1], 180, 360, fill=APRICOT, width=int(w))
    for ang in (180, 360):  # round caps
        cx = (x0 + x1) / 2 + (x1 - x0) / 2 * math.cos(math.radians(ang))
        cy = (y0 + y1) / 2 + (y1 - y0) / 2 * math.sin(math.radians(ang))
        d.ellipse([cx - w / 2 + w * 0.5 * (1 if ang == 180 else -1), cy - w / 2, cx + w / 2 + w * 0.5 * (1 if ang == 180 else -1), cy + w / 2], fill=APRICOT)
    cx, cy = P(0.5, 0.62)
    r = s * 0.13
    pad_cy = cy + r * 0.45
    d.ellipse([cx - r * 0.85, pad_cy - r * 0.675, cx + r * 0.85, pad_cy + r * 0.675], fill=WHITE)
    for dx, dy in [(-0.95, -0.45), (-0.33, -0.95), (0.33, -0.95), (0.95, -0.45)]:
        tx, ty, tr = cx + dx * r, cy + dy * r, r * 0.34
        d.ellipse([tx - tr, ty - tr, tx + tr, ty + tr], fill=WHITE)
    return im.resize((size, size), Image.LANCZOS)


def save(im, *parts, rgb=False):
    path = os.path.join(ROOT, *parts)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if rgb:
        im = im.convert('RGB')
    im.save(path)


# Android legacy and adaptive icons
res = 'android/app/src/main/res'
for dpi, px in {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}.items():
    save(mark(px), res, f'mipmap-{dpi}', 'ic_launcher.png')
    fg = round(px * 108 / 48)
    save(mark(fg, tile=None, scale=0.62), res, f'drawable-{dpi}', 'ic_launcher_foreground.png')
    save(mark(round(px * 2), tile='rounded'), res, f'drawable-{dpi}', 'launch_image.png')
os.makedirs(os.path.join(ROOT, res, 'mipmap-anydpi-v26'), exist_ok=True)
open(os.path.join(ROOT, res, 'mipmap-anydpi-v26', 'ic_launcher.xml'), 'w').write(
    '<?xml version="1.0" encoding="utf-8"?>\n'
    '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
    '    <background android:drawable="@color/ic_launcher_background" />\n'
    '    <foreground android:drawable="@drawable/ic_launcher_foreground" />\n'
    '    <monochrome android:drawable="@drawable/ic_launcher_foreground" />\n'
    '</adaptive-icon>\n')

# iOS app icons (no transparency)
ios = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
contents = json.load(open(os.path.join(ROOT, ios, 'Contents.json')))
for img in contents['images']:
    if 'filename' not in img:
        continue
    base = float(img['size'].split('x')[0])
    px = round(base * int(img['scale'].replace('x', '')))
    save(mark(px, tile='square'), ios, img['filename'], rgb=True)

# Web
save(mark(32), 'web', 'favicon.png')
save(mark(192), 'web', 'icons', 'Icon-192.png')
save(mark(512), 'web', 'icons', 'Icon-512.png')
save(mark(192, tile='square', scale=0.8), 'web', 'icons', 'Icon-maskable-192.png')
save(mark(512, tile='square', scale=0.8), 'web', 'icons', 'Icon-maskable-512.png')
print('icons written')
