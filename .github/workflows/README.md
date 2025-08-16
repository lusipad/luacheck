# GitHub Actions Workflows

This repository contains several automated workflows to ensure code quality, test coverage, and smooth release processes.

## Workflows Overview

### 1. Auto Release Workflow (`.github/workflows/auto-release.yml`)

**Triggers:**
- Automatically after successful CI tests on master branch
- Manual dispatch with version type selection

**Purpose:**
- Automatically detects changes since last release
- Bumps version number (patch/minor/major)
- Updates version in code and changelog
- Creates git tags
- Triggers release workflow

**Features:**
- Automatic version increment
- Change detection
- Automated changelog updates
- Git tag creation

**Usage:**
```bash
# Manual trigger with specific version type
gh workflow run auto-release.yml -f release_type=minor -f create_tag=true
```

### 2. Manual Release Workflow (`.github/workflows/manual-release.yml`)

**Triggers:**
- Manual dispatch from GitHub Actions page

**Purpose:**
- Create releases with specific version numbers
- Custom release notes
- Prerelease support
- Immediate release creation

**Features:**
- Exact version specification
- Custom release notes
- Prerelease option
- Direct release creation

### 3. Release Workflow (`.github/workflows/release.yml`)

**Triggers:**
- Push to tags matching `v*` (e.g., `v1.2.0`)
- Manual dispatch

**Purpose:**
- Creates GitHub releases automatically when tags are pushed
- Builds binaries for multiple platforms (Linux, Windows, macOS)
- Tests across multiple Lua versions (5.1, 5.2, 5.3, 5.4)
- Includes ks language support tests
- Creates release assets and uploads them

**Release Assets Generated:**
- `luacheck-{version}-linux-x86_64.tar.gz` - Linux binary
- `luacheck-{version}-windows-x86_64.zip` - Windows binary
- `luacheck-{version}-macos-x86_64.tar.gz` - macOS binary
- `luacheck-{version}-source.tar.gz` - Source code
- `luacheck-{version}-1.rockspec` - Luarocks package

**Usage:**
```bash
# Create a new release
git tag v1.2.0
git push origin v1.2.0
```

### 4. CI Workflow (`.github/workflows/ci.yml`)

**Triggers:**
- Push to `master`, `main`, or `develop` branches
- Pull requests to `master` or `main`

**Purpose:**
- Continuous integration testing
- Multi-platform testing (Linux, Windows, macOS)
- Multi-version testing (Lua 5.1, 5.2, 5.3, 5.4, LuaJIT)
- Code linting and formatting checks
- Security audits
- Documentation validation
- Triggers auto release on successful master branch pushes

**Jobs:**
- `test` - Runs unit tests and ks language tests
- `lint` - Code linting with luacheck
- `format` - Code formatting checks
- `security` - Security vulnerability scanning
- `docs` - Documentation validation
- `trigger-release` - Triggers auto release on success

### 3. Documentation Workflow (`.github/workflows/docs.yml`)

**Triggers:**
- Push to `master` or `main` with documentation changes
- Pull requests with documentation changes

**Purpose:**
- Builds documentation using Sphinx
- Deploys to GitHub Pages
- Validates documentation consistency
- Checks for broken links

**Features:**
- English and Chinese documentation support
- Automatic deployment to GitHub Pages
- Documentation validation

### 4. KS Language Tests (`.github/workflows/ks-tests.yml`)

**Triggers:**
- Push to `master`, `main`, or `develop`
- Pull requests to `master` or `main`
- Daily scheduled runs

**Purpose:**
- Comprehensive testing of ks language support
- Performance benchmarking
- Compatibility testing
- Automated test reporting

**Test Categories:**
- Basic functionality tests
- Comprehensive tests
- Boundary and error handling tests
- Comparison tests (vs standard Lua)
- Performance benchmarks
- Compatibility validation

### 5. Dependencies Workflow (`.github/workflows/dependencies.yml`)

**Triggers:**
- Daily scheduled runs
- Manual dispatch

**Purpose:**
- Checks for outdated dependencies
- Security auditing
- License compliance checking
- Code quality analysis

**Features:**
- LuaRocks dependency checking
- GitHub Actions version checking
- Security vulnerability scanning
- License compliance validation
- Code quality metrics

## Usage Instructions

### Creating a Release

You now have three ways to create releases:

#### Option 1: Automated Release (Recommended)
1. **Make Changes:** Push your changes to the master branch
2. **Wait for CI:** CI tests will run automatically
3. **Auto Release:** If CI passes, auto release will trigger automatically
4. **Monitor:** Watch the auto release workflow progress

#### Option 2: Manual Release with Specific Version
1. **Go to Actions:** Navigate to the Actions tab in GitHub
2. **Select Manual Release:** Choose the "Manual Release" workflow
3. **Run Workflow:** Click "Run workflow" and fill in:
   - **Version:** Exact version number (e.g., 1.0.1)
   - **Release Notes:** Optional custom notes
   - **Prerelease:** Mark as prerelease if needed

#### Option 3: Traditional Tag-based Release
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

### Release Types

The auto release workflow supports three version bump types:
- **patch:** Bug fixes and minor changes (default)
- **minor:** New features and enhancements
- **major:** Breaking changes and major updates

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
   cd test && lua test_ks_comprehensive.lua
   ```

### Manual Workflow Triggers

You can manually trigger workflows from the GitHub Actions page:
1. Go to the Actions tab
2. Select the workflow
3. Click "Run workflow"
4. Choose the branch and click "Run workflow"

## Configuration

### Environment Variables

The following environment variables can be configured in repository secrets:

- `LUAROCKS_API_KEY` - For automatic Luarocks publishing
- `GITHUB_TOKEN` - Default token for GitHub operations

### Customization

To customize the workflows:

1. **Matrix Builds:** Modify the `matrix` sections in workflow files
2. **Dependencies:** Update dependency lists in workflow files
3. **Release Process:** Modify the release workflow for different asset types
4. **Test Coverage:** Add additional test cases to the ks language tests

## Monitoring and Debugging

### Viewing Results

- Check the Actions tab for workflow results
- Individual job logs show detailed output
- Artifacts can be downloaded from completed runs

### Common Issues

1. **Build Failures:**
   - Check dependency versions
   - Verify Lua version compatibility
   - Review error logs in the Actions tab

2. **Test Failures:**
   - Check test output for specific failures
   - Verify ks language implementation
   - Update test expectations if needed

3. **Release Issues:**
   - Verify tag format (must match `v*`)
   - Check release notes generation
   - Ensure proper permissions for releases

## Contributing

When contributing to this repository:

1. All workflows run automatically on pull requests
2. Ensure all tests pass before merging
3. Update documentation as needed
4. Follow the existing code style and patterns

For more information about contributing, see the main [README.md](README.md).