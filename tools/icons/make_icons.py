"""Draws the UI Design 5 PawSetu mark and writes every app icon.

The mark matches lib/core/widgets/logo.dart: a white paw under a marigold
bridge arch on a cocoa tile. Run from the project root:

    python3 tools/icons/make_icons.py

Writes Android launcher icons (legacy + adaptive foreground), the Android
launch image, iOS AppIcon sizes and the web icons and favicon.
"""
from PIL import Image, ImageDraw

COCOA = (74, 42, 18, 255)        # #4A2A12 (PawColors.light.brand)
MARIGOLD = (245, 181, 63, 255)   # #F5B53F (PawColors.dark.action)
WHITE = (255, 255, 255, 255)
SS = 4  # supersampling for smooth edges


def mark(size, tile=True, rounded=True, scale=1.0):
    """The mark on a transparent canvas of [size]; [scale] shrinks the
    drawing around the centre (for safe zones)."""
    S = size * SS
    im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(im)
    if tile:
        if rounded:
            d.rounded_rectangle([0, 0, S - 1, S - 1], radius=int(S * 0.28), fill=COCOA)
        else:
            d.rectangle([0, 0, S, S], fill=COCOA)
    s = S * scale
    off = (S - s) / 2

    def P(x, y):
        return (off + x * s, off + y * s)

    # Arch: the top half of the ellipse in rect (0.16, 0.2, 0.68, 0.5),
    # drawn as one smooth arc with round ends.
    w = s * 0.08
    x0, y0 = P(0.16, 0.2)
    x1, y1 = P(0.84, 0.7)
    d.arc([x0, y0, x1, y1], start=180, end=360, fill=MARIGOLD, width=int(w))
    # round caps: the arc is drawn inside its box, so the caps sit half a
    # stroke inwards from the box edges.
    cy = (y0 + y1) / 2
    for x in (x0 + w / 2, x1 - w / 2):
        d.ellipse([x - w / 2, cy - w / 2, x + w / 2, cy + w / 2], fill=MARIGOLD)
    # Paw: pad and four toes.
    ox, oy = P(0.5, 0.62)
    r = 0.13 * s
    pcx, pcy = ox, oy + r * 0.45
    d.ellipse([pcx - r * 0.85, pcy - r * 0.675, pcx + r * 0.85, pcy + r * 0.675], fill=WHITE)
    for dx, dy in [(-0.95, -0.45), (-0.33, -0.95), (0.33, -0.95), (0.95, -0.45)]:
        tx, ty = ox + dx * r, oy + dy * r
        tr = r * 0.34
        d.ellipse([tx - tr, ty - tr, tx + tr, ty + tr], fill=WHITE)
    return im.resize((size, size), Image.LANCZOS)


def save(im, path):
    im.save(path)
    print('wrote', path, im.size)


def main():
    a = 'android/app/src/main/res'
    for name, px in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
        save(mark(px), f'{a}/mipmap-{name}/ic_launcher.png')
    # Adaptive foreground: 108 dp canvas, the drawing inside the 66 dp safe
    # zone, no tile (the background colour is the tile).
    for name, px in [('mdpi', 108), ('hdpi', 162), ('xhdpi', 216), ('xxhdpi', 324), ('xxxhdpi', 432)]:
        save(mark(px, tile=False, scale=0.62), f'{a}/drawable-{name}/ic_launcher_foreground.png')
    for name, px in [('mdpi', 96), ('hdpi', 144), ('xhdpi', 192), ('xxhdpi', 288), ('xxxhdpi', 384)]:
        save(mark(px), f'{a}/drawable-{name}/launch_image.png')
    ios = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    for base, mults in [(20, [1, 2, 3]), (29, [1, 2, 3]), (40, [1, 2, 3]), (60, [2, 3]), (76, [1, 2]), (83.5, [2]), (1024, [1])]:
        for m in mults:
            px = int(round(base * m))
            label = ('%g' % base)
            # iOS rounds the corners itself and wants no transparency.
            save(mark(px, rounded=False).convert('RGB'), f'{ios}/Icon-App-{label}x{label}@{m}x.png')
    save(mark(192), 'web/icons/Icon-192.png')
    save(mark(512), 'web/icons/Icon-512.png')
    # Maskable: full-bleed tile, the drawing inside the 80% safe zone.
    save(mark(192, rounded=False, scale=0.8), 'web/icons/Icon-maskable-192.png')
    save(mark(512, rounded=False, scale=0.8), 'web/icons/Icon-maskable-512.png')
    save(mark(32), 'web/favicon.png')


if __name__ == '__main__':
    main()
