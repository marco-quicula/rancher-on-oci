#!/bin/bash

# Exit script immediately on first error
set -e

# Replace with your username
USERNAME="$1"

# Get the host from the first script argument
HOST="$2"

# Get the file name from the second script argument
FILE="$3"

# Connect to the cluster and get the file content
FILE_CONTENT=$(ssh -o StrictHostKeyChecking=no -i instance_key $USERNAME@$HOST "sudo cat $FILE")

# Encode the file content in base64
FILE_CONTENT_BASE64=$(echo -n "$FILE_CONTENT" | base64 -w0) # Linux

# Print the base64-encoded file content as a JSON object
echo "{\"file_content\": \"$FILE_CONTENT_BASE64\"}"