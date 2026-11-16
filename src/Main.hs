{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Base
import Data.Aeson qualified as A
import Data.Aeson.Encode.Pretty qualified as A
import Data.List.Extra (trim, find, isPrefixOf, split)
import Data.String (fromString)
import Data.Text.Lazy qualified as TL
import Data.Text.Lazy.Builder qualified as TLB
import Development.Shake.Config
import Rules.Boost
import Rules.Fcitx5
import Rules.GLog
import Rules.LevelDB
import Rules.LibIntlLite
import Rules.LibRime
import Rules.LibUV
import Rules.Marisa
import Rules.OpenCC
import Rules.YAMLCpp

main :: IO ()
main =
  shakeArgsWith
    shakeOptions
      { shakeReport = ["report.html"],
        shakeVersion = prebuilderVersion,
        shakeFiles = outputDir
      }
    []
    $ \_ files -> pure . Just $ do
      want files
      usingConfigFile "build.cfg"
      downloadFileRule
      hostFcitx5Rule
      spellDictRule
      libuvRule
      libintlLiteRule
      hostOpenCCRule
      openccRule
      boostRule
      glogRule
      yamlCppRule
      leveldbRule
      marisaSourceRule
      hostMarisaRule
      marisaRule
      librimeRule
      isInGitHubActionRule
      getOutputDirRule
      "everything" ~> do
        let artifacts =
              [ "boost",
                "libuv",
                "libintl-lite",
                "opencc",
                "glog",
                "yaml-cpp",
                "leveldb",
                "marisa",
                "librime",
                "spell-dict"
              ]
        need artifacts
        getToolchainVersions >>= writeFile' (outputDir </> "toolchain-versions.json") . TL.unpack . TLB.toLazyText . A.encodePrettyToTextBuilder
        writeFileLines (outputDir </> "artifacts.txt") (artifacts <> ["toolchain-versions.json"])
      "clean" ~> removeFilesAfter outputDir ["//*"]

data ToolchainVersions = ToolchainVersions
  { prebuilderRev :: String,
    ndkVersion :: String,
    platformVersion :: Int,
    cmakeVersion :: String
  }

instance A.ToJSON ToolchainVersions where
  toJSON ToolchainVersions {..} =
    A.object
      [ fromString "prebuilder" A..= prebuilderRev,
        fromString "ndk" A..= ndkVersion,
        fromString "platform" A..= platformVersion,
        fromString "cmake" A..= cmakeVersion
      ]

getToolchainVersions :: Action ToolchainVersions
getToolchainVersions = do
  StdoutTrim prebuilderRev <- cmd "git" "rev-parse" "HEAD"
  AndroidEnv {sdkCMakeVersion = cmakeVersion, platform = platformVersion, ..} <- getAndroidEnv
  properties <- readFileLines $ ndkRoot </> "source.properties"
  ndkVersion <- case find ("Pkg.Revision" `isPrefixOf`) properties of
    Just line
      | [_, ndkVersion] <- split (== '=') line -> pure $ trim ndkVersion
      | otherwise -> fail "Failed to parse Pkg.Revision"
    Nothing -> fail "Pkg.Revision not found in source.properties"
  pure ToolchainVersions {..}
