#!/bin/sh

set -euo pipefail

if [ -z "${NO_INIT_USER:-}" ]
then
    addgroup -g "${STRELAYSRV_GID}" strelaysrv
    adduser -h "${STRELAYSRV_HOME}" -g strelaysrv -s /sbin/nologin -G strelaysrv -D -u "${STRELAYSRV_UID}" strelaysrv
fi

cd "${STRELAYSRV_HOME}"

"${@}"
