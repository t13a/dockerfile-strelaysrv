#!/bin/sh

set -euo pipefail

addgroup -g "${STRELAYSRV_GID}" strelaysrv
adduser -h "${STRELAYSRV_HOME}" -g strelaysrv -s /sbin/nologin -G strelaysrv -D -u "${STRELAYSRV_UID}" strelaysrv
cd "${STRELAYSRV_HOME}"
exec su-exec strelaysrv strelaysrv "${@}"
