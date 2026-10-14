#!/bin/bash
# Typographic wallpapers. Fonts (all SIL Open Font License): UnifrakturMaguntia,
# Abril Fatface, Libre Franklin. Run from the theme root.
set -e
W=2560 H=1440
PAPER="#EEEAE0" INK="#1C1B19" OX="#7E2B22" RULE="#78736A" GRAY="#5F5B54"
SMALL=(-font Libre-Franklin-SemiBold -pointsize 26 -kerning 4)

# 6. The masthead: blackletter nameplate between fine double rules, set like a front page.
magick -size ${W}x${H} xc:"$PAPER" -fill "$INK" \
  -draw "rectangle 240,472 2320,475" -draw "rectangle 240,482 2320,483" \
  -font UnifrakturMaguntia -pointsize 420 -gravity center -annotate +0-28 'Omarchy' \
  -draw "rectangle 240,930 2320,931" -draw "rectangle 240,938 2320,941" \
  "${SMALL[@]}" -fill "$GRAY" -gravity northwest -annotate +244+958 'VOL. IV' \
  -gravity north -annotate +0+958 'ARCH  ·  HYPRLAND  ·  WAYLAND' \
  -gravity northeast -annotate +244+958 'LATE EDITION' \
  backgrounds/6-masthead.png

# 7. The cover: one oversized headline word spanning the page, with an oxblood full stop.
# Measure the word at 100pt, then scale it to fill the width between the margins.
WORD_W=$(magick -font Abril-Fatface -pointsize 100 -kerning -2 label:'omarchy.' -format '%w' info:)
PT=$(( 100 * (W - 240) / WORD_W ))
magick -size ${W}x${H} xc:"$PAPER" \
  -font Abril-Fatface -pointsize $PT -kerning $(( -2 * PT / 100 )) \
  -fill "$OX" -gravity northwest -annotate +120+230 'omarchy.' \
  -fill "$INK" -annotate +120+230 'omarchy' \
  "${SMALL[@]}" -fill "$INK" -gravity northwest -annotate +120+110 'No. 01' \
  -gravity northeast -annotate +120+110 'THE  DESKTOP  ISSUE' \
  -fill "$INK" -draw "rectangle 120,160 2440,163" \
  -fill "$RULE" -draw "rectangle 120,1250 2440,1251" \
  "${SMALL[@]}" -fill "$GRAY" -gravity southwest -annotate +120+120 'ARCH LINUX, SET IN TYPE' \
  -gravity southeast -annotate +120+120 'PAGE ONE' \
  backgrounds/7-cover.png
echo built
