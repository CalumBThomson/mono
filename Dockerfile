ARG IMAGE_BASE_DISTRO="alpine"
ARG IMAGE_BASE_VER="3.12"
ARG IMAGE_MONO_VER="6.12.0.93"
ARG IMAGE_MONO_PREFIX="/usr/local"


FROM ${IMAGE_BASE_DISTRO}:${IMAGE_BASE_VER} AS base
RUN apk --no-cache add libgcc ca-certificates


LABEL maintainer="CBT Docker Maintainers <docker-maint@cbthomson.com>"


FROM base AS build
# install packages
RUN apk --no-cache add --virtual .build-deps-1 \
        curl \
        git
RUN mkdir /build
WORKDIR /build
# clone mono git repo (takes time!)
RUN git clone https://github.com/mono/mono.git
WORKDIR /build/mono
# update all git repo sub-modules
RUN git submodule update --init --recursive
# install packages
RUN apk --no-cache add --virtual .build-deps-2 \
        autoconf \
        automake \
        bash \
        cmake \
        g++ \
        gcc \
        gdb \
        libtool \
        linux-headers \
        make \
        musl-dev \
        python3 \
        strace \
        xz
ARG IMAGE_MONO_VER
# fetch & checkout required branch / tag
RUN git fetch \
 && git checkout mono-${IMAGE_MONO_VER} \
 && git submodule update --init --recursive
# build mono
ARG IMAGE_MONO_PREFIX
RUN ./autogen.sh \
        --prefix=${IMAGE_MONO_PREFIX} \
        --with-mcs-docs=no \
        --with-sigaltstack=no \
        --disable-nls
RUN ln -s /usr/bin/python3 /usr/bin/python
# patch by rickardp (https://github.com/CombinationAB/mono-alpine)
RUN mkdir -p /usr/include/sys \
 && touch /usr/include/sys/sysctl.h
RUN sed -i 's/HAVE_DECL_PTHREAD_MUTEXATTR_SETPROTOCOL/0/' mono/utils/mono-os-mutex.h
RUN make -j 16
RUN make install
# clean up
RUN apk del --purge .build-deps-1 \
 && apk del --purge .build-deps-2
RUN rm -rf ${IMAGE_MONO_PREFIX}/include && find ${IMAGE_MONO_PREFIX} -name \*.a | xargs rm


FROM base AS final
# copy in required mono files
ARG IMAGE_MONO_PREFIX
COPY --from=build ${IMAGE_MONO_PREFIX}/ ${IMAGE_MONO_PREFIX}/
# install tini (https://github.com/krallin/tini.git) and run cert-sync
RUN apk --no-cache add tini \
 && cert-sync /etc/ssl/certs/ca-certificates.crt
# set entry point
USER nobody
ENTRYPOINT ["/sbin/tini","-vv","-e","143","--","mono"]
CMD ["--version"]
