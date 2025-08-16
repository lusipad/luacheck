#!/usr/bin/env lua
-- ks 语言综合测试运行器
-- 这个脚本会运行所有的 ks 语言测试

-- 添加当前目录到包路径
package.path = package.path .. ';?.lua'

-- 颜色输出
local colors = {
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    magenta = '\27[35m',
    cyan = '\27[36m',
    white = '\27[37m',
    reset = '\27[0m'
}

local function color_print(color, text)
    print(colors[color] .. text .. colors.reset)
end

-- 测试结果统计
local test_results = {
    total = 0,
    passed = 0,
    failed = 0,
    suites = {}
}

-- 运行单个测试文件
local function run_test_file(test_file, suite_name)
    color_print('cyan', string.format("运行测试文件: %s", test_file))
    
    local success, result = pcall(function()
        local test_module = dofile(test_file)
        if type(test_module) == "table" and test_module.run_all_tests then
            return test_module.run_all_tests()
        elseif type(test_module) == "table" and test_module.run_boundary_tests then
            -- 对于边界测试文件
            local boundary_passed, boundary_failed = test_module.run_boundary_tests()
            local error_passed, error_failed = test_module.run_error_handling_tests()
            local perf_passed, perf_failed = test_module.run_performance_tests()
            local total_passed = boundary_passed + error_passed + perf_passed
            local total_failed = boundary_failed + error_failed + perf_failed
            return total_passed, total_failed
        end
        return 0, 0
    end)
    
    if not success then
        color_print('red', string.format("❌ 测试文件 %s 运行失败: %s", test_file, result))
        return 0, 1
    end
    
    local passed, failed = result
    passed = passed or 0
    failed = failed or 0
    color_print('green', string.format("✅ %s 完成: %d 通过, %d 失败", suite_name, passed, failed))
    
    return passed, failed
end

-- 测试套件定义
local test_suites = {
    {
        name = "基础功能测试",
        file = "test_ks_automation.lua",
        description = "测试 ks 语言的基础功能"
    },
    {
        name = "对比测试",
        file = "test_ks_comparison.lua",
        description = "对比 ks 语言和标准 Lua 的差异"
    },
    {
        name = "边界测试",
        file = "test_ks_boundary.lua",
        description = "测试边界情况和错误处理"
    }
}

-- 验证示例文件
local function validate_example_files()
    color_print('blue', "=== 验证示例文件 ===")
    
    local example_files = {
        "basic_ks_example.ks",
        "advanced_ks_example.ks", 
        "ks_vs_lua_comparison.ks",
        "ks_features_demo.ks",
        "sample.ks"
    }
    
    local valid_examples = 0
    local total_examples = #example_files
    
    for i = 1, total_examples do
        local filename = example_files[i]
        local file = io.open(filename, "r")
        if file then
            file:close()
            color_print('green', string.format("✅ 示例文件存在: %s", filename))
            valid_examples = valid_examples + 1
        else
            color_print('red', string.format("❌ 示例文件缺失: %s", filename))
        end
    end
    
    color_print('yellow', string.format("示例文件验证: %d/%d", valid_examples, total_examples))
    return valid_examples == total_examples
end

