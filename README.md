# Firefox ESR for V2Mac Sandbox

Firefox ESR as a V2Mac Secure Sandbox app: it runs in a mini VM and every site sees only that mini
VM's exit server. Install it from the V2Mac Store in the Sandbox window.

Privacy settings (in `policies.json` and `start.sh`):
- Time zone follows the exit; fingerprinting protection is on, without forcing UTC.
- Location answers with the exit's city, read from `/run/v2mac/exit.json` at launch.
- WebRTC offers no local addresses; telemetry and studies are off.

Permissions: clipboard, Shared (downloads go to `~/V2Mac Sandbox/<Mini VM>/Shared`), sound and microphone.

Build: `Scripts/package.sh . "$(cat base.txt)" <url prefix>`. Release: push a `v*` tag; the workflow
attaches the archive and the filled `plugin.json`, which is submitted to the V2Mac store.
Built from [v2mac-plugin-template](https://github.com/v2macapp/v2mac-plugin-template). Licence: 0BSD.
