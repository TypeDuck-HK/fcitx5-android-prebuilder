# TypeDuck Android Prebuilder

Build the native dependencies used by TypeDuck Android.

## Build

Requires GHC, cabal-install, bash, tar, unzip, curl, git, Python, CMake,
Ninja, extra-cmake-modules and the host dependencies required by fcitx5.
Host fmt, fcitx5, Marisa and OpenCC tools are built from pinned sources.

```bash
git submodule update --init
git -C librime submodule update --init plugins/rime-dictionary-lookup-filter
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/28.0.13004108"
export CMAKE_VERSION=3.31.6
export ANDROID_PLATFORM=23
export ABI=armeabi-v7a,arm64-v8a,x86,x86_64
export CMAKE_BUILD_PARALLEL_LEVEL=4
./build-cabal -j4 everything
```

The SDK must contain the selected NDK and CMake versions.
`build/artifacts.txt` lists the complete distributable output:
boost, libuv, libintl-lite, opencc, glog, yaml-cpp, leveldb, marisa,
librime, spell-dict and toolchain-versions.json.

LibRime is pinned to [TypeDuck-HK/librime](https://github.com/TypeDuck-HK/librime)
with its required dictionary-lookup plugin merged into the static library.
Its Android patch preserves option persistence and removes embedded source paths.
Do not recursively initialize librime: its nested schema checkout is not a build
input here. The Android repository packages the complete schema separately.
