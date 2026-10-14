# OmaPaper — Omarchy theme

Tracking issue: wstough/projects#5 (board: github.com/users/wstough/projects/1).
Owner is new to Linux: explain theme concepts plainly while working.

## Goal
Desktop that feels like a great newspaper, with Apple-like calm and polish
(added 2026-10-13: beautiful, intuitive). NYT-*inspired*, never NYT's fonts, logo or
artwork. Bone paper, warm black ink, graphite gray accent and rules, color only where it means
something (code/terminal), editorial typography. Light first; dark variant after.

## How it's installed here
- Lives at `~/.config/omarchy/themes/omapaper/` and *is* this git repo.
- Apply after edits: `omarchy theme set omapaper`.
- Excluded from the dotfiles backup (`~/.config/.gitignore`) since GitHub holds it.

## Decisions
- Name **OmaPaper** (renamed from Broadsheet 2026-10-13 at owner's request); slug `omapaper` shows
  as "Omapaper" in Omarchy (it title-cases lowercase slugs). Repo `omarchy-omapaper-theme`.
- Base: stock `flexoki-light` (ink on paper).
- **Everything goes through `colors.toml`.** Themes installed via `omarchy theme install`
  have `*.lua`, terminal configs and `vscode.json` dropped (they can run code) and
  regenerated from `colors.toml`. So no `neovim.lua`/`vscode.json`; Neovim uses the
  generated aether palette.
- Palette: bone paper `#EEEAE0` (v1 `#FBF9F4` was "too white, aggressive"), warm ink `#1C1B19`,
  true black for emphasis. Accent history: blue (v2, "doesn't fit") -> oxblood (v3, "don't love")
  -> **graphite gray `#55524C`** (v4, owner asked for gray). v4 code colors = "Clear ink"
  (crimson/vermilion/ochre/bottle green/petrol/cobalt/violet): v3's muted inks passed contrast but
  owner said blue/purple didn't stand out and green looked bad. Compare candidates visually with
  `tools/palette-preview.py out.html "A=a.toml" "B=b.toml"` and open it in the browser. Owner found green etc. hard to read: rule is every text
  color >= 4.5:1 on paper (code colors ~5.5-6) and hue pairs >= 30 apart in Lab;
  `tools/check-palette.py` enforces both. Comments (`muted`) deliberately ~3.9.
  ANSI colors are dark, desaturated "printing inks" so terminals stay legible.
- Borders: focused window = graphite hairline, unfocused = lighter gray `#BFB9AC` (owner asked). Owner likes this shape. Shape (1px border, rounding 10, directional shadow lit from above, owner picked
  the "crisp" preset: range 12, power 3, offset -3,5; deeper on focused window) lives in the owner's `~/.config/hypr/looknfeel.lua` (themes can't set it); README recommends it.
- `icons.theme` = `Yaru` (neutral).
- Inspirations: newspapers (NYT), Apple (calm, intuitive), magazine covers (Rolling Stone).
- Wallpapers = a *collection*: art & architecture re-printed in ink on bone, filling the screen,
  varied print textures (pixel / halftone / grain / engraving), shared "Fig. N" caption plate.
  Built by `tools/make-wallpapers.sh` from `tools/wallpapers.list`. Owner feedback: smaller dots
  are better (px 3-4); people welcome but NO nudity (Goltzius Hercules kept, cropped to head and
  shoulders: owner loved its etching); variety wanted: architecture, astronomy, animals.
  Great Wave removed ("doesn't fit"). Piranesi etchings need gamma ~1.7-1.8; trim mount
  margins from drawings shown "fit" on paper.
  Logo wallpaper history: blackletter masthead / headline cover / three scripts all rejected.
  Signature script (Great Vibes + hand-drawn looping y tail) also rejected ("isn't working").
  Final: Omarchy's ORIGINAL pixel logo re-inked (21-omarchy light, 22-omarchy-ink), straight
  from /usr/share/omarchy/themes/flexoki-light/backgrounds/2-omarchy.png. Don't redesign it.
  Caption plates: small (22pt) and lower-RIGHT (owner request).
  Sources must be CC0/public domain; verify captions against museum metadata; credit in
  `tools/sources/CREDITS.md`. Wikimedia rate-limits: send a User-Agent, pause between downloads.
