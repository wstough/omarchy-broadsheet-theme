# Broadsheet — Omarchy theme

Tracking issue: wstough/projects#5 (board: github.com/users/wstough/projects/1).
Owner is new to Linux: explain theme concepts plainly while working.

## Goal
Desktop that feels like a great newspaper, with Apple-like calm and polish
(added 2026-10-13: beautiful, intuitive). NYT-*inspired*, never NYT's fonts, logo or
artwork. Paper-white/slight-cream background, true-black ink, almost no color except one
deep-blue accent, thin gray rules, editorial typography.

## How it's installed here
- Lives at `~/.config/omarchy/themes/broadsheet/` and *is* this git repo.
- Apply after edits: `omarchy theme set broadsheet`.
- Excluded from the dotfiles backup (`~/.config/.gitignore`) since GitHub holds it.

## Decisions
- Name **Broadsheet**; repo `omarchy-broadsheet-theme` (install strips `omarchy-`/`-theme`).
- Base: stock `flexoki-light` (ink on paper).
- **Everything goes through `colors.toml`.** Themes installed via `omarchy theme install`
  have `*.lua`, terminal configs and `vscode.json` dropped (they can run code) and
  regenerated from `colors.toml`. So no `neovim.lua`/`vscode.json`; Neovim uses the
  generated aether palette.
- Palette: bone paper `#EEEAE0` (v1 `#FBF9F4` was "too white, aggressive"), warm ink `#1C1B19`,
  true black for emphasis. v3: owner felt blue didn't fit -> accent **oxblood `#7E2B22`**, and a
  full "printing ink" set for code colors. Owner found green etc. hard to read: rule is every text
  color >= 4.5:1 on paper (code colors ~5.5-6) and hue pairs >= 30 apart in Lab;
  `tools/check-palette.py` enforces both. Comments (`muted`) deliberately ~3.9.
  ANSI colors are dark, desaturated "printing inks" so terminals stay legible.
- Borders: focused window = oxblood hairline, others faint gray. Owner likes this shape. Shape (1px border, rounding 10, directional shadow lit from above: offset -5,9,
  deeper on focused window) lives in the owner's `~/.config/hypr/looknfeel.lua` (themes can't set it); README recommends it.
- `unlock.png` = Omarchy logo recolored to ink. `icons.theme` = `Yaru` (neutral).
- Inspirations: newspapers (NYT), Apple (calm, intuitive), magazine covers (Rolling Stone).
- Wallpapers = a *collection*: classical art re-printed in ink on bone, filling the screen,
  each a different print texture (pixel / halftone / grain / engraving), shared "Fig. N" caption
  plate. Built by `tools/make-wallpapers.sh` from `tools/wallpapers.list` (one line per image:
  crop, texture, dot size, brightness). Owner wanted bigger pixels and fuller frames.
  Type covers (`tools/make-type.sh`): blackletter masthead + Abril Fatface "omarchy." cover.
  Owner disliked the first masthead + slogan; wants bold, designed typography.
  Sources must be CC0/public domain; verify captions against museum metadata; credit in
  `tools/sources/CREDITS.md`. Wikimedia rate-limits: send a User-Agent, pause between downloads.
- Lock screen `unlock.png` = blackletter "Omarchy" in ink.
- Fonts (owner's machine, not shippable in a theme): mono BlexMono Nerd Font (IBM Plex Mono),
  sans Libre Franklin, serif Newsreader (via ~/.config/fontconfig/conf.d/60-broadsheet.conf;
  Omarchy's /etc/fonts/conf.d/50-omarchy.conf *assigns* generics, so use prepend_first matches),
  GTK font via gsettings. NYT's fonts are proprietary; use free cousins only.
## Progress
- [x] v1: colors, masthead wallpaper, lock logo, applied on desktop (2026-10-13)
- [x] v2: bone palette, blue hairline borders, rounded corners/shadow, statue + wordmark wallpapers
- [x] v3: ink palette (oxblood accent), directional shadows, fonts, 5 art + 2 type wallpapers
- [ ] Owner to react to v3 (fonts especially; they hadn't looked at the specimen)
- [ ] Dark variant (`broadsheet-dark`?) once light is dialed in; needs a dark mode in make-wallpapers.sh
  (ink paper, bone dots); Aelius Verus source is ready
- [ ] More statues / wallpapers
- [ ] Fonts: owner likes NYT fonts (proprietary) -> free lookalikes. Installed 2026-10-13:
  Newsreader, Libre Franklin, Courier Prime (~/.local/share/fonts/broadsheet), IBM Plex +
  BlexMono Nerd, Inter, Source Serif 4, Nerd symbols fallback (pacman).
- [ ] Optional `shell.toml` (bar typography/rules)
- [ ] Check browser, Neovim, VS Code, btop
- [ ] Clean preview.png screenshot; announce for other Omarchy users
