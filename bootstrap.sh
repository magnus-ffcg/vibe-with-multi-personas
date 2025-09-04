#!/bin/bash

# Multi-Persona Development Bootstrap Script
# Automates the setup of a new project using this multi-persona development template
# Supports both Windsurf Cascade and Cursor IDE
# Usage: ./bootstrap.sh /path/to/new-project [project-name] [ide]

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

# Function to prompt for user input with default
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local result
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " result
        echo "${result:-$default}"
    else
        read -p "$prompt: " result
        echo "$result"
    fi
}

# Function to detect IDE environment
detect_ide() {
    local target_ide="$1"
    
    # If IDE specified as argument, validate and use it
    if [ -n "$target_ide" ]; then
        case "$target_ide" in
            "windsurf"|"cascade")
                echo "windsurf"
                return 0
                ;;
            "cursor")
                echo "cursor"
                return 0
                ;;
            *)
                print_error "Unsupported IDE: $target_ide. Supported: windsurf, cursor"
                return 1
                ;;
        esac
    fi
    
    # Auto-detect based on environment or prompt user
    print_info "Detecting IDE environment..."
    
    # Check for Windsurf environment indicators
    if [ -n "$WINDSURF_WORKSPACE" ] || [ -d ".windsurf" ]; then
        print_info "Windsurf Cascade environment detected"
        echo "windsurf"
        return 0
    fi
    
    # Check for Cursor environment indicators  
    if [ -n "$CURSOR_WORKSPACE" ] || [ -d ".cursor" ] || command -v cursor >/dev/null 2>&1; then
        print_info "Cursor IDE environment detected"
        echo "cursor"
        return 0
    fi
    
    # Prompt user to choose
    print_info "Could not auto-detect IDE. Please choose:"
    echo "1) Windsurf Cascade"
    echo "2) Cursor IDE"
    
    local choice
    choice=$(prompt_with_default "Enter choice (1-2)" "1")
    
    case "$choice" in
        1|"windsurf"|"cascade")
            echo "windsurf"
            return 0
            ;;
        2|"cursor")
            echo "cursor"
            return 0
            ;;
        *)
            print_error "Invalid choice. Defaulting to Windsurf Cascade"
            echo "windsurf"
            return 0
            ;;
    esac
}

# Function to validate directory path
validate_directory() {
    local dir="$1"
    
    if [ -z "$dir" ]; then
        print_error "Directory path cannot be empty"
        return 1
    fi
    
    if [ -e "$dir" ] && [ "$(ls -A "$dir" 2>/dev/null)" ]; then
        print_warning "Directory '$dir' exists and is not empty"
        local confirm
        confirm=$(prompt_with_default "Continue anyway? (y/N)" "N")
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            print_info "Bootstrap cancelled"
            return 1
        fi
    fi
    
    return 0
}

# Function to copy template files
copy_template() {
    local source_dir="$1"
    local target_dir="$2"
    local ide="$3"
    
    print_info "Copying template files for $ide IDE..."
    
    # Create target directory
    mkdir -p "$target_dir"
    
    # Copy base template files (clean installation)
    rsync -av "$source_dir/template/" "$target_dir/" --exclude='windsurf' --exclude='cursor' --exclude='workflow'
    
    # Copy workflow configuration (regular → hidden)
    if [ -d "$source_dir/template/workflow" ]; then
        rsync -av "$source_dir/template/workflow/" "$target_dir/.workflow/"
        print_info "Workflow configuration installed"
    fi
    
    # Copy IDE-specific configuration
    case "$ide" in
        "windsurf")
            if [ -d "$source_dir/template/windsurf" ]; then
                rsync -av "$source_dir/template/windsurf/" "$target_dir/.windsurf/"
                print_info "Windsurf Cascade configuration installed"
            fi
            ;;
        "cursor")
            if [ -d "$source_dir/template/cursor" ]; then
                rsync -av "$source_dir/template/cursor/" "$target_dir/.cursor/"
                print_info "Cursor IDE configuration installed"
            fi
            ;;
    esac
    
    print_success "Template files copied successfully for $ide IDE"
}

# Function to initialize git repository
init_git() {
    local project_dir="$1"
    
    print_info "Initializing git repository..."
    
    cd "$project_dir"
    
    if [ -d ".git" ]; then
        print_warning "Git repository already exists"
        return 0
    fi
    
    git init
    git add .
    git commit -m "init: bootstrap project with multi-persona development workflow template"
    
    print_success "Git repository initialized with initial commit"
}

