#!/bin/bash
# Generates backgrounds/1-masthead.png: an original front-page masthead on paper.
# Fonts are Noto Serif (SIL Open Font License). Run from the theme root.
set -e
W=2560 H=1440
PAPER='#FBF9F4' INK='#111111' RULE='#8C8880'

magick -size ${W}x${H} xc:"$PAPER" -attenuate 0.12 +noise Gaussian -blur 0x0.5 \
  -fill "$INK" -stroke none \
  -draw "rectangle 320,250 2240,253" \
  -draw "rectangle 320,259 2240,260" \
  -font Noto-Serif-Display-Black -pointsize 190 -gravity north \
  -annotate +0+290 'The Broadsheet' \
  -font Noto-Serif-Display-Italic -pointsize 34 -fill "#333333" \
  -annotate +0+545 '“All the bits that fit.”' \
  -fill "$INK" \
  -draw "rectangle 320,610 2240,612" \
  -font Noto-Serif-Bold -pointsize 26 -gravity northwest \
  -annotate +330+632 'VOL. I . . . No. 1' \
  -gravity north -annotate +0+632 'ESTABLISHED 2026' \
  -gravity northeast -annotate +330+632 'OMARCHY EDITION' \
  -draw "rectangle 320,684 2240,685" \
  -draw "rectangle 320,690 2240,692" \
  -fill "$RULE" -draw "rectangle 1279,740 1280,1200" \
  backgrounds/1-masthead.png
