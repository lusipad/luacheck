#!/usr/bin/env lua

-- Simple test for ks language support
package.path = './src/?.lua;./src/?/init.lua;' .. package.path

local decoder = require "luacheck.decoder"
local lexer = require "luacheck.lexer"

-- Test normal mode
print("=== Testing normal mode ===")
local source_normal = [[
local arr = {"first", "second", "third"}
print(#arr)  -- Should be length operator
]]

local decoded_normal = decoder.decode(source_normal)
local lexer_state_normal = lexer.new_state(decoded_normal)
local token = lexer.next_token(lexer_state_normal)
while token and token ~= "eof" do
    print(token, lexer_state_normal.token_value or "")
    token = lexer.next_token(lexer_state_normal)
end

-- Test ks mode
print("\n=== Testing ks mode ===")
local source_ks = [[
local # = {key = "value"}
print(#.key)
]]

local decoded_ks = decoder.decode(source_ks)
local lexer_state_ks = lexer.new_state(decoded_ks, nil, nil, {ks = true})
local token = lexer.next_token(lexer_state_ks)
while token and token ~= "eof" do
    print(token, lexer_state_ks.token_value or "")
    token = lexer.next_token(lexer_state_ks)
end