module GetAhaHTML where

import           System.Process.ByteString      ( readProcessWithExitCode )
import           Data.ByteString                ( ByteString )
import qualified Data.ByteString.Char8         as B
import           System.Exit                    ( ExitCode )
import           GetGrepResults                 ( runGrep )

runAha
  :: String
  -> String
  -> Bool
  -> Bool
  -> Maybe Int
  -> IO (ExitCode, ByteString, ByteString)
runAha fileType pattern wholeword ignorecase depth = do
  (_, stdout, _) <- runGrep fileType pattern wholeword ignorecase depth
  readProcessWithExitCode "aha" ["--black"] stdout

getAhaHTML :: String -> String -> Bool -> Bool -> Maybe Int -> IO ()
getAhaHTML fileType pattern wholeword ignorecase depth = do
  (_, stdout, _) <- runAha fileType pattern wholeword ignorecase depth
  B.putStrLn stdout
