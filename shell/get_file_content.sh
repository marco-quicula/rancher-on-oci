#!/bin/bash

# Exit script immediately on first error
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <connection_file> <username> <host> <file>"
    exit 1
fi

# Get the connection file from the fourth script argument
CONNECTION_FILE="$1"

# Get the username from the first script argument
USERNAME="$2"

# Get the host from the second script argument
HOST="$3"

# Get the file name from the third script argument
FILE="$4"

# Connect to the cluster and get the file content
FILE_CONTENT=$(ssh -o StrictHostKeyChecking=no -i $CONNECTION_FILE $USERNAME@$HOST "sudo cat $FILE")

# Encode the file content in base64
FILE_CONTENT_BASE64=$(echo -n "$FILE_CONTENT" | base64 -w0) # Linux

# Print the base64-encoded file content as a JSON object
echo "{\"file_content\": \"$FILE_CONTENT_BASE64\"}"