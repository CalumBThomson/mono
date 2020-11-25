![Docker Image Version (latest semver)](https://img.shields.io/docker/v/cbtcr/mono?style=flat)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/cbtcr/mono/latest?style=flat)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/cbtcr/mono?style=flat)
![Docker Pulls](https://img.shields.io/docker/pulls/cbtcr/mono?style=flat)
![GitHub](https://img.shields.io/github/license/CalumBThomson/mono?style=flat)

# mono
Dockerised container image for Mono running on an Alpine base with tini init.  

## Quick Start
Launch a new container -- mount host directory containing the .exe you want to run, then pass this .exe plus any arguments it requires as parameters to Mono:  
```
docker run --rm -it --name mono -v /path-to-local-dir/:/example cbtcr/mono /example/example.exe arg1 arg2
```

Alternatively, create a Dockerfile to build a new image based on this one, then copy in your executable(s):  
```
FROM cbtcr/mono
COPY ["src/example.exe","/example/"]
```

## References
- Mono -- https://github.com/mono/mono
- Mono-Alpine -- https://github.com/CombinationAB/mono-alpine
- Alpine -- https://hub.docker.com/_/alpine
- tini -- https://github.com/krallin/tini
