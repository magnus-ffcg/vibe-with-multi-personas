#!/bin/bash

# Multi-Persona Development Bootstrap Template - Installer
# Downloads template files directly from GitHub without requiring git
# Usage: ./install.sh <github-repo-url> <target-directory> [project-name] [ide]

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

# Template file manifest - all files needed for the template
TEMPLATE_FILES=(
    "template/README.md"
    "template/cursor/rules/hand-offs.mdc"
    "template/cursor/rules/personas.mdc"
    "template/cursor/rules/workflow.mdc"
    "template/docs/changelog.md"
    "template/docs/dependencies.md"
    "template/windsurf/rules/hand-offs.md"
    "template/windsurf/rules/personas.md"
    "template/windsurf/rules/workflow.md"
    "template/workflow/docs/backlog.md"
    "template/workflow/docs/hand-offs.md"
    "template/workflow/docs/personas.md"
    "template/workflow/docs/plan.md"
    "template/workflow/docs/release-notes.md"
    "template/workflow/docs/workflow.md"
)

# Function to download a single file
download_file() {
    local repo_url="https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/refs/heads/main/"
    local file_path="$1"
    local target_dir="$2"
    
    local raw_url=$("$repo_url$file_path")
    local target_file="$target_dir/$file_path"
    local target_file_dir=$(dirname "$target_file")
    
    # Create target directory
    mkdir -p "$target_file_dir"
    
    # Download file
    if ! curl -s -f -o "$target_file" "$raw_url" -H "Cache-Control: no-cache, no-store"; then
        print_warning "Failed to download: $file_path"
        return 1
    fi
    
    return 0
}

# Function to download all template files
download_template() {
    local temp_dir="$2"
    
    print_info "Downloading template files from repository..."
    
    local downloaded=0
    local failed=0
    
    for file in "${TEMPLATE_FILES[@]}"; do
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
    local target_dir="$2"
    local project_name="$3"
    local target_ide="$4"
    
    print_info "Setting up project structure..."
    
    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"
    
    # Create necessary directories
    mkdir -p "$target_dir/docs"
    mkdir -p "$target_dir/workflow/docs"
    
    # Copy template files individually to avoid copying the template directory itself
    if [ -f "$template_dir/template/README.md" ]; then
        cp "$template_dir/template/README.md" "$target_dir/"
    fi
    
    # Copy docs files
    if [ -d "$template_dir/template/docs" ]; then
        cp -r "$template_dir/template/docs/"* "$target_dir/docs/" 2>/dev/null || true
    fi
    
    # Copy workflow files to hidden .workflow directory
    if [ -d "$template_dir/template/workflow" ]; then
        mkdir -p "$target_dir/.workflow"
        cp -r "$template_dir/template/workflow/"* "$target_dir/.workflow/" 2>/dev/null || true
        # Remove non-hidden workflow directory if it exists
        rm -rf "$target_dir/workflow"
    fi
    
    # Handle IDE-specific files
    if [ "$target_ide" = "windsurf" ]; then
        # Copy windsurf-specific files to hidden directory
        if [ -d "$template_dir/template/windsurf" ]; then
            mkdir -p "$target_dir/.windsurf"
            cp -r "$template_dir/template/windsurf/"* "$target_dir/.windsurf/" 2>/dev/null || true
        fi
        # Remove any non-hidden windsurf directory if it exists
        rm -rf "$target_dir/windsurf"
        # Remove cursor directories if they exist
        rm -rf "$target_dir/cursor"
        rm -rf "$target_dir/.cursor"
    elif [ "$target_ide" = "cursor" ]; then
        # Copy cursor-specific files to hidden directory
        if [ -d "$template_dir/template/cursor" ]; then
            mkdir -p "$target_dir/.cursor"
            cp -r "$template_dir/template/cursor/"* "$target_dir/.cursor/" 2>/dev/null || true
        fi
        # Remove any non-hidden cursor directory if it exists
        rm -rf "$target_dir/cursor"
        # Remove windsurf directories if they exist
        rm -rf "$target_dir/windsurf"
        rm -rf "$target_dir/.windsurf"
    fi
    
    # Update project name in README if provided
    if [ -n "$project_name" ]; then
        # Use different sed syntax for macOS and Linux
        if [[ "$(uname)" == "Darwin" ]]; then
            sed -i '' "s/\[PROJECT_NAME\]/$project_name/g" "$target_dir/README.md"
        else
            sed -i "s/\[PROJECT_NAME\]/$project_name/g" "$target_dir/README.md"
        fi
    fi
    
    return $?
}

# Function to cleanup temporary files
cleanup() {
    local temp_dir="$1"
    
    if [ -d "$temp_dir" ]; then
        print_info "Cleaning up temporary files..."
        rm -rf "$temp_dir"
        print_success "Cleanup complete"
    fi
}

# Function to show usage
show_usage() {
    echo "Multi-Persona Development Template Installer"
    echo ""
    echo "Usage:"
    echo "  bash <(curl -s URL/install.sh) GITHUB_URL /path/to/new-project [project-name] [ide]"
    echo "  ./install.sh GITHUB_URL /path/to/new-project [project-name] [ide]"
    echo ""
    echo "Arguments:"
    echo "  /path/to/new-project  Directory where new project will be created"
    echo "  project-name    Optional project name (defaults to directory name)"
    echo "  ide             Optional IDE (windsurf, cursor - defaults to auto-detect)"
    echo ""
    echo "Examples:"
    echo "  bash <(curl -s URL/install.sh) https://github.com/user/template /tmp/my-project"
    echo "  ./install.sh https://github.com/user/template.git /home/user/projects/new-app \"My App\" windsurf"
    echo ""
    echo "Benefits:"
    echo "  - No git dependency required"
    echo "  - Faster downloads (only needed files)"
    echo "  - Smaller footprint"
    echo "  - Works with curl only"
}

# Main function
main() {
    print_info "Multi-Persona Development Template Installer"
    print_info "============================================="
    
    # Parse arguments
    TARGET_DIR="$1"
    PROJECT_NAME="$2"
    TARGET_IDE="$3"
    
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
    print_info "Temporary directory: $TEMP_DIR"
    
    # Download template files
    if ! download_template "$TEMP_DIR"; then
        print_error "Template download failed"
        exit 1
    fi
    
    # Validate template
    if ! validate_template "$TEMP_DIR"; then
        print_warning "Template validation had warnings, but continuing..."
    fi
    
    # Run bootstrap
    if ! run_bootstrap "$TEMP_DIR" "$TARGET_DIR" "$PROJECT_NAME" "$TARGET_IDE"; then
        print_error "Bootstrap failed"
        exit 1
    fi
    
    print_success "Installation complete!"
    print_info ""
    print_info "Next steps:"
    print_info ""
    print_info "Start typing your requests..."
    print_info ""
    print_info "Happy multi-persona development! 🚀"
}

# Run main function with all arguments
main "$@"
