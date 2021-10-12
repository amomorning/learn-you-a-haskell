qsort :: (Ord a) => [a] -> [a]
qsort [] = []
qsort (x:xs) =
    let sm = qsort [a | a <- xs, a <= x]
        bg = qsort [a | a <- xs, a > x]
    in sm ++ [x] ++ bg

