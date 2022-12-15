{-# LANGUAGE OverloadedStrings #-}

module Receipt
    ( 
    getReceipt,
    createReceipt,
    updateReceipt,
    deleteReceipt,
    getReceiptId
    ) where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Receipt = Receipt { 
    id :: Int, 
    meal_id :: Int, 
    ingredient_id :: Int, 
    quantity :: Int 
} deriving (Show)

getReceiptId :: Receipt -> Int
getReceiptId = Receipt.id

instance FromRow Receipt where
  fromRow = Receipt <$> field <*> field <*> field <*> field

getReceipt :: Connection -> Int -> IO [Receipt]
getReceipt conn cid = query conn "SELECT * FROM receipts WHERE id = ?" (Only cid)

createReceipt :: Connection -> Int -> Int -> Int -> IO [Receipt]
createReceipt conn meal_id ingredient_id quantity = do 
  query conn "INSERT INTO receipts (meal_id, ingredient_id, quantity) VALUES (?, ?, ?) RETURNING *" (meal_id, ingredient_id, quantity)
  
updateReceipt :: Connection -> Int -> Int -> Int -> Int -> IO [Receipt]
updateReceipt conn cid meal_id ingredient_id quantity = do
  query conn "UPDATE receipts SET meal_id = ?, ingredient_id = ?, quantity = ? WHERE id = ? RETURNING *" (meal_id, ingredient_id, quantity, cid)
  

deleteReceipt :: Connection -> Int -> IO Bool
deleteReceipt conn cid = do
  n <- execute conn "DELETE FROM receipts WHERE id = ?" (Only cid)
  return $ n > 0
