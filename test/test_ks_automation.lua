#!/usr/bin/env lua
-- ks 语言自动化测试运行器
-- 这个脚本会自动测试 ks 语言的各种功能

-- 添加 src 目录到包路径
package.path = package.path .. ';../src/?.lua;../src/?/init.lua'

local luacheck = require('luacheck')

-- 测试统计
local total_tests = 0
local passed_tests = 0
local failed_tests = 0

-- 颜色输出
local colors = {
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    reset = '\27[0m'
}

local function color_print(color, text)
    print(colors[color] .. text .. colors.reset)
end

-- 测试用例定义
local test_cases = {
    {
        name = "基础 0-based 索引",
        code = [[
local arr = {10, 20, 30}
return arr[0] + arr[1] + arr[2]
]],
        expected_error_count = 0,
        description = "测试数组 0-based 索引访问"
    },
    {
        name = "getlength 函数",
        code = [[
local arr = {1, 2, 3, 4, 5}
return getlength(arr)
]],
        expected_error_count = 0,
        description = "测试 getlength 函数"
    },
    {
        name = "# 作为全局表",
        code = [[
#config = {value = 42}
return #config.value
]],
        expected_error_count = 0,
        description = "测试 # 作为全局表标识符"
    },
    {
        name = "字符串 0-based 索引",
        code = [[
local str = "Hello"
return str[0] .. str[4]
]],
        expected_error_count = 0,
        description = "测试字符串 0-based 索引"
    },
    {
        name = "循环遍历",
        code = [[
local arr = {1, 2, 3}
local sum = 0
for i = 0, getlength(arr) - 1 do
    sum = sum + arr[i]
end
return sum
]],
        expected_error_count = 0,
        description = "测试 0-based 循环遍历"
    },
    {
        name = "嵌套 # 全局表",
        code = [[
#db = {
    config = {
        host = "localhost",
        port = 3306
    },
    users = {"admin", "user1", "user2"}
}
return #db.config.host, #db.users[0]
]],
        expected_error_count = 0,
        description = "测试嵌套 # 全局表访问"
    },
    {
        name = "函数参数传递",
        code = [[
local function process(data)
    local result = 0
    for i = 0, getlength(data) - 1 do
        result = result + data[i]
    end
    return result
end

local numbers = {10, 20, 30}
return process(numbers)
]],
        expected_error_count = 0,
        description = "测试函数参数传递和 0-based 处理"
    },
    {
        name = "多维数组",
        code = [[
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
return matrix[0][0] + matrix[1][1] + matrix[2][2]
]],
        expected_error_count = 0,
        description = "测试多维数组 0-based 索引"
    },
    {
        name = "条件语句",
        code = [[
#settings = {debug = true}
local arr = {1, 2, 3}
if #settings.debug then
    return getlength(arr)
else
    return 0
end
]],
        expected_error_count = 0,
        description = "测试 # 全局表在条件语句中的使用"
    },
    {
        name = "复杂数据结构",
        code = [[
#game = {
    players = {},
    add_player = function(self, name)
        local player = {
            name = name,
            score = 0,
            id = getlength(self.players)
        }
        self.players[getlength(self.players)] = player
        return player
    end,
    get_player_count = function(self)
        return getlength(self.players)
    end
}

#game:add_player("Alice")
#game:add_player("Bob")
#game:add_player("Charlie")

return #game:get_player_count()
]],
        expected_error_count = 0,
        description = "测试复杂数据结构和对象方法"
    }
}

-- 运行单个测试
local function run_test(test_case)
    total_tests = total_tests + 1
    
    print(string.format("测试 %d: %s", total_tests, test_case.name))
    print("描述: " .. test_case.description)
    
    local success, report = pcall(function()
        return luacheck.check_strings({test_case.code}, {ks = true})
    end)
    
    if not success then
        color_print('red', "❌ 测试失败: " .. report)
        failed_tests = failed_tests + 1
        return false
    end
    
    local actual_errors = report.errors or 0
    local actual_warnings = report.warnings or 0
    
    if actual_errors == test_case.expected_error_count then
        color_print('green', "✅ 测试通过")
        passed_tests = passed_tests + 1
        return true
    else
        color_print('red', string.format("❌ 测试失败: 预期 %d 个错误，实际 %d 个错误", 
              test_case.expected_error_count, actual_errors))
        failed_tests = failed_tests + 1
        return false
    end
end

-- 运行所有测试
local function run_all_tests()
    color_print('blue', "=== ks 语言自动化测试 ===")
    color_print('blue', "开始运行 " .. #test_cases .. " 个测试用例")
    print()
    
    for i = 1, #test_cases do
        run_test(test_cases[i])
        print()
    end
    
    color_print('blue', "=== 测试结果总结 ===")
    color_print('green', string.format("✅ 通过: %d", passed_tests))
    color_print('red', string.format("❌ 失败: %d", failed_tests))
    color_print('yellow', string.format("📊 总计: %d", total_tests))
    
    if failed_tests == 0 then
        color_print('green', "🎉 所有测试通过！")
        return 0
    else
        color_print('red', "❌ 有测试失败，请检查代码")
        return 1
    end
end

-- 主函数
local function main()
    local exit_code = run_all_tests()
    os.exit(exit_code)
end

-- 如果直接运行此脚本，则执行测试
if arg and arg[0] and arg[0]:find("test_ks_automation%.lua$") then
    main()
end

return {
    run_all_tests = run_all_tests,
    run_test = run_test,
    test_cases = test_cases
}