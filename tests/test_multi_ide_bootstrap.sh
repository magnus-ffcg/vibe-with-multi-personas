#!/bin/bash

# Test Suite for Multi-IDE Bootstrap Functionality
# Tests IDE detection, parameter handling, and template copying for both Windsurf and Cursor

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_test_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}[PASS]${NC} $test_name: $message"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}[FAIL]${NC} $test_name: $message"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# Function to cleanup test directories
cleanup_test_dirs() {
    local dirs=("$@")
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            rm -rf "$dir"
        fi
    done
}

# Test 1: Bootstrap script with Windsurf IDE parameter
test_windsurf_bootstrap() {
    local test_dir="/tmp/test_windsurf_project"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing Windsurf IDE bootstrap..."
    
    # Run bootstrap with windsurf parameter
    if ./bootstrap.sh "$test_dir" "Test Windsurf Project" windsurf >/dev/null 2>&1; then
        # Check if .windsurf directory exists
        if [ -d "$test_dir/.windsurf" ]; then
            # Check if Windsurf-specific files exist
            if [ -f "$test_dir/.windsurf/rules/personas.md" ] && [ -f "$test_dir/.windsurf/rules/workflow.md" ]; then
                # Check that .cursor directory does NOT exist
                if [ ! -d "$test_dir/.cursor" ]; then
                    print_test_result "test_windsurf_bootstrap" "PASS" "Windsurf configuration created correctly"
                else
                    print_test_result "test_windsurf_bootstrap" "FAIL" "Cursor directory incorrectly created for Windsurf project"
                fi
            else
                print_test_result "test_windsurf_bootstrap" "FAIL" "Windsurf configuration files missing"
            fi
        else
            print_test_result "test_windsurf_bootstrap" "FAIL" ".windsurf directory not created"
        fi
    else
        print_test_result "test_windsurf_bootstrap" "FAIL" "Bootstrap script failed to run"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Test 2: Bootstrap script with Cursor IDE parameter
test_cursor_bootstrap() {
    local test_dir="/tmp/test_cursor_project"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing Cursor IDE bootstrap..."
    
    # Run bootstrap with cursor parameter
    if ./bootstrap.sh "$test_dir" "Test Cursor Project" cursor >/dev/null 2>&1; then
        # Check if .cursor directory exists
        if [ -d "$test_dir/.cursor" ]; then
            # Check if Cursor-specific files exist
            if [ -f "$test_dir/.cursor/rules/personas.md" ] && [ -f "$test_dir/.cursor/rules/workflow.md" ]; then
                # Check that .windsurf directory does NOT exist
                if [ ! -d "$test_dir/.windsurf" ]; then
                    print_test_result "test_cursor_bootstrap" "PASS" "Cursor configuration created correctly"
                else
                    print_test_result "test_cursor_bootstrap" "FAIL" "Windsurf directory incorrectly created for Cursor project"
                fi
            else
                print_test_result "test_cursor_bootstrap" "FAIL" "Cursor configuration files missing"
            fi
        else
            print_test_result "test_cursor_bootstrap" "FAIL" ".cursor directory not created"
        fi
    else
        print_test_result "test_cursor_bootstrap" "FAIL" "Bootstrap script failed to run"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Test 3: IDE detection function with invalid parameter
test_invalid_ide_parameter() {
    local test_dir="/tmp/test_invalid_ide"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing invalid IDE parameter handling..."
    
    # Run bootstrap with invalid IDE parameter
    if ! ./bootstrap.sh "$test_dir" "Test Invalid Project" invalid_ide >/dev/null 2>&1; then
        print_test_result "test_invalid_ide_parameter" "PASS" "Invalid IDE parameter correctly rejected"
    else
        print_test_result "test_invalid_ide_parameter" "FAIL" "Invalid IDE parameter should have been rejected"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Test 4: Common files exist in both IDE configurations
test_common_files_exist() {
    local windsurf_dir="/tmp/test_windsurf_common"
    local cursor_dir="/tmp/test_cursor_common"
    cleanup_test_dirs "$windsurf_dir" "$cursor_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing common files exist in both configurations..."
    
    # Create both projects
    ./bootstrap.sh "$windsurf_dir" "Test Windsurf" windsurf >/dev/null 2>&1
    ./bootstrap.sh "$cursor_dir" "Test Cursor" cursor >/dev/null 2>&1
    
    # Check common files exist in both
    local common_files=(
        ".workflow/docs/personas.md"
        ".workflow/docs/workflow.md"
        ".workflow/docs/plan.md"
        ".workflow/docs/backlog.md"
        ".workflow/docs/hand-offs.md"
        "docs/changelog.md"
        "docs/dependencies.md"
        "README.md"
    )
    
    local all_exist=true
    for file in "${common_files[@]}"; do
        if [ ! -f "$windsurf_dir/$file" ] || [ ! -f "$cursor_dir/$file" ]; then
            all_exist=false
            break
        fi
    done
    
    if [ "$all_exist" = true ]; then
        print_test_result "test_common_files_exist" "PASS" "All common files exist in both IDE configurations"
    else
        print_test_result "test_common_files_exist" "FAIL" "Some common files missing from IDE configurations"
    fi
    
    cleanup_test_dirs "$windsurf_dir" "$cursor_dir"
}

# Test 5: Cursor-specific content validation
test_cursor_specific_content() {
    local test_dir="/tmp/test_cursor_content"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing Cursor-specific content..."
    
    ./bootstrap.sh "$test_dir" "Test Cursor Content" cursor >/dev/null 2>&1
    
    # Check for Cursor-specific content in personas.md
    if grep -q "Apply feature" "$test_dir/.cursor/rules/personas.md" && \
       grep -q "Cursor IDE" "$test_dir/.cursor/rules/personas.md"; then
        print_test_result "test_cursor_specific_content" "PASS" "Cursor-specific content found in configuration"
    else
        print_test_result "test_cursor_specific_content" "FAIL" "Cursor-specific content missing from configuration"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Test 6: Windsurf-specific content validation
test_windsurf_specific_content() {
    local test_dir="/tmp/test_windsurf_content"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing Windsurf-specific content..."
    
    ./bootstrap.sh "$test_dir" "Test Windsurf Content" windsurf >/dev/null 2>&1
    
    # Check for updated terminology (should be Multi-Persona Development, not Mob Programming)
    if grep -q "Multi-Persona Development" "$test_dir/.windsurf/rules/personas.md" && \
       ! grep -q "Mob Programming" "$test_dir/.windsurf/rules/personas.md"; then
        print_test_result "test_windsurf_specific_content" "PASS" "Windsurf template has updated terminology"
    else
        print_test_result "test_windsurf_specific_content" "FAIL" "Windsurf template still contains old 'Mob Programming' terminology"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Test 7: Project name customization
test_project_name_customization() {
    local test_dir="/tmp/test_project_name"
    local project_name="My Custom Project Name"
    cleanup_test_dirs "$test_dir"
    
    echo -e "${BLUE}[TEST]${NC} Testing project name customization..."
    
    ./bootstrap.sh "$test_dir" "$project_name" windsurf >/dev/null 2>&1
    
    # Check if project name appears in README
    if grep -q "$project_name" "$test_dir/README.md"; then
        print_test_result "test_project_name_customization" "PASS" "Project name correctly customized in README"
    else
        print_test_result "test_project_name_customization" "FAIL" "Project name not found in README"
    fi
    
    cleanup_test_dirs "$test_dir"
}

# Main test execution
main() {
    echo -e "${BLUE}Multi-IDE Bootstrap Test Suite${NC}"
    echo -e "${BLUE}==============================${NC}"
    echo ""
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$SCRIPT_DIR/.."
    
    # Check if bootstrap script exists
    if [ ! -f "./bootstrap.sh" ]; then
        echo -e "${RED}[ERROR]${NC} Bootstrap script not found"
        exit 1
    fi
    
    # Run tests
    test_windsurf_bootstrap
    test_cursor_bootstrap
    test_invalid_ide_parameter
    test_common_files_exist
    test_cursor_specific_content
    test_windsurf_specific_content
    test_project_name_customization
    
    # Print summary
    echo ""
    echo -e "${BLUE}Test Summary${NC}"
    echo -e "${BLUE}============${NC}"
    echo "Tests Run: $TESTS_RUN"
    echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

# Run main function
main "$@"
