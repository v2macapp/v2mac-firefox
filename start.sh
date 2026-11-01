#!/bin/sh
# The base's sway makes every window fullscreen, which Firefox takes as F11 (no tabs, no address bar).
# Its window is still the only one, so it fills the screen without it.
SWAYSOCK=$(ls "$XDG_RUNTIME_DIR"/sway-ipc.*.sock | head -n1) swaymsg 'for_window [app_id="firefox-esr"] fullscreen disable' >/dev/null
p=~/.mozilla/v2mac
mkdir -p "$p"
# Firefox's own lock names this container's hostname, new at every launch, so after a hard stop it would
# refuse the profile. flock guards it instead: the file is on the mini VM's disk and the kernel drops it.
exec 9>"$p/.v2mac-lock"
flock -n 9 || { echo "Firefox is already open in this mini VM." >&2; exit 1; }
rm -f "$p/lock"
# Geolocation answers with the exit's city, never the Mac's; without coordinates it finds nothing.
# shortcut: read at launch only, so an exit change shows after Firefox reopens; watch exit.json if users need it live.
num() { sed -n "s/.*\"$1\": *\(-\{0,1\}[0-9][0-9.]*\).*/\1/p" /run/v2mac/exit.json 2>/dev/null; }
lat=$(num latitude); lng=$(num longitude)
if [ -n "$lat" ] && [ -n "$lng" ]; then
  geo="data:application/json,{\\\"location\\\":{\\\"lat\\\":$lat,\\\"lng\\\":$lng},\\\"accuracy\\\":5000}"
else
  geo=""
fi
{
  echo "user_pref(\"geo.provider.network.url\", \"$geo\");"
  [ -d ~/Shared ] && echo "user_pref(\"browser.download.dir\", \"$HOME/Shared\");" && echo 'user_pref("browser.download.folderList", 2);'
} > "$p/user.js"
# Debian updates Firefox without a V2Mac release: say once when a major version nobody here has tested arrives.
tested=153
major=$(firefox-esr --version | sed -n 's/.* \([0-9][0-9]*\)\..*/\1/p')
if [ -n "$major" ] && [ "$major" != "$tested" ] && [ ! -e "$p/.v2mac-warned-$major" ]; then
  touch "$p/.v2mac-warned-$major"
  zenity --warning --title="Firefox $major" --text="Debian updated Firefox to version $major. V2Mac has tested version $tested, so its privacy settings may behave differently until V2Mac tests this one." &
fi
export MOZ_ENABLE_WAYLAND=1
exec firefox-esr --no-remote --profile "$p" "$@"
