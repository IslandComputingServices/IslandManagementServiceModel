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
        ResizeIsland
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

/// Resize island compute capacity (scale up or down)
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

    /// Deployment configuration (optional - reasonable defaults applied if not specified)
    DeploymentConfig: DeploymentPreferences

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
structure ResizeIslandRequest {
    /// The action to perform
    @required
    Action: String = "ResizeIsland"

    /// Island IRN to resize
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+$")
    IslandId: String

    /// Compute resizing configuration
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
structure ResizeIslandResponse {
    /// Resizing activity information
    @required
    ResizingActivity: ResizingActivity

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

    /// Compute configurations (supports transition states)
    Compute: ComputeConfigurationList

    /// Application deployment configurations
    Deployments: DeploymentConfigurationList

    /// Operational context and runtime state
    OperationalConfig: OperationalConfiguration

    /// Storage attachments
    BlockDeviceMappings: BlockDeviceMappingList
}

/// Compute configuration for island
structure ComputeConfiguration {
    /// Configuration version (increments with each change)
    @required
    Version: Integer

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

    /// Current running instance count for this configuration
    @required
    @range(min: 0, max: 1000)
    RunningCount: Integer

    /// Configuration status
    @required
    Status: ComputeConfigurationStatus

    /// Deployment strategy for this configuration
    DeploymentStrategy: DeploymentStrategy

    /// Health check type
    HealthCheckType: HealthCheckType = "ILB"

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

    /// Deployment strategy for updates
    DeploymentStrategy: DeploymentStrategy = "RollingUpdate"
}

/// Application deployment configuration
structure DeploymentConfiguration {
    /// Deployment version (increments with each deployment)
    @required
    Version: Integer

    /// Application identifier
    @required
    @length(min: 1, max: 255)
    ApplicationName: String

    /// Container image specification
    @required
    Image: ContainerImage

    /// Deployment preferences and constraints
    @required
    DeploymentPreferences: DeploymentPreferences

    /// Current deployment status
    @required
    Status: DeploymentStatus

    /// Number of instances running this deployment
    @required
    @range(min: 0, max: 1000)
    RunningCount: Integer

    /// Deployment start time
    @required
    @timestampFormat("date-time")
    StartTime: Timestamp

    /// Deployment completion time (if finished)
    @timestampFormat("date-time")
    CompletionTime: Timestamp

    /// Deployment description or change notes
    @length(max: 1000)
    Description: String
}

/// Container image specification
structure ContainerImage {
    /// Container registry URI
    @required
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]/[a-zA-Z0-9][a-zA-Z0-9._/-]*[a-zA-Z0-9]:[a-zA-Z0-9._-]+$")
    ImageUri: String

    /// Image digest for immutable reference
    @pattern("^sha256:[a-f0-9]{64}$")
    ImageDigest: String

    /// Image pull policy
    PullPolicy: ImagePullPolicy = "IfNotPresent"
}

/// Deployment preferences - all configuration in one place
structure DeploymentPreferences {
    /// Deployment type - rolling or blue-green
    @required
    DeploymentType: DeploymentType = "ROLLING"

    /// Minimum percentage of instances that must stay healthy during deployment
    @required
    @range(min: 0, max: 100)
    MinHealthyPercentage: Integer = 75

    /// Maximum percentage of total capacity allowed during deployment (for surge capacity)
    @required
    @range(min: 100, max: 300)
    MaxCapacityPercentage: Integer = 150

    /// Deployment timeout in minutes
    @range(min: 1, max: 1440)
    TimeoutMinutes: Integer = 30

    /// Deployment block windows (maintenance windows)
    BlockWindows: DeploymentBlockWindowList

    /// Canary deployment configuration
    CanaryConfig: CanaryConfiguration

    /// Rollback configuration
    RollbackConfig: RollbackConfiguration
}

/// Deployment mode - clear outcomes customers can understand and predict
enum DeploymentMode {
    ZERO_DOWNTIME = "zero-downtime"      // Guarantee no service interruption (may cost 2x during deployment)
    MINIMAL_RISK = "minimal-risk"        // Keep 90% capacity, replace 10% at a time (may cost 1.1x during deployment)  
    COST_OPTIMIZED = "cost-optimized"    // No extra cost, replace instances one-by-one (slower deployment)
}

/// Canary deployment configuration
structure CanaryConfiguration {
    /// Enable canary deployment
    Enabled: Boolean = false

    /// Percentage of traffic for canary
    @range(min: 1, max: 50)
    TrafficPercentage: Integer = 10

    /// Canary duration in minutes before full rollout
    @range(min: 5, max: 1440)
    DurationMinutes: Integer = 15

    /// Success criteria for canary promotion
    SuccessCriteria: CanarySuccessCriteria
}

/// Canary success criteria
structure CanarySuccessCriteria {
    /// Maximum error rate percentage for success
    @range(min: 0, max: 100)
    MaxErrorRate: Double = 5.0

    /// Minimum success rate percentage for success
    @range(min: 0, max: 100)
    MinSuccessRate: Double = 95.0

    /// Required number of successful requests
    @range(min: 1, max: 10000)
    MinRequestCount: Integer = 100
}

/// Rollback configuration
structure RollbackConfiguration {
    /// Enable automatic rollback on failure
    AutoRollbackEnabled: Boolean = true

    /// Rollback triggers
    RollbackTriggers: RollbackTriggerList

    /// Maximum rollback attempts
    @range(min: 1, max: 10)
    MaxRollbackAttempts: Integer = 3
}

