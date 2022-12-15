module Lib
    ( 
    solveForInterval
    ) where


solveForInterval :: [Int] -> Int -> Int -> Int -> [Int]
solveForInterval candidates base mod_ res = [x | x <- candidates, solveForOne x base mod_ res]
    
solveForOne :: Int -> Int -> Int -> Int -> Bool
solveForOne candidate base mod_ res = base ^ candidate `mod` mod_ == res
