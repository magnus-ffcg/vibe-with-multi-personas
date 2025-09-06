#!/bin/bash

# Multi-Persona Development Bootstrap Template - Installer
# Downloads template files directly from GitHub without requiring git
# Usage: ./install.sh <github-repo-url> <target-directory> [project-name] [ide] [workflow]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Template file manifest - files for team-development workflow (backward compatibility)
TEAM_DEVELOPMENT_FILES=(
    "template/README.md"
    "template/bootstrap/team-development/cursor/rules/hand-offs.mdc"
    "template/bootstrap/team-development/cursor/rules/personas.mdc"
    "template/bootstrap/team-development/cursor/rules/workflow.mdc"
    "template/bootstrap/team-development/docs/changelog.md"
    "template/bootstrap/team-development/docs/dependencies.md"
    "template/bootstrap/team-development/windsurf/rules/hand-offs.md"
    "template/bootstrap/team-development/windsurf/rules/personas.md"
    "template/bootstrap/team-development/windsurf/rules/workflow.md"
    "template/bootstrap/team-development/workflow/docs/backlog.md"
    "template/bootstrap/team-development/workflow/docs/hand-offs.md"
    "template/bootstrap/team-development/workflow/docs/personas.md"
    "template/bootstrap/team-development/workflow/docs/plan.md"
    "template/bootstrap/team-development/workflow/docs/release-notes.md"
    "template/bootstrap/team-development/workflow/docs/workflow.md"
)

# Template file manifest - files for strict-tdd workflow
STRICT_TDD_FILES=(
    "template/README.md"
    "template/bootstrap/strict-tdd/cursor/rules/hand-offs.mdc"
    "template/bootstrap/strict-tdd/cursor/rules/personas.mdc"
    "template/bootstrap/strict-tdd/cursor/rules/workflow.mdc"
    "template/bootstrap/strict-tdd/docs/changelog.md"
    "template/bootstrap/strict-tdd/docs/dependencies.md"
    "template/bootstrap/strict-tdd/windsurf/rules/hand-offs.md"
    "template/bootstrap/strict-tdd/windsurf/rules/personas.md"
    "template/bootstrap/strict-tdd/windsurf/rules/workflow.md"
    "template/bootstrap/strict-tdd/workflow/docs/changelog.md"
    "template/bootstrap/strict-tdd/workflow/docs/hand-offs.md"
    "template/bootstrap/strict-tdd/workflow/docs/personas.md"
    "template/bootstrap/strict-tdd/workflow/docs/test-plan.md"
    "template/bootstrap/strict-tdd/workflow/docs/workflow.md"
)

# Template file manifest - files for team-development-mcp workflow
TEAM_DEVELOPMENT_MCP_FILES=(
    "template/README.md"
    "template/bootstrap/team-development-mcp/README.md"
    "template/bootstrap/team-development-mcp/docs/changelog.md"
    "template/bootstrap/team-development-mcp/docs/dependencies.md"
    "template/bootstrap/team-development-mcp/windsurf/mcp_servers.json"
    "template/bootstrap/team-development-mcp/windsurf/rules/hand-offs.md"
    "template/bootstrap/team-development-mcp/windsurf/rules/personas.md"
    "template/bootstrap/team-development-mcp/windsurf/rules/workflow.md"
    "template/bootstrap/team-development-mcp/workflow/docs/backlog.md"
    "template/bootstrap/team-development-mcp/workflow/docs/hand-offs.md"
    "template/bootstrap/team-development-mcp/workflow/docs/personas.md"
    "template/bootstrap/team-development-mcp/workflow/docs/plan.md"
    "template/bootstrap/team-development-mcp/workflow/docs/release-notes.md"
    "template/bootstrap/team-development-mcp/workflow/docs/workflow.md"
    "mcp-coordinator/README.md"
    "mcp-coordinator/package.json"
    "mcp-coordinator/tsconfig.json"
    "mcp-coordinator/src/index.ts"
    "mcp-coordinator/src/storage.ts"
    "mcp-coordinator/src/types.ts"
)

# Function to download a single file
download_file() {
    local repo_url="https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/refs/heads/main"
    local file_path="$1"
    local target_dir="$2"
    
    # Remove 'template/' prefix from file path fogr the URL
    local relative_path="${file_path}"
    local raw_url="${repo_url}/${relative_path}"
    local target_file="$target_dir/$file_path"
    local target_file_dir=$(dirname "$target_file")
    
    # Create target directory
    mkdir -p "$target_file_dir"
    
    # Download file
    if ! curl -fsSL -o "$target_file" "$raw_url"; then
        print_warning "Failed to download: $file_path"
        return 1
    fi
    
    return 0
}

