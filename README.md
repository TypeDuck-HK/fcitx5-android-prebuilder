# Hints from Copilit-Claude3.7


要編譯這個 fcitx5-android-prebuilder 專案，您需要先確保已安裝所有必要的依賴項，然後按照以下步驟進行：

1. 首先，確保您已安裝所有所需的依賴項：

```bash
# 在 macOS 上安裝基本工具
brew install bash tar curl git python

# 安裝 Haskell 相關工具
brew install ghc cabal-install
cabal install shake aeson-pretty

# 安裝其他必要的依賴項
brew install fcitx5 libime opencc
```

2. 確保您已安裝指定版本的 Android NDK (25.2.9519653)：

3. 可以從 Android Studio 的 SDK Manager 下載
或直接從 Google 的 NDK 下載頁面取得
配置環境變數：

```bash
export ANDROID_NDK_HOME=/path/to/your/android-ndk-25.2.9519653
export PATH=$PATH:$ANDROID_NDK_HOME
```

4. 編譯專案：
```bash
# 進入專案目錄
cd /Users/leungtsinam/Documents/proj/fcitx5-android-prebuilder

# 使用 cabal 建置
cabal update
cabal build

# 執行建置腳本
cabal run prebuilder -- --help  # 查看可用的編譯選項
cabal run prebuilder -- all     # 編譯所有函式庫
```

如果您想要單獨編譯特定的函式庫，可以替換最後的 all 參數，例如：
```bash
cabal run prebuilder -- boost fmt  # 只編譯 boost 和 fmt 函式庫
```

編譯完成後，生成的靜態函式庫應該會出現在專案的 build 或 output 目錄中，可以用於 fcitx5-android 專案。


# prebuilder

Build static libraries for [fcitx5-android](https://github.com/fcitx5-android/fcitx5-android).

## Build environment

Cabal is required to build this project.

* NDK Vesion: `25.2.9519653`
* CMake Version: `3.22.1`
* Android Platform (API Level): `23`
* `bash tar unzip curl git python ghc haskell-shake haskell-aeson-pretty cabal-install`
* `fcitx5` (`fcitx5-modules` on Debian): for `comp-spell-dict`
* `libime` (`libime-bin` on Debian) >= 1.0.5 : for various `libime_*` tools
* `opencc`: for `opencc_dict`

## Libraries

* boost: [moritz-wundke/Boost-for-Android](https://github.com/moritz-wundke/Boost-for-Android)
* fmt: [fmtlib/fmt](https://github.com/fmtlib/fmt)
* libevent: [libevent/libevent](https://github.com/libevent/libevent/tree/release-2.1.12-stable)
* libintl-lite: [j-jorge/libintl-lite](https://github.com/j-jorge/libintl-lite)
* libime data: [fcitx/libime](https://github.com/fcitx/libime)
* lua: [walterschell/LuaCMake](https://github.com/walterschell/Lua)
* opencc: [BYVoid/OpenCC](https://github.com/BYVoid/OpenCC)
* spell-dict data: [fcitx/fcitx5](https://github.com/fcitx/fcitx5/blob/master/src/modules/spell/dict)
* anthy dict: [fujiwarat/anthy-unicode](https://github.com/fujiwarat/anthy-unicode)
* glog: [google/glog](https://github.com/google/glog)
* yaml-cpp: [jbeder/yaml-cpp](https://github.com/jbeder/yaml-cpp)
* leveldb: [google/leveldb](https://github.com/google/leveldb)
* marisa-trie: [rime/marisa-trie](https://github.com/rime/marisa-trie)
* librime: [rime/librime](https://github.com/rime/librime)
* librime-lua: [rime/librime-lua](https://github.com/hchunhui/librime-lua)
* librime-octagram: [rime/librime-octagram](https://github.com/lotem/librime-octagram)
* libhangul: [libhangul/libhangul](https://github.com/libhangul/libhangul)
* libchewing: [chewing/libchewing](https://github.com/chewing/libchewing)
* libthai: [tlwg/libthai](https://github.com/tlwg/libthai)
* libiconv: [GNU/libiconv](https://savannah.gnu.org/projects/libiconv)
