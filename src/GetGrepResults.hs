module GetGrepResults where

import System.Process.ByteString (readProcessWithExitCode)
import Data.ByteString (ByteString, empty)
import qualified Data.ByteString.Char8 as B
import System.Exit (ExitCode)
import System.FilePath.Glob (glob)
import AbsoluteFilePathToRelativeFilePath

runGrep :: String -> String -> Bool -> Maybe Int 
           -> IO(ExitCode, ByteString, ByteString)
runGrep fileType pattern wholeword depth = 
  do
    let option = if wholeword then "-nw" else "-n"
    case depth of 
       Nothing -> 
         readProcessWithExitCode "grep" 
           (
             [option] ++ 
             ["--colour=always", 
              "--include", 
              "*." ++ fileType, 
              "-r", 
              "-e", 
              pattern]
           ) 
           empty
       Just n -> do 
         absFiles <- glob $ (foldr (++) "*." (replicate n "*/")) ++ fileType
         relFiles <- mapM absoluteFilePathToRelativeFilePath absFiles
         readProcessWithExitCode "grep" 
           ([pattern] ++ relFiles ++ ["--colour=always", option]) empty
       
getGrepResults :: String -> String -> Bool -> Maybe Int -> IO()
getGrepResults fileType pattern wholeword depth = 
  do
    (_, stdout, stderr) <- runGrep fileType pattern wholeword depth
    putStrLn "\n--- Results: ---\n"
    case stdout==empty of
      True -> putStrLn "No result" 
      False ->  B.putStrLn stdout
