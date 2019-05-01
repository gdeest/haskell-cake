module Main where

import Cake

addSomeUsers :: (AddUser m, HasLogger m) => m ()
addSomeUsers = do
  uid1 <- addUser (User () "Paul")
  uid2 <- addUser (User () "Jacques")
  logMessage $ show (uid1, uid2)

logUsers :: (GetUsers m, HasLogger m) => m ()
logUsers = do
  users <- getUsers
  logMessage $ show users

main :: IO ()
main = runMemory $ do
  addSomeUsers
  logUsers
