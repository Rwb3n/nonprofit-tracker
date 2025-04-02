# Usage Instructions for Your Specific Setup

## Folder Structure

Your setup will have the following structure:
```
parent_folder/
│
├── human_log.md      <-- This is where the log entries will be saved
│
└── human_log_script/ <-- This is where the script is located
    ├── timestamp_logger.py
    └── setup.py
```

## Installation

1. Save the `timestamp_logger.py` file in the `human_log_script` folder.
2. Save the `setup.py` file in the same folder.
3. Open a terminal and navigate to the `human_log_script` folder:
   ```bash
   cd path/to/human_log_script
   ```
4. Install the tool with pip:
   ```bash
   pip install -e .
   ```

## Usage

After installation, you can log your activities from anywhere using:

```bash
log Started working on project X
```

The timestamp and activity will be added to `human_log.md` in the parent folder.

For interactive mode:

```bash
log -i
```

## How It Works

The script automatically:
1. Determines its own location in the `human_log_script` folder
2. Finds the parent folder
3. Creates/updates the `human_log.md` file in that parent folder
4. Appends timestamped entries to the file

Each log entry will be formatted as:
```
- 2025-04-02 14:30:45: Your activity description here
```

This format is ideal for both Obsidian display and future AI parsing.