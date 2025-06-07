#!/bin/bash

CHANNEL_URL=$1

if [ -z "$CHANNEL_URL" ]; then
  echo "Usage: $0 https://www.youtube.com/@SomeHandle"
  exit 1
fi

# Fetch the channel page HTML
HTML=$(curl -sL "$CHANNEL_URL")

# Extract the browse_id is usually in JSON as: "browseId":"UCxxxxxx"
CHANNEL_ID=$(echo "$HTML" | grep -oP '"browseId":"\KUC[a-zA-Z0-9_-]{22}' | head -1)

if [ -z "$CHANNEL_ID" ]; then
  echo "Channel ID not found"
  exit 1
fi

echo "Channel ID: $CHANNEL_ID"
