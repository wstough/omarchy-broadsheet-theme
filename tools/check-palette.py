#!/usr/bin/env python3
"""Score colors.toml: WCAG contrast of each text color against the background,
and how distinct the code colors are from each other (CIE Lab distance).
Usage: tools/check-palette.py [colors.toml]"""
import sys, tomllib, itertools, math

def rgb(h): h = h.lstrip('#'); return [int(h[i:i+2], 16) / 255 for i in (0, 2, 4)]
def lin(c): return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
def lum(h): r, g, b = map(lin, rgb(h)); return 0.2126*r + 0.7152*g + 0.0722*b
def contrast(a, b): la, lb = sorted((lum(a), lum(b)), reverse=True); return (la + 0.05) / (lb + 0.05)
def lab(h):
    r, g, b = map(lin, rgb(h))
    x, y, z = (r*.4124+g*.3576+b*.1805)/.95047, r*.2126+g*.7152+b*.0722, (r*.0193+g*.1192+b*.9505)/1.08883
    f = lambda t: t ** (1/3) if t > 0.008856 else 7.787*t + 16/116
    return 116*f(y)-16, 500*(f(x)-f(y)), 200*(f(y)-f(z))

c = tomllib.load(open(sys.argv[1] if len(sys.argv) > 1 else 'colors.toml', 'rb'))
bg = c['background']
text = ['foreground', 'light_foreground', 'dark_foreground', 'accent', 'red', 'orange', 'yellow',
        'green', 'cyan', 'blue', 'magenta', 'brown', 'bright_red', 'bright_yellow', 'bright_green',
        'bright_cyan', 'bright_blue', 'bright_magenta', 'muted']
print(f'Contrast vs background {bg}  (4.5 = comfortable text, 3.0 = large text/UI only)')
for k in text:
    if k in c:
        r = contrast(c[k], bg)
        print(f'  {k:18} {c[k]}  {r:5.2f}  {"ok" if r >= 4.5 else "ui-only" if r >= 3 else "FAIL"}')
hues = ['red', 'orange', 'yellow', 'green', 'cyan', 'blue', 'magenta']
pairs = sorted((math.dist(lab(c[a]), lab(c[b])), a, b) for a, b in itertools.combinations(hues, 2))
print('Closest code-color pairs (Lab distance; under ~20 is easy to confuse):')
for d, a, b in pairs[:4]: print(f'  {a}/{b}: {d:.0f}')
