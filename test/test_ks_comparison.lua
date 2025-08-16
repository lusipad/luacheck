#!/usr/bin/env lua
-- ks 语言 vs 标准 Lua 对比测试
-- 这个脚本会对比测试标准 Lua 和 ks 语言的不同行为

-- 添加 src 目录到包路径
package.path = package.path .. ';../src/?.lua;../src/?/init.lua'

local luacheck = require('luacheck')

-- 颜色输出
local colors = {
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    cyan = '\27[36m',
    reset = '\27[0m'
}

local function color_print(color, text)
    print(colors[color] .. text .. colors.reset)
end

-- 对比测试用例
local comparison_tests = {
    {
        name = "# 运算符行为",
        lua_code = [[local arr = {1, 2, 3}; return #arr]],
        ks_code = [[local arr = {1, 2, 3}; return getlength(arr)]],
        description = "# 在标准 Lua 中是长度运算符，在 ks 中 getlength() 是长度函数"
    },
    {
        name = "数组索引访问",
        lua_code = "local arr = {10, 20, 30}; return arr[1] + arr[2]",
        ks_code = "local arr = {10, 20, 30}; return arr[0] + arr[1]",
        description = "标准 Lua 使用 1-based 索引，ks 使用 0-based 索引"
    },
    {
        name = "# 作为标识符",
        lua_code = "local #arr = {1, 2, 3}",
        ks_code = "#arr = {1, 2, 3}",
        description = "标准 Lua 中 # 不能作为标识符，ks 中 # 可以作为全局表前缀"
    },
    {
        name = "循环遍历",
        lua_code = "local arr = {1, 2, 3, 4, 5}\nlocal sum = 0\nfor i = 1, #arr do\n    sum = sum + arr[i]\nend\nreturn sum",
        ks_code = "local arr = {1, 2, 3, 4, 5}\nlocal sum = 0\nfor i = 0, getlength(arr) - 1 do\n    sum = sum + arr[i]\nend\nreturn sum",
        description = "循环遍历的不同方式"
    },
    {
        name = "字符串索引",
        lua_code = "local str = \"Hello\"; return str:sub(1,1)",
        ks_code = "local str = \"Hello\"; return str[0]",
        description = "字符串访问的不同方式"
    }
}

-- 运行单个对比测试
local function run_comparison_test(test, index)
    color_print('cyan', string.format("=== 对比测试 %d: %s ===", index + 1, test.name))
    print("描述: " .. test.description)
    print()
    
    -- 测试标准 Lua 代码
    color_print('yellow', "标准 Lua 模式:")
    print("代码: " .. test.lua_code:gsub("\n", "; "))
    
    local lua_success, lua_report = pcall(function()
        return luacheck.check_strings({test.lua_code}, {})
    end)
    
    if lua_success then
        color_print('green', string.format("✅ 标准 Lua: %d 个错误, %d 个警告", 
              lua_report.errors or 0, lua_report.warnings or 0))
    else
        color_print('red', "❌ 标准 Lua 测试失败: " .. lua_report)
    end
    
    print()
    
    -- 测试 ks 代码
    color_print('yellow', "ks 语言模式:")
    print("代码: " .. test.ks_code:gsub("\n", "; "))
    
    local ks_success, ks_report = pcall(function()
        return luacheck.check_strings({test.ks_code}, {ks = true})
    end)
    
    if ks_success then
        color_print('green', string.format("✅ ks 语言: %d 个错误, %d 个警告", 
              ks_report.errors or 0, ks_report.warnings or 0))
    else
        color_print('red', "❌ ks 语言测试失败: " .. ks_report)
    end
    
    print()
    print(string.format("%s~%s", string.rep("~", 50), string.rep("~", 50)))
    print()
end

-- 运行所有对比测试
local function run_all_comparison_tests()
    color_print('blue', "=== ks 语言 vs 标准 Lua 对比测试 ===")
    color_print('blue', "开始运行 " .. #comparison_tests .. " 个对比测试")
    print()
    
    for i = 1, #comparison_tests do
        run_comparison_test(comparison_tests[i], i - 1)
    end
    
    color_print('blue', "=== 对比测试完成 ===")
end

-- 兼容性测试
local function run_compatibility_tests()
    color_print('blue', "=== 兼容性测试 ===")
    print("测试相同的代码在不同模式下的行为")
    print()
    
    local compatibility_tests = {
        {
            name = "普通 Lua 代码",
            code = "local function add(a, b)\n    return a + b\nend\n\nlocal result = add(10, 20)\nprint(\"结果: \" .. result)",
            description = "测试标准 Lua 代码在两种模式下的表现"
        },
        {
            name = "包含 # 的代码",
            code = "local arr = {1, 2, 3, 4, 5}\nlocal length = #arr  -- 在标准 Lua 中正常，在 ks 中会报错\nreturn length",
            description = "测试 # 运算符在不同模式下的行为"
        }
    }
    
    for i = 1, #compatibility_tests do
        local test = compatibility_tests[i]
        color_print('cyan', string.format("兼容性测试 %d: %s", i + 1, test.name))
        print("描述: " .. test.description)
        print("代码: " .. test.code:gsub("\n", "; "))
        print()
        
        -- 在标准 Lua 模式下测试
        color_print('yellow', "标准 Lua 模式:")
        local lua_success, lua_report = pcall(function()
            return luacheck.check_strings({test.code}, {})
        end)
        
        if lua_success then
            color_print('green', string.format("✅ 标准 Lua: %d 个错误, %d 个警告", 
                  lua_report.errors or 0, lua_report.warnings or 0))
        else
            color_print('red', "❌ 标准 Lua 测试失败: " .. lua_report)
        end
        
        print()
        
        -- 在 ks 模式下测试
        color_print('yellow', "ks 语言模式:")
        local ks_success, ks_report = pcall(function()
            return luacheck.check_strings({test.code}, {ks = true})
        end)
        
        if ks_success then
            color_print('green', string.format("✅ ks 语言: %d 个错误, %d 个警告", 
                  ks_report.errors or 0, ks_report.warnings or 0))
        else
            color_print('red', "❌ ks 语言测试失败: " .. ks_report)
        end
        
        print()
        print(string.rep("-", 60))
        print()
    end
end

-- 主函数
local function main()
    run_all_comparison_tests()
    print()
    run_compatibility_tests()
    
    color_print('blue', "=== 所有对比测试完成 ===")
end

-- 如果直接运行此脚本，则执行测试
if arg and arg[0] and arg[0]:find("test_ks_comparison%.lua$") then
    main()
end

return {
    run_all_comparison_tests = run_all_comparison_tests,
    run_compatibility_tests = run_compatibility_tests,
    comparison_tests = comparison_tests
}