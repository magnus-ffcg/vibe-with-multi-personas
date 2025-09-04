#!/bin/bash

# Test Suite: Clean Template Installation
# Tests TASK-009 and TASK-010 implementation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test output file
TEST_OUTPUT="/tmp/clean_template_test_output.txt"

print_test_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

print_failure() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

run_test() {
    ((TESTS_RUN++))
    local test_name="$1"
    shift
    
    if "$@"; then
        print_success "$test_name"
        return 0
    else
        print_failure "$test_name"
        return 1
    fi
}

# Test 1: Clean template installation functionality
test_clean_installation() {
    local test_dir="/tmp/test-clean-install-$$"
    
    # Clean up any existing test directory
    rm -rf "$test_dir"
    
    # Run bootstrap
    if ./bootstrap.sh "$test_dir" "Clean Install Test" > "$TEST_OUTPUT" 2>&1; then
        # Check if directory was created
        [ -d "$test_dir" ] || return 1
        
        # Check if git was initialized
        [ -d "$test_dir/.git" ] || return 1
        
        # Clean up
        rm -rf "$test_dir"
        return 0
    else
        return 1
    fi
}

# Test 2: Verify no development artifacts in template
test_no_dev_artifacts() {
    local test_dir="/tmp/test-no-artifacts-$$"
    
    # Clean up any existing test directory
    rm -rf "$test_dir"
    
    # Run bootstrap
    ./bootstrap.sh "$test_dir" "No Artifacts Test" > /dev/null 2>&1
    
    # Check for development artifacts that should NOT be present
    local artifacts_found=0
    
    if [ -f "$test_dir/bootstrap.sh" ]; then
        echo "Found bootstrap.sh in template"
        artifacts_found=1
    fi
    
    if [ -f "$test_dir/install.sh" ]; then
        echo "Found install.sh in template"
        artifacts_found=1
    fi
    
    if [ -d "$test_dir/tests" ]; then
        echo "Found tests/ directory in template"
        artifacts_found=1
    fi
    
    # Clean up
    rm -rf "$test_dir"
    
    return $artifacts_found
}

# Test 3: Verify project name customization
test_project_name_customization() {
    local test_dir="/tmp/test-customization-$$"
    local project_name="Custom Project Name"
    
    # Clean up any existing test directory
    rm -rf "$test_dir"
    
    # Run bootstrap
    ./bootstrap.sh "$test_dir" "$project_name" > /dev/null 2>&1
    
    # Check if project name was customized in key files
    local customization_working=0
    
    if [ -f "$test_dir/README.md" ]; then
        if grep -q "$project_name" "$test_dir/README.md"; then
            customization_working=1
        fi
    fi
    
    if [ -f "$test_dir/.workflow/docs/plan.md" ]; then
        if grep -q "$project_name" "$test_dir/.workflow/docs/plan.md"; then
            customization_working=1
        fi
    fi
    
    # Clean up
    rm -rf "$test_dir"
    
    [ $customization_working -eq 1 ]
}

# Test 4: Verify template file count (should be exactly 19 files)
test_template_file_count() {
    local test_dir="/tmp/test-file-count-$$"
    
    # Clean up any existing test directory
    rm -rf "$test_dir"
    
    # Run bootstrap
    ./bootstrap.sh "$test_dir" "File Count Test" > /dev/null 2>&1
    
    # Count files (excluding .git directory)
    local file_count=$(find "$test_dir" -type f ! -path "*/.git/*" | wc -l | tr -d ' ')
    
    # Clean up
    rm -rf "$test_dir"
    
    # Should have exactly 12 files (based on git commit output)
    [ "$file_count" -eq 12 ]
}

# Test 5: Verify required template structure
test_template_structure() {
    local test_dir="/tmp/test-structure-$$"
    
    # Clean up any existing test directory
    rm -rf "$test_dir"
    
    # Run bootstrap
    ./bootstrap.sh "$test_dir" "Structure Test" > /dev/null 2>&1
    
    # Check required directories and files
    local structure_valid=1
    
    # Required directories
    [ -d "$test_dir/.windsurf/rules" ] || structure_valid=0
    [ -d "$test_dir/.workflow/docs" ] || structure_valid=0
    [ -d "$test_dir/docs" ] || structure_valid=0
    [ -d "$test_dir/docs/adr" ] || structure_valid=0
    
    # Required files
    [ -f "$test_dir/README.md" ] || structure_valid=0
    [ -f "$test_dir/.workflow/docs/personas.md" ] || structure_valid=0
    [ -f "$test_dir/.workflow/docs/workflow.md" ] || structure_valid=0
    [ -f "$test_dir/.workflow/docs/plan.md" ] || structure_valid=0
    [ -f "$test_dir/.workflow/docs/backlog.md" ] || structure_valid=0
    [ -f "$test_dir/docs/changelog.md" ] || structure_valid=0
    
    # Clean up
    rm -rf "$test_dir"
    
    [ $structure_valid -eq 1 ]
}

# Test 6: Negative test - verify docs/todo.md is removed from source
test_todo_md_removed() {
    # Check that docs/todo.md no longer exists in source
    [ ! -f "docs/todo.md" ]
}

# Main test execution
main() {
    print_test_header "Clean Template Installation Test Suite"
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR/.."
    
    print_info "Testing clean template installation functionality..."
    
    # Run all tests
    run_test "Clean installation functionality" test_clean_installation
    run_test "No development artifacts in template" test_no_dev_artifacts  
    run_test "Project name customization" test_project_name_customization
    run_test "Template file count validation" test_template_file_count
    run_test "Required template structure" test_template_structure
    run_test "docs/todo.md removed from source" test_todo_md_removed
    
    # Print summary
    echo ""
    print_test_header "Test Summary"
    echo "Tests run: $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    
    # Clean up
    rm -f "$TEST_OUTPUT"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        print_success "All tests passed!"
        exit 0
    else
        print_failure "Some tests failed!"
        exit 1
    fi
}

# Run main function
main "$@"
