module Task2
    ( task2
    )where

import           Control.Monad        (mapM_)
import           Data.AndLogic        as And
import qualified Data.ByteString.Lazy as BS
import           Debug.Trace
import qualified Network.Factory      as Factory
import           Network.Helpers

task2 :: IO ()
task2 = do
  putStrLn "EXAMPLE wine dataset"
  res <- Factory.wineOptimal
--  resRec <- Factory.carRange
  putStrLn "RESULT:"
  kFoldSummary True res
--  mapM_ (kFoldSummary False) resRec
  return ()