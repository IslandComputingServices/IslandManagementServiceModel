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

/// ICS Island Management Service - Native service for managing compute islands
@service(
    sdkId: "ICS Island Management"
    endpointPrefix: "ims"
)
@irnNamespace("ims")
@restJson1
@title("ICS Island Management Service")
service IslandManagementService {
    version: "2025-09-08"
    operations: [
        LaunchIsland
        DescribeIslands
        ModifyIsland
        TerminateIslands
        ScaleIsland
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

// ========== Operations ==========

/// Launch a new island with specified configuration
@http(method: "POST", uri: "/")
@idempotent
operation LaunchIsland {
    input: LaunchIslandRequest
    output: LaunchIslandResponse
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
@paginated(
    inputToken: "nextToken"
    outputToken: "nextToken"
    pageSize: "maxResults"
)
operation DescribeIslands {
    input: DescribeIslandsRequest
    output: DescribeIslandsResponse
    errors: [
        InvalidParameterException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Modify island configuration
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

/// Terminate one or more islands
@http(method: "POST", uri: "/")
@idempotent
operation TerminateIslands {
    input: TerminateIslandsRequest
    output: TerminateIslandsResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

/// Scale island compute capacity
@http(method: "POST", uri: "/")
@idempotent
operation ScaleIsland {
    input: ScaleIslandRequest
    output: ScaleIslandResponse
    errors: [
        InvalidParameterException
        ResourceNotFoundException
        UnauthorizedException
        AccessDeniedException
        ThrottlingException
        InternalServerException
    ]
}

// ========== Request Structures ==========

@input
structure LaunchIslandRequest {
    /// The action to perform
    @required
    Action: String = "LaunchIsland"

    /// Name of the island
    @required
    @length(min: 1, max: 255)
    Name: String

    /// Organization identifier
    @required
    @pattern("^org-[a-zA-Z0-9-]+$")
    OrganizationId: String

    /// Environment classification
    @required
    EnvironmentType: EnvironmentType

    /// Description of the island
    @length(max: 1000)
    Description: String

    /// Compute configuration
    Compute: ComputeSpecification

    /// Storage attachments
    BlockDeviceMappings: BlockDeviceMappingList

    /// Idempotency token for safe retries
    @idempotencyToken
    IdempotencyToken: String
}

@input
structure DescribeIslandsRequest {
    /// The action to perform
    @required
    Action: String = "DescribeIslands"

    /// List of island IRNs to describe
    IslandIds: IslandIdList

    /// Filters to apply
    Filters: FilterList

    /// Maximum number of results to return
    @range(min: 1, max: 1000)
    MaxResults: Integer = 50

    /// Token for pagination
    NextToken: String
}

@input
structure ModifyIslandRequest {
    /// The action to perform
    @required
    Action: String = "ModifyIsland"

    /// Island IRN to modify
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandId: String

    /// Environment classification
    EnvironmentType: EnvironmentType

    /// Compute configuration changes
    Compute: ComputeSpecification

    /// Idempotency token for safe retries
    @idempotencyToken
    IdempotencyToken: String
}

@input
structure TerminateIslandsRequest {
    /// The action to perform
    @required
    Action: String = "TerminateIslands"

    /// List of island IRNs to terminate
    @required
    IslandIds: IslandIdList

    /// Idempotency token for safe retries
    @idempotencyToken
    IdempotencyToken: String
}

@input
structure ScaleIslandRequest {
    /// The action to perform
    @required
    Action: String = "ScaleIsland"

    /// Island IRN to scale
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandId: String

    /// Compute scaling configuration
    Compute: ComputeSpecification

    /// Idempotency token for safe retries
    @idempotencyToken
    IdempotencyToken: String
}

// ========== Response Structures ==========

@output
structure LaunchIslandResponse {
    /// The launched island
    @required
    Island: Island

    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

@output
structure DescribeIslandsResponse {
    /// List of islands
    @required
    Islands: IslandList

    /// Token for next page of results
    NextToken: String

    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

@output
structure ModifyIslandResponse {
    /// The modified island
    @required
    Island: Island

    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

@output
structure TerminateIslandsResponse {
    /// Islands being terminated
    @required
    TerminatingIslands: IslandStateChangeList

    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

@output
structure ScaleIslandResponse {
    /// Scaling activity information
    @required
    ScalingActivity: ScalingActivity

    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

// ========== Core Data Structures ==========

/// Core island resource model
structure Island {
    /// Full island IRN following ICS standards
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandIRN: String

    /// Short island identifier for convenience
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    IslandId: String

    /// Island name
    @required
    @length(min: 1, max: 255)
    Name: String

    /// Island description
    @length(max: 1000)
    Description: String

    /// Island lifecycle state
    @required
    State: IslandState

    /// Environment classification
    @required
    EnvironmentType: EnvironmentType

    /// Island launch time
    @required
    @timestampFormat("date-time")
    LaunchTime: Timestamp

    /// Compute configuration
    Compute: ComputeConfiguration

    /// Storage attachments
    BlockDeviceMappings: BlockDeviceMappingList
}

/// Compute configuration for island
structure ComputeConfiguration {
    /// Instance type
    @required
    InstanceType: InstanceType

    /// Minimum number of instances
    @required
    @range(min: 0, max: 1000)
    MinSize: Integer

    /// Maximum number of instances
    @required
    @range(min: 0, max: 1000)
    MaxSize: Integer

    /// Desired number of instances
    @required
    @range(min: 0, max: 1000)
    DesiredCapacity: Integer

    /// Health check type
    HealthCheckType: HealthCheckType = "ELB"

    /// Health check grace period in seconds
    @range(min: 0, max: 7200)
    HealthCheckGracePeriod: Integer = 300
}

/// Compute specification for requests
structure ComputeSpecification {
    /// Instance type
    @required
    InstanceType: InstanceType

    /// Minimum number of instances
    @range(min: 0, max: 1000)
    MinSize: Integer = 1

    /// Maximum number of instances
    @range(min: 0, max: 1000)
    MaxSize: Integer = 10

    /// Desired number of instances
    @range(min: 0, max: 1000)
    DesiredCapacity: Integer
}

/// Storage attachment configuration
structure BlockDeviceMapping {
    /// Device name
    @required
    DeviceName: String

    /// EBS configuration
    @required
    Ebs: EbsBlockDevice
}

/// EBS block device configuration
structure EbsBlockDevice {
    /// Volume size in GB (local storage at hypervisor level)
    @required
    @range(min: 1, max: 16384)
    VolumeSize: Integer = 20

    /// Volume type (only local storage supported)
    @required
    VolumeType: VolumeType = "local"

    /// Delete on termination
    DeleteOnTermination: Boolean = true
}

/// Filter for describe operations
structure Filter {
    /// Filter name
    @required
    Name: FilterName

    /// Filter values
    @required
    Values: FilterValueList
}

/// Island state change information
structure IslandStateChange {
    /// Island IRN
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandId: String

    /// Current state
    @required
    CurrentState: IslandStateInfo

    /// Previous state
    @required
    PreviousState: IslandStateInfo
}

/// Island state information
structure IslandStateInfo {
    /// State code
    @required
    Code: Integer

    /// State name
    @required
    Name: String
}

/// Scaling activity information
structure ScalingActivity {
    /// Activity IRN
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+:resource/[a-zA-Z0-9-]+$")
    ActivityId: String

    /// Activity status
    @required
    Status: ScalingActivityStatus

    /// Activity start time
    @required
    @timestampFormat("date-time")
    StartTime: Timestamp

    /// Activity description
    Description: String
}

/// Response metadata
structure ResponseMetadata {
    /// Request identifier
    @required
    @pattern("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$")
    RequestId: String
}

// ========== Enums ==========

/// Island lifecycle states
enum IslandState {
    PENDING = "pending"
    PROVISIONING = "provisioning"
    RUNNING = "running"
    STOPPING = "stopping"
    STOPPED = "stopped"
    SHUTTING_DOWN = "shutting-down"
    TERMINATED = "terminated"
}

/// Environment classification types
enum EnvironmentType {
    TESTING = "testing"
    STAGING = "staging"
    PRODUCTION = "production"
}

/// Instance types following industry standards
enum InstanceType {
    T3_MICRO = "t3.micro"
    T3_SMALL = "t3.small"
    T3_MEDIUM = "t3.medium"
    T3_LARGE = "t3.large"
    T3_XLARGE = "t3.xlarge"
    T3_2XLARGE = "t3.2xlarge"
}

/// Health check types
enum HealthCheckType {
    ELB = "ELB"
    ICS = "ICS"
}

/// Volume types (local storage only)
enum VolumeType {
    LOCAL = "local"
}

/// Filter names for describe operations
enum FilterName {
    STATE = "state"
    ENVIRONMENT_TYPE = "environment-type"
    INSTANCE_TYPE = "instance-type"
}

/// Scaling activity status
enum ScalingActivityStatus {
    IN_PROGRESS = "InProgress"
    SUCCESSFUL = "Successful"
    CANCELLED = "Cancelled"
    FAILED = "Failed"
}

// ========== Lists ==========

list IslandIdList {
    member: String
}

list IslandList {
    member: Island
}

list BlockDeviceMappingList {
    member: BlockDeviceMapping
}

list FilterList {
    member: Filter
}

list FilterValueList {
    member: String
}

list IslandStateChangeList {
    member: IslandStateChange
}

// ========== Error Structures ==========

/// Invalid parameter error
@error("client")
@httpError(400)
structure InvalidParameterException {
    @required
    message: String
}

/// Resource not found error
@error("client")
@httpError(404)
structure ResourceNotFoundException {
    @required
    message: String
}

/// Unauthorized operation error
@error("client")
@httpError(401)
structure UnauthorizedException {
    @required
    message: String
}

/// Access denied error
@error("client")
@httpError(403)
structure AccessDeniedException {
    @required
    message: String
}

/// Throttling error
@error("client")
@httpError(429)
structure ThrottlingException {
    @required
    message: String
    
    /// Seconds to wait before retrying
    retryAfterSeconds: Integer
}

/// Internal server error
@error("server")
@httpError(500)
structure InternalServerException {
    @required
    message: String
}

/// Service unavailable error
@error("server")
@httpError(503)
structure ServiceUnavailableException {
    @required
    message: String
    
    /// Seconds to wait before retrying
    retryAfterSeconds: Integer
}
