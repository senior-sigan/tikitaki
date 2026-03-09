# Workflow

## Development Approach: Agent Team

Claude Code acts as a **team lead** and never writes code directly. All implementation is delegated to specialized agents:

| Role | Responsibility |
|------|----------------|
| **Architect** | Project setup, directory structure, dependencies |
| **TDD Developer(s)** | Feature implementation using strict RED-GREEN-REFACTOR |
| **UI/Design Expert** | Theme, layout, visual design, platform conventions |
| **Code Reviewer** | Full codebase review after each major milestone |
| **Bug Fixer** | Addresses issues found during review |
| **Integration Dev** | Wiring, DI, final assembly |

### Parallelization
- Launch independent agents in parallel (e.g., data layer + settings persistence)
- Sequential agents for dependent phases (e.g., ViewModels after Models)
- Always run Code Review after feature phases complete, then Bug Fixer for found issues

## TDD Discipline

Strict RED-GREEN-REFACTOR cycle:
1. **RED**: Write a failing test first
2. **GREEN**: Write minimal code to make it pass
3. **REFACTOR**: Clean up without changing behavior

### Testing Rules
- Use `package:checks` for assertions (NOT expect/matcher)
- Use `package:mocktail` for mocks
- Prefer Fakes over Mocks for ChangeNotifier-based ViewModels
- Every agent must run `flutter test` + `flutter analyze` before finishing

## Git Commits

- Commit after each completed phase or logical milestone
- Every agent prompt should include instruction to commit after finishing work
- Use conventional commit messages: `feat:`, `fix:`, `refactor:`, `chore:`, `test:`
- Never push without explicit user request
- Stage specific files (`git add lib/ test/`), never `git add -A`

## Code Review Cycle

After major features are complete, run three parallel review agents:
1. **Reuse Review** — duplicates, dead code, DRY violations
2. **Quality Review** — lifecycle issues, error handling, null safety
3. **Efficiency Review** — hot-path performance, unnecessary rebuilds, memory leaks

Then launch a fixer agent to address all confirmed issues. Skip false positives and trivial style preferences.
