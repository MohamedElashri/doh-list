#!/bin/bash

# Define the file path for the DNS-over-HTTPS markdown file
FILE="curl.wiki/DNS-over-HTTPS.md"

# Check if the file exists and is readable
if [ ! -r "$FILE" ]; then
    echo "Error: File $FILE not found or not readable."
    exit 1
fi

# Extract URLs from the "Base URL" column of the table
CONTENT=$(awk '
    BEGIN { capture = 0; }
    /^# Publicly available servers/ { capture = 1; }
    /^# Private DNS Server with DoH setup examples/ { capture = 0; exit; }
    capture && /^\|/ {
        split($0, columns, "|");
        gsub(/<br>.*$/, "", columns[3]);  # Remove <br> and anything following it
        url = columns[3];
        if (url ~ /https?:\/\//) {
            print url;
        }
    }
' "$FILE")

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
