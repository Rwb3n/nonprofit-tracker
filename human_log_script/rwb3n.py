#!/usr/bin/env python3
"""
Timestamp logger that appends entries after the last --- marker
in the human_log.md file
"""

import os
import datetime

# Get the script directory and parent directory
script_dir = os.path.dirname(os.path.abspath(__file__))
log_file = os.path.join(script_dir, "human_log.md")

print(f"Logging activities to: {log_file}")
print("Enter your activities (type 'exit' to stop)")

while True:
    activity = input("> ")
    
    if activity.lower() == 'exit':
        break
    
    if activity.strip():
        # Get current timestamp
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        # Format the log entry
        entry = f"- {timestamp}: {activity}\n"
        
        # Read the existing file content
        if os.path.exists(log_file):
            with open(log_file, 'r') as f:
                content = f.readlines()
        else:
            # Create a new file with headers if it doesn't exist
            content = [
                'title: "Nonprofit Membership Tracking - Human Log"\n',
                'project: "Nonprofit Membership Tracking"\n',
                'type: "Documentation"\n',
                'phase: "Build"\n',
                'status: "In Progress"\n',
                'version: "1.0"\n',
                'created: "2025-04-02"\n',
                'updated: "2025-04-02"\n',
                'author: "Rwb3n"\n',
                '---\n',
                '\n',
                '# Human Log 2025, April 2nd\n',
                '\n',
                '## To be parsed and transformed by AI at EOD into Progress.md\n',
                '\n',
                '---\n',
                '\n'
            ]
            
        # Find the position of the last "---" marker
        marker_positions = [i for i, line in enumerate(content) if line.strip() == "----"]
        
        if marker_positions:
            insert_position = marker_positions[-1] + 1
            # Add a blank line after the marker if there isn't one already
            if insert_position >= len(content):
                content.append('\n')
            elif content[insert_position].strip() != '':
                content.insert(insert_position, '\n')
                insert_position += 1
        else:
            # If no marker found, append to the end
            insert_position = len(content)
            
        # Insert the new entry
        content.insert(insert_position, entry)
        
        # Write back to the file
        with open(log_file, 'w') as f:
            f.writelines(content)
            
        print(f"Logged: {timestamp}: {activity}")

print("Logger closed. All activities have been saved.")