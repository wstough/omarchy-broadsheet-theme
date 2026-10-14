# Broadsheet

An [Omarchy](https://omarchy.org) theme that reads like a good newspaper, with a little Apple calm:
bone-colored paper, warm black ink, thin rules and an oxblood accent. Every code color is a
printing ink (crimson, vermilion, ochre, moss, verdigris, Prussian slate, plum) darkened until it
reads comfortably on paper (WCAG 4.5:1+; check with `tools/check-palette.py`).

![Broadsheet preview](preview.png)

## Install

```bash
omarchy theme install https://github.com/wstough/omarchy-broadsheet-theme
```

## What's inside

| File | Purpose |
|------|---------|
| `colors.toml` | The palette. Omarchy generates terminal, bar, Hyprland borders, btop, Neovim, VS Code and more from it. |
| `backgrounds/` | Wallpapers (cycle with `omarchy theme bg next`): classical sculpture and engravings printed as halftone, pixel and grain, plus two typographic covers. |
| `chromium.theme` | Browser toolbar color (R,G,B). |
| `icons.theme` | GTK icon set name. |
| `unlock.png` | Logo on the lock screen. |
| `preview.png` | Thumbnail in the theme picker. |
| `tools/` | `make-wallpapers.sh` + `wallpapers.list` (art), `make-type.sh` (type covers), `check-palette.py`, `try-shadow.sh`. |

## Recommended window style and fonts

Themes can't change window shape or fonts, so for the intended look add this to
`~/.config/hypr/looknfeel.lua` (rounded corners, hairline border, a soft shadow lit from above):

```lua
hl.config({
  general = { border_size = 1 },
  decoration = {
    rounding = 10,
    shadow = { enabled = true, range = 28, render_power = 2, offset = { -5, 9 },
               color = "rgba(1c1b1933)", color_inactive = "rgba(1c1b1918)" },
  },
})
```

Try other shadows live with `tools/try-shadow.sh airy|soft|crisp|paper|off`.

Fonts: `omarchy font set "BlexMono Nerd Font"` (IBM Plex Mono; `pacman -S ttf-ibmplex-mono-nerd`),
with Libre Franklin for apps and Newsreader for serif text.

## Credits

Inspired by newspaper design in general. It doesn't use any newspaper's fonts, logos or artwork.
Art wallpapers are re-printed from public-domain/CC0 images on Wikimedia Commons (see
`tools/sources/CREDITS.md`). Type: Newsreader, Libre Franklin, Abril Fatface, UnifrakturMaguntia (all OFL).

## License

MIT
