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
  -> Maybe Int
  -> IO (ExitCode, ByteString, ByteString)
runAha fileType pattern wholeword depth = do
  (_, stdout, _) <- runGrep fileType pattern wholeword depth
  readProcessWithExitCode "aha" ["--black"] stdout

getAhaHTML :: String -> String -> Bool -> Maybe Int -> IO ()
getAhaHTML fileType pattern wholeword depth = do
  (_, stdout, _) <- runAha fileType pattern wholeword depth
  B.putStrLn stdout
