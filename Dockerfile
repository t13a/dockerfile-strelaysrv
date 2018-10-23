ARG ALPINE_IMAGE=alpine
ARG GOLANG_ALPINE_IMAGE=golang:alpine

FROM ${GOLANG_ALPINE_IMAGE} AS builder

ARG SYNCTHING_BRANCH=master
ARG SYNCTHING_REPOSITORY=https://github.com/syncthing/syncthing

ENV CGO_ENABLED=0

WORKDIR /go/src/github.com/syncthing/syncthing

RUN apk add --no-cache git && \
    git clone -b "${SYNCTHING_BRANCH}" "${SYNCTHING_REPOSITORY}" "$(pwd)" && \
    rm -f strelaysrv && \
    go run build.go -no-upgrade build strelaysrv

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