-- 运行所有测试
local function run_all_tests()
    color_print('magenta', "========================================")
    color_print('magenta', "=== ks 语言综合测试套件 ===")
    color_print('magenta', "========================================")
    print()
    
    -- 验证示例文件
    local examples_valid = validate_example_files()
    print()
    
    -- 运行测试套件
    color_print('blue', "=== 开始运行测试套件 ===")
    print()
    
    for i = 1, #test_suites do
        local suite = test_suites[i]
        color_print('cyan', string.format("测试套件 %d: %s", i, suite.name))
        color_print('yellow', string.format("描述: %s", suite.description))
        
        local passed, failed = run_test_file(suite.file, suite.name)
        
        test_results.total = test_results.total + passed + failed
        test_results.passed = test_results.passed + passed
        test_results.failed = test_results.failed + failed
        
        test_results.suites[suite.name] = {
            passed = passed,
            failed = failed,
            total = passed + failed
        }
        
        print()
    end
    
    -- 输出详细结果
    color_print('blue', "=== 详细测试结果 ===")
    for suite_name, results in pairs(test_results.suites) do
        local status = results.failed == 0 and "✅" or "❌"
        local color = results.failed == 0 and "green" or "red"
        color_print(color, string.format("%s %s: %d/%d 通过 (%d 失败)", 
              status, suite_name, results.passed, results.total, results.failed))
    end
    print()
    
    -- 输出汇总
    color_print('blue', "=== 汇总结果 ===")
    color_print('green', string.format("✅ 总计通过: %d", test_results.passed))
    color_print('red', string.format("❌ 总计失败: %d", test_results.failed))
    color_print('yellow', string.format("📊 总计测试: %d", test_results.total))
    
    if not examples_valid then
        color_print('red', "⚠️  部分示例文件缺失")
    end
    
    local exit_code = 0
    if test_results.failed > 0 then
        color_print('red', "❌ 部分测试失败，请检查实现")
        exit_code = 1
    else
        color_print('green', "🎉 所有测试通过！")
    end
    
    return exit_code
end

-- 显示帮助信息
local function show_help()
    color_print('cyan', "ks 语言测试运行器")
    print()
    color_print('yellow', "用法:")
    print("  lua test_ks_comprehensive.lua [选项]")
    print()
    color_print('yellow', "选项:")
    print("  -h, --help     显示帮助信息")
    print("  -v, --version  显示版本信息")
    print("  -a, --all      运行所有测试（默认）")
    print("  -b, --basic    只运行基础功能测试")
    print("  -c, --compare  只运行对比测试")
    print("  -e, --boundary 只运行边界测试")
    print()
    color_print('yellow', "示例:")
    print("  lua test_ks_comprehensive.lua")
    print("  lua test_ks_comprehensive.lua --basic")
    print("  lua test_ks_comprehensive.lua --compare")
    print("  lua test_ks_comprehensive.lua --boundary")
end

-- 显示版本信息
local function show_version()
    color_print('cyan', "ks 语言测试运行器 v1.0.0")
    color_print('yellow', "用于测试 Luacheck 的 ks 语言支持")
end

-- 主函数
local function main()
    local args = arg or {}
    
    if #args == 0 or args[1] == "-a" or args[1] == "--all" then
        local exit_code = run_all_tests()
        os.exit(exit_code)
    elseif args[1] == "-h" or args[1] == "--help" then
        show_help()
    elseif args[1] == "-v" or args[1] == "--version" then
        show_version()
    elseif args[1] == "-b" or args[1] == "--basic" then
        color_print('blue', "运行基础功能测试...")
        local passed, failed = run_test_file("test_ks_automation.lua", "基础功能测试")
        os.exit(failed > 0 and 1 or 0)
    elseif args[1] == "-c" or args[1] == "--compare" then
        color_print('blue', "运行对比测试...")
        local passed, failed = run_test_file("test_ks_comparison.lua", "对比测试")
        os.exit(failed > 0 and 1 or 0)
    elseif args[1] == "-e" or args[1] == "--boundary" then
        color_print('blue', "运行边界测试...")
        local passed, failed = run_test_file("test_ks_boundary.lua", "边界测试")
        os.exit(failed > 0 and 1 or 0)
    else
        color_print('red', string.format("未知选项: %s", args[1]))
        show_help()
        os.exit(1)
    end
end

-- 如果直接运行此脚本，则执行测试
if arg and arg[0] and arg[0]:find("test_ks_comprehensive%.lua$") then
    main()
end

return {
    run_all_tests = run_all_tests,
    run_test_file = run_test_file,
    validate_example_files = validate_example_files,
    test_results = test_results
}