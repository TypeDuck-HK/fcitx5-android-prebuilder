{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}

module Rules.LibRime where

import Base
import CMakeBuilder
import Data.List.Extra (intercalate)

data LibRime = LibRime
  deriving stock (Eq, Show, Typeable, Generic)
  deriving anyclass (Hashable, Binary, NFData)

type instance RuleResult LibRime = ()

librimeRule :: Rules ()
librimeRule = do
  buildLibrime <-
    useCMake $
      (cmakeBuilder "librime")
        { preBuild = BuildAction $ \_ src -> do
            -- remove absolute path by __FILE__ macro
            cmd_ (Cwd src) "git checkout ."
            cmd_ (Cwd src) "git apply ../patches/librime.patch",
          cmakeEnv = const [("RIME_PLUGINS", "rime-dictionary-lookup-filter")],
          cmakeFlags = \BuildEnv {..} ->
            [ "-DBUILD_SHARED_LIBS=OFF",
              "-DBUILD_STATIC=ON",
              "-DBUILD_TEST=OFF",
              "-DBUILD_DATA=OFF",
              "-DBUILD_MERGED_PLUGINS=ON",
              "-DALSO_LOG_TO_STDERR=ON",
              "-DCMAKE_FIND_ROOT_PATH="
                <> intercalate
                  ";"
                  ( map
                      (\x -> buildEnvOut </> x </> buildEnvABI)
                      [ "boost",
                        "glog",
                        "yaml-cpp",
                        "leveldb",
                        "marisa",
                        "opencc"
                      ]
                      <> ["."]
                  )
            ]
        }
  "librime" ~> do
    need
      [ "opencc",
        "boost",
        "glog",
        "yaml-cpp",
        "leveldb",
        "marisa"
      ]
    buildWithAndroidEnv buildLibrime LibRime