# Function to get template files based on workflow
get_template_files() {
    local workflow="$1"
    
    case "$workflow" in
        "team-development")
            echo "${TEAM_DEVELOPMENT_FILES[@]}"
            ;;
        "team-development-mcp")
            echo "${TEAM_DEVELOPMENT_MCP_FILES[@]}"
            ;;
        "strict-tdd")
            echo "${STRICT_TDD_FILES[@]}"
            ;;
        *)
            # Default to team-development for backward compatibility
            echo "${TEAM_DEVELOPMENT_FILES[@]}"
            ;;
    esac
}

# Function to download all template files
download_template() {
    local temp_dir="$1"
    local workflow="$2"
    
    print_info "Downloading template files for workflow: $workflow"
    
    local downloaded=0
    local failed=0
    
    # Get the appropriate file list for the workflow
    local template_files=($(get_template_files "$workflow"))
    
    for file in "${template_files[@]}"; do
        if download_file "$file" "$temp_dir"; then
            ((downloaded++))
        else
            ((failed++))
        fi
    done
    
    print_info "Downloaded: $downloaded files, Failed: $failed files"
    
    if [ $failed -gt 0 ]; then
        print_warning "Some files failed to download, but continuing..."
    fi
    
    print_success "Template download complete"
    return 0
}

# Function to validate template structure
validate_template() {
    local template_dir="$1"
    
    print_info "Validating template structure..."
    
    # Check for required files
    local required_files=(
        "template/workflow/docs/personas.md"
        "template/cursor/rules/personas.mdc"
    )
    
    local missing=0
    for file in "${required_files[@]}"; do
        if [ ! -f "$template_dir/$file" ]; then
            print_warning "Template may be incomplete - missing: $file"
            ((missing++))
        fi
    done
    
    # Check if bootstrap.sh is executable
    if [ -f "$template_dir/bootstrap.sh" ]; then
        chmod +x "$template_dir/bootstrap.sh"
        print_info "Made bootstrap.sh executable"
    fi
    
    if [ $missing -eq 0 ]; then
        print_success "Template validation complete - all required files present"
    else
        print_warning "Template validation complete - $missing files missing"
    fi
    
    return 0
}

