# Agent notes

- This repository is the OTClient application, not the game server. The related backend lives separately at a different repository called `otserver`, existing at `../otserver/`; make server-side changes there rather than treating it as part of this CMake project.
- The executable is a single CMake target, `otclient` (`src/main.cpp`); the root CMake file includes `src/framework` and `src/client`. C++ is compiled as C++20.
- Most game UI and functionality is Lua-driven: `modules/` contains built-in modules, `mods/` is for optional/custom mods, and `data/` holds client assets/configuration. Keep changes in the appropriate layer; module UI layouts are commonly `.otui` alongside Lua and `.otmod` metadata.
- Build from the repository root with `cmake -S . -B build` followed by `cmake --build build -j$(nproc)`. CMake requires external libraries (including Lua, PhysFS, zlib, graphics and, with default options, OpenAL/Vorbis); see `src/framework/CMakeLists.txt` for package detection and toggles. The README defers platform-specific dependency setup to the project wiki.
- `compile.sh` is a Docker-oriented helper, not a general local build command: inside the expected container it configures `/otclient/build` with Vorbis library overrides; outside it delegates to `setup-and-run-docker.sh`.
- No test, lint, or formatter target/configuration is defined in the root CMake project. Verify C++ changes by building the target; test Lua/UI changes in a running client when the environment permits.
- Client protocol behavior is implemented in `src/client/protocolgame*`; coordinate any protocol changes with the separate server repository when needed.

## Extended context details
- `context/CONTEXT.md` — index of project knowledge pages; add or read pages under `context/pages/*`.
