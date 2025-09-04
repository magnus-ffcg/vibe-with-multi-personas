# Release Checklist

## Pre-Release Testing
- [ ] Run all test suites: `./tests/test_install.sh`
- [ ] Verify installation on both macOS and Linux
- [ ] Test with both Windsurf and Cursor IDEs
- [ ] Verify README customization works with special characters in project names
- [ ] Test installation with different paths (spaces, special characters)

## Documentation
- [ ] Update version number in all relevant files
- [ ] Ensure all new features are documented
- [ ] Update installation instructions if needed
- [ ] Verify all links in documentation are working

## Code Quality
- [ ] Run shellcheck on all bash scripts
- [ ] Ensure consistent code formatting
- [ ] Verify error handling and edge cases

## Release Process
- [ ] Create a new git tag with version number (vX.Y.Z)
- [ ] Push the tag to trigger CI/CD pipeline
- [ ] Verify the release on GitHub
- [ ] Update the changelog with release date
- [ ] Create release notes on GitHub

## Post-Release
- [ ] Test the installation from the released version
- [ ] Verify all links in the release notes
- [ ] Announce the release to relevant channels
- [ ] Update any dependent projects if needed
