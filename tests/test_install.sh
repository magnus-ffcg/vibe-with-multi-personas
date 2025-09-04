#!/bin/bash

# Simple test script to verify the installation works as expected
# Usage: ./tests/test_install.sh

set -e

# Configuration
TEST_DIR="/tmp/test-windsurf-install"
REPO_URL="https://github.com/magnus-ffcg/vibe-with-multi-personas.git"
PROJECT_NAME="Test Project"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color


# Simple test function to verify installation
run_installation_test() {
    echo -e "${GREEN}Running installation test...${NC}"
    echo "Repository: $REPO_URL"
    echo "Target directory: $TEST_DIR"
    echo "Project name: $PROJECT_NAME"
    
    # Clean up from previous test
    rm -rf "$TEST_DIR"
    
    # Run the installation
    echo -e "\n${GREEN}Step 1: Running installation...${NC}"
    # Run the local install.sh script directly with the windsurf IDE parameter
    ./install.sh "$REPO_URL" "$TEST_DIR" "$PROJECT_NAME" "windsurf"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Installation failed!${NC}"
        return 1
    fi
    
    # Verify the installation
    echo -e "\n${GREEN}Step 2: Verifying installation...${NC}"
    
    # Show directory structure on failure
    show_debug_info() {
        echo -e "\n${YELLOW}Debug information:${NC}"
        echo -e "\n${YELLOW}Directory structure:${NC}"
        find "$TEST_DIR" -type f -o -type d | sort
    }
    
    # Check for required files and directories based on actual installation
    local required_files=(
        "$TEST_DIR/README.md"
        "$TEST_DIR/docs/changelog.md"
        "$TEST_DIR/docs/dependencies.md"
        "$TEST_DIR/.windsurf/rules/hand-offs.md"
        "$TEST_DIR/.windsurf/rules/personas.md"
        "$TEST_DIR/.windsurf/rules/workflow.md"
        "$TEST_DIR/.workflow/docs/backlog.md"
        "$TEST_DIR/.workflow/docs/hand-offs.md"
        "$TEST_DIR/.workflow/docs/personas.md"
        "$TEST_DIR/.workflow/docs/plan.md"
        "$TEST_DIR/.workflow/docs/release-notes.md"
        "$TEST_DIR/.workflow/docs/workflow.md"
    )
    
    # Verify non-hidden directories don't exist
    if [ -d "$TEST_DIR/windsurf" ] || [ -d "$TEST_DIR/cursor" ] || [ -d "$TEST_DIR/workflow" ]; then
        echo -e "${RED}Found non-hidden directories that should be hidden${NC}"
        return 1
    fi
    
    local all_files_exist=true
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Missing file: $file${NC}"
            all_files_exist=false
        fi
    done
    
    if [ "$all_files_exist" = false ]; then
        echo -e "${RED}Some required files are missing!${NC}"
        show_debug_info
        return 1
    fi
    
    # Verify README was customized with project name
    if ! grep -q "$PROJECT_NAME" "$TEST_DIR/README.md"; then
        echo -e "${RED}README.md was not customized with project name${NC}"
        show_debug_info
        return 1
    fi
    
    # Verify .cursor directory doesn't exist for windsurf installation
    if [ -d "$TEST_DIR/.cursor" ]; then
        echo -e "${RED}Found .cursor directory in windsurf installation${NC}"
        show_debug_info
        return 1
    fi
    
    echo -e "\n${GREEN}Installation test completed successfully!${NC}"
    return 0
}

# Function to test Cursor IDE installation
test_cursor_installation() {
    local test_dir="/tmp/test-cursor-install"
    echo -e "\n${GREEN}Testing Cursor IDE installation...${NC}"
    
    # Clean up from previous test
    rm -rf "$test_dir"
    
    # Run the installation with Cursor IDE
    ./install.sh "$REPO_URL" "$test_dir" "$PROJECT_NAME" "cursor"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Cursor installation failed!${NC}"
        return 1
    fi
    
    # Verify the installation
    echo -e "\n${GREEN}Verifying Cursor installation...${NC}"
    
    # Check for required files
    local required_files=(
        "$test_dir/README.md"
        "$test_dir/docs/changelog.md"
        "$test_dir/docs/dependencies.md"
        "$test_dir/.cursor/rules/hand-offs.md"
        "$test_dir/.cursor/rules/personas.md"
        "$test_dir/.cursor/rules/workflow.md"
        "$test_dir/.workflow/docs/backlog.md"
        "$test_dir/.workflow/docs/hand-offs.md"
        "$test_dir/.workflow/docs/personas.md"
        "$test_dir/.workflow/docs/plan.md"
        "$test_dir/.workflow/docs/release-notes.md"
        "$test_dir/.workflow/docs/workflow.md"
    )
    
    # Verify non-hidden directories don't exist
    if [ -d "$test_dir/windsurf" ] || [ -d "$test_dir/cursor" ] || [ -d "$test_dir/workflow" ]; then
        echo -e "${RED}Found non-hidden directories that should be hidden in Cursor installation${NC}"
        show_debug_info
        return 1
    fi
    
    local all_files_exist=true
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Missing file in Cursor installation: $file${NC}"
            all_files_exist=false
        fi
    done
    
    if [ "$all_files_exist" = false ]; then
        echo -e "${RED}Some required files are missing in Cursor installation!${NC}"
        show_debug_info
        return 1
    fi
    
    # Verify .windsurf directory doesn't exist for cursor installation
    if [ -d "$test_dir/.windsurf" ]; then
        echo -e "${RED}Found .windsurf directory in Cursor installation${NC}"
        show_debug_info
        return 1
    fi
    
    echo -e "\n${GREEN}Cursor installation test completed successfully!${NC}
"
    rm -rf "$test_dir"
    return 0
}

# Run the tests
echo -e "${GREEN}Running installation tests...${NC}"

# Test windsurf installation
run_installation_test

# Test cursor installation
test_cursor_installation

# Print summary
echo
echo -e "${GREEN}Test Summary:${NC}"
echo -e "${GREEN}Installation test completed!${NC}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! GitHub installation script is working correctly.${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please check the output above for details.${NC}"
    exit 1
fi


Run tests with: \`./tests/test_install.sh\`

Last validated: $timestamp
EOF
}

# Main test execution
main() {
    log_info "GitHub Installation Script Test Suite"
    log_info "===================================="
    
    setup_test_env
    
    # Run all tests
    run_test "URL Validation - Valid URLs" test_url_validation_valid
    run_test "URL Validation - Invalid URLs" test_url_validation_invalid
    run_test "Missing Arguments Handling" test_missing_arguments
    run_test "Usage Information Display" test_usage_display
    run_test "Dependency Checking" test_dependency_checking
    run_test "Script Structure Validation" test_script_structure
    run_test "Template Installation" test_template_installation
    run_test "IDE Directory Handling" test_ide_directory_handling
    run_test "Error Message Quality" test_error_messages
    
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
        log_success "All tests passed! GitHub installation script is working correctly."
        echo
        log_info "Test report generated: tests/test_install_report.md"
        return 0
    else
        log_failure "Some tests failed. Please review the installation script."
        return 1
    fi
}

# Run main function
main "$@"
