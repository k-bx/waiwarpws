{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Concurrent (threadDelay)
import           Control.Monad      (forM_)
import           Data.Text          (Text)
import qualified Network.WebSockets as WS
import           SlaveThread        (fork)

main :: IO ()
main = do
    putStrLn "Forking clients"
    forM_ ([1..1000]::[Int]) $ \_ -> fork $ do
        WS.runClient "0.0.0.0" 9160 "/" clientApp
    threadDelay 10000000
    putStrLn "Done"

clientApp :: WS.ClientApp ()
clientApp conn = do
    WS.sendTextData conn ("Hello, server!"::Text)
    threadDelay 1000000
