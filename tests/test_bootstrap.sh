#!/bin/bash

# Bootstrap Script Test Suite
# Provides continuous validation of bootstrap.sh functionality
# Usage: ./tests/test_bootstrap.sh

set -e

# Test configuration
TEST_DIR="/tmp/bootstrap-test-suite"
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/bootstrap.sh"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test result tracking
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_info() {
    echo -e "${BLUE}[TEST-INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[TEST-PASS]${NC} $1"
    ((TESTS_PASSED++))
}

log_failure() {
    echo -e "${RED}[TEST-FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

log_warning() {
    echo -e "${YELLOW}[TEST-WARN]${NC} $1"
}

# Test execution wrapper
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    log_info "Running: $test_name"
    ((TESTS_RUN++))
    
    if $test_function; then
        log_success "$test_name"
        return 0
    else
        log_failure "$test_name"
        return 1
    fi
}

# Setup test environment
setup_test_env() {
    log_info "Setting up test environment..."
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"
    
    if [ ! -f "$SCRIPT_PATH" ]; then
        log_failure "Bootstrap script not found at: $SCRIPT_PATH"
        exit 1
    fi
    
    if [ ! -x "$SCRIPT_PATH" ]; then
        log_failure "Bootstrap script is not executable: $SCRIPT_PATH"
        exit 1
    fi
}

# Cleanup test environment
cleanup_test_env() {
    log_info "Cleaning up test environment..."
    rm -rf "$TEST_DIR"
}

# Test 1: Basic functionality - successful bootstrap
test_basic_bootstrap() {
    local project_path="$TEST_DIR/basic-test"
    
    # Run bootstrap script
    if ! "$SCRIPT_PATH" "$project_path" "Basic Test Project" >/dev/null 2>&1; then
        return 1
    fi
    
    # Verify project structure
    [ -d "$project_path" ] || return 1
    [ -f "$project_path/README.md" ] || return 1
    [ -d "$project_path/docs" ] || return 1
    [ -d "$project_path/.windsurf" ] || return 1
    [ -d "$project_path/.git" ] || return 1
    
    # Verify file count (should be 22 files excluding .git - includes test file)
    local file_count=$(find "$project_path" -type f ! -path "*/.git/*" | wc -l | tr -d ' ')
    [ "$file_count" -eq 22 ] || return 1
    
    # Verify customization
    grep -q "Basic Test Project" "$project_path/README.md" || return 1
    grep -q "Basic Test Project" "$project_path/docs/plan.md" || return 1
    
    return 0
}

# Test 2: Error handling - missing arguments
test_missing_arguments() {
    # Should fail with exit code 1
    if "$SCRIPT_PATH" >/dev/null 2>&1; then
        return 1
    fi
    
    return 0
}

# Test 3: Project customization validation
test_project_customization() {
    local project_path="$TEST_DIR/custom-test"
    local project_name="Custom Project Name"
    
    # Run bootstrap script
    "$SCRIPT_PATH" "$project_path" "$project_name" >/dev/null 2>&1 || return 1
    
    # Check if project customization worked
    if ! grep -q "$project_name" "$project_path/.workflow/docs/plan.md" 2>/dev/null; then
        echo "❌ Project plan not customized with project name"
        return 1
    fi
    
    if ! grep -q "$project_name" "$project_path/.workflow/docs/backlog.md" 2>/dev/null; then
        echo "❌ Project backlog not customized with project name"
        return 1
    fi
    
    # Verify README customization
    grep -q "# $project_name" "$project_path/README.md" || return 1
    
    # Verify plan.md customization
    grep -q "Project Plan: $project_name" "$project_path/.workflow/docs/plan.md" || return 1
    
    # Verify backlog.md customization
    grep -q "Project Backlog: $project_name" "$project_path/.workflow/docs/backlog.md" || return 1
    
    return 0
}

# Test 4: Git initialization
test_git_initialization() {
    local project_path="$TEST_DIR/git-test"
    
    # Run bootstrap script
    "$SCRIPT_PATH" "$project_path" "Git Test Project" >/dev/null 2>&1 || return 1
    
    # Verify git repository
    [ -d "$project_path/.git" ] || return 1
    
    # Verify initial commit exists
    (cd "$project_path" && git log --oneline | grep -q "init: bootstrap project") || return 1
    
    # Verify all files are committed
    local uncommitted=$(cd "$project_path" && git status --porcelain | wc -l)
    [ "$uncommitted" -eq 0 ] || return 1
    
    return 0
}

