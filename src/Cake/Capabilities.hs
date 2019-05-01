{-# LANGUAGE ConstraintKinds #-}

module Cake.Capabilities
  ( GetUsers(..)
  , AddUser(..)
  , HasLogger(..)
  , UserManagement
  ) where

import Cake.Domain

class Monad m => GetUsers m where
  getUsers :: m [User UserId]

class Monad m => AddUser m where
  addUser :: User () -> m UserId

class Monad m => HasLogger m where
  logMessage :: String -> m ()

-- Set of constraints ; requires ConstraintKinds
type UserManagement m = (GetUsers m, AddUser m)
