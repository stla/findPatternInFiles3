module GetGrepResults where

import           System.Process.ByteString      ( readProcessWithExitCode )
import           Data.ByteString                ( ByteString
                                                , empty
                                                )
import qualified Data.ByteString.Char8         as B
import           System.Exit                    ( ExitCode )
import           System.FilePath.Find           ( find
                                                , extension
                                                , (<=?)
                                                , (==?)
                                                )
import qualified System.FilePath.Find          as F

runGrep
  :: String
  -> String
  -> Bool
  -> Bool
  -> Maybe Int
  -> IO (ExitCode, ByteString, ByteString)
runGrep fileType pattern wholeword ignorecase depth = do
  let option = case (wholeword, ignorecase) of
                 (False, False) -> "-n"
                 (False, True) -> "-ni"
                 (True, False) -> "-nw"
                 (True, True) -> "-nwi"
  case depth of
    Nothing -> readProcessWithExitCode
      "grep"
      (  [option]
      ++ [ "--colour=always"
         , "--include"
         , "*." ++ fileType
         , "-r"
         , "-e"
         , pattern
         ]
      )
      empty
    Just n -> do
      files <- find (F.depth <=? n) (extension ==? ("." ++ fileType)) "./"
      readProcessWithExitCode
        "grep"
        ([pattern] ++ files ++ ["--colour=always", option])
        empty

getGrepResults :: String -> String -> Bool -> Bool -> Maybe Int -> IO ()
getGrepResults fileType pattern wholeword ignorecase depth = do
  (_, stdout, stderr) <- runGrep fileType pattern wholeword ignorecase depth
  putStrLn "\n--- Results: ---\n"
  case stdout == empty of
    True  -> putStrLn "No result"
    False -> B.putStrLn stdout
