#!/bin/bash
# Turns a sculpture photo (on a black backdrop) into a pixel-dithered "halftone" wallpaper.
# Usage: tools/make-statue.sh <source.jpg> <output.png> <light|dark> [caption]
#   light: ink dots on bone paper, statue on the right, caption bottom-left
#   dark:  bone dots on ink, statue centered
set -e
SRC=$1 OUT=$2 MODE=${3:-light} CAPTION=$4
W=2560 H=1440 PX=4                     # PX = size of one "pixel" of the dither
PAPER="#EEEAE0" INK="#1C1B19" CAP="#3A3835" RULE="#8E897F"
TMP=$(mktemp --suffix=.png)
read -r SW SH < <(magick identify -format '%w %h\n' "$SRC")

if [[ $MODE == light ]]; then
  # Fill the black backdrop with white so it becomes paper, then dither.
  magick "$SRC" -fuzz 10% -fill white \
    -draw "color 2,2 floodfill" -draw "color $((SW-3)),2 floodfill" \
    -draw "color 2,$((SH-3)) floodfill" -draw "color $((SW-3)),$((SH-3)) floodfill" \
    -colorspace gray -resize x$((1160/PX)) -level 3%,90% -gamma 1.15 -white-threshold 92% \
    -ordered-dither o8x8 -clamp -threshold 50% -filter point -resize $((PX*100))% +level-colors "$INK","$PAPER" "$TMP"
  magick -size ${W}x${H} xc:"$PAPER" "$TMP" -gravity east -geometry +260+40 -composite \
    -fill "$RULE" -draw "rectangle 260,1220 900,1221" \
    -font Newsreader-16pt-Italic -pointsize 30 -fill "$CAP" -gravity southwest -annotate +260+170 "$CAPTION" \
    "$OUT"
else
  magick "$SRC" -colorspace gray -resize x$((1200/PX)) -level 5%,95% \
    -ordered-dither o8x8 -clamp -threshold 50% -filter point -resize $((PX*100))% +level-colors "$INK","$PAPER" "$TMP"
  magick -size ${W}x${H} xc:"$INK" "$TMP" -gravity center -composite "$OUT"
fi
rm -f "$TMP"
