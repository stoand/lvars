{-# LANGUAGE CPP #-}
{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies #-}
{-# LANGUAGE TypeFamilies, FlexibleInstances #-}
{-| 

  A simple type class for data that can be split into pieces for parallel operation,
  and then reassembled.

-}

module Data.Splittable.Class
       (Split(..), Generator(..))
       where

import Control.Applicative
import qualified Data.Foldable as F

-- | Data that can be split into balanced pieces.  The main application of this is
-- parallel consumption of the data.
class Eq a => Split a where

  -- | Split the data value into pieces.  An empty data structure may return an empty
  -- list.
  split :: a -> [a]

  -- | A variant of `split` that allows the user to provide a /hint/ as to how many
  -- pieces they would like to split into.  There is no obligation for the
  -- implementation to follow this hint (either as an upper or lower bound).
  splitPlease :: Int -> a -> [a]
  -- The defaul implementation ignorse the hint:
  splitPlease _ = split

  -- -- | The inverse of split.
  -- combine :: [a] -> a
  
--  empty   :: a 

-- In some cases we may know exactly how many pieces the underlying data structur
-- can produce efficiently.
  
--  split2  :: a -> (a,a)
--  split3  :: a -> (a,a,a)


-- | We have a problem where some types (like Ranges) are splittable, but they are
--   not containers for arbitrary data.  Thus we introduce a more limited concept of
--   a data source that can generate only a particular kind of element (but cannot be
--   constructed or traversed).
--
--   It is trivial to provide an instance for any type that is already a `Functor`:
--   
-- > import Data.Foldable as F
-- > instance Foldable f => Generator (f a) where
-- >   type ElemOf (f a) = a
-- >   foldrM = F.foldrM 
--
--   However, we don't provide this blanket instance because it would conflict with
--   more tailored instances that may be desired for particular containers.  For
--   example, a "Data.Map" generator might include keys as well as values.
--
--   Finally, note that a much more general version of this class can be found in
--   "Data.Generator" from the reducers package.
class Generator c where
  type ElemOf c :: *
  -- | Fold all outputs from the generator, sequentially.
  foldrM :: (Monad m) => (ElemOf c -> acc -> m acc) -> acc -> c -> m acc

  -- | Execute an action for each output of the generator.
  forM_ :: (Monad m) => (ElemOf c -> m ()) -> c -> m ()
  forM_ fn = foldrM (\ x () -> fn x) ()

-- instance F.Foldable f => Generator (f a) where
--   type ElemOf (f a) = a
--   {-# INLINE foldrM #-}
--   foldrM = F.foldrM 


