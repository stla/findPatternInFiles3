module Main where

import GetGrepResults
import GetAhaHTML
import Options.Applicative

data Arguments = Arguments
  { filetype :: String
  , pattern :: String
  , wholeword :: Bool
  , depth :: Maybe Int
  , html :: Bool }

findFiles :: Arguments -> IO()
findFiles (Arguments filetype pattern w d html) = 
  if html
    then
      getAhaHTML filetype pattern w d  
    else
      getGrepResults filetype pattern w d  
  
run :: Parser Arguments
run = Arguments
     <$> argument str 
          ( metavar "FILETYPE"
         <> help "Type of the files to search in" )
     <*> argument str 
          ( metavar "PATTERN"
         <> help "The pattern to search" )
     <*> switch
          ( long "wholeword"
         <> short 'w'
         <> help "Match whole word" ) 
     <*> ( optional $ option auto 
          ( metavar "DEPTH"
         <> long "depth"
         <> short 'd'
         <> help "Depth of the search (0: current directory)" ))
     <*> switch
          ( long "html"
         <> short 'm'
         <> help "HTML output" ) 

main :: IO ()
main = execParser opts >>= findFiles
  where
    opts = info (helper <*> run)
      ( fullDesc
     <> progDesc "Find files containing a pattern"
     <> header "findPatternInFiles -- based on 'grep' and 'aha'" )