# Test 5: File exclusions
test_file_exclusions() {
    local project_path="$TEST_DIR/exclusion-test"
    
    # Run bootstrap script
    "$SCRIPT_PATH" "$project_path" "Exclusion Test" >/dev/null 2>&1 || return 1
    
    # Verify excluded files are not copied
    [ ! -f "$project_path/bootstrap.sh" ] || return 1
    
    return 0
}

# Test 6: Template completeness
test_template_completeness() {
    local project_path="$TEST_DIR/completeness-test"
    
    # Run bootstrap script
    "$SCRIPT_PATH" "$project_path" "Completeness Test" >/dev/null 2>&1 || return 1
    
    # Verify essential files exist
    local essential_files=(
        "README.md"
        "docs/personas.md"
        "docs/workflow.md"
        "docs/backlog.md"
        "docs/plan.md"
        "docs/hand-offs.md"
        "docs/glossary.md"
        "docs/adr/README.md"
        ".windsurf/rules/personas.md"
        ".windsurf/rules/workflow.md"
        ".windsurf/rules/hand-offs.md"
    )
    
    local workflow_files=(
        ".workflow/docs/personas.md"
        ".workflow/docs/workflow.md"
        ".workflow/docs/backlog.md"
        ".workflow/docs/hand-offs.md"
        ".workflow/docs/release-notes.md"
    )
    
    for file in "${essential_files[@]}"; do
        [ -f "$project_path/$file" ] || return 1
    done
    
    for file in "${workflow_files[@]}"; do
        [ -f "$project_path/$file" ] || return 1
    done
    
    return 0
}


# Generate test report
generate_test_report() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > "$TEMPLATE_DIR/tests/test_report.md" << EOF
# Bootstrap Script Test Report

**Generated**: $timestamp
**Script**: bootstrap.sh
**Test Suite**: test_bootstrap.sh

## Test Results Summary

- **Tests Run**: $TESTS_RUN
- **Tests Passed**: $TESTS_PASSED
- **Tests Failed**: $TESTS_FAILED
- **Success Rate**: $(( TESTS_PASSED * 100 / TESTS_RUN ))%

## Test Status

$([ $TESTS_FAILED -eq 0 ] && echo "✅ **ALL TESTS PASSED**" || echo "❌ **SOME TESTS FAILED**")

## Test Coverage

1. ✅ Basic Bootstrap Functionality
2. ✅ Error Handling - Missing Arguments
3. ✅ Project Customization
4. ✅ Git Repository Initialization
5. ✅ File Exclusion Rules
6. ✅ Template Completeness

## Validation Proof

This test suite provides continuous validation that:
- Bootstrap script creates complete project structure (22 files)
- Git initialization works with proper initial commit
- Project customization replaces template placeholders
- Error handling prevents invalid operations
- File exclusions work correctly
- All essential template files are copied

## Usage

Run tests with: \`./tests/test_bootstrap.sh\`

Last validated: $timestamp
EOF
}

# Main test execution
main() {
    log_info "Bootstrap Script Test Suite"
    log_info "=========================="
    
    setup_test_env
    
    # Run all tests
    run_test "Basic Bootstrap Functionality" test_basic_bootstrap
    run_test "Missing Arguments Error Handling" test_missing_arguments
    run_test "Project Customization" test_project_customization
    run_test "Git Repository Initialization" test_git_initialization
    run_test "File Exclusion Rules" test_file_exclusions
    run_test "Template Completeness" test_template_completeness
    
    cleanup_test_env
    generate_test_report
    
    # Print summary
    echo
    log_info "Test Summary:"
    log_info "Tests Run: $TESTS_RUN"
    log_success "Tests Passed: $TESTS_PASSED"
    if [ $TESTS_FAILED -gt 0 ]; then
        log_failure "Tests Failed: $TESTS_FAILED"
    fi
    
    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "All tests passed! Bootstrap script is working correctly."
        echo
        log_info "Test report generated: tests/test_report.md"
        return 0
    else
        log_failure "Some tests failed. Please review the bootstrap script."
        return 1
    fi
}

# Run main function
main "$@"
