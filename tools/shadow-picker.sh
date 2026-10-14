#!/bin/bash
# Pop-up shadow picker: choose a preset, see it applied to every window instantly,
# then save it to ~/.config/hypr/looknfeel.lua (or quit to go back to what was saved).
# Opens itself in a small floating terminal when launched from a keybinding or menu.
DIR=$(cd "$(dirname "$0")" && pwd)
if [[ $1 != --inside ]]; then
  exec setsid -f foot --app-id=TUI.float --title="Shadow picker" "$DIR/shadow-picker.sh" --inside
fi

LOOKNFEEL=~/.config/hypr/looknfeel.lua
current=""
while true; do
  clear
  gum style --border rounded --padding "0 2" --margin "1 2" \
    "Window shadows" "" "Pick one to try it live on every window." \
    "airy  · wide and very soft        soft  · the default" \
    "crisp · tight, close to the page   paper · hard edge, like a stacked sheet" \
    "${current:+Now trying: $current}"
  choice=$(gum choose --cursor.foreground="#55524C" airy soft crisp paper off "Save this one" "Quit without saving") || break
  case $choice in
    "Save this one")
      [[ -z $current ]] && continue
      body=$(grep -oP "^\s+$current\)\s+S='\K[^']+" "$DIR/try-shadow.sh")
      python3 - "$LOOKNFEEL" "$body" <<'PY'
import re, sys
path, body = sys.argv[1], sys.argv[2]
s = open(path).read()
fields = [f.strip() for f in re.split(r',\s*(?![^{]*\})', body) if f.strip()]
block = "    shadow = {\n" + "".join(f"      {f},\n" for f in fields) + "    },\n"
s = re.sub(r"    shadow = \{\n(?:.*\n)*?    \},\n", block, s, count=1)
open(path, "w").write(s)
PY
      hyprctl reload >/dev/null
      gum style --margin "0 2" "Saved \"$current\". Close this window whenever you like."; sleep 2; break ;;
    "Quit without saving") hyprctl reload >/dev/null; break ;;
    *) "$DIR/try-shadow.sh" "$choice" >/dev/null; current=$choice ;;
  esac
done
