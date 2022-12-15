{-# LANGUAGE OverloadedStrings #-}

module Meal
  ( getMeal,
    createMeal,
    updateMeal,
    deleteMeal,
    getMealId
  )
where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Meal = Meal { 
    id :: Int,
    meal_name :: String,
    category_id :: Int,
    price :: Double,
    amount :: Double
} deriving (Show)

getMealId :: Meal -> Int
getMealId = Meal.id

instance FromRow Meal where
  fromRow = Meal <$> field <*> field <*> field <*> field <*> field

getMeal :: Connection -> Int -> IO [Meal]
getMeal conn cid = query conn "SELECT * FROM meals WHERE id = ?" (Only cid)

createMeal :: Connection -> String -> Int -> Double -> Double -> IO [Meal]
createMeal conn meal_name category_id price amount = do
  query conn "INSERT INTO meals (meal_name, category_id, price, amount) VALUES (?, ?, ?, ?) RETURNING *" (meal_name, category_id, price, amount)

updateMeal :: Connection -> Int -> String -> Int -> Double -> Double -> IO [Meal]
updateMeal conn cid meal_name category_id price amount = do
  query conn "UPDATE meals SET meal_name = ?, category_id = ?, price = ?, amount = ? WHERE id = ? RETURNING *" (meal_name, category_id, price, amount, cid)

deleteMeal :: Connection -> Int -> IO Bool
deleteMeal conn cid = do
  n <- execute conn "DELETE FROM meals WHERE id = ?" (Only cid)
  return $ n > 0
