# Multi-Persona Development Bootstrap Template

This template provides a complete multi-persona development workflow system with 6 defined personas, comprehensive documentation structure, and automated bootstrap tools. Supports both **Windsurf Cascade** and **Cursor IDE**. It demonstrates best practices by following its own workflow during development.

## 🚀 Quick Start

### One-Line Installation (Recommended)
```bash
# For Windsurf Cascade
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/refs/heads/main/install.sh')" windsurf

# For Cusror 
bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/magnus-ffcg/vibe-with-multi-personas/refs/heads/main/install.sh')" cursor
```

### Installation Benefits
✅ **No Git Required** - Uses only `curl` (available on all systems)  
✅ **Faster Setup** - Downloads only needed files (~16 files vs full repo)  
✅ **Smaller Footprint** - ~15-20KB download vs 72KB+ with git history  
✅ **Direct Access** - Works from any terminal without cloning  

### Next Steps
1. **Run the installation command** above with your project path
2. **Follow the generated instructions** in your new project
3. Start coding with multi-persona development workflow!

## What You Get

This template provides a complete multi-persona development system with:

✅ **6 Defined Personas** - Clear roles from architecture to stakeholder approval  
✅ **Structured Workflow** - Proven pipeline from idea to completion  
✅ **Quality Gates** - Multiple checkpoints ensure high-quality output  
✅ **Documentation Templates** - All the docs you need, ready to customize  
✅ **Multi-IDE Support** - Works with both Windsurf Cascade and Cursor IDE  
✅ **IDE-Specific Configuration** - Optimized rules and workflows for each IDE  

## File Structure

```
├── README.md                # This file - overview and quick start
├── install.sh               # One-command installer (no git required)
├── .windsurf/               # Windsurf Cascade IDE configuration
│   └── rules/
│       ├── personas.md      # Windsurf-specific persona definitions
│       ├── workflow.md      # Windsurf-specific workflow process
│       └── hand-offs.md     # Hand-off tracking template
├── .cursor/                 # Cursor IDE configuration
│   └── rules/
│       ├── personas.md      # Cursor-specific persona definitions
│       ├── workflow.md      # Cursor-specific workflow process
│       └── hand-offs.md     # Hand-off tracking template
├── .workflow/               # IDE-agnostic workflow documentation
│   └── docs/
│       ├── personas.md      # Core persona definitions
│       ├── workflow.md      # Core workflow process
│       ├── plan.md          # Design notes and architecture
│       ├── backlog.md       # Task management
│       └── hand-offs.md     # Hand-off tracking
├── docs/
│   ├── adr/                 # Architecture Decision Records
│   ├── changelog.md         # Implementation changes
│   ├── dependencies.md      # External dependencies
│   └── glossary.md          # Project terminology
└── template/                # Clean template for new projects
    ├── windsurf/            # Windsurf configuration template
    ├── cursor/              # Cursor configuration template
    ├── workflow/            # Core workflow documentation
    ├── docs/                # Project documentation structure
    └── README.md            # Project-specific README template
```

## IDE-Specific Features

### Windsurf Cascade
- **AI Pair Programming**: Optimized for Cascade's collaborative AI features
- **Context Awareness**: Rules designed for Windsurf's workspace understanding
- **Tool Integration**: Leverages Windsurf's built-in development tools
- **Configuration**: `.windsurf/rules/` contains Windsurf-specific workflow adaptations

### Cursor IDE
- **AI Code Generation**: Adapted for Cursor's advanced AI capabilities
- **Apply Feature**: Workflow optimized for Cursor's Apply functionality
- **Chat Integration**: Personas designed to work with Cursor's chat interface
- **Configuration**: `.cursor/rules/` contains Cursor-specific workflow adaptations

## After Bootstrapping Your Project

### 1. Customize for Your Project
- Update `.workflow/docs/plan.md` with your project overview
- Modify `docs/dependencies.md` with your tech stack
- Add project-specific terms to `docs/glossary.md`

### 2. Start Your First Feature
```markdown
[ARCHITECT] Starting analysis of [your feature]
- Researching requirements and constraints
- Will document design in .workflow/docs/plan.md
- Will create initial backlog items
```

### 3. Follow the Workflow
```
Backlog → In Progress → Coded → Tested → Reviewed → QA → Ready for Stakeholder → Complete
```

## Key Workflow Rules

1. **Prefix all messages** with persona (e.g., `[ARCHITECT]`)
2. **Update documentation** as you work
3. **Log hand-offs** in `/.workflow/docs/hand-offs.md`
4. **Only stakeholders** can mark tasks complete
5. **Blockers return** to architect for redesign

## Documentation Included

- **`.workflow/docs/personas.md`** - Role definitions
- **`.workflow/docs/workflow.md`** - Process documentation
- **`.workflow/docs/backlog.md`** - Task management
- **`.workflow/docs/plan.md`** - Project design notes
- **`.workflow/docs/test-plan.md`** - Testing strategy template
- **`.workflow/docs/adr/`** - Architecture decision records
- **Plus 8 more** documentation templates ready to use

## Why Use This Template?

✅ **This project follows a structured multi-persona development workflow with 6 personas:** 
✅ **Quality Focus** - Multiple review stages catch issues early  
✅ **Complete Documentation** - Nothing to set up, just start coding  
✅ **Windsurf Optimized** - Designed for Cascade AI pair programming  
✅ **Stakeholder Control** - Clear approval process for all work  

---

**Ready to bootstrap your next project?** Copy this template and start with the [ARCHITECT] persona!
