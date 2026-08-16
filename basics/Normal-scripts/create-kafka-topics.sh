#!/bin/bash




set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
log_info() {
    local msg="$1"
    echo -e "${GREEN}[INFO]${NC} $msg"
    return 0
}

log_error() {
    local msg="$1"
    echo -e "${RED}[ERROR]${NC} $msg" >&2
    return 0
}

log_warn() {
    local msg="$1"
    echo -e "${YELLOW}[WARN]${NC} $msg"
    return 0
}

# Function to display usage
usage() {
cat <<EOF
Usage: $0 <env_name> <topic_name> [partitions] [replication_factor]

Arguments:
    env_name             Environment name (e.g., dev, dev2, qa, uat, ppe, prod, visdev, visqa, visuat, visppe, visprod)
    topic_name           Name of the Kafka topic to create
    partitions           Number of partitions (default: 3)
    replication_factor   Replication factor (default: 2)

Examples:
    $0 dev2 workflow_errors_v1
    $0 visdev user_events_v1 6 3
    $0 prod order_processing_v1 12 3
EOF
    exit 1
}

# Check if required arguments are provided
if [[ $# -lt 2 ]]; then
    log_error "Missing required arguments"
    usage
fi

ENV_NAME="$1"
TOPIC_NAME="$2"
PARTITIONS="${3:-3}"
REPLICATION_FACTOR="${4:-2}"
MAX_MESSAGE_BYTES="${5:-1048588}"  # Default to 1MB

log_info "Environment: $ENV_NAME"
log_info "Topic: $TOPIC_NAME"
log_info "Partitions: $PARTITIONS"
log_info "Replication Factor: $REPLICATION_FACTOR"
log_info "Topic config max.message.bytes: $MAX_MESSAGE_BYTES"

# Determine the prefix based on environment name
if [[ "$ENV_NAME" == vis* ]]; then
    PREFIX="a552816"
    log_info "Detected VIS environment, using prefix: $PREFIX"
else
    PREFIX="a552762"
    log_info "Detected standard environment, using prefix: $PREFIX"
fi

# Construct cluster name
CLUSTER_NAME="${PREFIX}-sl-foundation-${ENV_NAME}-kafka"
log_info "Cluster name: $CLUSTER_NAME"

# Find the cluster ARN
log_info "Searching for MSK cluster..."

CLUSTER_ARN=$(aws kafka list-clusters \
    --query "ClusterInfoList[?ClusterName=='$CLUSTER_NAME'].ClusterArn | [0]" \
    --output text)

if [[ -z "$CLUSTER_ARN" ]] || [[ "$CLUSTER_ARN" == "None" ]]; then
    log_error "Cluster '$CLUSTER_NAME' not found"
    log_info "Available clusters:"
    aws kafka list-clusters --query 'ClusterInfoList[*].ClusterName' --output table
    exit 1
fi

log_info "Found cluster ARN: $CLUSTER_ARN"

# Get bootstrap brokers
log_info "Retrieving bootstrap brokers..."

BOOTSTRAP_BROKERS=$(aws kafka get-bootstrap-brokers \
    --cluster-arn "$CLUSTER_ARN" \
    --query 'BootstrapBrokerStringTls' \
    --output text)

if [[ -z "$BOOTSTRAP_BROKERS" ]]; then
    log_error "Failed to retrieve bootstrap brokers"
    exit 1
fi

log_info "Bootstrap brokers: $BOOTSTRAP_BROKERS"

# Check if Java is installed
if ! command -v java &> /dev/null; then
    log_error "Java is not installed. Installing Amazon Corretto 17..."

    sudo yum install -y java-17-amazon-corretto-headless

    if [[ $? -ne 0 ]]; then
        log_error "Failed to install Java. Please install Java manually."
        exit 1
    fi

    log_info "Java installed successfully"
fi

# Verify Java version
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
log_info "Using Java: $JAVA_VERSION"

# Kafka version (can be overridden with KAFKA_VERSION env var)
# Default to 3.6.1 - a known stable, widely available version
KAFKA_VERSION="${KAFKA_VERSION:-3.6.1}"
KAFKA_DIR="kafka_2.13-${KAFKA_VERSION}"
KAFKA_ARCHIVE="kafka_2.13-${KAFKA_VERSION}.tgz"

# Check if Kafka CLI tools are available
if [[ ! -d "$KAFKA_DIR" ]]; then
    log_warn "Kafka CLI tools not found. Downloading version ${KAFKA_VERSION} (~100MB)..."
    log_info "To use a specific version: KAFKA_VERSION=3.5.1 $0 $@"
    echo ""

    # Try multiple download sources
    DOWNLOAD_SUCCESS=false

    # Source 1: Apache Archive (most reliable)
log_info "[1/2] Trying Apache Archive (archive.apache.org)..."

# Limit to 1 redirect for security (Apache mirrors may redirect once)
if wget --progress=bar:force --timeout=120 --max-redirect=1 \
    "https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_ARCHIVE}"; then
    DOWNLOAD_SUCCESS=true
else
    log_warn "Archive failed, trying CDN mirror..."
    rm -f "$KAFKA_ARCHIVE"

    # Source 2: Apache CDN
    log_info "[2/2] Trying Apache CDN (dlcdn.apache.org)..."

    # CDN intentionally redirects to geographically close mirrors (expected behavior)
    if wget --progress=bar:force --timeout=120 --max-redirect=1 \
        "https://dlcdn.apache.org/kafka/${KAFKA_VERSION}/${KAFKA_ARCHIVE}"; then
        DOWNLOAD_SUCCESS=true
    else
        rm -f "$KAFKA_ARCHIVE"
    fi
fi

if [[ "$DOWNLOAD_SUCCESS" = false ]]; then
    log_error "Failed to download Kafka ${KAFKA_VERSION}"
    echo ""
    log_info "Manual download options:"
    echo "  1. wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_ARCHIVE}"
    echo "  2. wget https://archive.apache.org/dist/kafka/3.6.1/kafka_2.13-3.6.1.tgz"
    echo "  3. wget https://archive.apache.org/dist/kafka/3.5.1/kafka_2.13-3.5.1.tgz"
    echo ""
    echo "After download:"
    echo "  tar -xzf ${KAFKA_ARCHIVE}"
    echo "  rm ${KAFKA_ARCHIVE}"
    echo "  $0 $@"
    exit 1
fi

log_info "Download complete. Extracting..."

tar -xzf "$KAFKA_ARCHIVE"
rm "$KAFKA_ARCHIVE"

log_info "Kafka CLI tools v${KAFKA_VERSION} ready"
fi

# Verify Kafka tools are properly extracted
if [[ ! -f "$KAFKA_DIR/bin/kafka-topics.sh" ]]; then
    log_error "Kafka tools not properly extracted. Please delete '$KAFKA_DIR' and try again."
    exit 1
fi

log_info "Using Kafka CLI v${KAFKA_VERSION}"

# Create client properties file
CLIENT_PROPERTIES="client.properties"

cat > "$CLIENT_PROPERTIES" <<EOF
security.protocol=SSL
EOF

log_info "Created client properties file"

# Create the topic
log_info "Creating topic '$TOPIC_NAME'..."

"$KAFKA_DIR/bin/kafka-topics.sh" --create \
    --bootstrap-server "$BOOTSTRAP_BROKERS" \
    --command-config "$CLIENT_PROPERTIES" \
    --topic "$TOPIC_NAME" \
    --partitions "$PARTITIONS" \
    --replication-factor "$REPLICATION_FACTOR" \
    --config "max.message.bytes=${MAX_MESSAGE_BYTES}" \
    --if-not-exists

if [[ $? -eq 0 ]]; then
    log_info "Topic '$TOPIC_NAME' created successfully (or already exists)"
else
    log_error "Failed to create topic '$TOPIC_NAME'"
    exit 1
fi

# Update topic configuration for both new and existing topics
log_info "Updating topic configuration for '$TOPIC_NAME'..."

"$KAFKA_DIR/bin/kafka-configs.sh" --alter \
    --bootstrap-server "$BOOTSTRAP_BROKERS" \
    --command-config "$CLIENT_PROPERTIES" \
    --entity-type topics \
    --entity-name "$TOPIC_NAME" \
    --add-config "max.message.bytes=${MAX_MESSAGE_BYTES}"

if [[ $? -eq 0 ]]; then
    log_info "Topic configuration updated: max.message.bytes=${MAX_MESSAGE_BYTES}"
else
    log_error "Failed to update topic configuration for '$TOPIC_NAME'"
    exit 1
fi

# Verify topic creation
log_info "Verifying topic creation..."

"$KAFKA_DIR/bin/kafka-topics.sh" --describe \
    --bootstrap-server "$BOOTSTRAP_BROKERS" \
    --command-config "$CLIENT_PROPERTIES" \
    --topic "$TOPIC_NAME"

# Verify topic configuration
log_info "Verifying topic configuration for '$TOPIC_NAME'..."

"$KAFKA_DIR/bin/kafka-configs.sh" --describe \
    --bootstrap-server "$BOOTSTRAP_BROKERS" \
    --command-config "$CLIENT_PROPERTIES" \
    --entity-type topics \
    --entity-name "$TOPIC_NAME"

if [[ $? -ne 0 ]]; then
    log_error "Failed to verify topic configuration for '$TOPIC_NAME'"
    exit 1
fi

log_info "✓ Topic creation complete!"

# Optional: List all topics
read -p "Do you want to list all topics in the cluster? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Listing all topics in cluster '$CLUSTER_NAME':"

    "$KAFKA_DIR/bin/kafka-topics.sh" --list \
        --bootstrap-server "$BOOTSTRAP_BROKERS" \
        --command-config "$CLIENT_PROPERTIES"
fi