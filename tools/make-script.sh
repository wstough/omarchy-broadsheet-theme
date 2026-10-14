#!/bin/bash
# Flowing script-logo wallpapers, in the spirit of classic American script marks.
# Fonts (OFL/Apache): Yellowtail, Pinyon Script, Mr Dafoe, Libre Franklin. Run from the theme root.
set -e
W=2560 H=1440
PAPER="#EEEAE0" INK="#1C1B19" GRAY="#5F5B54"

# A tapered swash: a crescent between two curves from (x0,y0) to (x1,y1), widest in the middle.
swash() { # x0 y0 x1 y1 lift thickness
  local x0=$1 y0=$2 x1=$3 y1=$4 lift=$5 t=$6 dx=$(( ($3-$1)/3 ))
  echo "path 'M $x0,$y0 C $((x0+dx)),$((y0+lift)) $((x1-dx)),$((y1+lift)) $x1,$y1 C $((x1-dx)),$((y1+lift+t)) $((x0+dx)),$((y0+lift+t)) $x0,$y0 Z'"
}

# 13. Retro script with an underline swash (think guitar headstock).
magick -size ${W}x${H} xc:"$PAPER" -fill "$INK" \
  -font Yellowtail-Regular -pointsize 520 -gravity center -annotate +0-80 'Omarchy' \
  -draw "$(swash 600 975 2040 905 105 44)" \
  backgrounds/13-script.png

# 14. Spencerian penmanship, bone on ink, with a ribbon flourish (think soda-fountain sign).
magick -size ${W}x${H} xc:"$INK" -fill "$PAPER" \
  -font Pinyon-Script-Regular -pointsize 560 -gravity center -annotate +0-60 'Omarchy' \
  -draw "$(swash 430 1010 2150 930 90 34)" \
  -draw "$(swash 760 1080 1880 1030 50 16)" \
  backgrounds/14-spencerian.png

# 15. Sign-painter brush script with a tracked caption line.
magick -size ${W}x${H} xc:"$PAPER" -fill "$INK" \
  -font Mr-Dafoe-Regular -pointsize 580 -gravity center -annotate +0-140 'Omarchy' \
  -fill "$GRAY" -draw "rectangle 900,1150 1660,1151" \
  -font Libre-Franklin-SemiBold -pointsize 30 -kerning 9 -gravity north -annotate +0+1180 'ARCH  ·  HYPRLAND  ·  WAYLAND' \
  backgrounds/15-signpainter.png
echo built
