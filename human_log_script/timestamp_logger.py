#!/usr/bin/env python3
"""
Timestamp Logger for Obsidian

This script logs timestamped activities to an Obsidian file.
After installation, you can use the 'log' command directly.

Usage: log [activity description]
       log -i (for interactive mode)
"""

import sys
import os
import datetime
import argparse
from pathlib import Path

# Configuration - update these values
OBSIDIAN_VAULT_PATH = os.path.expanduser("~/Documents/Obsidian/YourVaultName")
LOG_FILE = "ActivityLog.md"  # File within your vault

def get_full_path():
    """Get the full path to the log file."""
    return os.path.join(OBSIDIAN_VAULT_PATH, LOG_FILE)

def log_activity(activity):
    """Log a timestamped activity to the Obsidian file."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    entry = f"- {timestamp}: {activity}\n"
    
    file_path = get_full_path()
    
    # Create parent directories and file if they don't exist
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    if not os.path.exists(file_path):
        with open(file_path, 'w') as f:
            f.write("# Activity Log\n\n")
    
    # Append the new entry
    with open(file_path, 'a') as f:
        f.write(entry)
    
    print(f"Logged: {timestamp}: {activity}")

def interactive_mode():
    """Run in interactive mode, logging multiple activities until exit."""
    print("Timestamp Logger Interactive Mode (Type 'exit' to quit)")
    print(f"Logging to: {get_full_path()}")
    
    while True:
        activity = input("Activity: ")
        if activity.lower() in ('exit', 'quit', 'q'):
            break
        if activity.strip():
            log_activity(activity)

def main():
    parser = argparse.ArgumentParser(description="Log timestamped activities to an Obsidian file.")
    parser.add_argument('-i', '--interactive', action='store_true', help='Run in interactive mode')
    parser.add_argument('activity', nargs='*', help='Activity to log')
    
    args = parser.parse_args()
    
    # Check if Obsidian vault path is set correctly
    if not os.path.exists(OBSIDIAN_VAULT_PATH):
        print(f"Error: Obsidian vault path not found: {OBSIDIAN_VAULT_PATH}")
        print("Please update the OBSIDIAN_VAULT_PATH in the script.")
        return
    
    if args.interactive:
        interactive_mode()
    elif args.activity:
        activity = ' '.join(args.activity)
        log_activity(activity)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
    
# Add setup.py in the same directory with the following content:
"""
from setuptools import setup

setup(
    name="obsidian-logger",
    version="0.1",
    py_modules=["timestamp_logger"],
    entry_points={
        'console_scripts': [
            'log=timestamp_logger:main',
        ],
    },
)
"""