# Firefox ESR's settings on the released base; `packages` in plugin.json brings the browser from Debian.
ARG BASE
FROM ${BASE}
COPY policies.json /usr/lib/firefox-esr/distribution/policies.json
COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh
