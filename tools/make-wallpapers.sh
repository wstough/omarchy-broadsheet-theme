#!/bin/bash
# Builds the OmaPaper wallpaper collection from tools/wallpapers.list, or with --dark the
# OmaPaper Dark collection from tools/wallpapers-dark.list into ../omapaper-dark/backgrounds.
# Each line: out | source | style | px | zoom | gravity | x,y | backdrop | gamma | caption
#   style:    pixel (Bayer squares), halftone (round newspaper dots), grain (error diffusion),
#             engraving (clean ink lines for prints/drawings); add -neg (e.g. engraving-neg)
#             to print a negative: light lines on a dark page, like scratchboard
#   px:       size of one printed dot/pixel; bigger = chunkier
#   zoom:     1 = image just fills the screen; 1.6 = crop in closer;
#             fit:0.9 = whole image on paper, 90% of screen height (for statues on a backdrop)
#   gravity:  which part of the image to keep (center, north, east, southwest...)
#   x,y:      extra nudge of the crop in pixels
#   backdrop: "keep"; "paper" flood-fills a dark museum backdrop to white; "ink" fills it to black;
#             "trim" cuts a print's blank paper margin off first, so the crop is all picture
#   (A crop never pads: if it would come up short of the screen, it zooms in to fill it.)
#   gamma:    brightness; 1 = as is, 1.5 = lighter (for dark bronze or shadowy photos)
# Usage: tools/make-wallpapers.sh [--dark] [name-filter]      (run from the theme root)
set -e
W=2560 H=1440
if [[ $1 == --dark ]]; then
  shift; LIST=tools/wallpapers-dark.list OUT=../omapaper-dark/backgrounds
  DARK="#1A1917" LIGHT="#E4DFD3" PLATE="#1A1917" CAP="#A39E93" RULE="#7E796F"
  CANVAS=black CLEAN=(-black-threshold 8%)
else
  LIST=tools/wallpapers.list OUT=backgrounds
  DARK="#1C1B19" LIGHT="#EEEAE0" PLATE="#EEEAE0" CAP="#3A3835" RULE="#78736A"
  CANVAS=white CLEAN=()
fi
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT

grep -vE '^\s*(#|$)' "$LIST" | while IFS='|' read -r out src style px zoom gravity off backdrop gamma caption; do
  trim() { local s=$1; s=${s#"${s%%[![:space:]]*}"}; echo "${s%"${s##*[![:space:]]}"}"; }
  out=$(trim "$out") src=$(trim "$src") style=$(trim "$style") px=$(trim "$px") zoom=$(trim "$zoom")
  gravity=$(trim "$gravity") off=$(trim "$off") backdrop=$(trim "$backdrop") gamma=$(trim "$gamma") caption=$(trim "$caption")
  [[ -n $1 && $out != *$1* ]] && continue
  x=${off%,*} y=${off#*,}; [[ $x == -* ]] || x="+$x"; [[ $y == -* ]] || y="+$y"
  z=${zoom#fit:}; cw=$(awk "BEGIN{printf \"%d\", $W*$z}") ch=$(awk "BEGIN{printf \"%d\", $H*$z}")

  # 1. Grayscale, optional backdrop -> paper, crop to the screen's shape.
  fill=() neg=()
  [[ $style == *-neg ]] && { style=${style%-neg}; neg=(-negate); }
  if [[ $backdrop == paper || $backdrop == ink ]]; then
    read -r sw sh < <(magick identify -format '%w %h\n' "tools/sources/$src")
    fc=white; [[ $backdrop == ink ]] && fc=black
    fill=(-fuzz 12% -fill $fc -draw "color 2,2 floodfill" -draw "color $((sw-3)),2 floodfill"
          -draw "color 2,$((sh-3)) floodfill" -draw "color $((sw-3)),$((sh-3)) floodfill")
  fi
  if [[ $backdrop == trim ]]; then
    # Find the picture inside the paper margin on a blurred copy (ignores paper grain), inset 1.5%.
    read -r bw bh bx by < <(magick "tools/sources/$src" -colorspace gray -blur 0x4 -fuzz 14% -trim -format '%w %h %X %Y\n' info:)
    bx=${bx#+} by=${by#+}; ix=$((bw * 15 / 1000)) iy=$((bh * 15 / 1000))
    fill=(-crop "$((bw - 2*ix))x$((bh - 2*iy))+$((bx + ix))+$((by + iy))" +repage)
  fi
  if [[ $zoom == fit:* ]]; then
    fh=$(awk "BEGIN{printf \"%d\", $H*${zoom#fit:}}")
    magick "tools/sources/$src" "${fill[@]}" -colorspace gray "${neg[@]}" -auto-level -gamma "$gamma" -resize "x$fh" "$TMP/s.png"
    magick -size ${W}x${H} xc:$CANVAS "$TMP/s.png" -gravity "$gravity" -geometry "${x}${y}" -composite \
      -colorspace gray "$TMP/g.png"
  else
    magick "tools/sources/$src" "${fill[@]}" -colorspace gray "${neg[@]}" -auto-level -gamma "$gamma" \
      -resize "${cw}x${ch}^" \
      -gravity "$gravity" -crop "${W}x${H}${x}${y}" +repage \
      -resize "${W}x${H}^" -gravity center -extent "${W}x${H}" "$TMP/g.png"
  fi

  # 2. Print it.
  case $style in
    pixel)     magick "$TMP/g.png" -sigmoidal-contrast 4x50% "${CLEAN[@]}" -resize $((W/px))x$((H/px))! -white-threshold 92% \
                 -ordered-dither o8x8 -clamp -threshold 50% -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    halftone)  magick "$TMP/g.png" -sigmoidal-contrast 5x50% "${CLEAN[@]}" -resize $((W*2/px))x$((H*2/px))! -white-threshold 94% \
                 -ordered-dither h8x8o -clamp -threshold 50% -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    grain)     magick "$TMP/g.png" -sigmoidal-contrast 3x50% "${CLEAN[@]}" -resize $((W/px))x$((H/px))! -white-threshold 92% \
                 -dither FloydSteinberg -colors 2 -colorspace gray -auto-level -filter point -resize ${W}x${H}! "$TMP/p.png" ;;
    engraving) magick "$TMP/g.png" -level 30%,80% -blur 0x0.6 -threshold 55% "$TMP/p.png" ;;
  esac
  magick "$TMP/p.png" +level-colors "$DARK","$LIGHT" "$TMP/c.png"

  # 3. Caption plate: a small label in the lower-right corner with a hairline, like a photo credit.
  if [[ -n $caption ]]; then
    tw=$(magick -font Newsreader-16pt-Italic -pointsize 22 label:"$caption" -format '%w' info:)
    x0=$((W - tw - 96))
    magick "$TMP/c.png" -fill "$PLATE" -draw "rectangle $x0,$((H - 92)) $W,$H" \
      -fill "$RULE" -draw "rectangle $((x0 + 48)),$((H - 64)) $((W - 48)),$((H - 64))" \
      -font Newsreader-16pt-Italic -pointsize 22 -fill "$CAP" -gravity southeast -annotate +48+24 "$caption" \
      "$OUT/$out.png"
  else
    cp "$TMP/c.png" "$OUT/$out.png"
  fi
  echo "built $OUT/$out.png"
done
