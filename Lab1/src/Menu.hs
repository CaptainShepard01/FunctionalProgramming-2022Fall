{-# LANGUAGE OverloadedStrings #-}

module Menu
    ( 
    getMenu,
    createMenu,
    updateMenu,
    deleteMenu,
    getMenuId
    ) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Menu = Menu { 
    id :: Int, 
    cafe_id :: Int 
} deriving (Show)

getMenuId :: Menu -> Int
getMenuId = Menu.id

instance FromRow Menu where
  fromRow = Menu <$> field <*> field

getMenu :: Connection -> Int -> IO [Menu]
getMenu conn cid = query conn "SELECT * FROM menus WHERE id = ?" (Only cid)

createMenu :: Connection -> Int -> IO [Menu]
createMenu conn cafe_id = do 
  query conn "INSERT INTO menus (cafe_id) VALUES (?) RETURNING *" (Only cafe_id)
  
updateMenu :: Connection -> Int -> Int -> IO [Menu]
updateMenu conn cid cafe_id = do
  query conn "UPDATE menus SET cafe_id = ? WHERE id = ? RETURNING *" (cafe_id, cid)
  

deleteMenu :: Connection -> Int -> IO Bool
deleteMenu conn cid = do
  n <- execute conn "DELETE FROM menus WHERE id = ?" (Only cid)
  return $ n > 0
