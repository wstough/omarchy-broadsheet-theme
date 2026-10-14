#!/bin/bash
# Builds the Broadsheet wallpaper collection from tools/wallpapers.list.
# Each line: out | source | style | px | zoom | gravity | x,y | backdrop | gamma | caption
#   style:    pixel (Bayer squares), halftone (round newspaper dots), grain (error diffusion),
#             engraving (clean ink lines for prints/drawings)
#   px:       size of one printed dot/pixel; bigger = chunkier
#   zoom:     1 = image just fills the screen; 1.6 = crop in closer;
#             fit:0.9 = whole image on paper, 90% of screen height (for statues on a backdrop)
#   gravity:  which part of the image to keep (center, north, east, southwest...)
#   x,y:      extra nudge of the crop in pixels
#   backdrop: "keep", or "paper" to flood-fill a dark museum backdrop into paper
#   gamma:    brightness; 1 = as is, 1.5 = lighter (for dark bronze or shadowy photos)
# Usage: tools/make-wallpapers.sh [name-filter]      (run from the theme root)
set -e
W=2560 H=1440
PAPER="#EEEAE0" INK="#1C1B19" CAP="#3A3835" RULE="#78736A"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

grep -vE '^\s*(#|$)' tools/wallpapers.list | while IFS='|' read -r out src style px zoom gravity off backdrop gamma caption; do
  trim() { local s=$1; s=${s#"${s%%[![:space:]]*}"}; echo "${s%"${s##*[![:space:]]}"}"; }
  out=$(trim "$out") src=$(trim "$src") style=$(trim "$style") px=$(trim "$px") zoom=$(trim "$zoom")
  gravity=$(trim "$gravity") off=$(trim "$off") backdrop=$(trim "$backdrop") gamma=$(trim "$gamma") caption=$(trim "$caption")
  [[ -n $1 && $out != *$1* ]] && continue
  x=${off%,*} y=${off#*,}; [[ $x == -* ]] || x="+$x"; [[ $y == -* ]] || y="+$y"
  z=${zoom#fit:}; cw=$(awk "BEGIN{printf \"%d\", $W*$z}") ch=$(awk "BEGIN{printf \"%d\", $H*$z}")

  # 1. Grayscale, optional backdrop -> paper, crop to the screen's shape.
  fill=()
  if [[ $backdrop == paper ]]; then
    read -r sw sh < <(magick identify -format '%w %h\n' "tools/sources/$src")
    fill=(-fuzz 12% -fill white -draw "color 2,2 floodfill" -draw "color $((sw-3)),2 floodfill"
          -draw "color 2,$((sh-3)) floodfill" -draw "color $((sw-3)),$((sh-3)) floodfill")
  fi
  if [[ $zoom == fit:* ]]; then
    fh=$(awk "BEGIN{printf \"%d\", $H*${zoom#fit:}}")
    magick "tools/sources/$src" "${fill[@]}" -colorspace gray -auto-level -gamma "$gamma" -resize "x$fh" "$TMP/s.png"
    magick -size ${W}x${H} xc:white "$TMP/s.png" -gravity "$gravity" -geometry "${x}${y}" -composite \
      -colorspace gray "$TMP/g.png"
  else
    magick "tools/sources/$src" "${fill[@]}" -colorspace gray -auto-level -gamma "$gamma" \
      -resize "${cw}x${ch}^" \
      -gravity "$gravity" -crop "${W}x${H}${x}${y}" +repage -gravity center -extent "${W}x${H}" "$TMP/g.png"
  fi

  # 2. Print it.
  case $style in
    pixel)     magick "$TMP/g.png" -sigmoidal-contrast 4x50% -resize $((W/px))x$((H/px))! -white-threshold 92% \
                 -ordered-dither o8x8 -clamp -threshold 50% -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    halftone)  magick "$TMP/g.png" -sigmoidal-contrast 5x50% -resize $((W*2/px))x$((H*2/px))! -white-threshold 94% \
                 -ordered-dither h8x8o -clamp -threshold 50% -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    grain)     magick "$TMP/g.png" -sigmoidal-contrast 3x50% -resize $((W/px))x$((H/px))! -white-threshold 92% \
                 -dither FloydSteinberg -colors 2 -colorspace gray -auto-level -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    engraving) magick "$TMP/g.png" -level 30%,80% -blur 0x0.6 -threshold 55% "$TMP/p.png" ;;
  esac
  magick "$TMP/p.png" +level-colors "$INK","$PAPER" "$TMP/c.png"

  # 3. Caption plate: a small paper label with a hairline, like a photo caption.
  if [[ -n $caption ]]; then
    tw=$(magick -font Newsreader-16pt-Italic -pointsize 30 label:"$caption" -format '%w' info:)
    magick "$TMP/c.png" -fill "$PAPER" -draw "rectangle 0,1250 $((tw+260)),1440" \
      -fill "$RULE" -draw "rectangle 120,1290 $((tw+140)),1291" \
      -font Newsreader-16pt-Italic -pointsize 30 -fill "$CAP" -gravity northwest -annotate +120+1306 "$caption" \
      "backgrounds/$out.png"
  else
    cp "$TMP/c.png" "backgrounds/$out.png"
  fi
  echo "built backgrounds/$out.png"
done
