![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cbtcr/mono-alpine?style=flat)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/cbtcr/mono-alpine/latest?style=flat)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/cbtcr/mono-alpine?style=flat)
![Docker Pulls](https://img.shields.io/docker/pulls/cbtcr/mono-alpine?style=flat)
![GitHub](https://img.shields.io/github/license/CalumBThomson/mono-alpine?style=flat)

# mono-alpine
Docker container image for [Mono](https://github.com/mono/mono) running on Alpine base.

## Quick Start
Launch container, mounting a local dir containing the .exe you want to run and passing the .exe (plus any arguments required) as a parameter to Mono:
```
docker run --rm --name mono -v /path-to-local-dir/:/example cbtcr/mono-alpine /example/example.exe arg1 arg2
```

Alternatively, create following Dockerfile to build new image and copy in your executable(s):
```
FROM cbtcr/mono-alpine
COPY ["src/example.exe","/example/"]
```
