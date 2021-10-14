import Data.List  

qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) =
    let sm = qsort [a | a <- xs, a <= x]
        bg = qsort [a | a <- xs, a > x]
    in sm ++ [x] ++ bg


  
solveRPN :: String -> Float  
solveRPN = head . foldl foldingFunction [] . words  
    where   foldingFunction (x:y:ys) "*" = (x * y):ys  
            foldingFunction (x:y:ys) "+" = (x + y):ys  
            foldingFunction (x:y:ys) "-" = (y - x):ys  
            foldingFunction (x:y:ys) "/" = (y / x):ys  
            foldingFunction (x:y:ys) "^" = (y ** x):ys  
            foldingFunction (x:xs) "ln" = log x:xs  
            foldingFunction xs "sum" = [sum xs]  
            foldingFunction xs numberString = read numberString:xs  
