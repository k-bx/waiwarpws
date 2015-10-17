{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Concurrent (threadDelay)
import           Data.Bits.Utils
import qualified Data.Digest.MD5    as MD5
import           Data.String.Class  (toString)
import           Data.Text          (Text)
import qualified Network.WebSockets as WS

main :: IO ()
main = do
    WS.runServer "0.0.0.0" 9160 $ application

application :: WS.ServerApp
application pending = do
    conn <- WS.acceptRequest pending
    WS.forkPingThread conn 30
    msg <- WS.receiveData conn
    -- Doing this just to make sure msg if fully consumed
    putStr [head (w82s (MD5.hash (s2w8 (toString (msg :: Text)))))]
    threadDelay 1000000
