module Data.Numbers.Divisors
  ( divisors
  , positiveDivisors
  ) where

import           Control.Conditional
import           Control.Monad
import           Data.Numbers.Primes (primeFactors)

-- | Returns all divisors of a number sorted ascending
divisors :: Integral a => a -> [a]
divisors = liftM2 (foldl $ flip (:)) id (map negate) . positiveDivisors

-- | Returns positive divisors of a number sorted ascending
positiveDivisors :: Integral a => a -> [a]
positiveDivisors =
  select (< 1) (pure [])
  $ positiveDivisorsByFactors . primeFactors

positiveDivisorsByFactors :: Integral a => [a] -> [a]
positiveDivisorsByFactors factors = helper (map (const 0) maxPowers)
  where
    (uniqueFactors, maxPowers) = unzip $ countElems factors

    helper powers =
      product (zipWith (^) uniqueFactors powers)
      : maybe [] helper (next powers maxPowers)

next :: [Int] -> [Int] -> Maybe [Int]
next []     _          = Nothing
next (x:xs) (max:maxs)
  | x < max   = Just $ succ x : xs
  | otherwise = (0 :) <$> next xs maxs

-- It's supposed what list is sorted
countElems :: Eq a => [a] -> [(a, Int)]
countElems []       = []
countElems (x:list) = (x, length xs + 1) : countElems list'
  where (xs, list') = break (/= x) list
