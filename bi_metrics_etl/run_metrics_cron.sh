#!/bin/bash
################################################################################
# BI Metrics ETL - Cron Job Runner
# 
# This script activates the Python virtual environment and executes the
# metrics ETL process. Designed to be run via cron for daily automation.
#
# Usage:
#   ./run_metrics_cron.sh [--mode MODE] [--options]
#
# Crontab example:
#   0 2 * * * /home/ubuntu/GameOn-BI/bi_metrics_etl/run_metrics_cron.sh >> /home/ubuntu/GameOn-BI/bi_metrics_etl/logs/cron.log 2>&1
################################################################################

set -e  # Exit on error
set -u  # Exit on undefined variable

################################################################################
# CONFIGURATION
################################################################################

VENV_PATH="/home/ubuntu/GameOn-BI/venv"
SCRIPTS_DIR="/home/ubuntu/GameOn-BI/bi_metrics_etl"
LOG_DIR="/home/ubuntu/GameOn-BI/bi_metrics_etl/logs"

# Derived paths
PYTHON_EXEC="${VENV_PATH}/bin/python3"
ACTIVATE_SCRIPT="${VENV_PATH}/bin/activate"
RUN_METRICS_SCRIPT="${SCRIPTS_DIR}/run_metrics.py"

# Timestamp for logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
DATE_STRING=$(date '+%Y%m%d_%H%M%S')

################################################################################
# FUNCTIONS
################################################################################

log_info() {
    echo "[$TIMESTAMP] [INFO] $1"
}

log_error() {
    echo "[$TIMESTAMP] [ERROR] $1" >&2
}

log_success() {
    echo "[$TIMESTAMP] [SUCCESS] $1"
}

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if virtual environment exists
    if [ ! -d "$VENV_PATH" ]; then
        log_error "Virtual environment not found at: $VENV_PATH"
        exit 1
    fi
    
    # Check if activation script exists
    if [ ! -f "$ACTIVATE_SCRIPT" ]; then
        log_error "Activation script not found at: $ACTIVATE_SCRIPT"
        exit 1
    fi
    
    # Check if Python executable exists
    if [ ! -f "$PYTHON_EXEC" ]; then
        log_error "Python executable not found at: $PYTHON_EXEC"
        exit 1
    fi
    
    # Check if scripts directory exists
    if [ ! -d "$SCRIPTS_DIR" ]; then
        log_error "Scripts directory not found at: $SCRIPTS_DIR"
        exit 1
    fi
    
    # Check if run_metrics.py exists
    if [ ! -f "$RUN_METRICS_SCRIPT" ]; then
        log_error "run_metrics.py not found at: $RUN_METRICS_SCRIPT"
        exit 1
    fi
    
    # Check if log directory exists, create if not
    if [ ! -d "$LOG_DIR" ]; then
        log_info "Creating log directory: $LOG_DIR"
        mkdir -p "$LOG_DIR"
    fi
    
    log_success "All prerequisites checked successfully"
}

################################################################################
# MAIN EXECUTION
################################################################################

main() {
    echo ""
    echo "=============================================================================="
    echo "BI METRICS ETL - CRON JOB EXECUTION"
    echo "=============================================================================="
    log_info "Starting cron job execution"
    log_info "Timestamp: $TIMESTAMP"
    echo "=============================================================================="
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Change to scripts directory
    log_info "Changing to scripts directory: $SCRIPTS_DIR"
    cd "$SCRIPTS_DIR" || {
        log_error "Failed to change directory to: $SCRIPTS_DIR"
        exit 1
    }
    
    # Activate virtual environment
    log_info "Activating virtual environment: $VENV_PATH"
    # shellcheck source=/dev/null
    source "$ACTIVATE_SCRIPT" || {
        log_error "Failed to activate virtual environment"
        exit 1
    }
    log_success "Virtual environment activated"
    
    # Verify Python version
    PYTHON_VERSION=$("$PYTHON_EXEC" --version 2>&1)
    log_info "Using Python: $PYTHON_VERSION"
    
    # Load environment variables from .env file
    if [ -f "${SCRIPTS_DIR}/.env" ]; then
        log_info "Loading environment variables from .env"
        set -a  # Automatically export all variables
        # shellcheck source=/dev/null
        source "${SCRIPTS_DIR}/.env"
        set +a
        log_success "Environment variables loaded"
    else
        log_error ".env file not found at: ${SCRIPTS_DIR}/.env"
        #exit 1
    fi
    
    # Execute the Python script with arguments
    log_info "Executing run_metrics.py..."
    echo "------------------------------------------------------------------------------"
    
    # Pass all command line arguments to the Python script
    # Default is incremental mode if no arguments provided
    if [ $# -eq 0 ]; then
        "$PYTHON_EXEC" "$RUN_METRICS_SCRIPT" 
    else
        "$PYTHON_EXEC" "$RUN_METRICS_SCRIPT" "$@"
    fi
    
    # Capture exit code
    EXIT_CODE=$?
    
    echo "------------------------------------------------------------------------------"
    
    # Check exit code and log result
    if [ $EXIT_CODE -eq 0 ]; then
        log_success "Metrics job completed successfully"
        echo ""
        echo "=============================================================================="
        echo "✅ JOB COMPLETED SUCCESSFULLY"
        echo "=============================================================================="
        exit 0
    else
        log_error "Metrics job failed with exit code: $EXIT_CODE"
        echo ""
        echo "=============================================================================="
        echo "❌ JOB FAILED (Exit Code: $EXIT_CODE)"
        echo "=============================================================================="
        exit $EXIT_CODE
    fi
}

################################################################################
# SCRIPT ENTRY POINT
################################################################################

# Execute main function with all arguments
main "$@"
