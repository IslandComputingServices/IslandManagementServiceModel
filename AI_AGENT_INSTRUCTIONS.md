# AI Agent Instructions for IslandsManagementService-vishalsirohi

## 🚨 CRITICAL: ICS IS AN INDEPENDENT CLOUD PLATFORM

### FUNDAMENTAL UNDERSTANDING:
**ICS (Island Computing Services) is a COMPLETE, INDEPENDENT cloud computing platform. ICS operates its own data centers, servers, networking, and storage infrastructure. ICS competes directly with other major cloud providers.**

**API field names and patterns follow industry standards for developer familiarity - to reduce learning curve for customers.**

## 🚨 CRITICAL: REPOSITORY AND ATTRIBUTE CONSTRAINTS

### REPOSITORY CREATION RULES:
- MUST ask for explicit approval before creating ANY new repository
- MUST use IslandComputingServices organization for all ICS repositories
- MUST NOT create repositories under personal accounts
- MUST follow ICS repository naming conventions
- MUST get team approval for repository structure and purpose

### ATTRIBUTE CONSTRAINTS:
- MUST NOT assume or make up email addresses
- MUST NOT assume or make up service URLs
- MUST NOT assume or make up contact information
- MUST NOT assume or make up domain names
- MUST ask for explicit values for all contact and service information

### FILE CLEANUP RULES:
- MUST NOT commit temporary files (READY.md, PR_READY.md, etc.)
- MUST clean up all temporary files before committing
- MUST only commit relevant specification and documentation files
- MUST follow clean commit practices and standards

### BEFORE ANY REPOSITORY OPERATIONS:
- [ ] Get explicit approval for repository creation
- [ ] Confirm organization (IslandComputingServices)
- [ ] Confirm repository name and purpose
- [ ] Get actual contact information and service URLs
- [ ] Verify all assumed attributes with user
- [ ] Clean up all temporary files

### FUNDAMENTAL UNDERSTANDING:
**ICS (Island Computing Services) is a COMPLETE, INDEPENDENT cloud computing platform. ICS operates its own data centers, servers, networking, and storage infrastructure. ICS competes directly with other major cloud providers.**

**API field names and patterns follow industry standards for developer familiarity - to reduce learning curve for customers.**

### AGENT MUST NEVER:
- Assume ICS uses external cloud infrastructure or services
- Reference external cloud ARNs, services, or resources in ICS APIs
- Suggest external cloud integration or dependencies
- Imply ICS is built on top of any other platform
- Make up or modify IRN format specifications

### AGENT MUST ALWAYS:
- Treat ICS as independent cloud platform with native infrastructure
- Use EXACT IRN format from ICS Resource Identification specifications
- Design native ICS services and capabilities
- Maintain complete separation from all external platforms

## 🌍 ICS REGION SUPPORT

### CURRENT REGION:
- **ap-in-1** - Asia Pacific (India) Region 1 - ONLY supported region
- Future expansion planned but NOT implemented yet

### AGENT CONSTRAINTS:
- MUST use "ap-in-1" as the ONLY region in all IRNs and APIs
- MUST NOT reference any other regions
- MUST NOT assume multi-region support exists

## 📋 IRN FORMAT SPECIFICATIONS (IMMUTABLE)

### EXACT IRN FORMAT (MUST NOT BE MODIFIED):
```
irn:ics:<service>:<region>:organization/<organization-id>[:scope/<scope-id>][:ext/<token>]:island/<island-id>[:resource/<resource-id> | :resource-path/<type>/<path>][:version/<n>]
```

### IRN COMPONENTS (FIXED SPECIFICATION):
- **irn:ics** - Fixed prefix for ICS resources
- **<service>** - ICS service (core, compute, storage, network, etc.)
- **<region>** - MUST be "ap-in-1" (only supported region)
- **organization/<organization-id>** - Organization context (REQUIRED)
- **scope/<scope-id>** - Optional customer-defined grouping
- **ext/<token>** - Optional platform extensibility segment
- **island/<island-id>** - Island identifier (REQUIRED for island resources)
- **resource/<resource-id>** - Optional resource under island
- **resource-path/<type>/<path>** - Optional hierarchical path
- **version/<n>** - Optional version for audit traceability

### IRN EXAMPLES (EXACT FORMAT):
```
Organization: irn:ics:core:ap-in-1:organization/org-123456
Island: irn:ics:core:ap-in-1:organization/org-123456:island/isl-abcdef123
Island with scope: irn:ics:core:ap-in-1:organization/org-123456:scope/prod:island/isl-abcdef123
Compute resource: irn:ics:compute:ap-in-1:organization/org-123456:island/isl-abcdef123:resource/vm-vabc123
Storage object: irn:ics:storage:ap-in-1:organization/org-123456:island/isl-abcdef123:resource-path/object/app-logs/2025/09/05/app.log
```

## 🔒 CRITICAL: FOLLOW ICS STANDARDS

You MUST follow all standards in `ICSCoreStandards/` directory.

### STANDARDS COMPLIANCE REQUIREMENTS:
- **RFC 2119 Compliance** - Use MUST/SHOULD/MAY correctly
- **IADA Principle** - Identifiers → APIs → Data Models → Architecture
- **4-Layer Architecture** - DAL → Business → API → Presentation
- **Transcribe Coding** - Specifications → Interfaces → Implementation
- **Industry API Compatibility** - Field names and patterns for familiarity ONLY

