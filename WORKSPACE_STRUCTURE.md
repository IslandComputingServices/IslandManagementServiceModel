# Workspace Structure

This workspace follows ICS standards for multi-repository system development.

## Directory Structure

```
{WorkspaceName}/
├── ICSCoreStandards/           # ICS standards (auto-downloaded)
├── packages/                   # All packages/repositories for this system
│   ├── data-access-layer/      # Data Access Layer repositories
│   ├── business-layer/         # Business Logic Layer repositories
│   ├── api-layer/              # API Layer repositories
│   ├── presentation-layer/     # Presentation Layer repositories
│   └── shared/                 # Shared libraries and common types
├── specifications/             # System-wide specifications
├── docs/                       # System documentation
├── scripts/                    # Build and deployment scripts
├── AI_AGENT_INSTRUCTIONS.md    # AI agent guidance
└── WORKSPACE_STRUCTURE.md      # This file
```

## Multi-Repository Architecture

### Layer Organization
Each layer can contain one or more repositories:

**Data Access Layer (`packages/data-access-layer/`)**
- `{component}-dal/` - Data access repositories
- `{model}-data-model/` - Data model repositories
- `{model}-adt/` - Abstract Data Type repositories

**Business Layer (`packages/business-layer/`)**
- `{component}-business/` - Business logic repositories
- `{domain}-services/` - Domain service repositories

**API Layer (`packages/api-layer/`)**
- `{component}-api/` - API repositories
- `{model}-api-model/` - API model repositories

**Presentation Layer (`packages/presentation-layer/`)**
- `{component}-ui/` - Frontend repositories
- `{app}-web/` - Web application repositories

**Shared (`packages/shared/`)**
- `{model}-common-types/` - Common type repositories
- `{component}-interfaces/` - Shared interface repositories
- `{utility}-libs/` - Utility library repositories

### Repository Creation Process

1. **Create New Repository**
```bash
cd packages/{layer}/
git clone https://github.com/org/{repo-name}.git
# OR create new repository
mkdir {repo-name} && cd {repo-name} && git init
```

2. **Follow Layer Standards**
- Each repository must follow ICS layer architecture standards
- Repositories must only import from allowed layers
- Cross-layer communication must use defined interfaces

3. **Maintain Dependencies**
- Document inter-repository dependencies
- Use semantic versioning for repository releases
- Maintain dependency compatibility matrices

## Development Workflow

### 1. System-Wide Specifications
Create specifications in `specifications/` that cover the entire system:
- System architecture specification
- Cross-component integration specification
- Shared data model specifications

### 2. Repository-Specific Development
For each repository in `packages/`:
- Follow ICS development process (Specifications → Interfaces → Implementation)
- Maintain repository-specific documentation
- Ensure layer compliance

### 3. Integration and Testing
- Test repository interactions
- Validate layer boundary compliance
- Ensure system-wide functionality

## AI Agent Guidelines

When working with multi-repository workspaces:

### Repository Creation
- Ask for approval before creating new repositories
- Follow naming conventions: `{component}-{layer}`
- Place repositories in appropriate layer directories

### Cross-Repository Development
- Maintain clear boundaries between repositories
- Use only approved interfaces for communication
- Document dependencies between repositories

### Layer Compliance
- Ensure each repository follows its layer's constraints
- Validate that repositories only import from allowed layers
- Maintain proper abstraction levels