# Function to run bootstrap
run_bootstrap() {
    local template_dir="$1"
    local project_name="$3"
    local target_ide="$4"
    local workflow="$5"
    
    # Ensure target_dir is absolute
    target_dir="$(pwd)"
    
    print_info "Setting up project structure in $target_dir..."
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir" || {
        print_error "Failed to create target directory: $target_dir"
        return 1
    }
    
    # Change to target directory
    cd "$target_dir" || {
        print_error "Failed to change to target directory: $target_dir"
        return 1
    }
    
    # Copy template files individually based on workflow
    if [ -f "$template_dir/template/README.md" ]; then
        cp "$template_dir/template/README.md" "./" || print_warning "Failed to copy README.md"
    fi
    
    # Create and copy docs files based on workflow
    if [ -d "$template_dir/template/bootstrap/$workflow/docs" ]; then
        mkdir -p "./docs"
        cp -r "$template_dir/template/bootstrap/$workflow/docs/"* "./docs/" 2>/dev/null || true
    fi
    
    # Create and copy workflow files to hidden .workflow directory
    if [ -d "$template_dir/template/bootstrap/$workflow/workflow" ]; then
        mkdir -p "./.workflow"
        cp -r "$template_dir/template/bootstrap/$workflow/workflow/"* "./.workflow/" 2>/dev/null || true
        # Remove non-hidden workflow directory if it exists
        rm -rf "./workflow" 2>/dev/null || true
    fi
    
    # Handle IDE-specific files based on workflow
    if [ "$target_ide" = "windsurf" ]; then
        # Copy windsurf-specific files to hidden directory
        if [ -d "$template_dir/template/bootstrap/$workflow/windsurf" ]; then
            mkdir -p "./.windsurf"
            cp -r "$template_dir/template/bootstrap/$workflow/windsurf/"* "./.windsurf/" 2>/dev/null || true
        fi
        
        # Install MCP coordinator server for team-development-mcp workflow
        if [ "$workflow" = "team-development-mcp" ]; then
            print_info "Installing MCP coordinator server..."
            if [ -d "$template_dir/mcp-coordinator" ]; then
                cp -r "$template_dir/mcp-coordinator" "./" || {
                    print_error "Failed to copy MCP coordinator server"
                    return 1
                }
                print_success "MCP coordinator server installed"
            else
                print_warning "MCP coordinator server not found in template"
            fi
        fi
        
        # Remove any non-hidden windsurf directory if it exists
        rm -rf "./windsurf" 2>/dev/null || true
        # Remove cursor directories if they exist
        rm -rf "./cursor" 2>/dev/null || true
        rm -rf "./.cursor" 2>/dev/null || true
    elif [ "$target_ide" = "cursor" ]; then
        # Copy cursor-specific files to hidden directory
        if [ -d "$template_dir/template/bootstrap/$workflow/cursor" ]; then
            mkdir -p "./.cursor"
            cp -r "$template_dir/template/bootstrap/$workflow/cursor/"* "./.cursor/" 2>/dev/null || true
        fi
        # Remove any non-hidden cursor directory if it exists
        rm -rf "./cursor" 2>/dev/null || true
        # Remove windsurf directories if they exist
        rm -rf "./windsurf" 2>/dev/null || true
        rm -rf "./.windsurf" 2>/dev/null || true
    fi
    
    # Change back to original directory
    cd - >/dev/null || true
    
    # Handle MCP coordinator server setup for team-development-mcp workflow
    if [ "$workflow" = "team-development-mcp" ]; then
        print_info "Setting up MCP coordinator server..."
        if [ -d "./mcp-coordinator" ]; then
            # Check if npm is available
            if command -v npm >/dev/null 2>&1; then
                print_info "Installing MCP coordinator dependencies..."
                cd "./mcp-coordinator" && npm install && npm run build && cd - >/dev/null || {
                    print_warning "Failed to build MCP coordinator server. You'll need to run 'npm install && npm run build' manually in the mcp-coordinator directory."
                }
            else
                print_warning "npm not found. Please install Node.js and run 'npm install && npm run build' in the mcp-coordinator directory."
            fi
        fi
    fi
    
    # Update project name and workflow info in README if provided
    if [ -f "$target_dir/README.md" ]; then
        # Use different sed syntax for macOS and Linux
        if [[ "$(uname)" == "Darwin" ]]; then
            if [ -n "$project_name" ]; then
                sed -i '' "s/\[PROJECT_NAME\]/$project_name/g" "$target_dir/README.md"
            fi
            sed -i '' "s/\[WORKFLOW_NAME\]/$workflow/g" "$target_dir/README.md"
            sed -i '' "s/\[IDE_NAME\]/$target_ide/g" "$target_dir/README.md"
        else
            if [ -n "$project_name" ]; then
                sed -i "s/\[PROJECT_NAME\]/$project_name/g" "$target_dir/README.md"
            fi
            sed -i "s/\[WORKFLOW_NAME\]/$workflow/g" "$target_dir/README.md"
            sed -i "s/\[IDE_NAME\]/$target_ide/g" "$target_dir/README.md"
        fi
    fi
    
    return $?
}

# Function to cleanup temporary files
cleanup() {
    local temp_dir="$1"
    
    if [ -d "$temp_dir" ]; then
        print_info "Cleaning up temporary files..."
        #rm -rf "$temp_dir"
        print_success "Cleanup complete"
    fi
}

# Function to show usage
show_usage() {
    echo "Development Bootstrap Installer"
    echo ""
    echo "Usage:"
    echo "  bash <(curl -s URL/install.sh) [flags]"
    echo "Usage: $0 [--cursor|--windsurf] [--team-development|--team-development-mcp|--strict-tdd]"
    echo ""
    echo "Options:"
    echo "  --cursor              Target Cursor IDE (default)"
    echo "  --windsurf            Target Windsurf IDE"
    echo "  --team-development    Use team development workflow (default)"
    echo "  --team-development-mcp Use team development workflow with MCP coordinator (Windsurf only)"
    echo "  --strict-tdd          Use strict TDD workflow"
    echo ""
    echo "Available Workflows:"
    echo "  team-development     - 6 personas with comprehensive review process"
    echo "                         ARCHITECT → CODER → TESTER → REVIEWER → QA → STAKEHOLDER"
    echo "  team-development-mcp - Same as team-development but with MCP coordinator server"
    echo "                         Uses MCP tools for state management (Windsurf only)"
    echo "  strict-tdd           - 3 personas with strict Test-Driven Development"
    echo "                         ARCHITECT → TDD_DEVELOPER [RED → GREEN → REFACTOR] → STAKEHOLDER"
    echo ""
    echo "Examples:"
    echo "  bash <(curl -s URL/install.sh) --windsurf --team-development"
    echo "  bash <(curl -s URL/install.sh) --windsurf --team-development-mcp"
    echo "  bash <(curl -s URL/install.sh) --cursor --strict-tdd"
    echo "  bash <(curl -s URL/install.sh) --strict-tdd"
    echo "  ./install.sh --windsurf --strict-tdd"
    echo ""
    echo "Benefits:"
    echo "  - No git dependency required"
    echo "  - Faster downloads (only needed files)"
    echo "  - Smaller footprint"
    echo "  - Works with curl only"
}

