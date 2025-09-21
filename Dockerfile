FROM debian:13.1-slim

ARG VERSION=0.0.0
ENV VERSION=${VERSION}

LABEL version="${VERSION}" \
    description="Use same Docker image for compiling Rust programs for Linux (musl libc) & macOS (osxcross)." \
    maintainer="Jose Quintana <joseluisq.net>"

RUN set -eux \
    && dpkg --add-architecture arm64 \
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
        flex \
        g++-aarch64-linux-gnu \
        gcc-aarch64-linux-gnu \
        git \
        libbz2-dev \
        libgmp-dev \
        libicu-dev \
        libmpc-dev \
        libmpfr-dev \
        libpq-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        libxml2-dev \
        linux-libc-dev \
        llvm-dev \
        musl-dev \
        musl-dev:arm64 \
        musl-tools \
        patch \
        pkgconf \
        python3 \
        xutils-dev \
        xz-utils \
        yasm \
        zlib1g-dev \
    # Clean up local repository of retrieved packages and remove the package lists
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true

# pkg-config related environment variables
ENV PKG_CONFIG_ALLOW_CROSS=true \
    PKG_CONFIG_ALL_STATIC=true

    
# Mac OS X SDK version - https://github.com/joseluisq/macosx-sdks
WORKDIR /usr/local/osxcross

ARG OSX_SDK_VERSION=13.3
ARG OSX_SDK_SUM=518e35eae6039b3f64e8025f4525c1c43786cc5cf39459d609852faf091e34be
ARG OSX_VERSION_MIN=10.14

# OS X Cross - https://github.com/tpoechtrager/osxcross
ARG OSX_CROSS_COMMIT=f873f534c6cdb0776e457af8c7513da1e02abe59

# Install OS X Cross
# A Mac OS X cross toolchain for Linux, FreeBSD, OpenBSD and Android
RUN set -eux \
    && echo "Cloning osxcross..." \
    && git clone https://github.com/tpoechtrager/osxcross.git /usr/local/osxcross \
    && git checkout -q "${OSX_CROSS_COMMIT}" \
    && rm -rf ./.git \
    && true

RUN set -eux \
    && echo "Building osxcross with ${OSX_SDK_VERSION}..." \
    && curl -Lo "./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        "https://github.com/joseluisq/macosx-sdks/releases/download/${OSX_SDK_VERSION}/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
    && echo "${OSX_SDK_SUM}  ./tarballs/MacOSX${OSX_SDK_VERSION}.sdk.tar.xz" \
        | sha256sum -c - \
    && UNATTENDED=yes OSX_VERSION_MIN=${OSX_VERSION_MIN} ./build.sh \
    && rm -rf *~ taballs *.tar.xz \
    && rm -rf /tmp/* \
    && true

# Build osxcross compiler-rt
RUN set -eux \
    && cd /usr/local/osxcross \
    && echo "Building osxcross with compiler-rt..." \
    # compiler-rt can be needed to build code using `__builtin_available()`
    && env DISABLE_PARALLEL_ARCH_BUILD=1 ./build_compiler_rt.sh \
    && true

# osxcross related environment variables
ENV PATH=$PATH:/usr/local/osxcross/target/bin
ENV MACOSX_DEPLOYMENT_TARGET=${OSX_VERSION_MIN}
ENV OSXCROSS_MACPORTS_MIRROR=https://packages.macports.org
ENV OSXCROSS_MACPORTS_LOCAL=/usr/local/osxcross/target/macports/pkgs/opt/local
ENV OSXCROSS_MACPORTS_LIBEXEC=${OSXCROSS_MACPORTS_LOCAL}/libexec

# Test osxcross compiler-rt
RUN set -eux \
    && echo "Testing osxcross with compiler-rt..." \
    && echo "int main(void){return 0;}" | xcrun clang -xc -o/dev/null -v - 2>&1 | grep "libclang_rt" 1>/dev/null \
    && echo "compiler-rt installed and working successfully!" \
    && true

RUN set -eux \
    && echo "Install dependencies via osxcross tools..." \
    && apt-get update \
    && /usr/local/osxcross/tools/get_dependencies.sh \
    && true

RUN set -eux \
    && echo "Removing temp files..." \
    && rm -rf *~ taballs *.tar.xz \
    && rm -rf /tmp/* \
    && true

WORKDIR /root/src

CMD ["bash"]
