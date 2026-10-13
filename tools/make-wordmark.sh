#!/bin/bash
# Minimal wordmark wallpaper: "omarchy" in Newsreader italic (SIL Open Font License).
set -e
PAPER="#EEEAE0" INK="#1C1B19" RULE="#8E897F"
magick -size 2560x1440 xc:"$PAPER" -fill "$INK" -font Newsreader-16pt-Italic -pointsize 130 \
  -gravity center -annotate +0-20 'omarchy' \
  -fill "$RULE" -draw "rectangle 1200,1320 1360,1321" "${1:-backgrounds/2-wordmark.png}"
