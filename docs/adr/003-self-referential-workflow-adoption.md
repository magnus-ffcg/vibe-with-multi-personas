# ADR-003: Self-Referential Workflow Adoption

## Status
Accepted

## Context
The bootstrap template defines a mob programming workflow but wasn't following its own practices. To be truly "best-in-class" and demonstrate the workflow's effectiveness, this project should "eat its own dogfood" by actually using the personas, documentation practices, and quality gates it defines.

## Decision
Adopt the complete mob programming workflow defined in this template for the development of the template itself. This includes:
- Using persona prefixes in all development work
- Maintaining proper documentation (plan.md, backlog.md, changelog.md, etc.)
- Following hand-off protocols between work phases
- Creating ADRs for architectural decisions
- Demonstrating the complete workflow pipeline

## Consequences

### Positive
- **Credibility**: Template demonstrates its own effectiveness
- **Validation**: Workflow gets real-world testing and refinement
- **Examples**: Users see concrete examples of proper workflow usage
- **Quality**: Multiple review stages ensure template excellence
- **Documentation**: Complete documentation serves as both template and example

### Negative
- **Overhead**: More documentation work for simple changes
- **Complexity**: Following full workflow for template development
- **Time**: Additional steps slow down rapid iteration

## Alternatives Considered
1. **Minimal documentation** - Faster but less credible
2. **Partial workflow adoption** - Inconsistent demonstration
3. **External examples only** - Misses self-validation opportunity

## Implementation
- Update all documentation to reflect actual project state
- Create proper backlog items for remaining work
- Document all architectural decisions in ADRs
- Maintain changelog and hand-off logs
- Follow persona-based development approach

## References
- User request for "best-in-class" and "dogfooding"
- Template workflow definition in docs/workflow.md
- Template persona definitions in docs/personas.md
