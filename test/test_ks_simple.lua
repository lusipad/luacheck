#!/usr/bin/env lua
-- Simple KS language compatibility test
-- This test verifies basic KS language functionality

-- Add src directory to package path
package.path = package.path .. ';../src/?.lua;../src/?/init.lua'

local luacheck = require('luacheck')

-- Test results
local results = {
    total = 0,
    passed = 0,
    failed = 0
}

-- Simple test function
local function run_test(name, test_func)
    results.total = results.total + 1
    local success, err = pcall(test_func)
    if success then
        results.passed = results.passed + 1
        print("PASS: " .. name)
    else
        results.failed = results.failed + 1
        print("FAIL: " .. name .. " - " .. tostring(err))
    end
end

-- Test basic KS syntax
local function test_basic_ks_syntax()
    local ks_code = [[
#config = {value = 42}
local arr = {1, 2, 3}
local len = getlength(arr)
local first = arr[0]  -- 0-based indexing
]]
    
    local report = luacheck.get_report(ks_code)
    -- Should not have fatal errors
    assert(not report.fatal, "KS code should not have fatal syntax errors")
end

-- Test 0-based indexing
local function test_zero_based_indexing()
    local ks_code = [[
local arr = {10, 20, 30}
local first = arr[0]
local second = arr[1]
local third = arr[2]
]]
    
    local report = luacheck.get_report(ks_code)
    assert(not report.fatal, "0-based indexing should work")
end

-- Test getlength function
local function test_getlength_function()
    local ks_code = [[
local arr = {1, 2, 3, 4, 5}
local len = getlength(arr)
]]
    
    local report = luacheck.get_report(ks_code)
    assert(not report.fatal, "getlength function should be recognized")
end

-- Test global table prefix
local function test_global_table_prefix()
    local ks_code = [[
#settings = {enabled = true}
#database = {host = "localhost", port = 3306}
]]
    
    local report = luacheck.get_report(ks_code)
    assert(not report.fatal, "Global table prefix should work")
end

-- Run all tests
print("Running KS language compatibility tests...")
print()

run_test("Basic KS syntax", test_basic_ks_syntax)
run_test("0-based indexing", test_zero_based_indexing)
run_test("getlength function", test_getlength_function)
run_test("Global table prefix", test_global_table_prefix)

-- Print results
print()
print("Test Results:")
print("Total: " .. results.total)
print("Passed: " .. results.passed)
print("Failed: " .. results.failed)

if results.failed == 0 then
    print("All tests passed!")
    os.exit(0)
else
    print("Some tests failed!")
    os.exit(1)
end