# Objective

Safely update a specified npm package and all related packages in a JavaScript /
TypeScript project, ensuring dependency consistency and verification.

The agent must detect the package manager (npm or yarn), update dependencies
accordingly, and validate the result using existing project scripts.

# Context

This repository uses automated agents to maintain dependency hygiene.
Dependency updates must:

- Respect the package manager used by the project
- Update direct, related, and constrained dependencies
- Keep lockfiles, overrides, and resolution rules in sync
- Run verification scripts when available

The agent will be invoked with a package name (and optionally a version range).

# Inputs

- Git repository (working tree)
- Target package name (provided via prompt)
- Optional target version or version range

# Responsibilities

- Detect the package manager (npm vs yarn)
- Update the specified package
- Update related ecosystem packages (peer / scoped / strongly-coupled deps)
- Update overrides / resolutions if applicable
- Reinstall dependencies
- Run dependency verification if configured

# Instructions

1. Detect package manager:
   - If `yarn.lock` exists → use Yarn
   - Else if `package-lock.json` exists → use npm
   - If both exist, prefer the one referenced by `packageManager` in package.json

2. Inspect `package.json`:
   - Locate the target package in:
     - dependencies
     - devDependencies
     - peerDependencies (do not auto-add new peers)
   - Detect related packages:
     - Same scope (e.g. `@types/*`, `@nestjs/*`, `@aws-sdk/*`)
     - Known peer dependencies declared by the target package

3. Update versions:
   - Update the target package to the requested version (or latest compatible)
   - Update related packages to compatible versions
   - Keep version ranges consistent across dependency sections

4. Update constraints:
   - If package appears in:
     - `overrides` (npm)
     - `resolutions` (yarn)
       update those entries to match the new version
   - Remove stale overrides only if no longer required

5. Install dependencies:
   - Yarn: `yarn install`
   - npm: `npm install`

6. Verification:
   - If `package.json` defines a script named `deps:verify`,
     run it after installation
   - Capture failures as hard errors

7. Output:
   - Modify only files required for the dependency update:
     - package.json
     - lockfile (yarn.lock or package-lock.json)
   - Do NOT update unrelated dependencies

# Output Format

Produce changes only; do not generate narrative text files.

If a summary is required by another agent, ensure commits clearly reflect:

- Updated packages
- Version changes
- Lockfile updates
- Verification status

# Constraints

- Do NOT switch package managers
- Do NOT delete lockfiles
- Do NOT bulk upgrade unrelated dependencies
- Do NOT suppress install or verification errors
- Do NOT introduce new scripts or configuration keys

# Failure Conditions

The agent must fail if:

- The package manager cannot be unambiguously determined
- Dependency installation fails
- `deps:verify` exists and fails
- Dependency constraints conflict and cannot be resolved cleanly

# Success Criteria

- Target package and related packages are updated consistently
- Lockfile reflects the updated dependency graph
- Overrides / resolutions are aligned with new versions
- Dependency verification (if present) passes successfully
  ``
