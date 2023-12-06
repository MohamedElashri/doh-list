#!/bin/bash

# Define the file path for the DNS-over-HTTPS markdown file
FILE="curl.wiki/DNS-over-HTTPS.md"

# Check if the file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "Error: File $FILE not found or not readable."
    exit 1
fi

# Get the current date for the "Last modified" entry
CURRENT_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Extract only URLs from the "Base URL" column of the table
CONTENT=$(awk '
    BEGIN { capture = 0; }
    /^# Publicly available servers/ { capture = 1; }
    /^# Private DNS Server with DoH setup examples/ { capture = 0; exit; }
    capture && /^\|/ {
        split($0, columns, "|");
        print columns[3];
    }
' "$FILE" | grep -o 'https://[a-zA-Z0-9./?=_%:-]*')

# Generate the doh-list.txt file with the header
{
    echo "! Title: DoH DNS Block Filter"
    echo "! Description: Filter to block the public available DoH servers."
    echo "! Homepage: https://github.com/MohamedElashri/doh-list"
    echo "! License: https://github.com/MohamedElashri/doh-list/blob/master/LICENSE"
    echo "! Last modified: $CURRENT_DATE"
    echo "#"
    echo "# Full URLs of DoH services:"
    echo "#"
    echo "$CONTENT"
} > doh-list.txt
