#!/bin/bash

# Multi-Persona Development Bootstrap Template - GitHub Installation Script
# Downloads and runs the bootstrap script from a GitHub repository
# Usage: ./install.sh <github-repo-url> <target-directory> [project-name] [ide]
# Or: ./install.sh GITHUB_URL /path/to/new-project [project-name]

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

# Function to validate GitHub URL
validate_github_url() {
    local url="$1"
    
    if [ -z "$url" ]; then
        print_error "GitHub URL cannot be empty"
        return 1
    fi
    
    # Support various GitHub URL formats
    if [[ "$url" =~ ^https://github\.com/[^/]+/[^/]+/?$ ]] || \
       [[ "$url" =~ ^git@github\.com:[^/]+/[^/]+\.git$ ]] || \
       [[ "$url" =~ ^https://github\.com/[^/]+/[^/]+\.git$ ]]; then
        return 0
    else
        print_error "Invalid GitHub URL format. Supported formats:"
        print_error "  https://github.com/user/repo"
        print_error "  https://github.com/user/repo.git"
        print_error "  git@github.com:user/repo.git"
        return 1
    fi
}

# Function to normalize GitHub URL for cloning
normalize_github_url() {
    local url="$1"
    
    # Convert SSH to HTTPS for broader compatibility
    if [[ "$url" =~ ^git@github\.com:(.+)$ ]]; then
        url="https://github.com/${BASH_REMATCH[1]}"
    fi
    
    # Ensure .git suffix for cloning
    if [[ ! "$url" =~ \.git$ ]]; then
        url="${url}.git"
    fi
    
    echo "$url"
}

# Function to extract repository name from URL
extract_repo_name() {
    local url="$1"
    
    # Extract repo name from various URL formats
    if [[ "$url" =~ github\.com[:/]([^/]+)/([^/]+)(\.git)?/?$ ]]; then
        echo "${BASH_REMATCH[2]}"
    else
        echo "template"
    fi
}

# Function to clone repository
clone_repository() {
    local github_url="$1"
    local temp_dir="$2"
    
    print_info "Cloning repository from $github_url..."
    
    # Normalize URL for cloning
    local clone_url=$(normalize_github_url "$github_url")
    
    # Clone with error handling
    if ! git clone --depth 1 --quiet "$clone_url" "$temp_dir" 2>/dev/null; then
        print_error "Failed to clone repository. Please check:"
        print_error "  - Repository URL is correct"
        print_error "  - Repository is public or you have access"
        print_error "  - Internet connection is working"
        print_error "  - Git is installed and configured"
        return 1
    fi
    
    print_success "Repository cloned successfully"
    return 0
}

# Function to validate template structure
validate_template() {
    local template_dir="$1"
    
    print_info "Validating template structure..."
    
    # Check for required files
    local required_files=(
        "bootstrap.sh"
        "template/workflow/docs/personas.md"
        "template/workflow/docs/workflow.md"
        "template/windsurf/rules/personas.md"
        "template/cursor/rules/personas.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$template_dir/$file" ]; then
            print_warning "Template may be incomplete - missing: $file"
        fi
    done
    
    # Check if bootstrap.sh is executable
    if [ -f "$template_dir/bootstrap.sh" ] && [ ! -x "$template_dir/bootstrap.sh" ]; then
        print_info "Making bootstrap.sh executable..."
        chmod +x "$template_dir/bootstrap.sh"
    fi
    
    print_success "Template validation complete"
    return 0
}

# Function to run bootstrap
run_bootstrap() {
    local template_dir="$1"
    local target_dir="$2"
    local project_name="$3"
    
    print_info "Running bootstrap script..."
    
    if [ ! -f "$template_dir/bootstrap.sh" ]; then
        print_error "Bootstrap script not found in template"
        return 1
    fi
    
    # Run bootstrap script from template directory
    cd "$template_dir"
    
    if [ -n "$project_name" ] && [ -n "$TARGET_IDE" ]; then
        ./bootstrap.sh "$target_dir" "$project_name" "$TARGET_IDE"
    elif [ -n "$project_name" ]; then
        ./bootstrap.sh "$target_dir" "$project_name"
    else
        ./bootstrap.sh "$target_dir"
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
    echo "  bash <(curl -s URL/install.sh) GITHUB_URL /path/to/new-project [project-name]"
    echo "  ./install.sh GITHUB_URL /path/to/new-project [project-name]"
    echo ""
    echo "Arguments:"
    echo "  GITHUB_URL      GitHub repository URL (https://github.com/user/repo)"
    echo "  /path/to/new-project  Directory where new project will be created"
    echo "  project-name    Optional project name (defaults to directory name)"
    echo ""
    echo "Examples:"
    echo "  bash <(curl -s URL/install.sh) https://github.com/user/template /tmp/my-project"
    echo "  ./install.sh https://github.com/user/template.git /home/user/projects/new-app \"My App\""
}

# Main function
main() {
    print_info "Multi-Persona Development Template Installer"
    print_info "============================================="
    
    # Parse arguments
    REPO_URL="$1"
    TARGET_DIR="$2"
    PROJECT_NAME="$3"
    TARGET_IDE="$4"
    
    # Validate arguments
    if [ -z "$REPO_URL" ] || [ -z "$TARGET_DIR" ]; then
        print_error "Usage: $0 <github-repo-url> <target-directory> [project-name] [ide]"
        print_info "Example: $0 https://github.com/user/repo /path/to/new-project 'My Project' windsurf"
        print_info "Supported IDEs: windsurf, cursor"
        exit 1
    fi
    
    # Validate GitHub URL
    if ! validate_github_url "$REPO_URL"; then
        exit 1
    fi
    
    # Check dependencies
    if ! command -v git >/dev/null 2>&1; then
        print_error "Git is required but not installed"
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
    
    print_info "GitHub URL: $REPO_URL"
    print_info "Target directory: $TARGET_DIR"
    if [ -n "$PROJECT_NAME" ]; then
        print_info "Project name: $PROJECT_NAME"
    fi
    print_info "Temporary directory: $TEMP_DIR"
    
    # Clone repository
    if ! clone_repository "$REPO_URL" "$TEMP_DIR"; then
        exit 1
    fi
    
    # Validate template
    if ! validate_template "$TEMP_DIR"; then
        print_warning "Template validation had warnings, but continuing..."
    fi
    
    # Run bootstrap
    if ! run_bootstrap "$TEMP_DIR" "$TARGET_DIR" "$PROJECT_NAME"; then
        print_error "Bootstrap failed"
        exit 1
    fi
    
    print_success "Installation complete!"
    print_info ""
    print_info "Next steps:"
    print_info "1. cd $TARGET_DIR"
    print_info "2. Update .workflow/docs/plan.md with your project details"
    print_info "3. Start with: [ARCHITECT] Starting analysis of [your first feature]"
    print_info ""
    print_info "Happy multi-persona development! 🚀"
}

# Run main function with all arguments
main "$@"
