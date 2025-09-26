# Docker OSXCross

[![devel](https://github.com/joseluisq/docker-osxcross/actions/workflows/devel.yml/badge.svg)](https://github.com/joseluisq/docker-osxcross/actions/workflows/devel.yml) [![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/joseluisq/docker-osxcross/1.0.0-beta.1)](https://hub.docker.com/r/joseluisq/docker-osxcross/) [![Docker Image Size (tag)](https://img.shields.io/docker/image-size/joseluisq/docker-osxcross/1.0.0-beta.1)](https://hub.docker.com/r/joseluisq/docker-osxcross/tags) [![Docker Image](https://img.shields.io/docker/pulls/joseluisq/docker-osxcross.svg)](https://hub.docker.com/r/joseluisq/docker-osxcross/)

> Multi-arch Linux AMD64/ARM64 Docker images for [osxcross](https://github.com/tpoechtrager/osxcross) using the latest __Debian [13-slim](https://hub.docker.com/_/debian/tags?page=1&name=13-slim)__ ([Trixie](https://www.debian.org/News/2025/20250809)).

## OSX SDK Setup

- **OSX_SDK_VERSION**: `13.3`
- **OSX_SDK_SUM**: `518e35eae6039b3f64e8025f4525c1c43786cc5cf39459d609852faf091e34be` ([joseluisq/macosx-sdks@13.3](https://github.com/joseluisq/macosx-sdks/releases/tag/13.3))
- **OSX_VERSION_MIN**: `10.14`
- **OSX_CROSS_COMMIT**: `f873f534c6cdb0776e457af8c7513da1e02abe59` ([tpoechtrager/osxcross commit](https://github.com/tpoechtrager/osxcross/commit/f873f534c6cdb0776e457af8c7513da1e02abe59))

## Usage

```sh
docker pull joseluisq/docker-osxcross:1.0.0-beta.1
# or
docker pull ghcr.io/joseluisq/docker-osxcross:1.0.0-beta.1
```

## Contributions

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in current work by you, as defined in the Apache-2.0 license, shall be dual licensed as described below, without any additional terms or conditions.

Feel free to send some [Pull request](https://github.com/joseluisq/docker-osxcross/pulls) or file an [issue](https://github.com/joseluisq/docker-osxcross/issues).

## License

This work is primarily distributed under the terms of both the [MIT license](LICENSE-MIT) and the [Apache License (Version 2.0)](LICENSE-APACHE).

© 2025-present [Jose Quintana](https://github.com/joseluisq)
