db x = x + x
dbu x y = db x + db y

dbsmNum x = if x > 100 
    then x 
    else db x
