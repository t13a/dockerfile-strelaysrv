# Syncthing Relay Server

Dockerfile for [Syncthing Relay Server](https://docs.syncthing.net/users/strelaysrv.html), the relay server for [Syncthing](https://syncthing.net/).

## Usage

Run as local server:

```sh
docker run \
--rm \
-p 22067:22067 \
-v $(pwd)/strelaysrv:/strelaysrv \
t13a/strelaysrv \
-pools=""
```
