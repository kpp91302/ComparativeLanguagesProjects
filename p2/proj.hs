import System.Environment
import Data.List

main :: IO()
main = do
    args <- getArgs
    contents <- readFile(head args)
    let output = unlines (map processLine (lines contents))
    writeFile (args !! 1) output

processLine :: String -> String
processLine line = case evalForth (words line) [] of 
    ("illegal", "illegal") -> "(illegal,illegal)"
    (a, b) -> "(" ++ addQuotes a ++ "," ++ addQuotes b ++ ")"
    where
        addQuotes s = "\"" ++ s ++ "\""

evalForth :: [String] -> [Int] -> (String, String)
evalForth [] stack = ("", formatStack stack)
evalForth (x:xs) stack
    | x == "." = case stack of
        (a:as) -> let (res, s) = evalForth xs as
            in if res == "illegal" then ("illegal", "illegal") else (show a ++ "" ++res,s)
        [] ->("illegal", "illegal")
    | x == ".S" = if null xs
        then (formatStack stack, formatStack stack)
        else let (res, s) = evalForth xs stack
            in if res == "illegal" then ("illegal", "illegal") else (formatStack stack ++ " " ++ res, s)
    | x == "+" = case stack of
        (a:b:as) -> evalForth xs (b + a : as)
        _ -> ("illegal", "illegal")
    | x == "-" = case stack of
        (a:b:as) -> evalForth xs (b - a : as)
        _ -> ("illegal", "illegal")
    | x == "*" = case stack of
        (a:b:as) -> evalForth xs (b * a : as)
        _ -> ("illegal", "illegal")
    | x == "/" = case stack of
        (0:_) -> ("illegal", "illegal")
        (a:b:as) -> evalForth xs (b `div` a : as)
        _ -> ("illegal", "illegal")
    | x == "DUP" = case stack of
        (a:as) -> evalForth xs (a:a:as)
        _ -> ("illegal", "illegal")
    | x == "SWAP" = case stack of
        (a:b:as) -> evalForth xs (b:a:as)
        _ -> ("illegal", "illegal")
    | x == "DROP" = case stack of
        (_:as) -> evalForth xs as
        _ -> ("illegal", "illegal")
    | x == "OVER" = case stack of
        (a:b:as) -> evalForth xs (b:a:b:as)
        _ -> ("illegal", "illegal")
    | x == "ROT" = case stack of
        (a:b:c:as) -> evalForth xs (c:a:b:as)
        _ -> ("illegal", "illegal")
    | otherwise = case reads x of
        [(n, "")] -> evalForth xs (n:stack)
        _ -> ("illegal", "illegal")

formatStack :: [Int] -> String
formatStack stack = unwords (map show (reverse stack))