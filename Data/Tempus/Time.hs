module Data.Tempus.Time
  ( Time ()
  ) where

import Data.Ratio

import Data.Tempus.Class.IsTime
import Data.Tempus.Class.IsUnixTime
import Data.Tempus.Internal

data Time
   = Time
     { tHour           :: Integer
     , tMinute         :: Integer
     , tSecond         :: Integer
     , tSecondFraction :: Rational
     } deriving (Eq, Ord)

instance IsUnixTime Time where
  unixSeconds t
    = (hour t     * secsPerHour   % 1)
    + (minute t   * secsPerMinute % 1)
    + (second t                   % 1)
    + (secondFraction t)
  fromUnixSeconds s
    = return $ Time
               { tHour           = truncate s `div` secsPerHour   `mod` hoursPerDay
               , tMinute         = truncate s `div` secsPerMinute `mod` minsPerHour
               , tSecond         = truncate s                     `mod` secsPerMinute
               , tSecondFraction = s - (truncate s % 1)
               }

instance IsTime Time where
  hour
    = tHour
  minute
    = tMinute
  second
    = tSecond
  secondFraction
    = tSecondFraction

  setHour x t
    | x < 0 || 23 < x = fail   $ "Time.setHour "           ++ show x
    | otherwise       = return $ t { tHour           = x }
  setMinute x t
    | x < 0 || 59 < x = fail   $ "Time.setMinute "         ++ show x
    | otherwise       = return $ t { tMinute         = x }
  setSecond x t
    | x < 0 || 59 < x = fail   $ "Time.setSecond "         ++ show x
    | otherwise       = return $ t { tSecond         = x }
  setSecondFraction x t
    | x < 0 || 1 <= x = fail   $ "Time.setSecondFraction " ++ show x
    | otherwise       = return $ t { tSecondFraction = x }

  midnight
    = Time
      { tHour           = 0
      , tMinute         = 0
      , tSecond         = 0
      , tSecondFraction = 0
      }
