#!/usr/bin/env lua
-- ks 语言边界测试和错误处理测试
-- 测试 ks 语言在边界情况和错误处理方面的表现

-- 添加 src 目录到包路径
package.path = package.path .. ';../src/?.lua;../src/?/init.lua'

local luacheck = require('luacheck')

-- 颜色输出
local colors = {
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    magenta = '\27[35m',
    cyan = '\27[36m',
    reset = '\27[0m'
}

local function color_print(color, text)
    print(colors[color] .. text .. colors.reset)
end

-- 边界测试用例
local boundary_tests = {
    {
        name = "空数组访问",
        code = [[
local arr = {}
return arr[0]
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试空数组的 0-based 访问"
    },
    {
        name = "数组越界访问",
        code = [[
local arr = {1, 2, 3}
return arr[5]
]],
        expected_errors = 0,
        expected_warnings = 1,  -- 应该有访问未定义变量的警告
        description = "测试数组越界访问"
    },
    {
        name = "负数索引",
        code = [[
local arr = {1, 2, 3}
return arr[-1]
]],
        expected_errors = 0,
        expected_warnings = 1,
        description = "测试负数索引访问"
    },
    {
        name = "空字符串访问",
        code = [[
local str = ""
return str[0]
]],
        expected_errors = 0,
        expected_warnings = 1,
        description = "测试空字符串的字符访问"
    },
    {
        name = "大数组的 getlength",
        code = [[
local arr = {}
for i = 0, 999 do
    arr[i] = i
end
return getlength(arr)
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试大数组的 getlength 函数"
    },
    {
        name = "嵌套表深度访问",
        code = [[
#deep = {
    level1 = {
        level2 = {
            level3 = {
                value = 42
            }
        }
    }
}
return #deep.level1.level2.level3.value
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试深层嵌套 # 全局表访问"
    },
    {
        name = "循环中的 # 表访问",
        code = [[
#data = {}
for i = 0, 9 do
    #data[i] = i * 2
end
local sum = 0
for i = 0, 9 do
    sum = sum + #data[i]
end
return sum
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试循环中 # 表的访问和赋值"
    }
}

-- 错误处理测试用例
local error_handling_tests = {
    {
        name = "无效的 getlength 参数",
        code = [[
local len = getlength(nil)
]],
        expected_errors = 1,
        expected_warnings = 0,
        description = "测试对 nil 调用 getlength"
    },
    {
        name = "对数字调用 getlength",
        code = [[
local len = getlength(42)
]],
        expected_errors = 1,
        expected_warnings = 0,
        description = "测试对数字调用 getlength"
    },
    {
        name = "对字符串调用 getlength",
        code = [[
local len = getlength("hello")
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试对字符串调用 getlength（应该正常工作）"
    },
    {
        name = "未定义的 # 全局表",
        code = [[
local value = #undefined_table.key
]],
        expected_errors = 1,
        expected_warnings = 0,
        description = "测试访问未定义的 # 全局表"
    },
    {
        name = "混合使用 # 和 getlength",
        code = [[
local arr = {1, 2, 3}
local len1 = getlength(arr)
local len2 = #arr  -- 在 ks 模式下这应该报错
return len1 + len2
]],
        expected_errors = 1,
        expected_warnings = 0,
        description = "测试混合使用 # 运算符和 getlength 函数"
    },
    {
        name = "递归 getlength 调用",
        code = [[
local function recursive_len(arr)
    if getlength(arr) == 0 then
        return 0
    end
    return 1 + recursive_len(arr)
end
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试递归调用 getlength"
    },
    {
        name = "# 表名冲突",
        code = [[
#config = {value = 1}
local config = {value = 2}
return #config.value + config.value
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试 # 全局表与局部变量同名的情况"
    }
}

-- 性能测试用例
local performance_tests = {
    {
        name = "大量数组访问",
        code = [[
local arr = {}
for i = 0, 9999 do
    arr[i] = i
end
local sum = 0
for i = 0, 9999 do
    sum = sum + arr[i]
end
return sum
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试大量数组访问的性能"
    },
    {
        name = "频繁的 getlength 调用",
        code = [[
local arr = {1, 2, 3, 4, 5}
local count = 0
for i = 0, 9999 do
    if i % getlength(arr) == 0 then
        count = count + 1
    end
end
return count
]],
        expected_errors = 0,
        expected_warnings = 0,
        description = "测试频繁调用 getlength 的性能"
    }
}

-- 运行单个测试
local function run_single_test(test, test_type, index)
    total_tests = (total_tests or 0) + 1
    passed_tests = passed_tests or 0
    failed_tests = failed_tests or 0
    
    color_print('cyan', string.format("%s测试 %d: %s", test_type, index + 1, test.name))
    print("描述: " .. test.description)
    print("代码: " .. test.code:gsub("\n", "; "))
    
    local success, report = pcall(function()
        return luacheck.check_strings({test.code}, {ks = true})
    end)
    
    if not success then
        color_print('red', "❌ 测试失败: " .. report)
        failed_tests = failed_tests + 1
        return false
    end
    
    local actual_errors = report.errors or 0
    local actual_warnings = report.warnings or 0
    local expected_errors = test.expected_errors or 0
    local expected_warnings = test.expected_warnings or 0
    
    local errors_match = actual_errors == expected_errors
    local warnings_match = actual_warnings == expected_warnings
    
    if errors_match and warnings_match then
        color_print('green', string.format("✅ 测试通过: %d 个错误, %d 个警告", 
              actual_errors, actual_warnings))
        passed_tests = passed_tests + 1
        return true
    else
        color_print('red', string.format("❌ 测试失败: 预期 %d 个错误, %d 个警告；实际 %d 个错误, %d 个警告", 
              expected_errors, expected_warnings, actual_errors, actual_warnings))
        failed_tests = failed_tests + 1
        return false
    end
end

-- 运行测试套件
local function run_test_suite(tests, test_type_name)
    color_print('blue', string.format("=== %s ===", test_type_name))
    color_print('blue', string.format("开始运行 %d 个测试", #tests))
    print()
    
    -- 重置计数器
    total_tests = 0
    passed_tests = 0
    failed_tests = 0
    
    local suite_passed = 0
    local suite_failed = 0
    
    for i = 1, #tests do
        if run_single_test(tests[i], test_type_name:sub(1, 3), i - 1) then
            suite_passed = suite_passed + 1
        else
            suite_failed = suite_failed + 1
        end
        print()
    end
    
    color_print('yellow', string.format("%s 测试结果: %d 通过, %d 失败", 
          test_type_name, suite_passed, suite_failed))
    print()
    
    return suite_passed, suite_failed
end

-- 主函数
local function main()
    total_tests = 0
    passed_tests = 0
    failed_tests = 0
    
    color_print('magenta', "=== ks 语言边界和错误处理测试 ===")
    print()
    
    -- 运行边界测试
    local boundary_passed, boundary_failed = run_test_suite(boundary_tests, "边界测试")
    
    -- 运行错误处理测试
    local error_passed, error_failed = run_test_suite(error_handling_tests, "错误处理测试")
    
    -- 运行性能测试
    local perf_passed, perf_failed = run_test_suite(performance_tests, "性能测试")
    
    -- 汇总结果
    local total_passed = boundary_passed + error_passed + perf_passed
    local total_failed = boundary_failed + error_failed + perf_failed
    
    color_print('blue', "=== 测试结果汇总 ===")
    color_print('green', string.format("✅ 总计通过: %d", total_passed))
    color_print('red', string.format("❌ 总计失败: %d", total_failed))
    color_print('yellow', string.format("📊 总计测试: %d", total_passed + total_failed))
    
    if total_failed == 0 then
        color_print('green', "🎉 所有边界和错误处理测试通过！")
        return 0
    else
        color_print('red', "❌ 部分测试失败，请检查实现")
        return 1
    end
end

-- 如果直接运行此脚本，则执行测试
if arg and arg[0] and arg[0]:find("test_ks_boundary%.lua$") then
    main()
end

return {
    run_boundary_tests = function()
        return run_test_suite(boundary_tests, "边界测试")
    end,
    run_error_handling_tests = function()
        return run_test_suite(error_handling_tests, "错误处理测试")
    end,
    run_performance_tests = function()
        return run_test_suite(performance_tests, "性能测试")
    end,
    boundary_tests = boundary_tests,
    error_handling_tests = error_handling_tests,
    performance_tests = performance_tests
}