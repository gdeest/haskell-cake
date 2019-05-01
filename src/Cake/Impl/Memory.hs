{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Cake.Impl.Memory where

import Cake.Domain
import Cake.Capabilities

import Data.IORef
import Control.Monad.IO.Class
import Control.Monad.Reader


data MemoryState = MemoryState
  { users :: IORef [User UserId]
  , nextUserId :: IORef Int
  }

freshState :: IO MemoryState
freshState = MemoryState <$>
  newIORef [] <*>
  newIORef 1

newtype MemoryM a = MemoryM { unMemory :: ReaderT MemoryState IO a }
  deriving (Functor, Applicative, Monad, MonadReader MemoryState)

runMemory :: MemoryM a -> IO a
runMemory action = do
  state <- freshState
  runReaderT (unMemory action) state

instance GetUsers MemoryM where
  getUsers = MemoryM $ do
    ref <- asks users
    liftIO $ readIORef ref

instance AddUser MemoryM where
  addUser user = MemoryM $ do
    nextRef <- asks nextUserId
    usersRef <- asks users
    uid <- liftIO $ UserId <$> readIORef nextRef
    liftIO $ modifyIORef usersRef ((user { userId = uid}):)
    liftIO $ modifyIORef nextRef (+1)
    return uid

instance HasLogger MemoryM where
  logMessage = MemoryM . liftIO . putStrLn
