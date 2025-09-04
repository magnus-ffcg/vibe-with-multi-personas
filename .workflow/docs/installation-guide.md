# Installation and Testing Guide

## Prerequisites

- Bash 4.0 or later
- `curl` for downloading files
- `sed` for text processing
- `grep` for pattern matching

## Installation

### Quick Start

```bash
# For Windsurf Cascade
curl -s https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/main/install.sh | bash -s -- \
  https://github.com/magnus-ffcg/vibe-with-multi-personas.git \
  /path/to/your/project \
  "Your Project Name" \
  windsurf

# For Cursor IDE
curl -s https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/main/install.sh | bash -s -- \
  https://github.com/magnus-ffcg/vibe-with-multi-personas.git \
  /path/to/your/project \
  "Your Project Name" \
  cursor
```

### Installation Options

| Parameter | Description | Required | Default |
|-----------|-------------|----------|---------|
| `REPO_URL` | GitHub repository URL | Yes | - |
| `TARGET_DIR` | Target directory for installation | Yes | - |
| `PROJECT_NAME` | Name of your project | No | "My Project" |
| `IDE` | Target IDE (windsurf/cursor) | No | Auto-detected |

## Testing

### Running Tests

```bash
# Run all tests
./tests/test_install.sh

# Run specific test (windsurf or cursor)
./tests/test_install.sh windsurf
./tests/test_install.sh cursor
```

### Test Coverage

The test suite verifies:

1. **Installation**
   - All required files are copied
   - Correct file permissions
   - Proper directory structure

2. **IDE-Specific Files**
   - Only relevant IDE files are installed
   - No cross-contamination between IDEs

3. **Customization**
   - Project name replacement in README
   - Correct IDE configuration

4. **Cleanup**
   - No temporary files left behind
   - No duplicate or unnecessary files

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x install.sh
   chmod +x tests/test_install.sh
   ```

2. **Missing Dependencies**
   ```bash
   # On Ubuntu/Debian
   sudo apt-get install curl sed grep
   
   # On macOS
   brew install bash coreutils
   ```

3. **Test Failures**
   - Check for sufficient disk space
   - Verify internet connection
   - Ensure no conflicting files exist in target directory

## Maintenance

### Adding New Tests

1. Add test cases to `tests/test_install.sh`
2. Follow existing test patterns
3. Include proper cleanup
4. Document test purpose in comments

### Updating the Installer

1. Make changes to `install.sh`
2. Update tests if needed
3. Run all tests
4. Update documentation
