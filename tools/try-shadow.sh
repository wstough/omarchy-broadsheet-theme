#!/bin/bash
# Try window-shadow presets live (resets on reboot or Hyprland reload).
# Usage: tools/try-shadow.sh <airy|soft|crisp|paper|off>
# Light comes from above you, so shadows fall down and slightly left (negative x, positive y).
# The focused window casts a deeper shadow than the others, like on macOS.
set -e
case "$1" in
  airy)  S='enabled = true, sharp = false, range = 44, render_power = 1, offset = { -8, 14 }, color = "rgba(1c1b1926)", color_inactive = "rgba(1c1b1912)"' ;;
  soft)  S='enabled = true, sharp = false, range = 28, render_power = 2, offset = { -5, 9 }, color = "rgba(1c1b1933)", color_inactive = "rgba(1c1b1918)"' ;;
  crisp) S='enabled = true, sharp = false, range = 12, render_power = 3, offset = { -3, 5 }, color = "rgba(1c1b1940)", color_inactive = "rgba(1c1b1920)"' ;;
  paper) S='enabled = true, sharp = true,  range = 0,  render_power = 1, offset = { -5, 5 }, color = "rgba(1c1b1926)", color_inactive = "rgba(1c1b1914)"' ;;
  off)   S='enabled = false' ;;
  *) echo "Usage: $0 <airy|soft|crisp|paper|off>"; exit 1 ;;
esac
hyprctl eval "hl.config({ decoration = { shadow = { $S } } })" >/dev/null && echo "shadow: $1"
