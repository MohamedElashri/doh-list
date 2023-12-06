#!/bin/bash

# Define the file path for the DNS-over-HTTPS markdown file
FILE="curl.wiki/DNS-over-HTTPS.md"

# Check if the file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "Error: File $FILE not found or not readable."
    exit 1
fi

# Extract and format the list of DNS-over-HTTPS providers
# This time, we keep the full URL
CONTENT=$(awk '/^# Publicly available servers/,/^# Private DNS Server/ { print }' "$FILE" | \
    grep -o 'https://[a-zA-Z0-9./?=_%:-]*')

# Generate the doh-list.txt file
{
    echo "#$(sha256sum "$FILE" | cut -d' ' -f1)"
    echo "#"
    echo "# DNS-over-HTTPS Providers"
    echo "# Compiled from curl/curl wiki"
    echo "#"
    echo "# Full URLs of DoH services:"
    echo "#"
    echo "$CONTENT"
} > doh-list.txt
