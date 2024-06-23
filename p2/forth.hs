import System.IO
import System.Environment (getArgs)
import Data.List (intercalate) 

main = do
    args <- getArgs
    case args of 
        [inputFile, outputFile] -> do
            in_handle <- openFile inputFile ReadMode
            out_handle <- openFile outputFile WriteMode
            mainloop in_handle out_handle
            hClose in_handle
            hClose out_handle
        _ -> putStrLn "Usage: forth <input file> <output file>"

mainloop:: Handle -> Handle -> IO ()
mainloop in_handle out_handle = do
    ineof <- hIsEOF in_handle
    if ineof
        then return ()
        else do
            line <- hGetLine in_handle
            let line_words = words line
            (new_stack, command) <- process line_words stack
            let output = "(" ++ show command ++ "," ++ show (unwords new_stack) ++ ")\n"
            hPutStr out_handle output
            mainloop in_handle out_handle new_stack

process :: [String] -> String -> IO ([String], String)
process [] stack = return (stack, command)
process (".":xs) stack _ = do
    let command = "\"" ++ intercalate " " (reverse stack) ++ "\""
    return([], command)
process (".S":xs) stack = do
    let command = "\"" ++intercalate " " (reverse stack) ++ "\""
    return (stack, command)
process (x:xs) stack command = process xs (x:stack)