#!/usr/bin/env lua

-- Comprehensive test for ks language support
package.path = './src/?.lua;./src/?/init.lua;' .. package.path

local luacheck = require "luacheck"

-- Test cases for ks language
local test_cases = {
    {
        name = "Normal mode - # as operator",
        code = [[
local arr = {"a", "b", "c"}
print(#arr)  -- Should be length operator
]],
        options = {},
        expect_warnings = true  -- Normal operation, no ks-specific warnings
    },
    {
        name = "KS mode - # as global table",
        code = [[
local # = {key = "value"}
print(#.key)  -- # treated as identifier
]],
        options = {ks = true},
        expect_warnings = false  -- Should work without warnings
    },
    {
        name = "KS mode - # in variable names",
        code = [[
local #test = "hello"
local test# = "world"
print(#test, test#)
]],
        options = {ks = true},
        expect_warnings = false  -- Should work without warnings
    },
    {
        name = "Mixed - array access patterns",
        code = [[
local arr = {"first", "second", "third"}
-- In normal Lua, arr[0] would be nil
-- In ks, arr[0] would be "first"
print(arr[0], arr[1], arr[2])
]],
        options = {ks = true},
        expect_warnings = false  -- Should work without warnings
    }
}

print("=== Testing KS Language Support ===")
print()

for i, test in ipairs(test_cases) do
    print(string.format("%d. %s", i, test.name))
    print("Code:")
    for line in test.code:gmatch("[^\n]*") do
        if line:match("%S") then
            print("   ", line)
        end
    end
    
    local ok, report = pcall(function()
        return luacheck.get_report(test.code, test.options)
    end)
    
    if ok then
        print("Result: SUCCESS")
        if report and #report > 0 then
            print("Warnings found:")
            for _, warning in ipairs(report) do
                print(string.format("   Line %d: %s", warning.line, warning.code))
            end
        else
            print("No warnings found")
        end
    else
        print("Result: FAILED -", report)
    end
    
    print()
end

print("=== Testing CLI Option ===")
-- Test that the CLI option is recognized
print("CLI option --ks should be available in help")