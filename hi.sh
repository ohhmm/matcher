#!/bin/bash

INPUT="Hi"
if [ "$#" -ne 0 ]; then
    INPUT=$@
fi
MODEL_KEY_NAME="google/gemma-4-e4b"
LM_API_TOKEN="lm-studio"

curl http://localhost:1234/api/v1/chat   -H "Authorization: Bearer $LM_API_TOKEN"   -H "Content-Type: application/json"   -d "{
    \"model\": \"$MODEL_KEY_NAME\",
    \"input\": \"${INPUT}\",
    \"store\": false
  }" --progress-bar  | grep  -A2 '"type": "message"'  | grep '"content"' | sed -e 's/.*"content": "\(.*\)".*/\1/' | sed 's/\\n/\n/g'
