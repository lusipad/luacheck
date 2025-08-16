# GitHub Actions Workflows

This repository contains essential automated workflows for testing and releases.

## Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**
- Push to `master`, `main`, or `develop` branches
- Pull requests to `master` or `main`

**Purpose:**
- Continuous integration testing
- Multi-platform testing (Linux, Windows, macOS)
- Multi-version testing (Lua 5.1, 5.2, 5.3, 5.4, LuaJIT)
- KS language support testing

### 2. Release Workflow (`.github/workflows/release.yml`)

**Triggers:**
- Push to tags matching `v*` (e.g., `v1.2.0`)
- Manual dispatch

**Purpose:**
- Creates GitHub releases when tags are pushed
- Builds binaries for multiple platforms
- Tests across multiple Lua versions
- Creates release assets and uploads them

**Release Assets Generated:**
- `luacheck-{version}-linux-x86_64.tar.gz` - Linux binary
- `luacheck-{version}-windows-x86_64.zip` - Windows binary
- `luacheck-{version}-macos-x86_64.tar.gz` - macOS binary
- `luacheck-{version}-source.tar.gz` - Source code
- `luacheck-{version}-1.rockspec` - Luarocks package

## Usage

### Creating a Release

1. **Update Version:**
   ```bash
   # Update version in src/luacheck/init.lua
   # Update CHANGELOG.md
   ```

2. **Tag the Release:**
   ```bash
   git tag v1.2.0
   git push origin v1.2.0
   ```

3. **Monitor Progress:**
   - Check the Actions tab for release workflow status
   - Release will be automatically created with all assets

### Running Tests Locally

1. **Install Dependencies:**
   ```bash
   luarocks install luafilesystem
   luarocks install argparse
   ```

2. **Build Luacheck:**
   ```bash
   make
   ```

3. **Run Tests:**
   ```bash
   make test
   cd test && lua test_ks_simple.lua
   ```

## Configuration

### Environment Variables

- `LUAROCKS_API_KEY` - For automatic Luarocks publishing (optional)
- `GITHUB_TOKEN` - Default token for GitHub operations

## Troubleshooting

### Common Issues

1. **Build Failures:**
   - Check dependency versions
   - Verify Lua version compatibility
   - Review error logs in the Actions tab

2. **Test Failures:**
   - Check test output for specific failures
   - Verify KS language implementation
   - Update test expectations if needed

3. **Release Issues:**
   - Verify tag format (must match `v*`)
   - Check release notes generation
   - Ensure proper permissions for releases