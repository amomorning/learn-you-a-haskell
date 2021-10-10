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
