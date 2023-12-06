#!/bin/bash

# Define the file path for the DNS-over-HTTPS markdown file
FILE="curl.wiki/DNS-over-HTTPS.md"

# Check if the file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "Error: File $FILE not found or not readable."
    exit 1
fi

# Extract and format the list of DNS-over-HTTPS providers
CONTENT=$(awk '/^# Publicly available servers/,/^# Private DNS Server/ { print }' "$FILE" | \
    awk -F'|' '/^\|/ {gsub(/^ *| *$/, "", $2); print $2}' | \
    grep -o 'https://[a-zA-Z0-9./?=_%:-]*' | \
    awk -F[/:] '{ print $4 }')

# Generate the doh-list.txt file
{
    echo "#$(sha256sum "$FILE" | cut -d' ' -f1)"
    echo "#"
    echo "# DNS-over-HTTPS Providers"
    echo "# Compiled from curl/curl wiki"
    echo "#"
    echo "#"
    echo "$CONTENT" | awk -F'.' 'NF==2' | awk '{ print "#\t" $0 }'
    echo "#"
    echo "$CONTENT"
} > doh-list.txt