- Lock screen `unlock.png` = Omarchy's original pixel logo recolored to ink.
- Fonts (owner's machine, not shippable in a theme): mono BlexMono Nerd Font (IBM Plex Mono),
  sans Libre Franklin, serif Newsreader (via ~/.config/fontconfig/conf.d/60-omapaper.conf;
  Omarchy's /etc/fonts/conf.d/50-omarchy.conf *assigns* generics, so use prepend_first matches),
  GTK font via gsettings. NYT's fonts are proprietary; use free cousins only.
## Progress
- [x] v1: colors, masthead wallpaper, lock logo, applied on desktop (2026-10-13)
- [x] v2: bone palette, blue hairline borders, rounded corners/shadow, statue + wordmark wallpapers
- [x] v3: ink palette (oxblood accent), directional shadows, fonts, 5 art + 2 type wallpapers
- [x] v4: Claude Code switched to custom:omarchy (it was on built-in dark = pastel colors on paper),
  "Clear ink" palette, graphite accent, opacity 0.995/0.985, 11 art + 3 script wallpapers
- [x] Palette A ("Clear ink") chosen.
- [x] v5: renamed OmaPaper; 20 art wallpapers (people/architecture/sky/animals); signature logo
- [x] v6: owner loved v5 art; original Omarchy logo; caption lower-right; foot font size 10;
  `tools/shadow-picker.sh` pop-up (owner choosing)
- Display: 13.3" 1920x1080 (168 DPI) at 1.25x = 1536x864 logical. Foot font size 10 (owner approved).
- [x] Boot/login screen set from OmaPaper (`omarchy plymouth set by theme omapaper`); apps checked OK.
- [x] Dark variant v1: separate repo omarchy-omapaper-dark-theme at ../omapaper-dark (see its CLAUDE.md).
  `tools/make-wallpapers.sh --dark` builds it from `tools/wallpapers-dark.list` (+ `-neg` styles,
  `ink` backdrop). Owner rule: no artworks shared with the light set except the logo.
- [x] Wallpapers never show blank paper edges (no-pad crops + `trim` backdrop for prints).
- [x] shell.toml: owner noticed bar popups/notifications had heavier borders than windows (Omarchy
  default 2px). `tools/make-shell-toml.sh` regenerates each theme's shell.toml from Omarchy's
  output + 1px borders. RE-RUN IT after any colors.toml change (shipped shell.toml overrides
  generation). Corner radius already follows Hyprland rounding (Style.cornerRadius).
- [x] Tintype landscapes (owner request): new `tintype` style (soft dark vignette + fine grain).
  Real tintype landscapes don't exist in PD archives; used wet-plate stereographs (one frame).
  Light: Watkins Merced, O'Sullivan Shoshone. Dark: Jackson Holy Cross, O'Sullivan Cañon de Chelle.
- Fonts (2026-10-13): owner wants a true newspaper READING face visible. Bar must stay monospace
  (Omarchy shell). Menus/launcher/polkit/clipboard honor OMARCHY_MENU_FONT (set via hl.env in
  ~/.config/hypr/looknfeel.lua; restart shell to apply). Owner compared six faces and CHOSE
  **Source Serif 4**: menu font + fontconfig serif + GTK document font. Bar approved as-is.
- [x] Screensaver: Omarchy runs `ttfx --random-effect` (rainbow). `tools/ttfx-omapaper` installed
  as /usr/local/bin/ttfx (shadows /usr/bin/ttfx on PATH) picks calm effects in the active theme's
  colors on its paper. Owner's machine has it installed.
- [x] Lock card: size is hard-coded in Omarchy (381x67); theme can only style it. Now 35% opaque,
  1px border (make-shell-toml.sh). Shrinking it = cloning omarchy.lock -> loses security updates;
  advised against, owner's call.
- [x] Preview screenshots (2026-10-13): staged on empty workspace 9 with DND on; windows show only
  theme-repo content (nvim check-palette.py, git log, ink strip). Owner asked to hide the bar's
  screen-time widget (agx.screen-time, ~x1612-1704 at 1920x1080): painted over with bar color.
  preview.png = with windows; screenshots/wallpaper.png = desktop only. Same for the dark repo.
- [ ] More statues / wallpapers
- [ ] Fonts: owner likes NYT fonts (proprietary) -> free lookalikes. Installed 2026-10-13:
  Newsreader, Libre Franklin, Courier Prime (~/.local/share/fonts/omapaper), IBM Plex +
  BlexMono Nerd, Inter, Source Serif 4, Nerd symbols fallback (pacman).
- [ ] Check browser, Neovim, VS Code, btop
- [ ] Clean preview.png screenshot; announce for other Omarchy users
