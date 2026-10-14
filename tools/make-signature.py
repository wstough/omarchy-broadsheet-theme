#!/usr/bin/env python3
"""The signature wallpaper: "Omarchy" in Great Vibes (OFL) with a hand-drawn tail on the y
that dips down, loops back and sweeps left to underline the word.

The tail is a pen stroke: a smooth curve through control points, drawn as overlapping dots
whose size follows a per-point width, so it swells on downstrokes and thins to a hairline
like a pointed pen. Run from the theme root:  tools/make-signature.py [light|dark]"""
import subprocess, sys, tempfile

W, H = 2560, 1440
PAPER, INK = '#EEEAE0', '#1C1B19'
mode = sys.argv[1] if len(sys.argv) > 1 else 'light'
bg, fg = (PAPER, INK) if mode == 'light' else (INK, PAPER)
out = f'backgrounds/{"21-signature" if mode == "light" else "22-signature-ink"}.png'

CUT_Y = 727  # baseline of the y: the font's own descender below this is replaced
# (x, y, width) — the stem continues down-left, dips, loops, then underlines leftward
POINTS = [
    (1848, 695, 23), (1841, 710, 24), (1831, 727, 36), (1803, 778, 35), (1768, 836, 30), (1726, 885, 20), (1676, 912, 11),
    (1620, 905, 6),  (1578, 868, 4),  (1566, 812, 3),  (1592, 772, 3),  (1640, 778, 5),
    (1676, 820, 10), (1690, 870, 14), (1668, 918, 15), (1600, 945, 15), (1420, 960, 17),
    (1120, 953, 15), (860, 928, 8),   (710, 900, 3),   (645, 884, 1.2),
]

def catmull(points, steps=60):
    pts = [points[0]] + points + [points[-1]]
    for i in range(1, len(pts) - 2):
        p0, p1, p2, p3 = pts[i-1], pts[i], pts[i+1], pts[i+2]
        for s in range(steps):
            t = s / steps
            yield tuple(0.5 * (2*b + (-a + c)*t + (2*a - 5*b + 4*c - d)*t*t + (-a + 3*b - 3*c + d)*t**3)
                        for a, b, c, d in zip(p0, p1, p2, p3))
    yield points[-1]

with tempfile.NamedTemporaryFile('w', suffix='.mvg', delete=False) as f:
    f.write(f'fill "{fg}"\n')
    for x, y, w in catmull(POINTS):
        r = max(w / 2, 0.6)
        f.write(f'circle {x:.1f},{y:.1f} {x + r:.1f},{y:.1f}\n')
    mvg = f.name

subprocess.run(['magick', '-size', f'{W}x{H}', f'xc:{bg}', '-fill', fg,
    '-font', 'Great-Vibes-Regular', '-pointsize', '460', '-gravity', 'center', '-annotate', '+0-120', 'Omarchy',
    '-gravity', 'northwest', '-fill', bg, '-draw', f'rectangle 1640,{CUT_Y} 1990,1000', '-draw', 'rectangle 1700,710 1812,727',
    '-draw', f'@{mvg}', out], check=True)
print('built', out)
