#!/usr/bin/env python3
"""Side-by-side preview of one or more colors.toml palettes as an HTML page:
swatches with contrast scores, highlighted code, terminal output and a diff.
Usage: tools/palette-preview.py out.html "Label=path/colors.toml" ["Label2=other.toml" ...]"""
import sys, tomllib, html

def rgb(h): h = h.lstrip('#'); return [int(h[i:i+2], 16) / 255 for i in (0, 2, 4)]
def lin(c): return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
def lum(h): r, g, b = map(lin, rgb(h)); return 0.2126*r + 0.7152*g + 0.0722*b
def contrast(a, b): la, lb = sorted((lum(a), lum(b)), reverse=True); return (la + 0.05) / (lb + 0.05)
def mix(a, b, t): return '#%02X%02X%02X' % tuple(round((x*(1-t) + y*t) * 255) for x, y in zip(rgb(a), rgb(b)))

NAMES = [('foreground', 'ink'), ('dark_foreground', 'caption'), ('muted', 'comment / rule'), ('accent', 'accent'),
         ('red', 'red · errors'), ('orange', 'orange'), ('yellow', 'yellow · types'), ('green', 'green · strings'),
         ('cyan', 'cyan · properties'), ('blue', 'blue · functions'), ('magenta', 'magenta · keywords')]

def panel(label, c):
    s = lambda k, t: f'<span style="color:{c[k]}">{html.escape(t)}</span>'
    sw = ''.join(f'<div class="sw"><i style="background:{c[k]}"></i><b>{n}</b><code>{c[k]}</code>'
                 f'<em>{contrast(c[k], c["background"]):.1f}:1</em></div>' for k, n in NAMES if k in c)
    code = '\n'.join([
        s('muted', '# Fetch the morning edition and count the headlines'),
        f'{s("magenta", "def")} {s("blue", "count_headlines")}(edition: {s("yellow", "Edition")}, limit{s("foreground", "=")}{s("orange", "40")}) -> {s("yellow", "int")}:',
        f'    pages {s("foreground", "=")} edition.{s("cyan", "pages")}',
        f'    {s("magenta", "if not")} pages:',
        f'        {s("magenta", "raise")} {s("yellow", "ValueError")}({s("green", chr(34)+"no pages in this edition"+chr(34))})',
        f'    {s("magenta", "return")} {s("blue", "sum")}({s("blue", "len")}(p.{s("cyan", "headlines")}) {s("magenta", "for")} p {s("magenta", "in")} pages[:limit])',
        f'{s("blue", "print")}({s("green", "f" + chr(34) + "Today: ")}{{{s("blue", "count_headlines")}(today)}}{s("green", chr(34))}, {s("orange", "True")})',
    ])
    term = '\n'.join([
        f'{s("green", "wts@omarchy")} {s("blue", "~/projects/omapaper")} {s("magenta", "main")} {s("muted", "❯")} git status',
        f'On branch main',
        f'  {s("green", "modified:   colors.toml")}',
        f'  {s("red", "deleted:    backgrounds/old.png")}',
        f'  {s("yellow", "warning:")} 2 files over 1 MB',
        f'{s("cyan", "info")}  build finished in {s("orange", "1.4s")}   {s("green", "✓ 12 passed")}  {s("red", "✗ 1 failed")}',
    ])
    add, rem = mix(c['background'], c['green'], .16), mix(c['background'], c['red'], .14)
    diff = (f'<div style="background:{rem}">{s("red", "- accent = ")}{s("red", chr(34)+"#7E2B22"+chr(34))}</div>'
            f'<div style="background:{add}">{s("green", "+ accent = ")}{s("green", chr(34)+c["accent"]+chr(34))}</div>')
    bord_a = c.get('hyprland_active_border', c['accent'])
    return f'''<section style="background:{c["background"]};color:{c["foreground"]}">
<h2>{html.escape(label)}</h2><div class="sws">{sw}</div>
<div class="win" style="border-color:{c["accent"]}"><div class="bar">focused window</div><pre>{code}</pre></div>
<div class="win dim" style="border-color:{mix(c["background"], c["muted"], .55)}"><div class="bar">unfocused window</div><pre>{term}</pre><pre class="diff">{diff}</pre></div>
</section>'''

out, specs = sys.argv[1], sys.argv[2:]
panels = ''.join(panel(l, tomllib.load(open(p, 'rb'))) for l, p in (x.split('=', 1) for x in specs))
open(out, 'w').write(f'''<!doctype html><meta charset="utf-8"><title>OmaPaper palettes</title>
<style>
body{{margin:0;font-family:"Libre Franklin",sans-serif;background:#d9d4c8;display:flex;gap:2px;min-height:100vh}}
section{{flex:1;padding:28px 26px;min-width:0}} h2{{font:600 15px "Libre Franklin";letter-spacing:.12em;text-transform:uppercase;margin:0 0 18px}}
.sws{{display:grid;grid-template-columns:1fr 1fr;gap:6px 14px;margin-bottom:22px;font-size:12.5px}}
.sw{{display:grid;grid-template-columns:22px 1fr auto auto;gap:8px;align-items:center}}
.sw i{{width:22px;height:22px;border-radius:5px}} .sw code{{font:12px "BlexMono Nerd Font",monospace;opacity:.75}} .sw em{{font-style:normal;font-size:11.5px;opacity:.7}}
.win{{border:1px solid;border-radius:10px;margin-bottom:22px;box-shadow:-5px 9px 28px rgba(28,27,25,.2);overflow:hidden}}
.win.dim{{box-shadow:-5px 9px 28px rgba(28,27,25,.09)}}
.bar{{font-size:11px;letter-spacing:.1em;text-transform:uppercase;opacity:.55;padding:8px 14px 0}}
pre{{font:14px/1.55 "BlexMono Nerd Font",monospace;margin:0;padding:10px 14px 14px;white-space:pre-wrap}} .diff{{padding-top:0}}
</style>{panels}''')
print(out)
