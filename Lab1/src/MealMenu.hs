{-# LANGUAGE OverloadedStrings #-}

module MealMenu
    ( 
    getMealMenu,
    createMealMenu,
    updateMealMenu,
    deleteMealMenu,
    getMealMenuId
    ) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data MealMenu = MealMenu { 
    id :: Int, 
    meal_id :: Int, 
    menu_id :: Int 
} deriving (Show)

getMealMenuId :: MealMenu -> Int
getMealMenuId = MealMenu.id

instance FromRow MealMenu where
  fromRow = MealMenu <$> field <*> field <*> field

getMealMenu :: Connection -> Int -> IO [MealMenu]
getMealMenu conn cid = query conn "SELECT * FROM meal_menus WHERE id = ?" (Only cid)

createMealMenu :: Connection -> Int -> Int -> IO [MealMenu]
createMealMenu conn meal_id menu_id = do 
  query conn "INSERT INTO meal_menus (meal_id, menu_id) VALUES (?, ?) RETURNING *" (meal_id, menu_id)
  
updateMealMenu :: Connection -> Int -> Int -> Int -> IO [MealMenu]
updateMealMenu conn cid meal_id menu_id = do
  query conn "UPDATE meal_menus SET meal_id = ?, menu_id = ? WHERE id = ? RETURNING *" (meal_id, menu_id, cid)
  

deleteMealMenu :: Connection -> Int -> IO Bool
deleteMealMenu conn cid = do
  n <- execute conn "DELETE FROM meal_menus WHERE id = ?" (Only cid)
  return $ n > 0
