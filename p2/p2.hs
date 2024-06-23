-- CS 3304 Project 2
-- Kyle Peterson

-- Imports
import System.Environment (getArgs)

-- Interpreter
interpret :: String -> (String, String) -- (String, String) is the output and the state of the stack after the program
interpret input = interpret' (words input) []
    where
        interpret' :: [String] -> [Int] -> (String, String)
        interpret' [] stack = ("", stackToString stack)
        interpret' (x:xs) stack
            | x == "." = (show (head stack) ++ fst (interpret' xs (tail stack)), snd (interpret' xs (tail stack)))
            | x == ".S" = (stackToString stack ++ fst (interpret' xs stack), snd (interpret' xs stack))
            | x == "+" = arithmeticOp (+) xs stack
            | x == "-" = arithmeticOp (-) xs stack
            | x == "*" = arithmeticOp (*) xs stack
            | x == "/" = arithmeticOp div xs stack
            | x == "DUP" = if null stack then illegal else interpret' xs (head stack : stack)
            | x == "SWAP" = if length stack < 2 then illegal else interpret' xs (stack !! 1 : head stack : drop 2 stack)
            | x == "DROP" = if null stack then illegal else interpret' xs (tail stack)
            | x == "OVER" = if length stack < 2 then illegal else interpret' xs (stack !! 1 : stack)
            | x == "ROT" = if length stack < 3 then illegal else interpret' xs (stack !! 2 : take 2 stack ++ drop 3 stack)
            | otherwise = case reads x of
                    [(num, "")] -> interpret' xs (num : stack)
                    _ -> illegal
        illegal = ("(illegal, illegal)", "(illegal, illegal)")


        arithmeticOp :: (Int -> Int -> Int) -> [String] -> [Int] -> (String, String)
        arithmeticOp op xs stack
            | length stack < 2 = illegal
            | otherwise = interpret' xs (op (stack !! 1) (head stack) : drop 2 stack)

        stackToString :: [Int] -> String
        stackToString = unwords . reverse . map show

-- Main function
main :: IO ()
main = do
    args <- getArgs
    let inputFile = head args
        outputFile = args !! 1
    input <- readFile inputFile
    let output = unlines $ map (show . interpret) (lines input)
    writeFile outputFile output