module Cake.Domain
  ( User(..)
  , UserId(..)
  ) where

newtype UserId = UserId Int
  deriving Show

data User i = User
  { userId :: i
  , userName :: String
  }
  deriving Show