# Main function
main() {
    print_info "Development Bootstrap Installer"
    print_info "============================================="
    
    # Always use current directory as target
    TARGET_DIR="$(pwd)"
    # Parse flags
    TARGET_IDE="cursor"  # Default IDE
    TARGET_WORKFLOW="team-development"  # Default workflow
    
    for arg in "$@"; do
        case $arg in
            --cursor)
                TARGET_IDE="cursor"
                ;;
            --windsurf)
                TARGET_IDE="windsurf"
                ;;
            --team-development)
                TARGET_WORKFLOW="team-development"
                ;;
            --team-development-mcp)
                TARGET_WORKFLOW="team-development-mcp"
                ;;
            --strict-tdd)
                TARGET_WORKFLOW="strict-tdd"
                ;;
            *)
                print_error "Unknown flag: $arg"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Show usage if no arguments provided
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    # Validate workflow parameter
    if ! [[ "$TARGET_WORKFLOW" =~ ^(team-development|team-development-mcp|strict-tdd)$ ]]; then
        print_error "Invalid workflow: $TARGET_WORKFLOW. Must be 'team-development', 'team-development-mcp', or 'strict-tdd'"
        show_usage
        exit 1
    fi
    
    # Validate team-development-mcp is only used with Windsurf
    if [ "$TARGET_WORKFLOW" = "team-development-mcp" ] && [ "$TARGET_IDE" != "windsurf" ]; then
        print_error "team-development-mcp workflow is only supported with Windsurf IDE"
        print_error "Use --windsurf --team-development-mcp"
        show_usage
        exit 1
    fi
    
    # Check dependencies
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required but not installed"
        exit 1
    fi
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    if [ ! -d "$TEMP_DIR" ]; then
        print_error "Failed to create temporary directory"
        exit 1
    fi
    
    # Set up cleanup trap
    trap "cleanup '$TEMP_DIR'" EXIT
    
    print_info "Target directory: $TARGET_DIR"
    if [ -n "$PROJECT_NAME" ]; then
        print_info "Project name: $PROJECT_NAME"
    fi
    if [ -n "$TARGET_IDE" ]; then
        print_info "Target IDE: $TARGET_IDE"
    fi
    if [ -n "$TARGET_WORKFLOW" ]; then
        print_info "Target workflow: $TARGET_WORKFLOW"
    fi
    print_info "Temporary directory: $TEMP_DIR"
    
    # Download template files
    if ! download_template "$TEMP_DIR" "$TARGET_WORKFLOW"; then
        print_error "Template download failed"
        exit 1
    fi
    
    # Validate template
    if ! validate_template "$TEMP_DIR"; then
        print_warning "Template validation had warnings, but continuing..."
    fi
    
    # Run bootstrap
    if ! run_bootstrap "$TEMP_DIR" "$TARGET_DIR" "$PROJECT_NAME" "$TARGET_IDE" "$TARGET_WORKFLOW"; then
        print_error "Bootstrap failed"
        exit 1
    fi
    
    print_success "Installation complete!"
    print_info ""
    print_info "Next steps:"
    print_info ""
    
    # Show MCP-specific instructions for team-development-mcp workflow
    if [ "$TARGET_WORKFLOW" = "team-development-mcp" ]; then
        print_info "MCP Coordinator Setup:"
        print_info "1. The MCP coordinator server has been installed in ./mcp-coordinator/"
        if command -v npm >/dev/null 2>&1; then
            print_info "2. Dependencies installed and server built automatically"
        else
            print_info "2. Install Node.js, then run: cd mcp-coordinator && npm install && npm run build"
        fi
        print_info "3. The MCP server is configured in .windsurf/mcp_servers.json"
        print_info "4. Restart Windsurf to load the MCP server configuration"
        print_info "5. Use MCP tools: create_plan, add_task, create_handoff, etc."
        print_info ""
    fi
    
    print_info "Start typing your requests..."
    print_info ""
    print_info "Happy multi-persona development! 🚀"
}

# Run main function with all arguments
main "$@"
