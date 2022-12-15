{-# LANGUAGE OverloadedStrings #-}

module Category
    (
    getCategory,
    createCategory,
    updateCategory,
    deleteCategory,
    getCategoryId
    ) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Category = Category { 
    id :: Int, 
    category_name :: String,
    unit :: String
} deriving (Show)

getCategoryId :: Category -> Int
getCategoryId = Category.id

instance FromRow Category where
  fromRow = Category <$> field <*> field <*> field

getCategory :: Connection -> Int -> IO [Category]
getCategory conn cid = query conn "SELECT * FROM categories WHERE id = ?" (Only cid)

createCategory :: Connection -> String -> String -> IO [Category]
createCategory conn category_name unit = do
  query conn "INSERT INTO categories (category_name, unit) VALUES (?, ?) RETURNING *" (category_name, unit)

updateCategory :: Connection -> Int -> String -> String -> IO [Category]
updateCategory conn cid category_name unit = do
  query conn "UPDATE categories SET category_name = ?, unit = ? WHERE id = ? RETURNING *" (category_name, unit, cid)

deleteCategory :: Connection -> Int -> IO Bool
deleteCategory conn cid = do
  n <- execute conn "DELETE FROM categories WHERE id = ?" (Only cid)
  return $ n > 0
