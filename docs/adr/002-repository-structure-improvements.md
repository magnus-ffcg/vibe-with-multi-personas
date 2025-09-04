# ADR-002: Repository Structure Improvements

## Status
Proposed

## Context
The current bootstrap repository has several structural issues:
1. README references deleted files (personas.md, workflow.md)
2. Missing core workflow definitions that users need
3. Inconsistent documentation organization
4. No clear bootstrap/template separation

## Decision
Restructure the repository to be a proper bootstrap template with:
1. Self-contained documentation in docs/
2. Clear separation between template and example content
3. Consistent file organization
4. Working references in all documentation

## Consequences

### Positive
- Users get complete, working documentation
- Clear template structure for new projects
- No broken references or missing files
- Better organization and discoverability

### Negative
- Requires refactoring existing structure
- May need to update existing documentation

## Alternatives Considered
1. **Keep current broken structure** - Unacceptable, confuses users
2. **Restore deleted files** - Creates redundancy between root and docs/
3. **Move everything to docs/** - Better organization and consistency

## Implementation Plan
1. Consolidate workflow documentation in docs/
2. Update README to reflect actual structure
3. Create clear templates vs examples separation
4. Add bootstrap automation scripts

## References
- Current broken README references
- User feedback on missing workflow files