# Function to customize project files
customize_project() {
    local project_dir="$1"
    local project_name="$2"
    
    print_info "Customizing project files..."
    
    # Update README.md with project name
    if [ -f "$project_dir/README.md" ]; then
        # Create a project-specific README
        cat > "$project_dir/README.md" << EOF
# $project_name

This project uses the Windsurf Multi-Persona Development Workflow.

## Getting Started

This project follows a structured multi-persona development workflow with 6 personas:
- **[ARCHITECT]** - Research, design, and task breakdown
- **[CODER]** - Implementation using Python 3.12
- **[TESTER]** - Comprehensive testing with 80% coverage
- **[REVIEWER]** - Code review for quality and maintainability  
- **[QA]** - Validation against acceptance criteria
- **[STAKEHOLDER]** - Final approval (you, the user)

## Workflow

\`\`\`
Backlog → In Progress → Coded → Tested → Reviewed → QA → Ready for Stakeholder → Complete
\`\`\`

## Documentation

See the `.workflow/docs/` directory for complete workflow documentation:
- `.workflow/docs/personas.md` - Role definitions
- `.workflow/docs/workflow.md` - Process documentation
- `.workflow/docs/backlog.md` - Task management
- `.workflow/docs/plan.md` - Project design notes

## Next Steps

1. Update `.workflow/docs/plan.md` with your project overview
2. Start with the [ARCHITECT] persona to analyze requirements
3. Follow the workflow pipeline for all development work

Ready to start? Begin with: `[ARCHITECT] Starting analysis of [your first feature]`
EOF
    fi
    
    # Customize template files with project name (with proper error handling)
    local files_to_customize=(
        ".workflow/docs/plan.md"
        ".workflow/docs/backlog.md" 
        ".workflow/docs/release-notes.md"
        "docs/changelog.md"
        "docs/dependencies.md"
    )
    
    for file in "${files_to_customize[@]}"; do
        if [ -f "$project_dir/$file" ]; then
            if sed -i.bak "s/\[PROJECT_NAME\]/$project_name/g" "$project_dir/$file" 2>/dev/null; then
                rm "$project_dir/$file.bak" 2>/dev/null || true
            else
                print_warning "Could not customize $file - file may be read-only"
            fi
        fi
    done
    
    print_success "Project files customized for '$project_name'"
}

# Main function
main() {
    print_info "Multi-Persona Development Bootstrap Script"
    print_info "=========================================="
    
    # Get script directory (where template is located)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Parse arguments
    TARGET_DIR="$1"
    PROJECT_NAME="$2"
    TARGET_IDE="$3"
    
    # Validate arguments
    if [ -z "$TARGET_DIR" ]; then
        print_error "Usage: $0 /path/to/new-project [project-name] [ide]"
        print_info "Supported IDEs: windsurf, cursor"
        exit 1
    fi
    
    # Convert to absolute path
    TARGET_DIR="$(cd "$(dirname "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename "$TARGET_DIR")" || {
        # If parent directory doesn't exist, create it
        mkdir -p "$(dirname "$TARGET_DIR")"
        TARGET_DIR="$(cd "$(dirname "$TARGET_DIR")" && pwd)/$(basename "$TARGET_DIR")"
    }
    
    # Detect or validate IDE
    IDE=$(detect_ide "$TARGET_IDE")
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    # Get project name if not provided
    if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME=$(basename "$TARGET_DIR")
        PROJECT_NAME=$(prompt_with_default "Project name" "$PROJECT_NAME")
    fi
    
    print_info "Target directory: $TARGET_DIR"
    print_info "Project name: $PROJECT_NAME"
    print_info "Target IDE: $IDE"
    
    # Validate target directory
    if ! validate_directory "$TARGET_DIR"; then
        exit 1
    fi
    
    # Copy template files with IDE-specific configuration
    copy_template "$SCRIPT_DIR" "$TARGET_DIR" "$IDE"
    
    # Customize project
    customize_project "$TARGET_DIR" "$PROJECT_NAME"
    
    # Initialize git repository
    if command -v git >/dev/null 2>&1; then
        init_git "$TARGET_DIR"
    else
        print_warning "Git not found, skipping repository initialization"
    fi
    
    print_success "Bootstrap complete!"
    print_info ""
    print_info "Next steps:"
    print_info "1. cd $TARGET_DIR"
    case "$IDE" in
        "windsurf")
            print_info "2. Open in Windsurf Cascade IDE"
            print_info "3. The .windsurf/rules/ directory contains your workflow configuration"
            ;;
        "cursor")
            print_info "2. Open in Cursor IDE"
            print_info "3. The .cursor/rules/ directory contains your workflow configuration"
            ;;
    esac
    print_info "4. Update .workflow/docs/plan.md with your project details"
    print_info "5. Start with: [ARCHITECT] Starting analysis of [your first feature]"
    print_info ""
    print_info "Happy multi-persona development with $IDE! 🚀"
}

# Run main function with all arguments
main "$@"
