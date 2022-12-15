module Main (main) where

import Category
import Meal
import Receipt
import Menu
import MealMenu

import Database.PostgreSQL.Simple

localPG :: ConnectInfo
localPG = defaultConnectInfo
        { connectHost = "127.0.0.1"
        , connectDatabase = "Menu"
        , connectUser = "postgres"
        , connectPassword = "password"
        }

main :: IO ()
main = do
  conn <- connect localPG
  putStrLn "Enter name of the new category: "
  categoryName <- getLine
  putStrLn "Enter units of the new category: "
  categoryUnit <- getLine
  newCategory <- createCategory conn categoryName categoryUnit
  let categoryId = getCategoryId (head newCategory)
  putStrLn $ "New Category: " ++ show newCategory  
  currentCategory <- getCategory conn categoryId
  putStrLn $ "Recently created Category: " ++ show currentCategory
  updatedCategory <- updateCategory conn categoryId "NewCategory" "NewUnit"
  putStrLn $ "Updated Category: " ++ show updatedCategory
  
--  isDeleted <- deleteCategory conn categoryId
--  putStrLn $ "Category deleted: " ++ show isDeleted

  putStrLn "Enter name of the new meal: "
  mealName <- getLine
  putStrLn "Enter category_id of the new meal: "
  temp <- getLine
  let relateCategoryId = read temp :: Int
  putStrLn "Enter price of the new meal: "
  temp1 <- getLine
  let price = read temp1 :: Double
  putStrLn "Enter amount of the new meal: "
  temp2 <- getLine
  let amount = read temp2 :: Double
  newMeal <- createMeal conn mealName relateCategoryId price amount
  putStrLn $ "New Meal: " ++ show newMeal  
  let mealId = getMealId (head newMeal)
  
  newReceipt <- createReceipt conn mealId 1 5
  putStrLn $ "New Receipt: " ++ show newReceipt 
  
  newMenu <- createMenu conn 1
  let menuId = getMenuId (head newMenu)
  putStrLn $ "New Menu: " ++ show newMeal  
  
  newMealMenu <- createMealMenu conn mealId menuId
  putStrLn $ "New MealMenu: " ++ show newMealMenu  
  