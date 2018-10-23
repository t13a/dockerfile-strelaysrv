ARG ALPINE_IMAGE=alpine
ARG GOLANG_IMAGE=golang:alpine

FROM ${ALPINE_IMAGE} AS collector

ARG SYNCTHING_BRANCH=master
ARG SYNCTHING_SRC=
ARG SYNCTHING_SRC_DIR=syncthing-${SYNCTHING_BRANCH}
ARG SYNCTHING_SRC_ZIP=https://github.com/syncthing/syncthing/archive/${SYNCTHING_BRANCH}.zip
ARG SYNCTHING_DEST=${SYNCTHING_SRC:+/syncthing}
ARG SYNCTHING_DEST_ZIP=${SYNCTHING_DEST:-/syncthing.zip}

ADD "${SYNCTHING_SRC:-${SYNCTHING_SRC_ZIP}}" "/${SYNCTHING_DEST:-${SYNCTHING_DEST_ZIP}}"

RUN [ -d /syncthing ] || (unzip /syncthing.zip && mv "${SYNCTHING_SRC_DIR}" /syncthing)

FROM ${GOLANG_IMAGE} AS builder

ENV CGO_ENABLED=0

COPY --from=collector /syncthing /go/src/github.com/syncthing/syncthing

WORKDIR /go/src/github.com/syncthing/syncthing

RUN go run build.go -no-upgrade build strelaysrv

FROM ${ALPINE_IMAGE}

ENV STRELAYSRV_USER=strelaysrv
ENV STRELAYSRV_UID=1000
ENV STRELAYSRV_GID=1000
ENV STRELAYSRV_HOME=/strelaysrv

COPY --from=builder /go/src/github.com/syncthing/syncthing/strelaysrv /usr/local/bin/strelaysrv
COPY /rootfs /

RUN apk add --no-cache \
    ca-certificates \
    su-exec

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "su-exec", "strelaysrv", "strelaysrv" ]
