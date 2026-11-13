# Build and toolchain

## Technologies

The stack below is for this **client repository**; it is not a list of technologies used by the separate game server.

- **C++20** is the native implementation language. **CMake** configures the single `otclient` executable.
- **Lua 5.1** drives much of the client behavior and modules, with C++/Lua bindings in `src/framework/luaengine` and client bindings in `src/client`. LuaJIT is a supported alternative, but `LUAJIT` defaults to OFF.
- **OTUI** styles/layouts and **OTML** configuration are used by UI/modules. The framework also includes **TinyXML** for XML data. These are distinct formats; do not assume the client uses JSON for its module/config system.
- **Networking:** standalone **ASIO** provides asynchronous TCP networking; the client implements the Tibia game protocol in `src/client/protocolgame*` and has HTTP protocol support in the framework. ASIO is header-only here and detected from installed headers.
- **Graphics:** **OpenGL** (the client has OpenGL 1.x/2.0 rendering paths) with **GLEW** on desktop Linux/X11; OpenGL ES 1.0/2.0 and EGL are optional platform paths. **X11** is linked on non-Windows, non-Apple desktop builds.
- **Audio:** **OpenAL** with **Vorbis/Ogg** decoding (via VorbisFile) when `FRAMEWORK_SOUND` is enabled; it is ON by default.
- **Support libraries:** **PhysicsFS (PhysFS)** for filesystem/archive access, **zlib** for compression, and **OpenSSL** when found (otherwise **GMP** is required for the corresponding crypto support).
- **MySQL/MariaDB:** these are not client technologies in this repository. The root CMake file declares `FRAMEWORK_SQL` but defaults it OFF; there is no MySQL client dependency in the configured target. Database/server technology belongs to the separate `otserver` project.
- **Build environment:** the documented development path uses Docker image `otbi` and Distrobox container `otb`; the root Dockerfile is based on Ubuntu 24.04. See [SETUP.md](SETUP.md).

## Build

From the repository root, build in the project's Distrobox environment:

```sh
tools/dtb /otclient/compile.sh
```

`tools/dtb` runs the command in container `otb`; `compile.sh` configures and builds `/otclient/build`. See [SETUP.md](SETUP.md) to create the environment. Outside Distrobox, use CMake directly:

```sh
cmake -S . -B build
cmake --build build -j$(nproc)
```

The default build type is `RelWithDebInfo`; override it with `-DCMAKE_BUILD_TYPE=Debug` when configuring. Dependencies and feature toggles are defined in the root and framework CMake files.

## Docker build helper

`compile.sh` is intended to run inside `otb`. If run on the host, it delegates to `setup-and-run-docker.sh`, which selects a Dockerfile for the host Ubuntu version and runs the build container. See [SETUP.md](SETUP.md) for environment prerequisites and setup.

## Verification and runtime data

- There is no test suite wired into CMake/CTest in the repository. For C++ changes, configure and build the `otclient` target. For Lua/OTUI/module changes, exercise the affected behavior in a running client when possible.
- Running the client may require Tibia `spr`/`dat` assets in `data/things/VERSION/`; these are not supplied by the repository (see `README.md`).
- Protocol implementation is under `src/client/protocolgame*`. Server-side implementation is in the separate `../otserver/` repository, not in this build.
