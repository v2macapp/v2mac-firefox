# CLAUDE.md (firefox)

Secure Sandbox plugin: Debian's Firefox ESR, `display: gui`. Made from `../plugin-template`; its
`docs/plugin-api.md` is the API and `../store/REVIEW.md` what the store checks. The privacy profile is
the sandbox plan §10 Firefox item.

- A recipe (api 2): `packages` in `plugin.json` brings Firefox from Debian and Debian updates it; the `Containerfile` only copies settings, `FROM` the base pinned in `base.txt` (from `../store/bases.json`). After testing a new major version, set `tested` in `start.sh` and release.
- Static privacy prefs and telemetry off live in `policies.json` (installed as Firefox's distribution
  policies); what depends on the exit (location from `exit.json`) and on permissions (download folder)
  is written to `user.js` by `start.sh` at each launch.
- `start.sh` turns sway's forced fullscreen off for Firefox and guards the profile with flock, as Chromium does.
- Test locally: `Scripts/package.sh . "$(cat base.txt)" http://127.0.0.1:8765`, then run the image
  with the sandbox's flags (`--cap-drop=all --read-only`, tmpfs `/tmp`) under headless sway.
- Release: bump `version` and `changelog` in `plugin.json`, tag `vX.Y.Z` when the user says, then a
  store PR adding `submissions/firefox.json`. Planned public repo: `v2macapp/v2mac-firefox` (not created yet).
