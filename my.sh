#!/bin/bash

# Global variables
LOG_FILE="directory_changes.log"
DIR_TO_MONITOR=""
INOTIFY_CMD="inotifywait"

# Function to check if directory exists
check_directory() {
    if [[ ! -d "$DIR_TO_MONITOR" ]]; then
        echo "Error: Directory '$DIR_TO_MONITOR' does not exist."
        exit 1
    fi
}

# Function to start monitoring
start_monitoring() {
    check_directory
    echo "Monitoring directory: $DIR_TO_MONITOR"
    echo "Monitoring started at $(date)" >> "$LOG_FILE"
    
    # Use inotifywait to monitor the directory
    # Events: create, modify, delete
    $INOTIFY_CMD -m -r "$DIR_TO_MONITOR" -e create -e modify -e delete --format '%T %e %w%f' --timefmt '%Y-%m-%d %H:%M:%S' | while read line
    do
        echo "$line" >> "$LOG_FILE"
        event=$(echo $line | awk '{print $2}')
        if [[ "$event" == "DELETE" ]]; then
            send_email_alert "$line"
        fi
    done
}

# Function to send email alert (Optional feature)
send_email_alert() {
    local delete_event="$1"
    local email_recipient="youremail@example.com"
    local subject="File Deletion Alert"
    local body="A file was deleted: $delete_event"
    
    # Using mail command (make sure it's installed and configured)
    echo "$body" | mail -s "$subject" "$email_recipient"
}

# Function to stop monitoring
stop_monitoring() {
    pkill -f "$INOTIFY_CMD"  # Kill inotifywait process
    echo "Monitoring stopped at $(date)" >> "$LOG_FILE"
}

# Main function to process commands
main() {
    if [[ -z "$1" ]]; then
        echo "Usage: $0 <start|stop> <directory_path>"
        exit 1
    fi

    case $1 in
        start)
            if [[ -z "$2" ]]; then
                echo "Error: Please specify a directory to monitor."
                exit 1
            fi
            DIR_TO_MONITOR="$2"
            start_monitoring
            ;;
        stop)
            stop_monitoring
            ;;
        *)
            echo "Usage: $0 <start|stop> <directory_path>"
            exit 1
            ;;
    esac
}

# Run the main function
main "$@"
