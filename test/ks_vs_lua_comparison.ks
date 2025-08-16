-- ks 语言 vs 标准 Lua 对比示例
-- 这个文件展示了 ks 语言和标准 Lua 的主要区别

-- =====================================================================
-- 1. 数组索引对比
-- =====================================================================

-- ks 语言 (0-based)
local arr_ks = {10, 20, 30, 40, 50}
print("=== 数组索引对比 ===")
print("ks 语言:")
print("  arr_ks[0] =", arr_ks[0])  --> 10 (第一个元素)
print("  arr_ks[1] =", arr_ks[1])  --> 20 (第二个元素)
print("  arr_ks[4] =", arr_ks[4])  --> 50 (第五个元素)

-- 标准 Lua (1-based) - 这里只是注释说明
--[[
local arr_lua = {10, 20, 30, 40, 50}
print("标准 Lua:")
print("  arr_lua[1] =", arr_lua[1])  --> 10 (第一个元素)
print("  arr_lua[2] =", arr_lua[2])  --> 20 (第二个元素)
print("  arr_lua[5] =", arr_lua[5])  --> 50 (第五个元素)
--]]

-- =====================================================================
-- 2. 长度获取对比
-- =====================================================================

print("\n=== 长度获取对比 ===")
print("ks 语言:")
local len_ks = getlength(arr_ks)
print("  getlength(arr_ks) =", len_ks)  --> 5

-- 标准 Lua - 这里只是注释说明
--[[
print("标准 Lua:")
local len_lua = #arr_lua
print("  #arr_lua =", len_lua)  --> 5
--]]

-- =====================================================================
-- 3. # 运算符对比
-- =====================================================================

print("\n=== # 运算符对比 ===")
print("ks 语言:")
#global_table = {
    setting1 = "value1",
    setting2 = "value2"
}
print("  #global_table.setting1 =", #global_table.setting1)  --> "value1"

-- 标准 Lua - 这里只是注释说明
--[[
print("标准 Lua:")
local length_op = #arr_lua
print("  #arr_lua =", length_op)  --> 5 (长度运算符)
--]]

-- =====================================================================
-- 4. 循环遍历对比
-- =====================================================================

print("\n=== 循环遍历对比 ===")
print("ks 语言:")
for i = 0, getlength(arr_ks) - 1 do
    print("  遍历 arr_ks[" .. i .. "] =", arr_ks[i])
end

-- 标准 Lua - 这里只是注释说明
--[[
print("标准 Lua:")
for i = 1, #arr_lua do
    print("  遍历 arr_lua[" .. i .. "] =", arr_lua[i])
end
--]]

-- =====================================================================
-- 5. 字符串索引对比
-- =====================================================================

print("\n=== 字符串索引对比 ===")
print("ks 语言:")
local str_ks = "Hello"
print("  str_ks[0] =", str_ks[0])  --> "H"
print("  str_ks[4] =", str_ks[4])  --> "o"

-- 标准 Lua - 这里只是注释说明
--[[
print("标准 Lua:")
local str_lua = "Hello"
print("  str_lua:sub(1,1) =", str_lua:sub(1,1))  --> "H"
print("  str_lua:sub(5,5) =", str_lua:sub(5,5))  --> "o"
--]]

-- =====================================================================
-- 6. 函数参数处理对比
-- =====================================================================

print("\n=== 函数参数处理对比 ===")
print("ks 语言:")
local function process_array_ks(arr)
    local result = 0
    for i = 0, getlength(arr) - 1 do
        result = result + arr[i]
    end
    return result
end

local sum_ks = process_array_ks(arr_ks)
print("  数组求和:", sum_ks)  --> 150

-- 标准 Lua - 这里只是注释说明
--[[
print("标准 Lua:")
local function process_array_lua(arr)
    local result = 0
    for i = 1, #arr do
        result = result + arr[i]
    end
    return result
end

local sum_lua = process_array_lua(arr_lua)
print("  数组求和:", sum_lua)  --> 150
--]]

-- =====================================================================
-- 7. 实际应用示例
-- =====================================================================

print("\n=== 实际应用示例 ===")
print("ks 语言 - 简单的学生成绩管理:")

#students = {
    {name = "张三", score = 85},
    {name = "李四", score = 92},
    {name = "王五", score = 78}
}

local function calculate_average_ks()
    local total = 0
    for i = 0, getlength(#students) - 1 do
        total = total + #students[i].score
    end
    return total / getlength(#students)
end

local average = calculate_average_ks()
print("  平均分:", average)  --> 85

print("\n=== 对比总结 ===")
print("ks 语言的主要特点:")
print("1. 数组和字符串使用 0-based 索引")
print("2. 使用 getlength() 函数获取长度")
print("3. # 作为全局表标识符，不是长度运算符")
print("4. 循环从 0 开始到 length-1 结束")
print("5. 更符合 C/C++/JavaScript 等语言的编程习惯")