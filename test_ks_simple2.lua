#!/usr/bin/env lua

-- Simple test for ks language support
package.path = './src/?.lua;./src/?/init.lua;' .. package.path

local decoder = require "luacheck.decoder"
local lexer = require "luacheck.lexer"

-- Test normal mode
print("=== Testing normal mode ===")
local source_normal = "#arr"

local decoded_normal = decoder.decode(source_normal)
local lexer_state_normal = lexer.new_state(decoded_normal)
local token, token_value = lexer.next_token(lexer_state_normal)
print("First token:", token, token_value or "")

-- Test normal identifier
print("\n=== Testing normal identifier ===")
local source_ident = "testvar"

local decoded_ident = decoder.decode(source_ident)
local lexer_state_ident = lexer.new_state(decoded_ident)
local token, token_value = lexer.next_token(lexer_state_ident)
print("First token:", token, token_value or "")

-- Test ks mode
print("\n=== Testing ks mode ===")
local source_ks = "#test"

local decoded_ks = decoder.decode(source_ks)
local lexer_state_ks = lexer.new_state(decoded_ks, nil, nil, {ks = true})
local token, token_value = lexer.next_token(lexer_state_ks)
print("First token:", token, token_value or "")
print("Lexer state offset:", lexer_state_ks.offset)