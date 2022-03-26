## Learn you a Haskell
[[Book](http://learnyouahaskell.com/chapters)] 
[[Library](https://downloads.haskell.org/~ghc/latest/docs/html/libraries/)]

### 交互式运行环境
在命令行输入 `ghci`，即可进入交互式运行环境
#### 引入`*.hs`文件
在命令行内引入文件，可以使用该文件内定义的函数。假设文件名为 `func.hs`，那么引入的代码如下：
``` haskell
ghci> :l func.hs
```

#### 类型与变量
Haskell 是强类型语言，但能自动从上下文推导变量类型。在`ghci`环境中，可以通过开启设置 `+t`，使之总是显示变量类型：
``` haskell
ghci> :set +t
ghci> let (x:xs) = [1..]
x :: Integer
xs :: [Integer]

-- 查询当前上下文已定义的变量
:show bindings
```
取消设置用`:unset`即可。

在强类型语言中，不同类型之间不能强制转换，只能通过相应函数使之改变类型。如将整数(Integral)变为数字(Num)的`fromIntegral`
``` haskell
ghci> (length [1,2,3,4]) + 3.2
-- 报错
<interactive>:33:22: error: ...

ghci> fromIntegral (length [1,2,3,4]) + 3.2
7.2

```
##### Common Types
- `Int` 整数，有界[-9223372036854775808, 9223372036854775808]，可以用`minBound :: Int` 和 `maxBound :: Int` 得到这对数字
- `Integer` 整数，任意范围，效率较 `Int` 低
- `Float` 单精度浮点数
- `Double` 双精度浮点数
- `Bool` 布尔类型
- `Char` 字符
- `String` 字符串

##### Typeclasses
Typeclasses 有点类似 Java 接口，它能支持并实现函数的行为，一般作用在传入参数上
- `Eq` 表示该类型可被用`==`或`/=`判定是否相等 (可能像实现 equalTo)
- `Ord` 表示该类型有序
- `Show` 把任何类型变成字符串（可能像实现 toString）
- `Read` 把字符串变成类型
- `Enum` 表示依次排序的类型，意味着你可以用`succ`得到下一个
- `Bounded` 表示类型有上下限，如 `Int` 的上下限
- `Num` 为所有数字类型
- `Integral` 为整数数字类型，包括`Int`和`Integer`
- `Floating` 为浮点数类型，包括`Float`和`Double`

### 运算符
在 Haskell 中可以使用符号表示的运算符（中缀），也可以将二目函数用中缀作为运算符
``` haskell
-- 整除
92 `div` 10
-- 取余
92 `mod` 10
```
### 数组
值得一提的设计是，在 Haskell 中，数组和字符串是完全相同的的设计 `'h','e','l','l','o'` 即 `"hello"`，可以使用类似的符号与操作。
#### 初始化
``` haskell
-- 定义名字
let num = [4, 8, 15, 23, 42]

-- range
ghci> [1..20]  
[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]  
ghci> ['a'..'z']  
"abcdefghijklmnopqrstuvwxyz"  
ghci> ['K'..'Z']  
"KLMNOPQRSTUVWXYZ"   

-- 设置range的step，只能是等差数列，可以是倒序
ghci> [2,4..20]  
[2,4,6,8,10,12,14,16,18,20]  
ghci> [3,6..20]  
[3,6,9,12,15,18]   

-- range 事实上提供无穷数字（Haskell is lazy!!）
-- 如果你想要24个13的乘积
ghci> [13,26..24*13]
-- 或
ghci> take 24 [13,26..]

-- 用 cycle 循环
ghci> take 10 (cycle [1,2,3])  
[1,2,3,1,2,3,1,2,3,1]  
ghci> take 12 (cycle "LOL ")  
"LOL LOL LOL "   

-- 重复数字用 repeat x 或 replicate n x
ghci> take 10 (repeat 5)  
[5,5,5,5,5,5,5,5,5,5]  
ghci> replicate 10 5

```
Haskell 以很数学的方式表达数组
![](imgs/2021-10-09-19-26-57.png)
``` haskell
-- 将上述映射用代码表示出来就是
ghci> [x*2 | x <- [1..10]]  
[2,4,6,8,10,12,14,16,18,20]  

-- 不等于13，15，19
ghci> [ x | x <- [10..20], x /= 13, x /= 15, x /= 19]  
[10,11,12,14,16,17,18,20]  

-- 嵌套
ghci> [ x*y | x <- [2,5,10], y <- [8,10,11]]  
[16,20,22,40,50,55,80,100,110]  

-- 遍历二维数组
ghci> let xxs = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]  
ghci> [ [ x | x <- xs, even x ] | xs <- xxs]  
[[2,2,4],[2,4,6,8],[2,4,2,6,2,6]]
```
#### 数组取数
数组取数使用符号 `!!`，Haskell 的下标从0开始（与人性化的mma不一样呢
``` haskell
ghci> "Steve Buscemi" !! 6  
'B'  
ghci> [9.4,33.2,96.2,11.2,23.25] !! 1  
33.2  
```
`head` `tail` `last` `init` 之间的关系如下
![](imgs/2021-10-09-23-04-00.png)

`take` 获取从 0 位开始的数组
`drop` 得到剩下的数组
#### 数组判断
``` haskell
-- length 获取数组长度
ghci> length [5,4,3,2,1]  
5  

-- null 判断是否为空
ghci> null [1,2,3]  
False  
ghci> null []  
True  

-- elem x y 判断x是否为y中元素
ghci> 4 `elem` [3,4,5,6]  
True  
ghci> 10 `elem` [3,4,5,6]  
False  
```
#### 数组运算
``` haskell
-- maximun 得到最大值
-- minimun 得到最小值
ghci> minimum [8,4,2,1,5,6]  
1  
ghci> maximum [1,9,2,3,4]  
9   

-- sum 得到和
-- product 得到乘积
ghci> sum [5,2,1,6,3,2,5,7]  
31  
ghci> product [6,2,1,2]  
24  
ghci> product [1,2,5,6,7,9,2,0]  
0   

```

#### 添加元素
``` haskell
-- 在数组末添加元素
ghci> [1,2,3,4] ++ [9,10,11,12]  
[1,2,3,4,9,10,11,12]  
ghci> [1,2,3] ++ [4]
[1,2,3,4]

-- 在数组开头添加元素
ghci> 'A':" SMALL CAT"  
"A SMALL CAT"  
ghci> 5:[1,2,3,4,5]  
[5,1,2,3,4,5]  
-- 多个元素也类似
ghci> 2:3:4:[1,2]
[2,3,4,1,2]
```
#### 数组比较
前面提到数组和字符串在 Haskell 中有高度一致性，在比较两个数组时，你可以用 `>`、`<`、`>=`、`<=` 比较两个数组的字典序
``` haskell
ghci> [3,2,1] > [2,1,0]  
True  
ghci> [3,2,1] > [2,10,100]  
True  
ghci> [3,4,2] > [3,4]  
True  
ghci> [3,4,2] > [2,4]  
True  
ghci> [3,4,2] == [3,4,2]  
True  
```

### 元组
元组类似数组，但是元组是定长的。
比如可以有`[[1,2],[8,11,5],[4,5]]`；
但只能有`[(1,2),(8,11),(4,5)]`，只有等长的元组被认为是一类；也只有等长的数组可以比较大小
#### 元组取数
如果元组长度为 2 那么可以用 `fst`、`snd`取其第一个数和第二个数
``` haskell
ghci> fst (8,11)  
8  
ghci> fst ("Wow", False)  
"Wow"  

ghci> snd (8,11)  
11  
ghci> snd ("Wow", False)  
False  
```
一般用 `zip` 生成成对的元组
``` haskell
ghci> zip [1,2,3,4,5] [5,5,5,5,5]  
[(1,5),(2,5),(3,5),(4,5),(5,5)]  


ghci> zip [1..] ["apple", "orange", "cherry", "mango"]  
[(1,"apple"),(2,"orange"),(3,"cherry"),(4,"mango")]  

-- 元组查询边长 100 内直角三角形的例子
ghci> let rightTriangles = [ (a,b,c) | c <- [1..100], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]             
ghci> rightTriangles 
[(3,4,5),(6,8,10),(5,12,13),(9,12,15),(8,15,17),(12,16,20),(15,20,25),(7,24,25),(10,24,26),(20,21,29),(18,24,30),(16,30,34),(21,28,35),(12,35,37),(15,36,39),(24,32,40),(9,40,41),(27,36,45),(30,40,50),(14,48,50),(24,45,51),(20,48,52),(28,45,53),(33,44,55),(40,42,58),(36,48,60),(11,60,61),(39,52,65),(33,56,65),(25,60,65),(16,63,65),(32,60,68),(42,56,70),(48,55,73),(24,70,74),(45,60,75),(21,72,75),(30,72,78),(48,64,80),(18,80,82),(51,68,85),(40,75,85),(36,77,85),(13,84,85),(60,63,87),(39,80,89),(54,72,90),(35,84,91),(57,76,95),(65,72,97),(60,80,100),(28,96,100)]

```

### 输入输出

#### 字符串到代码
``` haskell
-- read 字符串，并指定输入类型
ghci> read "5" :: Int  
5  
ghci> read "5" :: Float  
5.0  
ghci> (read "5" :: Float) * 4  
20.0  
ghci> read "[1,2,3,4]" :: [Int]  
[1,2,3,4]  
ghci> read "(3, 'a')" :: (Int, Char)  
(3, 'a') 
```
IO() 类型意味着，要么以 `name <- getLine` 从控制台输入，要么以`putStrLn something`在控制台输出，`do`是将这样的输入输出连接起来的命令
``` haskell
main = do  
    putStrLn "Hello, what's your name?"  
    name <- getLine  
    putStrLn $ "Read this carefully, because this is your future: " ++ tellFortune name  

-- 输入直到 -1
import Control.Monad

main = do
    line <- getLine
    when (line /= "-1") $ do
        -- do something
        main

```
#### 文件读写
下载的数据要输入到程序 `a.hs` 中：
``` bash
cat data.txt | runghc a.hs
```
在程序中打开文件：
``` haskell

-- 使用 openFile
-- data IOMode = ReadMode | WriteMode | AppendMode | ReadWriteMode  
import System.IO  
  
main = do  
    handle <- openFile "girlfriend.txt" ReadMode  
    contents <- hGetContents handle  
    putStr contents  
    hClose handle  

-- 使用 withFile
import System.IO     
    
main = do     
    withFile "girlfriend.txt" ReadMode (\handle -> do  
        contents <- hGetContents handle     
        putStr contents)  

-- 使用 readFile
import System.IO  
  
main = do  
    contents <- readFile "girlfriend.txt"  
    putStr contents  
```

写入文件有 `writeFile`、`appendFile`
### 函数
在 Haskell 中可为函数指定 Type 和 Typeclass
而函数定义时，可以检查参数是否符合某种形式，并映射到不同的结果上。
``` haskell
-- 定义 tell 可以根据数组有0、1、2个元素时特化其输出
tell :: (Show a) => [a] -> String  
tell [] = "The list is empty"  
tell (x:[]) = "The list has one element: " ++ show x  
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y  
tell (x:y:_) = "This list is long. The first two elements are: " ++ show x ++ " and " ++ show y  

-- 递归地算出数组的长度
length' :: (Num b) => [a] -> b  
length' [] = 0  
length' (_:xs) = 1 + length' xs  

-- all@(x:xs) 中 @前的all表示完整的数组，x匹配到数组的第一个元素，xs为剩下的元素
capital :: String -> String  
capital "" = "Empty string, whoops!"  
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]  

ghci> capital "Dracula"  
"The first letter of Dracula is D" 
```
#### Guards & Case
Guards 类似 if 语句，但有更高的可读性。Guards感觉就是门卫，变量通过函数进入后，根据门卫指示去向不同的地方。。
``` haskell
-- otherwise 用于指代没有匹配到的其他条件
max' :: (Ord a) => a -> a -> a  
max' a b   
    | a > b     = a  
    | otherwise = b

bmiTell :: (RealFloat a) => a -> a -> String  
bmiTell weight height  
    | bmi <= skinny = "You're underweight, you emo, you!"  
    | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"  
    | bmi <= fat    = "You're fat! Lose some weight, fatty!"  
    | otherwise     = "You're a whale, congratulations!"  
    where bmi = weight / height ^ 2  
          (skinny, normal, fat) = (18.5, 25.0, 30.0)    
```
Haskell 中也有 `case`，语法如下所示：
``` haskell
case expression of pattern -> result  
                   pattern -> result  
                   pattern -> result  
                   ...  

head' :: [a] -> a  
head' xs = case xs of [] -> error "No head for empty lists!"  
                      (x:_) -> x  

describeList :: [a] -> String  
describeList xs = "The list is " ++ case xs of [] -> "empty."  
                                               [x] -> "a singleton list."   
                                               xs -> "a longer list."  
```

#### 变量定义
在 Haskell 中变量定义称作 `bindings`，如上文提过可以用`:show bindings`查询ghci上下文的所有变量
在函数中，可以用`where`和`let`分别在**后**和**前**定义变量。

。。。好像缩进很重要，像 Python
``` haskell
-- where 是函数的一种语法构造，不能独立存在
initials :: String -> String -> String  
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."  
    where (f:_) = firstname  
          (l:_) = lastname    


-- let <bindings> in <expression> 这种表达式中，最后执行返回的是<expression>的结果
cylinder :: (RealFloat a) => a -> a -> a  
cylinder r h = 
    let sideArea = 2 * pi * r * h  
        topArea = pi * r ^2  
    in  sideArea + 2 * topArea  

-- let .. in .. 的结构本身就是表达式，可以独立存在
ghci> [let square x = x * x in (square 5, square 3, square 2)]  
[(25,9,4)]  
```
#### 高阶函数
前面对函数类型的定义中，对多个参数的处理使用了箭头指向的方式，这意味着可以逐步传入参数，来实现函数的功能（柯里化）。  
比如`fun:: (Ord a) => a -> a -> a -> a` 传入三个参数，但可以`fun:: (Ord a) => a -> (a -> (a -> a))`，拆分出来的每个局部本身也是一个函数。`fun x y` 为需要传入一个变量的函数。
``` haskell
-- 定义一个除以10函数，divideByTen 100 意味着 100/10
divideByTen :: (Floating a) => a -> a  
divideByTen = (/10)  

-- 是否为大写字母
isUpperAlphanum :: Char -> Bool  
isUpperAlphanum = (`elem` ['A'..'Z'])  

applyTwice :: (a -> a) -> a -> a  
applyTwice f x = f (f x)  

ghci> applyTwice (+3) 10  
16   
-- ("HAHA " ++) 是一个函数
ghci> applyTwice ("HAHA " ++) "HEY"  
"HAHA HAHA HEY" 
ghci> applyTwice (3:) [1]  
[3,3,1]  
```
#### Map & Filter
``` haskell
-- map :: (a -> b) -> [a] -> [b]   
ghci> map (+3) [1,5,3,1,6]  
[4,8,6,4,9]  

ghci> map fst [(1,2),(3,5),(6,3),(2,6),(2,5)]  
[1,3,6,2,2]  

-- 定义函数数组[(0*),(1*),(2*),(3*),(4*),(5*)..
ghci> let listOfFuns = map (*) [0..]  
ghci> (listOfFuns !! 4) 5  
20  

-- filter :: (a -> Bool) -> [a] -> [a]
ghci> filter (>3) [1,5,3,2,1,6,4,3,2,1]  
[5,6,4]  

ghci> filter (`elem` ['a'..'z']) "u LaUgH aT mE BeCaUsE I aM diFfeRent"  
"uagameasadifeent"  

```
#### Lambda 表达式
用`\`开始一个匿名表达式，因为`\`看起来很像 lambda 的 l（如果你斜着看的话
``` haskell
ghci> map (\(a,b) -> a + b) [(1,2),(3,5),(6,3),(2,6),(2,5)]  
[3,8,9,8,7]  
```

#### foldl & foldr
``` haskell
-- foldl 提供非显式的递归，从左往右，step by step
-- foldl <function> <start value>
sum' :: (Num a) => [a] -> a  
sum' = foldl (+) 0  

-- foldl1 和 foldr1 无需提供起始值
head' :: [a] -> a  
head' = foldr1 (\x _ -> x)  
  
last' :: [a] -> a  
last' = foldl1 (\_ x -> x)  

-- scanl 和 scanr 则可以直接给出fold作用后的结果
ghci> scanl (+) 0 [3,5,2,1]  
[0,3,8,10,11]  
ghci> scanr (+) 0 [3,5,2,1]  
[11,8,3,1,0]  
```
#### 函数前缀（`$`）、复合函数（`.`）
``` haskell
-- $ 用作函数前缀，右结合，具有最低优先级，一定在最后被执行
ghci> sum $ map sqrt [1..5]
8.382332347441762

-- 除此之外，借助 $ 我们可以将函数数组作用在值上
ghci> map ($ 3) [(4+), (10*), (^2), sqrt]  
[7.0,30.0,9.0,1.7320508075688772]  

-- . 用作复合函数，其定义如下
(.) :: (b -> c) -> (a -> b) -> a -> c  
f . g = \x -> f (g x) 

ghci> map (negate . abs) [5,-3,-6,7,-3,2,-19,24]  
[-5,-3,-6,-7,-3,-2,-19,-24]  

ghci> map (negate . sum . tail) [[1..5],[3..6],[1..7]]  
[-14,-15,-27]  

fn x = ceiling (negate (tan (cos (max 50 x))))  
-- 可写作
fn = ceiling . negate . tan . cos . max 50  
```

### Data.List
``` haskell
-- intersperse
ghci> intersperse '.' "MONKEY"  
"M.O.N.K.E.Y"  
ghci> intersperse 0 [1,2,3,4,5,6]  
[1,0,2,0,3,0,4,0,5,0,6]  

-- intercalate
ghci> intercalate " " ["hey","there","guys"]  
"hey there guys"  
ghci> intercalate [0,0,0] [[1,2,3],[4,5,6],[7,8,9]]  
[1,2,3,0,0,0,4,5,6,0,0,0,7,8,9]  

-- transpose
ghci> transpose [[1,2,3],[4,5,6],[7,8,9]]  
[[1,4,7],[2,5,8],[3,6,9]]  
ghci> transpose ["hey","there","guys"]  
["htg","ehu","yey","rs","e"]  

-- concat
ghci> concat ["foo","bar","car"]  
"foobarcar"  
ghci> concat [[3,4,5],[2,3,4],[2,1,1]]  
[3,4,5,2,3,4,2,1,1]  

-- concatMap
ghci> concatMap (replicate 4) [1..3]  
[1,1,1,1,2,2,2,2,3,3,3,3]  

-- and 作用于布尔数组
ghci> and $ map (>4) [5,6,7,8]  
True  
ghci> and $ map (==4) [4,4,4,3,4]  
False  

-- or
ghci> or $ map (==4) [2,3,4,5,6,1]  
True  
ghci> or $ map (>4) [1,2,3]  
False  

-- any / all
ghci> any (==4) [2,3,5,6,1,4]  
True  
ghci> all (>4) [6,9,10]  
True  
ghci> all (`elem` ['A'..'Z']) "HEYGUYSwhatsup"  
False  
ghci> any (`elem` ['A'..'Z']) "HEYGUYSwhatsup"  
True  

-- iterate
ghci> take 10 $ iterate (*2) 1  
[1,2,4,8,16,32,64,128,256,512]  
ghci> take 3 $ iterate (++ "haha") "haha"  
["haha","hahahaha","hahahahahaha"] 

-- splitAt return tuple
ghci> splitAt 3 "heyman"  
("hey","man")  
ghci> splitAt 100 "heyman"  
("heyman","")  
ghci> splitAt (-3) "heyman"  
("","heyman")  
ghci> let (a,b) = splitAt 3 "foobar" in b ++ a  
"barfoo"  

-- takeWhile
ghci> takeWhile (>3) [6,5,4,3,2,1,2,3,4,5,4,3,2,1]  
[6,5,4]  
ghci> takeWhile (/=' ') "This is a sentence"  
"This"  

-- dropWhile
ghci> dropWhile (/=' ') "This is a sentence"  
" is a sentence"  
ghci> dropWhile (<3) [1,2,2,2,3,4,5,4,3,2,1]  
[3,4,5,4,3,2,1]  

-- span / break
ghci> break (==4) [1,2,3,4,5,6,7]  
([1,2,3],[4,5,6,7])  
ghci> span (/=4) [1,2,3,4,5,6,7]  
([1,2,3],[4,5,6,7])  

-- sort
ghci> sort [8,5,3,2,1,6,4,2]  
[1,2,2,3,4,5,6,8]  
ghci> sort "This will be sorted soon"  
"    Tbdeehiillnooorssstw" 

-- nub 可 By
ghci> nub [1,2,3,4,3,2,1,2,3,4,3,2,1]  
[1,2,3,4]  
ghci> nub "Lots of words and stuff"  
"Lots fwrdanu"  

-- delete 可 By
ghci> delete 'h' "hey there ghang!"  
"ey there ghang!"  
ghci> delete 'h' . delete 'h' $ "hey there ghang!"  
"ey tere ghang!"  
ghci> delete 'h' . delete 'h' . delete 'h' $ "hey there ghang!"  
"ey tere gang!"

-- insert 找到第一个 比待插入元素更大的最小元素插入 可 By
ghci> insert 4 [3,5,1,2,8,2]  
[3,4,5,1,2,8,2]  
ghci> insert 4 [1,3,4,4,1]  
[1,3,4,4,4,1]  

-- \\ set difference 
ghci> [1..10] \\ [2,5,9]  
[1,3,4,6,7,8,10]  
ghci> "Im a big baby" \\ "big"  
"Im a  baby"  

-- union 第二个列表中的重复元素被移除 可 By
ghci> "hey man" `union` "man what's up"  
"hey manwt'sup"  
ghci> [1..7] `union` [5..10]  
[1,2,3,4,5,6,7,8,9,10]  

-- intersect 可 By
ghci> [1..7] `intersect` [5..10]  
[5,6,7]  

-- group 可 By
ghci> group [1,1,1,1,2,2,2,2,3,3,2,2,2,5,6,7]  
[[1,1,1,1],[2,2,2,2],[3,3],[2,2,2],[5],[6],[7]]  

-- inits / tails give the list of init and tail
ghci> inits "w00t"  
["","w","w0","w00","w00t"]  
ghci> tails "w00t"  
["w00t","00t","0t","t",""]  
ghci> let w = "w00t" in zip (inits w) (tails w)  
[("","w00t"),("w","00t"),("w0","0t"),("w00","t"),("w00t","")]

-- substring / sublist
ghci> "cat" `isInfixOf` "im a cat burglar"  
True  
ghci> "Cat" `isInfixOf` "im a cat burglar"  
False  
ghci> "cats" `isInfixOf` "im a cat burglar"  
False  

ghci> "hey" `isPrefixOf` "hey there!"  
True  
ghci> "hey" `isPrefixOf` "oh hey there!"  
False  
ghci> "there!" `isSuffixOf` "oh hey there!"  
True  
ghci> "there!" `isSuffixOf` "oh hey there"  
False  

-- partition
ghci> partition (`elem` ['A'..'Z']) "BOBsidneyMORGANeddy"  
("BOBMORGAN","sidneyeddy")  
ghci> partition (>3) [1,3,5,6,3,2,1,0,3,7]  
([5,6,7],[1,3,3,2,1,0,3])  
```

### Data.Char
字符处理 
``` haskell
ghci> import Data.Char
ghci> chr 112
'p'
ghci> ord 'c'
99


```

### Data.Map
``` haskell
import qualified Data.Map as Map  

```

### Data.Set
``` haskell
import qualified Data.Set as Set  

```
