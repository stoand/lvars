{-# LANGUAGE DataKinds      #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeFamilies   #-}

module Control.Par.Scheds.Trace (Par()) where

import           System.IO.Unsafe               (unsafePerformIO)

import           Control.Par.Class
import qualified Control.Par.Class.Unsafe       as PC
import           Control.Par.EffectSigs

import qualified Control.Monad.Par.Scheds.Trace as T

newtype Par (e :: EffectSig) s a =
  Trace { unwrapTrace :: T.Par a }

newtype TraceIVar s a = TraceIVar { unwrapTraceIVar :: T.IVar a }

instance PC.ParMonad Par where
  pbind (Trace p1) p2 = Trace $ p1 >>= unwrapTrace . p2
  preturn = Trace . return
  fork = Trace . T.fork . unwrapTrace
  internalLiftIO = return . unsafePerformIO

instance ParFuture Par where
  type Future Par = TraceIVar
  spawn_ = Trace . fmap TraceIVar . T.spawn_ . unwrapTrace
  read = Trace . T.get . unwrapTraceIVar