# AI Agent Instructions for IslandsManagementService-vishalsirohi

## 🚨 CRITICAL: ICS IS AN INDEPENDENT CLOUD PLATFORM

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

## 📝 PR DESCRIPTION FILE STANDARDS

### STANDARDIZED FILENAME:
- MUST always use `pr_description.md` as the standard filename
- MUST NOT create multiple PR description files with different names
- MUST overwrite existing `pr_description.md` for new PRs
- MUST clean up any old PR description files with different names
- MUST use `--body-file pr_description.md` when creating PRs

### FILE MANAGEMENT:
- MUST remove old PR description files (e.g., PR_SMITHY_DESCRIPTION.md, PR_DESCRIPTION_CORRECTED.md)
- MUST maintain only one PR description file at a time
- MUST update pr_description.md content for each new PR
- MUST NOT commit multiple PR description files to repository

## 📁 REPOSITORY DIRECTORY STRUCTURE STANDARDS

### DIRECTORY PURPOSE AND ORGANIZATION:
- **`model/`** - MUST contain Smithy IDL models, API models, service definitions
- **`specifications/`** - MUST contain change specifications, enhancement proposals, requirements documents
- **`src/`** - MUST contain implementation code (if present)
- **`docs/`** - MUST contain documentation (if present)

### AGENT DIRECTORY RULES:
- MUST place Smithy IDL models in `model/` directory
- MUST place change specifications and feature requests in `specifications/` directory
- MUST NOT mix models with specifications
- MUST maintain clear separation between current models and future specifications

## 🧠 AGENT CONTEXT UNDERSTANDING REQUIREMENTS

### MANDATORY CONTEXT ANALYSIS:
Agent MUST read and understand ALL existing content before making ANY assumptions:

#### **1. EXISTING MODELS AND SPECIFICATIONS:**
- MUST read all files in `model/` directory to understand current service definitions
- MUST read all files in `specifications/` directory to understand planned changes
- MUST read all files in `src/` directory to understand implementation patterns
- MUST analyze existing Smithy models to understand namespace hierarchy
- MUST understand existing IRN patterns and resource naming conventions

#### **2. NAMESPACE AND PACKAGE ANALYSIS:**
- MUST extract namespace patterns from existing Smithy models (e.g., `com.islandcomputing.ims`)
- MUST understand service abbreviations from existing code (e.g., `ims` for Island Management Service)
- MUST analyze package structure from existing implementations
- MUST identify naming conventions from existing resources
- MUST NEVER assume namespace values without referencing existing patterns

#### **3. IRN FORMAT UNDERSTANDING:**
- MUST read ICS IRN format specifications from ICSCoreStandards
- MUST analyze existing IRN patterns in models to understand service namespaces
- MUST understand IRN hierarchy: `irn:ics:<service>:<region>:organization/<org-id>:island/<island-id>`
- MUST identify correct service namespace from existing models (e.g., `ims` not `core`)
- MUST NEVER assume IRN format components without verification

#### **4. URL AND ENDPOINT ANALYSIS:**
- MUST extract endpoint patterns from existing service definitions
- MUST understand URL structure from existing API specifications
- MUST identify region patterns (e.g., `ap-in-1`) from existing configurations
- MUST analyze domain patterns from existing endpoints
- MUST NEVER assume URL structure without referencing existing patterns

#### **5. CONFIGURATION ATTRIBUTES:**
Agent MUST NEVER assume values for:
- **Service Names** - Extract from existing models and specifications
- **SDK Names** - Reference existing service definitions
- **Package Names** - Analyze existing code structure
- **Email Addresses** - Always ask user or reference existing configurations
- **Domain Names** - Extract from existing endpoint configurations
- **Region Codes** - Reference existing IRN patterns and service definitions
- **Organization IDs** - Use patterns from existing examples
- **Resource Names** - Follow existing naming conventions

### VERIFICATION AND CONFIRMATION PROCESS:

#### **BEFORE MAKING ANY CHANGES:**
1. **READ EXISTING CONTEXT** - Analyze all relevant files in repository
2. **EXTRACT PATTERNS** - Identify existing naming, namespace, and structure patterns
3. **VERIFY ASSUMPTIONS** - Cross-reference with ICS standards and existing implementations
4. **CONFIRM WITH USER** - When patterns are unclear or missing, ask for clarification
5. **DOCUMENT DECISIONS** - Explain reasoning based on existing patterns

#### **WHEN PATTERNS ARE UNCLEAR:**
- MUST ask user for clarification rather than assuming
- MUST provide options based on existing patterns when asking
- MUST explain what existing patterns were found and what is missing
- MUST confirm understanding before proceeding

#### **EXAMPLE VERIFICATION PROCESS:**
```
Agent Analysis:
1. Found namespace "com.islandcomputing.ims" in existing model
2. Found service abbreviation "ims" in @irnNamespace trait
3. Found region "ap-in-1" in existing IRN patterns
4. Missing: email configuration for service contact
5. Action: Ask user for email pattern or reference existing configuration
```

### CONTEXT INFERENCE RULES:

#### **SAFE TO INFER FROM EXISTING PATTERNS:**
- Namespace structure if consistent pattern exists
- Service abbreviations if defined in existing models
- IRN format components if examples exist
- URL patterns if endpoint definitions exist
- Resource naming if conventions are established

#### **MUST ALWAYS ASK USER:**
- Email addresses and contact information
- New service names not in existing patterns
- Domain names not in existing configurations
- Credentials or sensitive configuration
- Business logic decisions not documented

#### **MUST ALWAYS VERIFY:**
- IRN format compliance with ICS standards
- Namespace consistency across all models
- URL structure alignment with existing services
- Configuration attribute correctness

### ERROR PREVENTION:

#### **COMMON MISTAKES TO AVOID:**
- Assuming AWS patterns when ICS is independent platform
- Using generic values without checking existing patterns
- Creating inconsistent namespaces across models
- Mixing service abbreviations (e.g., using both "islands" and "ims")
- Hardcoding configuration values without verification

#### **VALIDATION CHECKLIST:**
- [ ] All namespaces consistent with existing patterns
- [ ] All IRN formats match ICS standards and existing examples
- [ ] All service names align with existing definitions
- [ ] All configuration attributes verified or confirmed with user
- [ ] All assumptions documented and justified

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
