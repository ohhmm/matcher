#!/bin/bash

INPUT="Select better match"
MODEL_KEY_NAME="google/gemma-4-e4b"

# List models
echo "Listing models with curl http://localhost:1234/api/v1/models -H \"Authorization: Bearer $LM_API_TOKEN\""
curl http://localhost:1234/api/v1/models -H "Authorization: Bearer $LM_API_TOKEN"
echo

# Download 
echo "Downloading model with curl http://localhost:1234/api/v1/models/download \
  -H \"Authorization: Bearer $LM_API_TOKEN\" \
  -H \"Content-Type: application/json\" \
  -d \"{ "model": \"$MODEL_KEY_NAME\" }\""
curl http://localhost:1234/api/v1/models/download \
  -H "Authorization: Bearer $LM_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{ \"model\": \"$MODEL_KEY_NAME\" }"
echo