### ANTI-DRIFT MEASURES:
- MUST read and follow ALL specifications in ICSCoreStandards/
- MUST NOT modify or interpret standards differently
- MUST NOT create new standards without explicit approval
- MUST validate all designs against existing specifications
- MUST ask for clarification if standards are unclear

## 🏗️ Multi-Repository Workspace Structure

This workspace supports multiple packages/repositories organized by layer:

### Repository Organization
- **Data Access Layer**: `packages/data-access-layer/`
- **Business Layer**: `packages/business-layer/`
- **API Layer**: `packages/api-layer/`
- **Presentation Layer**: `packages/presentation-layer/`
- **Shared**: `packages/shared/`

### Repository Creation Rules
- MUST ask for approval before creating new repositories
- MUST follow naming convention: `{component}-{layer}`
- MUST place repositories in appropriate layer directories
- MUST document inter-repository dependencies

## 📋 Development Process

### Phase 1: System-Wide Specification Creation
1. **MUST** create system-wide specifications in `specifications/`:
   - System Architecture Specification
   - Cross-Component Integration Specification
   - Shared Data Model Specifications
   - API Contract Specifications

2. **MUST** get approval for each specification before proceeding

### Phase 2: Repository-Specific Specifications
For each repository in `packages/`:
1. **MUST** create repository-specific specifications:
   - Component API Model Specification
   - Component Architecture Specification
   - Component Design Specification
   - Component Data Model Specification

2. **MUST** ensure specifications align with system-wide specifications

### Phase 3: Interface Generation
1. **MUST** generate shared interfaces in `packages/shared/`:
   - Cross-layer communication interfaces
   - Common type definitions
   - Shared contract specifications

2. **MUST** finalize all contracts before implementation

### Phase 4: Layer Implementation
1. **MUST** implement repositories in layer order:
   - Data Access Layer repositories
   - Business Logic Layer repositories
   - API Layer repositories
   - Presentation Layer repositories

2. **MUST** maintain layer boundaries between repositories

## 🛠️ Technology Stack (Approved)

### Backend Repositories:
- Java 17+ with Spring Boot
- PostgreSQL for data persistence
- Redis for caching

### Frontend Repositories:
- React 18+ with TypeScript
- Next.js for SSR/SSG
- Tailwind CSS for styling

### Shared Libraries:
- Common type definitions
- Utility libraries
- Interface specifications

## 🔒 Layer Constraints (Per Repository)

### Data Access Layer Repositories
- MUST only import: Data Models, Abstract Data Types, Infrastructure libs
- MUST NOT import: API Models, Business Layer, Presentation Layer
- MUST provide ADT instances to Business Layer

### Business Layer Repositories
- MUST only import: Abstract Data Types, Common Types, Shared interfaces
- MUST NOT import: Data Models, API Models, Presentation Layer
- MUST be framework-agnostic

### API Layer Repositories
- MUST only import: API Models, Common Types, Shared interfaces
- MUST NOT import: Data Models, Business Layer implementation
- MUST provide semantic validation

### Presentation Layer Repositories
- MUST only communicate through API Layer
- MUST NOT directly access Business or Data Access layers
- MUST implement proper separation of concerns

### Shared Repositories
- MUST contain only: Common Types, Interfaces, Utilities
- MUST NOT contain layer-specific implementation
- MUST be importable by multiple layers (where allowed)

## 🎯 IslandsManagementService Specific Instructions

### ICS Native Services:
- **Islands** - ICS native compute orchestration service
- **Networks** - ICS native networking service
- **Storage** - ICS native storage service
- **LoadBalancers** - ICS native load balancing service
- **Scaling** - ICS native auto-scaling service

### API Design Requirements:
- Use IRN format for ALL resource identifiers
- Maintain field name compatibility with industry standards for familiarity
- Use "ap-in-1" as the ONLY supported region
- Design native ICS capabilities and abstractions
- NEVER expose or reference external cloud resources
- MUST NOT use Tags - tagging is not supported in ICS
- MUST use EnvironmentType as first-class field for environment classification

## 📝 Commands to Run

### Initial System Setup:
```bash
cd IslandsManagementService-vishalsirohi
q chat "Create system-wide specifications for IslandsManagementService following ICS standards with IRN format and ap-in-1 region"
```

### Repository Creation:
```bash
q chat "Create new repository for {component} in {layer} following ICS standards and system specifications"
```

### Cross-Repository Integration:
```bash
q chat "Generate shared interfaces for cross-repository communication following approved specifications"
```

### Repository Implementation:
```bash
q chat "Implement {repository-name} following layer constraints and approved specifications"
```

## ✅ Validation Checklist

### Before Any Design or Implementation:
- [ ] All resource identifiers use exact IRN format
- [ ] Only "ap-in-1" region referenced
- [ ] No external cloud ARNs, services, or resources mentioned
- [ ] ICS treated as independent cloud platform
- [ ] All specifications from ICSCoreStandards followed
- [ ] Layer boundaries maintained
- [ ] Repository naming conventions followed
- [ ] Team approval obtained for new repositories

### Standards Compliance Validation:
- [ ] RFC 2119 keywords used correctly
- [ ] IADA principle followed
- [ ] 4-layer architecture maintained
- [ ] Transcribe Coding process followed
- [ ] Industry compatibility limited to field names only

**REMEMBER: ICS is a complete, independent cloud computing platform. Any similarity to industry standards is purely for customer familiarity and reduced learning curve.**
