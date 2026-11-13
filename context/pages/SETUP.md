# Development environment setup

## Prerequisites

- Run the setup from the OTClient repository. The helper scripts mount this checkout at `/otclient` inside the environment.
- Install Docker with Buildx support and Distrobox on the host. The Distrobox creation helper also requests NVIDIA integration (`--nvidia`), so use a host with the relevant NVIDIA support configured.
- The supplied root `Dockerfile` uses Ubuntu 24.04 and installs CMake, build tools, Lua 5.1, zlib, OpenSSL, GLEW, OpenAL, Vorbis, and ASIO development packages. It builds PhysFS from upstream `stable-3.2` and labels the resulting image `otbi`.

## Create the image and container

From the repository root, build the Docker image first:

```sh
tools/do
```

With no arguments, `tools/do` runs `docker buildx build -t otbi` using the repository root as the build context. Then create the Distrobox container:

```sh
tools/dtb
```

With no arguments, `tools/dtb` creates a Distrobox named `otb` from image `otbi` and mounts this repository at `/otclient`. Re-run the image build and recreate/update the container when you need changes made to the Dockerfile or image dependencies to take effect.

## Run commands in the development environment

Pass the command after `tools/dtb`; it runs inside the existing `otb` container; when referring to the folder, use `/otclient/` where the volume is mapped to:

```sh
tools/dtb /otclient/compile.sh
tools/dtb cmake --version
```

The first command is the normal project build flow. `compile.sh` detects its container environment, configures `/otclient/build` with explicit Vorbis library locations, then invokes `make -j$(nproc)`. Build details and CMake options are in [BUILD.md](BUILD.md).

`tools/do <command> [args...]` is a separate one-shot Docker path: it runs the command in a temporary `otbi` container (`--rm`), mounts the current working directory at `/otclient`, uses host networking, and runs as the current host UID/GID. Prefer `tools/dtb <command>` for ongoing development, as the project Distrobox persists between commands.

## Runtime assets

The repository does not include Tibia `spr`/`dat` assets. A complete client runtime needs compatible assets under `data/things/VERSION/` (see `README.md`).
