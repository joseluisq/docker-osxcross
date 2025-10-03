ARG VERSION=0.0.0
ARG OSX_SDK_VERSION=13.3
ARG OSX_SDK_SUM=518e35eae6039b3f64e8025f4525c1c43786cc5cf39459d609852faf091e34be
ARG OSX_VERSION_MIN=10.14
ARG OSX_CROSS_COMMIT=f873f534c6cdb0776e457af8c7513da1e02abe59

FROM debian:13.1-slim AS builder

ARG VERSION
ARG OSX_SDK_VERSION
ARG OSX_SDK_SUM
ARG OSX_VERSION_MIN
ARG OSX_CROSS_COMMIT

WORKDIR /usr/local/osxcross

RUN set -eux \
    && dpkg --add-architecture amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
        autoconf \
        automake \
        bison \
        build-essential \
        ca-certificates \
        clang \
        cmake \
        curl \
        file \
        git \
        libbz2-dev \
        libssl-dev \
        libxml2-dev \
        pkgconf \
        python3 \
        xutils-dev \
        xz-utils \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true

RUN set -eux \
    && echo "Cloning osxcross..." \
    && git clone --depth 10 --branch master https://github.com/tpoechtrager/osxcross.git /usr/local/osxcross \
    && git checkout -q "${OSX_CROSS_COMMIT}" \
    && rm -rf ./.git \
    && true

RUN set -eux \
    && curl -sSL -o "./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        "https://github.com/joseluisq/macosx-sdks/releases/download/${OSX_SDK_VERSION}/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
    && echo "${OSX_SDK_SUM}  ./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" | sha256sum -c - \
    && UNATTENDED=yes OSX_VERSION_MIN=${OSX_VERSION_MIN} ./build.sh \
    && cd /usr/local/osxcross/build/apple-libtapi/src/llvm \
    && rm -rf benchmarks examples unittests \
    && rm -rf ./tarballs *.tar.xz /tmp/* \
    && true

# compiler-rt can be needed to build code using `__builtin_available()`
RUN set -eux \
    && cd /usr/local/osxcross \
    && echo "Building osxcross with compiler-rt..." \
    && env DISABLE_PARALLEL_ARCH_BUILD=1 ./build_compiler_rt.sh \
    && cd /usr/local/osxcross/build/compiler-rt/llvm \
    && rm -rf test unittests benchmarks examples docs \
    && cd /usr/local/osxcross/build/compiler-rt/clang \
    && rm -rf test unittests docs examples \
    && rm -rf /tmp/* \
    && true

ENV VERSION=$VERSION
ENV OSX_SDK_VERSION=$OSX_SDK_VERSION
ENV OSX_SDK_SUM=$OSX_SDK_SUM
ENV OSX_VERSION_MIN=$OSX_VERSION_MIN
ENV OSX_CROSS_COMMIT=$OSX_CROSS_COMMIT

ENV PATH=$PATH:/usr/local/osxcross/target/bin
ENV MACOSX_DEPLOYMENT_TARGET=${OSX_VERSION_MIN}
ENV OSXCROSS_MACPORTS_MIRROR=https://packages.macports.org
ENV OSXCROSS_MACPORTS_LOCAL=/usr/local/osxcross/target/macports/pkgs/opt/local
ENV OSXCROSS_MACPORTS_LIBEXEC=${OSXCROSS_MACPORTS_LOCAL}/libexec

ENV PKG_CONFIG_ALLOW_CROSS=true
ENV PKG_CONFIG_ALL_STATIC=true

RUN set -eux \
    && echo "Testing osxcross with compiler-rt..." \
    && echo "int main(void){return 0;}" | xcrun clang -xc -o/dev/null -v - 2>&1 | grep "libclang_rt" 1>/dev/null \
    && echo "compiler-rt installed and woking successfully!" \
    && true

LABEL version="${VERSION}" \
    description="Linux AMR64 Docker image for osxcross" \
    maintainer="Jose Quintana <joseluisq.net>"\
    org.opencontainers.image.vendor="Jose Quintana" \
    org.opencontainers.image.url="https://github.com/joseluisq/docker-osxcross" \
    org.opencontainers.image.title="Docker OSXCross" \
    org.opencontainers.image.description="Linux AMR64 Docker image for osxcross." \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.documentation="https://github.com/joseluisq/docker-osxcross"

WORKDIR /root/src

CMD ["bash"]
