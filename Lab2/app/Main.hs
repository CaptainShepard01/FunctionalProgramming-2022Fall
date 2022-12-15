module Main (main) where

import Lib
import System.IO
import Control.Concurrent

showResult :: [Int] -> Int -> Int -> Int -> IO String
showResult interval base modulus remainder = do
  tid <- myThreadId
  let solved = multipleSolve interval base modulus remainder
  let result = "Result " ++ show tid ++ " : " ++ show solved
  return $! result

solveSingle :: MVar () -> Chan () -> [Int] -> Int -> Int -> Int -> IO()
solveSingle mutex endFlags interval base modulus remainder = do
  solution <- showResult interval base modulus remainder
  takeMVar mutex
  putStrLn solution
  putMVar mutex ()
  writeChan endFlags ()

main :: IO()
main = do
  putStrLn "Enter base, modulus and remainder of b^x = d (mod m)"
  putStrLn "Example with: 2^x = 8 (mod 13)"
  putStrLn "Base:"
  input1 <- getLine
  putStrLn "Modulus:"
  input2 <- getLine
  putStrLn "Remainder:"
  input3 <- getLine
  let base = (read input1 :: Int)
  let modulus = (read input2 :: Int)
  let remainder = (read input3 :: Int)
  
  hSetBuffering stdout NoBuffering
  mutex <- newEmptyMVar
  endFlags <- newChan

  forkIO $ solveSingle mutex endFlags [1..10] base modulus remainder
  forkIO $ solveSingle mutex endFlags [11..20] base modulus remainder
  forkIO $ solveSingle mutex endFlags [21..30] base modulus remainder
  forkIO $ solveSingle mutex endFlags [31..40] base modulus remainder

  putMVar mutex ()
  mapM_ (const $ readChan endFlags) [1..4]
