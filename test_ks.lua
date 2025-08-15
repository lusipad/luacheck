-- Test for ks language support
-- This should work with --ks flag: # treated as global table, not operator

local # = {key = "value"}
print(#.key)

-- Array access (0-based in ks)
local arr = {"first", "second", "third"}
print(arr[0])  -- Should be "first" in ks
print(arr[1])  -- Should be "second" in ks

-- getlength function instead of #
local len = getlength(arr)
print(len)  -- Should be 3