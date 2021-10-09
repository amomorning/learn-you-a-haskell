db x = x + x
dbu x y = db x + db y

dbsmNum x = if x > 100 
    then x 
    else db x

-- _ means anything from list
length' xs = sum [1 | _ <- xs]   


removeNonUppercase st = [ c | c <- st, c `elem` ['A'..'Z']]   


