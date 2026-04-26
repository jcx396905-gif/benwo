#!/bin/bash

# =============================================================================
# run-automation.sh - Automated Task Runner for Flutter BenWo
# =============================================================================
# This script runs Claude Code multiple times in a loop to automatically
# complete tasks defined in task.json
#
# Usage: ./run-automation.sh <number_of_runs>
# Example: ./run-automation.sh 10
# =============================================================================

set -e

# =============================================================================
# Environment Configuration - CRITICAL FOR ANDROID BUILD
# =============================================================================
export FLUTTER_SDK="C:/flutter-sdk"
export ANDROID_SDK="C:/android-sdk"
export CLAUDE_CODE_GIT_BASH_PATH="D:\\Git\\bin\\bash.exe"
export PATH="$FLUTTER_SDK/bin:$ANDROID_SDK/platform-tools:$ANDROID_SDK/cmdline-tools/latest/bin:$PATH"

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log file
LOG_DIR="./automation-logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/automation-$(date +%Y%m%d_%H%M%S).log"

# Function to log messages
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" >> "$LOG_FILE"

    case $level in
        INFO)
            echo -e "${BLUE}[INFO]${NC} ${message}"
            ;;
        SUCCESS)
            echo -e "${GREEN}[SUCCESS]${NC} ${message}"
            ;;
        WARNING)
            echo -e "${YELLOW}[WARNING]${NC} ${message}"
            ;;
        ERROR)
            echo -e "${RED}[ERROR]${NC} ${message}"
            ;;
        PROGRESS)
            echo -e "${CYAN}[PROGRESS]${NC} ${message}"
            ;;
    esac
}

# Function to count remaining tasks
count_remaining_tasks() {
    if [ -f "task.json" ]; then
        # Count tasks with passes: false
        local count=$(grep -c '"passes": false' task.json 2>/dev/null || echo "0")
        echo "$count"
    else
        echo "0"
    fi
}

# Banner
echo ""
echo "========================================"
echo "  Flutter BenWo Auto-Coding Agent"
echo "========================================"
echo ""
log "INFO" "Flutter SDK: $FLUTTER_SDK"
log "INFO" "Android SDK: $ANDROID_SDK"

# Check if number argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <number_of_runs>"
    echo "Example: $0 10"
    exit 1
fi

# Validate input is a number
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer"
    exit 1
fi

TOTAL_RUNS=$1

# Verify Flutter is available
if [ ! -f "$FLUTTER_SDK/bin/flutter.bat" ]; then
    log "ERROR" "Flutter SDK not found at: $FLUTTER_SDK"
    log "ERROR" "Please update FLUTTER_SDK in run-automation.sh"
    exit 1
fi

log "INFO" "Starting automation with $TOTAL_RUNS runs"
log "INFO" "Log file: $LOG_FILE"

# Check if task.json exists
if [ ! -f "task.json" ]; then
    log "ERROR" "task.json not found! Please run this script from the project root."
    exit 1
fi

# Initial task count
INITIAL_TASKS=$(count_remaining_tasks)
log "INFO" "Tasks remaining at start: $INITIAL_TASKS"

# Main loop
for ((run=1; run<=TOTAL_RUNS; run++)); do
    echo ""
    echo "========================================"
    log "PROGRESS" "Run $run of $TOTAL_RUNS"
    echo "========================================"

    # Check remaining tasks before this run
    REMAINING=$(count_remaining_tasks)

    if [ "$REMAINING" -eq 0 ]; then
        log "SUCCESS" "All tasks completed! No more tasks to process."
        log "INFO" "Automation finished early after $((run-1)) runs"
        exit 0
    fi

    log "INFO" "Tasks remaining before this run: $REMAINING"

    # Run timestamp for this iteration
    RUN_START=$(date +%s)
    RUN_LOG="$LOG_DIR/run-${run}-$(date +%Y%m%d_%H%M%S).log"

    log "INFO" "Starting Claude Code session..."
    log "INFO" "Run log: $RUN_LOG"

    # Create a temporary file with the prompt
    PROMPT_FILE=$(mktemp)
    cat > "$PROMPT_FILE" << 'PROMPT_EOF'
You are working on the BenWo Flutter project.

CRITICAL: First set the environment variables:
export FLUTTER_SDK="C:/flutter-sdk"
export ANDROID_SDK="C:/android-sdk"
export PATH="$FLUTTER_SDK/bin:$ANDROID_SDK/platform-tools:$ANDROID_SDK/cmdline-tools/latest/bin:$PATH"

Then follow the workflow in CLAUDE.md:

1. Read task.json and select the next task with passes: false
2. Implement the task following all steps in the task
3. Test thoroughly:
   - Run flutter analyze to check for code issues
   - Run flutter test to run tests  
   - Run flutter build apk --debug to verify build
4. Update progress.txt with your work
5. Commit all changes including task.json update in a single commit

Start by reading task.json to find your task.
Please complete only one task in this session, and stop once you are done or if you encounter an unresolvable issue.

IMPORTANT: If you encounter a blocking issue (missing API keys, configuration needed, etc.):
- Do NOT mark the task as complete
- Do NOT commit
- Write the blocking issue to progress.txt
- Report the issue clearly and stop
PROMPT_EOF

    # Run Claude with the prompt from stdin
    # Using -p for print mode (non-interactive)
    # Using --dangerously-skip-permissions to bypass all permission checks
    if claude -p \
        --dangerously-skip-permissions \
        < "$PROMPT_FILE" 2>&1 | tee "$RUN_LOG"; then

        RUN_END=$(date +%s)
        RUN_DURATION=$((RUN_END - RUN_START))

        log "SUCCESS" "Run $run completed in ${RUN_DURATION} seconds"
    else
        RUN_END=$(date +%s)
        RUN_DURATION=$((RUN_END - RUN_START))

        log "WARNING" "Run $run finished with exit code $? after ${RUN_DURATION} seconds"
    fi

    # Clean up temp file
    rm -f "$PROMPT_FILE"

    # Check remaining tasks after this run
    REMAINING_AFTER=$(count_remaining_tasks)
    COMPLETED=$((REMAINING - REMAINING_AFTER))

    if [ "$COMPLETED" -gt 0 ]; then
        log "SUCCESS" "Task(s) completed this run: $COMPLETED"
    else
        log "WARNING" "No tasks marked as completed this run"
    fi

    log "INFO" "Tasks remaining after run $run: $REMAINING_AFTER"

    # Add separator in log
    echo "" >> "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    # Small delay between runs
    if [ $run -lt $TOTAL_RUNS ]; then
        log "INFO" "Waiting 2 seconds before next run..."
        sleep 2
    fi
done

# Final summary
echo ""
echo "========================================"
log "SUCCESS" "Automation completed!"
echo "========================================"

FINAL_REMAINING=$(count_remaining_tasks)
TOTAL_COMPLETED=$((INITIAL_TASKS - FINAL_REMAINING))

log "INFO" "Summary:"
log "INFO" "  - Total runs: $TOTAL_RUNS"
log "INFO" "  - Tasks completed: $TOTAL_COMPLETED"
log "INFO" "  - Tasks remaining: $FINAL_REMAINING"
log "INFO" "  - Log file: $LOG_FILE"

if [ "$FINAL_REMAINING" -eq 0 ]; then
    log "SUCCESS" "All tasks have been completed!"
else
    log "WARNING" "Some tasks remain. You may need to run more iterations."
fi
