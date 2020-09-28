module AbsoluteFilePathToRelativeFilePath where

import Path (parseAbsFile, fromRelFile, parseAbsDir, stripProperPrefix)
import System.Directory (getCurrentDirectory)

absoluteFilePathToRelativeFilePath :: FilePath -> IO( FilePath )
absoluteFilePathToRelativeFilePath file = 
  do
    currentDir <- getCurrentDirectory
    currentAbsDir <- parseAbsDir currentDir
    absFile <- parseAbsFile file
    relFile <- stripProperPrefix currentAbsDir absFile
    return $ fromRelFile relFile
