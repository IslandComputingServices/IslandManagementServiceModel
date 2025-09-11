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
    version: "2025-09-11"
    operations: [
        LaunchIsland
        DescribeIslands
        ModifyIsland
        TerminateIslands
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

/// Connect islands to allow one-way communication from source to target
/// 
/// This creates a ONE-WAY connection allowing the source island to make 
/// requests to the target island.
/// 
/// For two-way communication, make two separate ConnectIslands calls.
/// However, you must think twice before creating a cyclic dependency
/// as it can lead to complex failure scenarios and tight coupling.
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

/// Disconnect islands by removing communication rules
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

@input
structure ConnectIslandsRequest {
    /// The action to perform
    @required
    Action: String = "ConnectIslands"

    /// Source island that will make requests (client)
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    SourceIslandId: String
    
    /// Target island that will receive requests (server)
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    TargetIslandId: String
    
    /// API patterns that source can access on target
    /// Examples: ["*"], ["/api/users/*", "/v1/payments"]
    AllowedAPIs: APIPatternList = ["*"]
    
    /// Rate limit for source→target requests
    RateLimit: RateLimitConfiguration
    
    /// Idempotency token for safe retries
    @idempotencyToken
    IdempotencyToken: String
}

@input
structure DisconnectIslandsRequest {
    /// The action to perform
    @required
    Action: String = "DisconnectIslands"

    /// Source island identifier
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    SourceIslandId: String
    
    /// Target island identifier
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    TargetIslandId: String
    
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

@output
structure ConnectIslandsResponse {
    /// One-way connection details
    @required
    Connection: IslandConnection
    
    /// Response metadata
    @required
    ResponseMetadata: ResponseMetadata
}

@output
structure DisconnectIslandsResponse {
    /// Disconnection confirmation
    @required
    Disconnected: Boolean

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

    /// Operational context and runtime state
    OperationalConfig: OperationalConfiguration

    /// Current deployment status (fetched from DeploymentRuntimeService if available)
    CurrentDeploymentStatus: DeploymentStatusSummary

    /// Recent island activities (deployments + resizing, last 10 events)
    RecentActivities: IslandActivityList

    /// Storage attachments
    BlockDeviceMappings: BlockDeviceMappingList

    /// SSA Configuration ID (managed by SSA Configuration Management Service)
    @required
    @pattern("^irn:ics:ssacms:[a-z0-9-]+:organization/[a-zA-Z0-9-]+:ssa-config/[a-zA-Z0-9-]+$")
    SSAConfigId: String
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

/// Current deployment status summary (from DeploymentRuntimeService)
structure DeploymentStatusSummary {
    /// Current deployment state
    Status: String

    /// Application name being deployed
    @length(min: 1, max: 255)
    ApplicationName: String

    /// Deployment version
    Version: String

    /// Deployment start time
    @timestampFormat("date-time")
    StartTime: Timestamp

    /// Progress percentage (0-100)
    @range(min: 0, max: 100)
    ProgressPercentage: Integer
}

/// Island activity (deployment or resizing event)
structure IslandActivity {
    /// Activity type
    @required
    ActivityType: IslandActivityType

    /// Activity description
    @required
    @length(min: 1, max: 500)
    Description: String

    /// Activity status
    @required
    Status: IslandActivityStatus

    /// Activity start time
    @required
    @timestampFormat("date-time")
    StartTime: Timestamp

    /// Activity completion time (if finished)
    @timestampFormat("date-time")
    CompletionTime: Timestamp

    /// Initiated by (user, system, external)
    InitiatedBy: String
}

/// Island activity type
enum IslandActivityType {
    DEPLOYMENT = "deployment"
    RESIZING = "resizing"
    CONFIGURATION_CHANGE = "configuration-change"
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

list IslandActivityList {
    member: IslandActivity
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

/// Network configuration for Envoy service mesh
structure NetworkConfiguration {
    /// Service mesh identity
    @required
    ServiceIdentity: ServiceIdentity

    /// Service discovery configuration
    ServiceDiscovery: ServiceDiscoveryConfig

    /// Public access configuration
    PublicAccess: PublicAccessConfig

    /// Service communication policies
    CommunicationPolicies: CommunicationPolicyList
}

/// Service identity in Envoy mesh
structure ServiceIdentity {
    /// Service name (same as Island ID)
    @required
    @pattern("^isl-[a-zA-Z0-9]+$")
    ServiceName: String

    /// Service port for communication
    @required
    @range(min: 1, max: 65535)
    ServicePort: Integer = 8080

    /// Service protocol
    @required
    Protocol: ServiceProtocol = "HTTP"

    /// Service version for routing
    ServiceVersion: String = "v1.0"

    /// Service tags for metadata
    ServiceTags: ServiceTagList
}

/// Service discovery configuration
structure ServiceDiscoveryConfig {
    /// Health check configuration
    @required
    HealthCheck: HealthCheckConfig

    /// Load balancing weight
    @range(min: 1, max: 1000)
    Weight: Integer = 100

    /// Service metadata
    ServiceMetadata: ServiceMetadataMap
}

/// Health check configuration
structure HealthCheckConfig {
    /// Health check type
    @required
    CheckType: HealthCheckType = "HTTP"

    /// Health check endpoint
    HealthCheckPath: String = "/health"

    /// Check interval in seconds
    @range(min: 5, max: 300)
    CheckInterval: Integer = 10

    /// Check timeout in seconds
    @range(min: 1, max: 60)
    CheckTimeout: Integer = 3
}

/// Public access configuration
structure PublicAccessConfig {
    /// Enable public internet access
    Enabled: Boolean = false

    /// Public IP allocation
    PublicIP: PublicIPConfig

    /// DNS configuration
    DNSConfig: DNSConfiguration

    /// TLS configuration for HTTPS
    TLSConfig: TLSConfiguration
}

/// Public IP configuration
structure PublicIPConfig {
    /// IP allocation type
    AllocationType: IPAllocationType = "DYNAMIC"

    /// Static IP address (if STATIC)
    StaticIP: String

    /// Load balancing configuration
    LoadBalancing: LoadBalancingConfig
}

/// DNS configuration
structure DNSConfiguration {
    /// Custom domain name
    DomainName: String

    /// DNS record TTL in seconds
    @range(min: 60, max: 86400)
    TTL: Integer = 300

    /// DNS record type
    RecordType: DNSRecordType = "A"
}

/// TLS configuration
structure TLSConfiguration {
    /// TLS certificate source
    CertificateSource: CertificateSource = "AUTO"

    /// Custom certificate ARN (if CUSTOM)
    CustomCertificateArn: String

    /// TLS version
    TLSVersion: TLSVersion = "TLS_1_3"
}

/// Load balancing configuration
structure LoadBalancingConfig {
    /// Load balancing algorithm
    Algorithm: LoadBalancingAlgorithm = "ROUND_ROBIN"

    /// Health check for load balancing
    HealthCheckEnabled: Boolean = true

    /// Session affinity
    SessionAffinity: SessionAffinityType = "NONE"
}

/// Security configuration for mTLS and policies
structure SecurityConfiguration {
    /// mTLS configuration (REQUIRED - Envoy mesh security)
    @required
    MTLSConfig: MTLSConfiguration

    /// Communication policies (REQUIRED - access control)
    CommunicationPolicies: CommunicationPolicyList

    /// Request timeout policies (SIMPLE - replaces circuit breakers)
    TimeoutPolicies: TimeoutPolicyList

    /// Rate limiting policies (OPTIONAL - protection)
    RateLimitPolicies: RateLimitPolicyList
}

/// mTLS configuration
structure MTLSConfiguration {
    /// Enable mTLS for service communication
    @required
    Enabled: Boolean = true

    /// Certificate rotation interval in hours
    @range(min: 1, max: 168)
    CertificateRotationHours: Integer = 24
}

/// Service communication policy
structure CommunicationPolicy {
    /// Target service pattern (e.g., "public", "ics-services", "org-123-*")
    @required
    TargetServicePattern: String

    /// Policy action
    @required
    Action: PolicyAction
}

/// Request timeout policy
structure TimeoutPolicy {
    /// Target service pattern
    @required
    TargetServicePattern: String

    /// Request timeout in seconds
    @required
    @range(min: 1, max: 300)
    TimeoutSeconds: Integer = 5

    /// Connection timeout in seconds
    @range(min: 1, max: 30)
    ConnectionTimeoutSeconds: Integer = 2
}

/// Rate limiting policy
structure RateLimitPolicy {
    /// Requests per second limit
    @required
    @range(min: 1, max: 1000000)
    RequestsPerSecond: Integer

    /// Burst capacity
    @range(min: 1, max: 10000)
    BurstCapacity: Integer = 100
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

/// Island connection information
structure IslandConnection {
    /// Source island (client)
    @required
    SourceIslandId: String
    
    /// Target island (server)
    @required
    TargetIslandId: String
    
    /// Allowed API patterns on target
    @required
    AllowedAPIs: APIPatternList
    
    /// Rate limit for source→target requests
    RateLimit: RateLimitConfiguration
    
    /// Connection status
    @required
    Status: ConnectionStatus
    
    /// Connection creation time
    @required
    @timestampFormat("date-time")
    CreatedTime: Timestamp
}

/// Rate limit configuration for connections
structure RateLimitConfiguration {
    /// Requests per second limit
    @required
    @range(min: 1, max: 1000000)
    RequestsPerSecond: Integer = 1000

    /// Burst capacity
    @range(min: 1, max: 10000)
    BurstCapacity: Integer = 100
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

/// Log levels
enum LogLevel {
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARN = "WARN"
    ERROR = "ERROR"
}

/// Service protocol types
enum ServiceProtocol {
    HTTP = "HTTP"
    HTTPS = "HTTPS"
    GRPC = "gRPC"
    TCP = "TCP"
}

/// IP allocation types
enum IPAllocationType {
    DYNAMIC = "dynamic"
    STATIC = "static"
}

/// DNS record types
enum DNSRecordType {
    A = "A"
    AAAA = "AAAA"
    CNAME = "CNAME"
}

/// Certificate source types
enum CertificateSource {
    AUTO = "auto"
    CUSTOM = "custom"
}

/// TLS version types
enum TLSVersion {
    TLS_1_2 = "TLS_1_2"
    TLS_1_3 = "TLS_1_3"
}

/// Load balancing algorithms
enum LoadBalancingAlgorithm {
    ROUND_ROBIN = "round_robin"
    LEAST_CONNECTIONS = "least_connections"
    WEIGHTED_ROUND_ROBIN = "weighted_round_robin"
}

/// Session affinity types
enum SessionAffinityType {
    NONE = "none"
    CLIENT_IP = "client_ip"
    COOKIE = "cookie"
}

/// Policy actions
enum PolicyAction {
    ALLOW = "allow"
    DENY = "deny"
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

map FeatureFlagMap {
    key: String
    value: Boolean
}

map EnvironmentVariableMap {
    key: String
    value: String
}

list ServiceTagList {
    member: String
}

list CommunicationPolicyList {
    member: CommunicationPolicy
}

list TimeoutPolicyList {
    member: TimeoutPolicy
}

list RateLimitPolicyList {
    member: RateLimitPolicy
}

map ServiceMetadataMap {
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
