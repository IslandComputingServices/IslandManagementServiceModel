$version: "2"

namespace com.islandcomputing.ims

use aws.protocols#restJson1
use aws.api#service
use smithy.framework#ValidationException

/// Custom trait for ICS IRN namespace generation
@trait(selector: "service")
structure irnNamespace {
    @required
    value: String
}

/// ICS Island Management Service
/// Manages complete isolated cloud environments (islands) within ICS platform
@service(
    sdkId: "ICS Island Management"
    endpointPrefix: "ims"
)
@irnNamespace("ims")
@restJson1
@title("ICS Island Management Service")
service IslandManagementService {
    version: "2025-09-13"
    operations: [
        CreateIsland
        DescribeIslands
        ModifyIsland
        DeleteIslands
        ResizeIsland
        ConnectIslands
        DisconnectIslands
    ]
    errors: [
        ValidationException
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
        ServiceUnavailableException
    ]
}

// ========== Island Lifecycle Operations ==========

/// Create a new island
@http(method: "POST", uri: "/")
@idempotent
operation CreateIsland {
    input: CreateIslandRequest
    output: CreateIslandResponse
    errors: [
        InvalidParameterException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Describe one or more islands
@http(method: "POST", uri: "/")
@readonly
operation DescribeIslands {
    input: DescribeIslandsRequest
    output: DescribeIslandsResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Modify island configuration (partial updates following ICS standards)
@http(method: "POST", uri: "/")
@idempotent
operation ModifyIsland {
    input: ModifyIslandRequest
    output: ModifyIslandResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Delete one or more islands
@http(method: "POST", uri: "/")
@idempotent
operation DeleteIslands {
    input: DeleteIslandsRequest
    output: DeleteIslandsResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Resize island compute capacity
@http(method: "POST", uri: "/")
@idempotent
operation ResizeIsland {
    input: ResizeIslandRequest
    output: ResizeIslandResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Connect islands for service-to-service communication
@http(method: "POST", uri: "/")
@idempotent
operation ConnectIslands {
    input: ConnectIslandsRequest
    output: ConnectIslandsResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Disconnect islands to remove service-to-service communication
@http(method: "POST", uri: "/")
@idempotent
operation DisconnectIslands {
    input: DisconnectIslandsRequest
    output: DisconnectIslandsResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

// ========== Request/Response Structures ==========

@input
structure CreateIslandRequest {
    @required
    Action: String = "CreateIsland"

    /// User must provide - Organization ID for ICS multi-tenant architecture
    @required
    @pattern("^org-[a-zA-Z0-9-]+$")
    OrganizationId: String

    /// User must provide - Island name
    @required
    @length(min: 1, max: 255)
    Name: String

    /// User must provide - Environment classification
    @required
    EnvironmentType: EnvironmentType

    /// User optional - Island description
    @length(max: 1000)
    Description: String

    /// User optional - Service references (auto-created with defaults if not provided)
    @pattern("^irn:ics:nms:ap-in-1:organization/[a-zA-Z0-9-]+:island-private-zone/[a-zA-Z0-9-]+$")
    IslandPrivateZoneIRN: String

    @pattern("^irn:ics:ssacms:ap-in-1:organization/[a-zA-Z0-9-]+:ssa-config/[a-zA-Z0-9-]+$")
    SSAConfigIRN: String

    /// User optional - Compute configuration (defaults applied if not provided)
    ComputeConfiguration: ComputeConfiguration

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure CreateIslandResponse {
    @required
    Island: Island
}

@input
structure DescribeIslandsRequest {
    @required
    Action: String = "DescribeIslands"

    /// Optional - List of island IRNs to describe
    IslandIds: IslandIdList

    /// Optional - Filters to apply
    Filters: FilterList

    @range(min: 1, max: 1000)
    MaxResults: Integer = 50

    NextToken: String
}

@output
structure DescribeIslandsResponse {
    Islands: IslandList

    NextToken: String
}

@input
structure ModifyIslandRequest {
    @required
    Action: String = "ModifyIsland"

    /// Required - Island IRN to identify what to modify
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandIRN: String

    /// Required - Version for optimistic locking (user must provide current version)
    @required
    @range(min: 1)
    Version: Integer

    /// Optional - Partial updates (ICS standards)
    EnvironmentType: EnvironmentType

    /// Optional - Island description update
    Description: String

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure ModifyIslandResponse {
    @required
    Island: Island
}

@input
structure DeleteIslandsRequest {
    @required
    Action: String = "DeleteIslands"

    /// Required - Island IRNs to delete
    @required
    IslandIds: IslandIdList

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure DeleteIslandsResponse {
    DeletingIslands: IslandStateChangeList
}

@input
structure ResizeIslandRequest {
    @required
    Action: String = "ResizeIsland"

    /// Required - Island IRN to identify what to resize
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandIRN: String

    /// Required - Version for optimistic locking
    @required
    @range(min: 1)
    Version: Integer

    /// Required - New compute configuration
    @required
    ComputeConfiguration: ComputeConfiguration

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure ResizeIslandResponse {
    @required
    Island: Island
}

@input
structure ConnectIslandsRequest {
    @required
    Action: String = "ConnectIslands"

    /// Required - Source island IRN (client)
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    SourceIslandIRN: String

    /// Required - Target island IRN (server)
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    TargetIslandIRN: String

    /// Optional - Allowed APIs for the connection
    AllowedAPIs: StringList

    /// Optional - Rate limiting configuration
    RateLimit: RateLimitConfiguration

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure ConnectIslandsResponse {
    @required
    Connection: IslandConnection
}

@input
structure DisconnectIslandsRequest {
    @required
    Action: String = "DisconnectIslands"

    /// Required - Connection IRN to disconnect
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island-connection/[a-zA-Z0-9-]+$")
    ConnectionIRN: String

    @idempotencyToken
    IdempotencyToken: String
}

@output
structure DisconnectIslandsResponse {
    @required
    Success: Boolean
}

// ========== Core Data Structures ==========

/// Island - Complete isolated cloud environment within ICS platform
structure Island {
    /// System-generated - Island IRN following ICS IRN format
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandIRN: String

    /// System-generated - Short island identifier for convenience
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    IslandId: String

    /// User-provided - Organization ID (for ICS multi-tenant architecture)
    @required
    @pattern("^org-[a-zA-Z0-9-]+$")
    OrganizationId: String

    /// System-managed - Version field required by ICS standards
    @required
    @range(min: 1)
    Version: Integer

    /// User-provided - Island name
    @required
    @length(min: 1, max: 255)
    Name: String

    /// User-provided - Island description
    @length(max: 1000)
    Description: String

    /// System-managed - Island lifecycle state
    @required
    State: IslandState

    /// User-provided - Environment classification
    @required
    EnvironmentType: EnvironmentType

    /// System-generated - Island creation time
    @required
    @timestampFormat("date-time")
    CreatedTime: Timestamp

    /// System-managed - Last modified time
    @required
    @timestampFormat("date-time")
    LastModifiedTime: Timestamp

    /// System-managed - Service integration references (auto-created if not provided)
    @pattern("^irn:ics:nms:ap-in-1:organization/[a-zA-Z0-9-]+:island-private-zone/[a-zA-Z0-9-]+$")
    IslandPrivateZoneIRN: String

    @pattern("^irn:ics:ssacms:ap-in-1:organization/[a-zA-Z0-9-]+:ssa-config/[a-zA-Z0-9-]+$")
    SSAConfigIRN: String

    /// User-configurable - Island-level compute configuration
    ComputeConfiguration: ComputeConfiguration

    /// System-managed - Recent island activities
    RecentActivities: IslandActivityList
}

/// Compute configuration for island auto-scaling
structure ComputeConfiguration {
    /// System-managed - Configuration version (increments with each change)
    @required
    @range(min: 1)
    Version: Integer

    /// User-configurable - ICS native instance type
    @required
    InstanceType: ICSInstanceType

    /// User-configurable - Minimum number of instances (for availability)
    @required
    @range(min: 0, max: 1000)
    MinCapacity: Integer

    /// User-configurable - Maximum number of instances (for cost control)
    @required
    @range(min: 1, max: 1000)
    MaxCapacity: Integer

    /// User-configurable - Desired number of instances (starting point)
    @required
    @range(min: 0, max: 1000)
    DesiredCapacity: Integer

    /// User-configurable - Multi-AZ configuration (true = multiple AZs, false = single AZ)
    MultiAZ: Boolean = true

    /// User-configurable - Operating system
    OperatingSystem: ICSOperatingSystem = "UBUNTU"
}

/// Island connection for service-to-service communication
structure IslandConnection {
    /// System-generated - Connection IRN following ICS IRN format
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island-connection/[a-zA-Z0-9-]+$")
    ConnectionIRN: String

    /// System-generated - Short connection identifier for convenience
    @required
    @pattern("^icon-[a-zA-Z0-9]+$")
    ConnectionId: String

    /// System-managed - Version field required by ICS standards
    @required
    @range(min: 1)
    Version: Integer

    @required
    SourceIslandIRN: String

    @required
    TargetIslandIRN: String

    /// System-determined - Connection type (inferred from organization IDs in IRNs)
    @required
    ConnectionType: ConnectionType

    /// System-generated - Creation time
    @required
    @timestampFormat("date-time")
    CreatedTime: Timestamp

    /// System-managed - Last modified time
    @required
    @timestampFormat("date-time")
    LastModifiedTime: Timestamp

    /// User-configurable - Allowed APIs
    AllowedAPIs: StringList

    /// User-configurable - Rate limiting
    RateLimit: RateLimitConfiguration
}

/// Rate limiting configuration
structure RateLimitConfiguration {
    @required
    @range(min: 1, max: 1000000)
    RequestsPerSecond: Integer

    @range(min: 1, max: 10000)
    BurstCapacity: Integer = 100
}

/// Island activity record
structure IslandActivity {
    @required
    ActivityType: ActivityType

    @required
    @timestampFormat("date-time")
    Timestamp: Timestamp

    @required
    Status: ActivityStatus

    Description: String

    Details: ActivityDetails
}

/// Activity details (flexible structure)
structure ActivityDetails {
    PreviousState: IslandState
    NewState: IslandState
    ComputeChanges: ComputeConfiguration
    ErrorMessage: String
}

/// Filter for describe operations
structure Filter {
    @required
    Name: String

    Values: StringList
}

/// Island state change information
structure IslandStateChange {
    @required
    IslandIRN: String

    @required
    CurrentState: IslandState

    @required
    PreviousState: IslandState
}

// ========== Enums ==========

/// Island lifecycle state
enum IslandState {
    PENDING = "pending"
    CREATING = "creating"
    RUNNING = "running"
    UPDATING = "updating"
    DELETING = "deleting"
    DELETED = "deleted"
    FAILED = "failed"
}

/// Environment classification (simplified)
enum EnvironmentType {
    TEST = "test"
    PRODUCTION = "production"
}

/// ICS native instance types
enum ICSInstanceType {
    ICS_NANO = "ics.nano"
    ICS_MICRO = "ics.micro"
    ICS_SMALL = "ics.small"
    ICS_MEDIUM = "ics.medium"
    ICS_LARGE = "ics.large"
    ICS_XLARGE = "ics.xlarge"
}

/// Operating systems (actual OS options)
enum ICSOperatingSystem {
    UBUNTU = "ubuntu"
    RHEL = "rhel"
}

/// Connection type (inferred from IRNs)
enum ConnectionType {
    INTRA_ORG = "intra-org"
    CROSS_ORG = "cross-org"
}

/// Activity type
enum ActivityType {
    CREATE = "create"
    DELETE = "delete"
    RESIZE = "resize"
    CONNECT = "connect"
    DISCONNECT = "disconnect"
    MODIFY = "modify"
}

/// Activity status
enum ActivityStatus {
    IN_PROGRESS = "in-progress"
    COMPLETED = "completed"
    FAILED = "failed"
}

// ========== Lists ==========

list IslandList {
    member: Island
}

list IslandIdList {
    member: String
}

list IslandActivityList {
    member: IslandActivity
}

list IslandStateChangeList {
    member: IslandStateChange
}

list FilterList {
    member: Filter
}

list StringList {
    member: String
}

// ========== Error Structures ==========

@error("client")
@httpError(400)
structure InvalidParameterException {
    @required
    message: String
}

@error("client")
@httpError(404)
structure ResourceNotFoundException {
    @required
    message: String
}

@error("client")
@httpError(401)
structure UnauthorizedException {
    @required
    message: String
}

@error("client")
@httpError(403)
structure AccessDeniedException {
    @required
    message: String
}

@error("client")
@httpError(429)
structure ThrottlingException {
    @required
    message: String
}

@error("server")
@httpError(500)
structure InternalServerException {
    @required
    message: String
}

@error("server")
@httpError(503)
structure ServiceUnavailableException {
    @required
    message: String
}
