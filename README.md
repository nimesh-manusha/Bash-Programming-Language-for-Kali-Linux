Objective
Evaluate students' ability to work with automation, data processing, and real-time monitoring using Bash scripting.



Part 1: Problem Solving and Programming
Students must write a Bash script that monitors a directory for changes and generates a real-time log of file modifications.

Problem Statement
Create a Bash script that:

Monitors a Specified Directory:
The script should take a directory path as an argument and continuously monitor it for any changes (e.g., file creation, deletion, modification).

Logs All File Changes:
Every detected change should be logged in a file (directory_changes.log) with details:
Timestamp of the change.
Type of change (Created, Modified, Deleted).
Filename affected.

Handles Large Directories Efficiently:
Ensure minimal CPU and memory usage while monitoring.

Runs as a Background Process:
The script should allow users to start and stop monitoring using a command (start or stop).

Requirements
The script should work on any user-specified directory.
Use efficient file monitoring tools (inotifywait, fswatch, or manual polling with ls).
Ensure error handling for invalid or missing directory paths.
