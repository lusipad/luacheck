#!/usr/bin/env lua
-- Release Helper Script
-- This script helps automate the release process

local function read_file(filename)
    local file = io.open(filename, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

local function write_file(filename, content)
    local file = io.open(filename, "w")
    if not file then return false end
    file:write(content)
    file:close()
    return true
end

local function get_current_version()
    local version_file = read_file("src/luacheck/version.lua")
    if not version_file then return nil end
    
    local version = version_file:match('version = "(.-)"')
    return version
end

local function update_version(new_version)
    local version_file = read_file("src/luacheck/version.lua")
    if not version_file then return false end
    
    local new_content = version_file:gsub('version = ".-"', 'version = "' .. new_version .. '"')
    return write_file("src/luacheck/version.lua", new_content)
end

local function update_rockspec_version(new_version)
    local rockspecs = {}
    for file in io.popen('ls *.rockspec 2>/dev/null'):lines() do
        table.insert(rockspecs, file)
    end
    
    for _, rockspec in ipairs(rockspecs) do
        local content = read_file(rockspec)
        if content then
            local new_content = content:gsub('version = ".-"', 'version = "' .. new_version .. '-1"')
            write_file(rockspec, new_content)
            print("Updated " .. rockspec)
        end
    end
end

local function update_changelog(new_version)
    local changelog = read_file("CHANGELOG.md")
    if not changelog then return false end
    
    local date = os.date("%Y-%m-%d")
    local new_entry = string.format([[
## %s - %s

### Added
- 

### Changed
- 

### Fixed
- 

]], new_version, date)
    
    local new_content = new_entry .. changelog
    return write_file("CHANGELOG.md", new_content)
end

local function validate_version(version)
    return version:match("^%d+%.%d+%.%d+$") or version:match("^%d+%.%d+%.%d+-%w+$")
end

local function run_command(cmd)
    local handle = io.popen(cmd .. " 2>&1")
    local output = handle:read("*all")
    local success = handle:close()
    return success, output
end

local function main()
    print("=== Luacheck Release Helper ===")
    print()
    
    -- Get current version
    local current_version = get_current_version()
    if current_version then
        print("Current version: " .. current_version)
    else
        print("Could not determine current version")
        return 1
    end
    
    -- Get new version
    io.write("Enter new version (e.g., 1.2.0 or 1.2.0-beta1): ")
    local new_version = io.read():gsub("^%s*", ""):gsub("%s*$", "")
    
    if not validate_version(new_version) then
        print("Invalid version format. Use format like 1.2.0 or 1.2.0-beta1")
        return 1
    end
    
    print("New version: " .. new_version)
    print()
    
    -- Confirm changes
    print("This script will:")
    print("1. Update version in src/luacheck/version.lua")
    print("2. Update version in rockspec files")
    print("3. Add new entry to CHANGELOG.md")
    print("4. Commit changes")
    print("5. Create git tag")
    print("6. Push to remote (triggers GitHub release)")
    print()
    
    io.write("Continue? (y/N): ")
    local response = io.read():gsub("^%s*", ""):gsub("%s*$", "")
    
    if response ~= "y" and response ~= "Y" then
        print("Cancelled.")
        return 0
    end
    
    -- Update version files
    print("Updating version files...")
    
    if not update_version(new_version) then
        print("Failed to update version.lua")
        return 1
    end
    print("✓ Updated src/luacheck/version.lua")
    
    update_rockspec_version(new_version)
    print("✓ Updated rockspec files")
    
    if not update_changelog(new_version) then
        print("Failed to update CHANGELOG.md")
        return 1
    end
    print("✓ Updated CHANGELOG.md")
    
    print()
    print("Please review the changes and update the CHANGELOG.md with actual changes.")
    print("Press Enter when ready to continue...")
    io.read()
    
    -- Commit changes
    print("Committing changes...")
    local success, output = run_command('git add -A')
    if not success then
        print("Failed to stage changes:", output)
        return 1
    end
    
    success, output = run_command('git commit -m "Release version ' .. new_version .. '"')
    if not success then
        print("Failed to commit changes:", output)
        return 1
    end
    print("✓ Committed changes")
    
    -- Create tag
    print("Creating tag...")
    success, output = run_command('git tag -a v' .. new_version .. ' -m "Release version ' .. new_version .. '"')
    if not success then
        print("Failed to create tag:", output)
        return 1
    end
    print("✓ Created tag v" .. new_version)
    
    -- Push changes
    print("Pushing changes...")
    io.write("Push to remote? (y/N): ")
    response = io.read():gsub("^%s*", ""):gsub("%s*$", "")
    
    if response == "y" or response == "Y" then
        success, output = run_command('git push origin HEAD')
        if not success then
            print("Failed to push changes:", output)
            return 1
        end
        print("✓ Pushed changes")
        
        success, output = run_command('git push origin v' .. new_version)
        if not success then
            print("Failed to push tag:", output)
            return 1
        end
        print("✓ Pushed tag")
        
        print()
        print("🎉 Release process initiated!")
        print("GitHub Actions will now:")
        print("- Build the project")
        print("- Run tests")
        print("- Create release assets")
        print("- Create GitHub release")
        print()
        print("Monitor progress at: https://github.com/" .. os.getenv("GITHUB_REPOSITORY") .. "/actions")
    else
        print("Changes committed locally but not pushed.")
        print("To complete the release:")
        print("  git push origin HEAD")
        print("  git push origin v" .. new_version)
    end
    
    return 0
end

if arg and arg[0] and arg[0]:find("release_helper%.lua$") then
    os.exit(main())
end

return {
    get_current_version = get_current_version,
    update_version = update_version,
    update_rockspec_version = update_rockspec_version,
    update_changelog = update_changelog,
    main = main
}