#!/bin/bash
# Integratord Watchdog - Persistent version that survives container restarts
# This script is designed to be added to container entrypoint or run as a systemd service

set -euo pipefail

INTEGRATORD_BIN="/var/ossec/bin/wazuh-integratord"
LOCK_DIR="/tmp/integratord_watchdog.lock"
STATE_FILE="/tmp/integratord_watchdog.state"
LOG_FILE="/var/log/integratord_watchdog.log"
ALERT_WEBHOOK=""
MAX_RESTARTS=5
RESET_WINDOW=300
BASE_BACKOFF=10
MAX_BACKOFF=300

touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/integratord_watchdog.log"

log() {
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $*" | tee -a "$LOG_FILE"
}

# Simple lock using mkdir (atomic)
acquire_lock() {
    if mkdir "$LOCK_DIR" 2>/dev/null; then
        echo $$ > "$LOCK_DIR/pid"
        return 0
    else
        if [ -f "$LOCK_DIR/pid" ]; then
            local pid=$(cat "$LOCK_DIR/pid" 2>/dev/null)
            if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
                return 1  # Lock held by live process
            fi
        fi
        rm -rf "$LOCK_DIR"
        return acquire_lock
    fi
}

release_lock() {
    rm -rf "$LOCK_DIR"
}

read_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "0 0"
    fi
}

write_state() {
    echo "$1 $2" > "$STATE_FILE"
}

get_integratord_pid() {
    pgrep -f "wazuh-integratord" | head -1
}

start_integratord() {
    log "Starting wazuh-integratord via wazuh-control..."
    /var/ossec/bin/wazuh-control start integratord 2>&1 | while IFS= read -r line; do log "wazuh-control: $line"; done
    sleep 3
    local pid=$(get_integratord_pid)
    if [ -n "$pid" ]; then
        log "integratord started with PID $pid"
        return 0
    else
        log "ERROR: integratord failed to start"
        return 1
    fi
}

check_and_restart() {
    local pid=$(get_integratord_pid)
    if [ -z "$pid" ]; then
        log "integratord is not running. Attempting restart..."
        
        local state=( $(read_state) )
        local restart_count=${state[0]}
        local last_restart=${state[1]}
        local now=$(date +%s)
        
        if [ $((now - last_restart)) -gt $RESET_WINDOW ]; then
            restart_count=0
        fi
        
        if [ $restart_count -ge $MAX_RESTARTS ]; then
            log "CRITICAL: Max restarts ($MAX_RESTARTS) reached in ${RESET_WINDOW}s. Manual intervention required."
            return 1
        fi
        
        local backoff=$((BASE_BACKOFF * (2 ** restart_count)))
        if [ $backoff -gt $MAX_BACKOFF ]; then
            backoff=$MAX_BACKOFF
        fi
        
        log "Restart attempt $((restart_count + 1))/$MAX_RESTARTS. Backing off for ${backoff}s..."
        sleep $backoff
        
        if start_integratord; then
            restart_count=$((restart_count + 1))
            write_state "$restart_count" "$(date +%s)"
            log "integratord restarted successfully (attempt $restart_count/$MAX_RESTARTS)"
            return 0
        else
            log "Failed to restart integratord (attempt $((restart_count + 1))/$MAX_RESTARTS)"
            return 1
        fi
    fi
    return 0
}

log() {
    echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $*" | tee -a "$LOG_FILE"
}

main() {
    log "=== Integratord Watchdog started (PID $$) ==="
    
    # Use mkdir for atomic lock
    LOCK_DIR="/tmp/integratord_watchdog.lock"
    STATE_FILE="/tmp/integratord_watchdog.state"
    
    if mkdir "$LOCK_DIR" 2>/dev/null; then
        echo $$ > "$LOCK_DIR/pid"
    else
        if [ -f "$LOCK_DIR/pid" ]; then
            local pid=$(cat "$LOCK_DIR/pid" 2>/dev/null)
            if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
                echo "Another watchdog instance is running (PID $pid). Exiting."
                exit 1
            fi
        fi
        rm -rf "$LOCK_DIR"
        mkdir "$LOCK_DIR"
        echo $$ > "$LOCK_DIR/pid"
    fi
    
    trap 'rm -rf "$LOCK_DIR"; log "Watchdog stopped"; exit 0' INT TERM EXIT
    
    echo "0 $(date +%s)" > "$STATE_FILE"
    
    # Ensure integratord is running at startup
    if ! pgrep -f "wazuh-integratord" >/dev/null; then
        log "integratord not running at startup. Attempting initial start..."
        /var/ossec/bin/wazuh-control start integratord 2>&1 | while IFS= read -r line; do echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] wazuh-control: $line" | tee -a "$LOG_FILE"; done
        sleep 3
    fi
    
    # Main monitoring loop
    while true; do
        sleep 10
        # Check if integratord is running
        if ! pgrep -f "wazuh-integratord" >/dev/null; then
            # Check restart limits
            state=( $(cat "/tmp/integratord_watchdog.state" 2>/dev/null || echo "0 0") )
            restart_count=${state[0]}
            last_restart=${state[1]}
            now=$(date +%s)
            
            if [ $((now - last_restart)) -gt 300 ]; then
                restart_count=0
            fi
            
            if [ ${restart_count:-0} -ge 5 ]; then
                echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] CRITICAL: Max restarts (5) reached in 300s. Manual intervention required." | tee -a /var/log/integratord_watchdog.log
                continue
            fi
            
            # Exponential backoff
            backoff=$((10 * (2 ** restart_count)))
            [ $backoff -gt 300 ] && backoff=300
            echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] integratord is not running. Attempting restart..." | tee -a /var/log/integratord_watchdog.log
            sleep 10
            
            /var/ossec/bin/wazuh-control start integratord 2>&1 | while IFS= read -r line; do echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] wazuh-control: $line" | tee -a /var/log/integratord_watchdog.log; done
            sleep 3
            
            if pgrep -f "wazuh-integratord" >/dev/null; then
                restart_count=$((restart_count + 1))
                echo "$restart_count $(date +%s)" > /tmp/integratord_watchdog.state
                echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] integratord restarted successfully (attempt $restart_count/5)" | tee -a /var/log/integratord_watchdog.log
            else
                echo "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] Failed to restart integratord" | tee -a /var/log/integratord_watchdog.log
            fi
        fi
        sleep 10
    done
}

main "$@"
