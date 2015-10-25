{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Control.Concurrent         (threadDelay)
import           Control.Concurrent.Async
import           Control.Exception.Enclosed
import           Data.Text                  (Text)
import           Data.Traversable
import qualified Network.WebSockets         as WS

main :: IO ()
main = do
    putStrLn "Forking clients"
    ts <- forM ([1..1000]::[Int]) $ \_ -> do
        t <- async (logErrors (WS.runClient "0.0.0.0" 9160 "/" clientApp))
        threadDelay 500
        return t
    mapM_ wait ts
    putStrLn "Done"

clientApp :: WS.ClientApp ()
clientApp conn = do
    WS.sendTextData conn ("Hello, server!"::Text)

logErrors :: IO () -> IO ()
logErrors f = catchAny f onErr
  where
    onErr e = putStrLn ("Computation error: " ++ show e)
