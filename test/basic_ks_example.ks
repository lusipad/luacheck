-- 基础 ks 语言示例
-- 这个文件展示了 ks 语言的主要特性

-- 0-based 索引
local arr = {10, 20, 30, 40, 50}
print(arr[0])      --> 10 (第一个元素)
print(arr[1])      --> 20 (第二个元素)
print(arr[4])      --> 50 (第五个元素)

-- 使用 getlength 函数而不是 # 运算符
local length = getlength(arr)
print("数组长度:", length) --> 5

-- # 作为全局表标识符
#config = {
    debug = true,
    version = "1.0"
}

#utils = {
    helper = function(x)
        return x * 2
    end
}

-- 访问 # 全局表
print("调试模式:", #config.debug)
print("版本:", #config.version)
print("帮助函数结果:", #utils.helper(5))

-- 数组遍历使用 0-based 索引
for i = 0, getlength(arr) - 1 do
    print("arr[" .. i .. "] = " .. arr[i])
end

-- 多维数组
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}

print("matrix[0][0] =", matrix[0][0]) --> 1
print("matrix[1][2] =", matrix[1][2]) --> 6
print("matrix[2][1] =", matrix[2][1]) --> 8

-- 字符串也是 0-based 索引
local str = "Hello"
print("str[0] =", str[0]) --> "H"
print("str[4] =", str[4]) --> "o"