/// Rollback trigger conditions
structure RollbackTrigger {
    /// Trigger type
    @required
    Type: RollbackTriggerType

    /// Threshold value for trigger
    @required
    Threshold: Double

    /// Duration in minutes to evaluate trigger
    @range(min: 1, max: 60)
    EvaluationMinutes: Integer = 5
}

/// Deployment block window (maintenance window)
structure DeploymentBlockWindow {
    /// Block window name
    @required
    @length(min: 1, max: 100)
    Name: String

    /// Start time (cron expression or ISO 8601)
    @required
    StartTime: String

    /// End time (cron expression or ISO 8601)
    @required
    EndTime: String

    /// Time zone for the window
    TimeZone: String = "UTC"

    /// Recurrence pattern
    Recurrence: RecurrencePattern
}

/// Operational configuration for runtime context
structure OperationalConfiguration {
    /// Application environment context
    @required
    Environment: EnvironmentType

    /// Application stage within environment
    Stage: ApplicationStage = "stable"

    /// Feature flags and toggles
    FeatureFlags: FeatureFlagMap

    /// Environment variables for applications
    EnvironmentVariables: EnvironmentVariableMap

    /// Resource quotas and limits
    ResourceQuotas: ResourceQuotaConfiguration

    /// Monitoring and observability configuration
    ObservabilityConfig: ObservabilityConfiguration
}

/// Resource quota configuration per tenant/workload
structure ResourceQuotaConfiguration {
    /// Maximum CPU cores per application
    @range(min: 0.1, max: 1000.0)
    MaxCpuCores: Double = 4.0

    /// Maximum memory in GB per application
    @range(min: 0.1, max: 1000.0)
    MaxMemoryGb: Double = 8.0

    /// Maximum storage in GB per application
    @range(min: 1, max: 10000)
    MaxStorageGb: Integer = 100

    /// Maximum network bandwidth in Mbps
    @range(min: 1, max: 10000)
    MaxNetworkMbps: Integer = 1000

    /// Request rate limit per second
    @range(min: 1, max: 100000)
    RequestRateLimit: Integer = 1000
}

/// Observability configuration
structure ObservabilityConfiguration {
    /// Enable structured logging
    LoggingEnabled: Boolean = true

    /// Log level
    LogLevel: LogLevel = "INFO"

    /// Enable metrics collection
    MetricsEnabled: Boolean = true

    /// Enable distributed tracing
    TracingEnabled: Boolean = true

    /// Sampling rate for tracing (0.0 to 1.0)
    @range(min: 0.0, max: 1.0)
    TracingSampleRate: Double = 0.1
}

/// Storage attachment configuration
structure BlockDeviceMapping {
    /// Device name
    @required
    DeviceName: String

    /// IBS configuration
    @required
    Ibs: IbsBlockDevice
}

/// IBS block device configuration
structure IbsBlockDevice {
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

/// Resizing activity information
structure ResizingActivity {
    /// Activity IRN
    @required
    @pattern("^irn:ics:ims:ap-in-1:organization/[a-zA-Z0-9-]+:island/[a-zA-Z0-9-]+:resource/[a-zA-Z0-9-]+$")
    ActivityId: String

    /// Activity status
    @required
    Status: ResizingActivityStatus

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
    UPDATING = "updating"
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
    ILB = "ILB"
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

/// Resizing activity status
enum ResizingActivityStatus {
    IN_PROGRESS = "InProgress"
    SUCCESSFUL = "Successful"
    CANCELLED = "Cancelled"
    FAILED = "Failed"
}

/// Compute configuration status
enum ComputeConfigurationStatus {
    PROVISIONING = "provisioning"
    RUNNING = "running"
    DRAINING = "draining"
    TERMINATING = "terminating"
}

/// Deployment type
enum DeploymentType {
    ROLLING = "rolling"         // Rolling deployment - replace instances gradually
    BLUE_GREEN = "blue-green"   // Blue-green deployment - full environment switch
}

/// Deployment strategy for compute updates
enum DeploymentStrategy {
    ROLLING_UPDATE = "RollingUpdate"
    BLUE_GREEN = "BlueGreen"
}

/// Deployment status
enum DeploymentStatus {
    PENDING = "pending"
    IN_PROGRESS = "in-progress"
    SUCCESSFUL = "successful"
    FAILED = "failed"
    ROLLING_BACK = "rolling-back"
    ROLLED_BACK = "rolled-back"
}

/// Container image pull policy
enum ImagePullPolicy {
    ALWAYS = "Always"
    IF_NOT_PRESENT = "IfNotPresent"
    NEVER = "Never"
}

/// Application stage within environment
enum ApplicationStage {
    CANARY = "canary"
    STABLE = "stable"
    DEPRECATED = "deprecated"
}

/// Rollback trigger types
enum RollbackTriggerType {
    ERROR_RATE = "ErrorRate"
    RESPONSE_TIME = "ResponseTime"
    HEALTH_CHECK_FAILURE = "HealthCheckFailure"
    CUSTOM_METRIC = "CustomMetric"
}

/// Recurrence pattern for block windows
enum RecurrencePattern {
    DAILY = "daily"
    WEEKLY = "weekly"
    MONTHLY = "monthly"
    NONE = "none"
}

/// Log levels
enum LogLevel {
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARN"
    ERROR = "ERROR"
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

list ComputeConfigurationList {
    member: ComputeConfiguration
}

list DeploymentConfigurationList {
    member: DeploymentConfiguration
}

list DeploymentBlockWindowList {
    member: DeploymentBlockWindow
}

list RollbackTriggerList {
    member: RollbackTrigger
}

map FeatureFlagMap {
    key: String
    value: Boolean
}

map EnvironmentVariableMap {
    key: String
    value: String
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
