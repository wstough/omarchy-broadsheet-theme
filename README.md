# Broadsheet

An [Omarchy](https://omarchy.org) theme that reads like a good newspaper, with a little Apple calm:
bone-colored paper, warm black ink, thin gray rules and one deep-blue accent.

![Broadsheet preview](preview.png)

## Install

```bash
omarchy theme install https://github.com/wstough/omarchy-broadsheet-theme
```

## What's inside

| File | Purpose |
|------|---------|
| `colors.toml` | The palette. Omarchy generates terminal, bar, Hyprland borders, btop, Neovim, VS Code and more from it. |
| `backgrounds/` | Wallpapers (cycle with `omarchy theme bg next`). |
| `chromium.theme` | Browser toolbar color (R,G,B). |
| `icons.theme` | GTK icon set name. |
| `unlock.png` | Logo on the lock screen. |
| `preview.png` | Thumbnail in the theme picker. |
| `tools/` | Scripts that generate the wallpapers. |

## Recommended window style

Themes can't change window shape, so add this to `~/.config/hypr/looknfeel.lua` for the
intended look (rounded corners, hairline border, soft shadow):

```lua
hl.config({
  general = { border_size = 1 },
  decoration = {
    rounding = 10,
    shadow = { enabled = true, range = 18, render_power = 3, color = "rgba(00000022)" },
  },
})
```

## Credits

Inspired by newspaper design in general. It doesn't use any newspaper's fonts, logos or artwork.
Statue wallpapers are dithered from CC0 photos on Wikimedia Commons (see `tools/sources/CREDITS.md`).
Type is Newsreader (SIL Open Font License).

## License

MIT
