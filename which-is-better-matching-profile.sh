#!/bin/bash

# --- Params VALIDATION ---
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <Job_Description_File> <Resume_Candidate1_PDF> <Resume_Candidate2_PDF>"
    echo "Example: $0 job.txt resume1.pdf resume2.pdf"
    exit 1
fi

PDF1TXT="${2%.*}.txt"
( pdftotext -layout $2 - > $PDF1TXT ) &
PDFtoTXTpid1=$!

PDF2TXT="${3%.*}.txt"
( pdftotext -layout $3 - > $PDF2TXT ) &
PDFtoTXTpid2=$!

escape_json() {
    printf '%s' "$1" | awk '{
        gsub(/\\/, "\\\\")
        gsub(/"/, "\\\"")
        gsub(/\x0C/, "")
        printf "%s\\n", $0
    }'
}

escape_json yo

DIR="${0%/*}"
LM_API_TOKEN="lm-studio"
MODEL_KEY_NAME="google/gemma-4-e4b"
INPUT="Select better match from pdfs attached to the job desciption. Which fits better Candidate 1 Resume or Candidate 1 Resume? Please, only respond with 1 or 2. Thanks in advance!"
JOB_DESC_FILE="$1"
echo Converting PDF to TXT $PDF1TXT and $PDF2TXT
JOB_DESC_CONTENT=$(cat "$JOB_DESC_FILE")
wait $PDFtoTXTpid1
PDF1TXT_CONTENT=$(cat "$PDF1TXT")
echo PDF1 convertion complete
wait $PDFtoTXTpid2
PDF2TXT_CONTENT=$(cat "$PDF2TXT")
echo PDF2 convertion complete

ESCAPED_INPUT=$(escape_json "$INPUT")
echo input
echo $ESCAPED_INPUT
ESCAPED_JOB_DESC_CONTENT=$(escape_json "$JOB_DESC_CONTENT")
echo ESCAPED_JOB_DESC_CONTENT
echo $ESCAPED_JOB_DESC_CONTENT
ESCAPED_PDF1TXT_CONTENT=$(escape_json "$PDF1TXT_CONTENT")
echo ESCAPED_PDF1TXT_CONTENT
echo $ESCAPED_PDF1TXT_CONTENT
ESCAPED_PDF2TXT_CONTENT=$(escape_json "$PDF2TXT_CONTENT")
echo ESCAPED_PDF2TXT_CONTENT
echo $ESCAPED_PDF2TXT_CONTENT
REQUEST=$(escape_json "$INPUT \nJob description: \n $JOB_DESC_CONTENT \n Candidate 1 Resume: $PDF1TXT_CONTENT \n Candidate 2 Resume: $PDF2TXT_CONTENT")
REQUEST=$(escape_json "$INPUT \nJob description: \n $JOB_DESC_CONTENT \n Candidate 1 Resume: $PDF1TXT_CONTENT")
REQUEST=$(escape_json "$INPUT \nJob description: \n $JOB_DESC_CONTENT \\n Candidate 1 Resume: ") # ok
REQUEST=$(escape_json "$INPUT \nJob description: \n $JOB_DESC_CONTENT \\n Candidate 1 Resume: \"# □ ")
REQUEST=$(escape_json "$ESCAPED_INPUT \nJob description: \n $ESCAPED_JOB_DESC_CONTENT \n Candidate 1 Resume: $ESCAPED_PDF1TXT_CONTENT \n Candidate 2 Resume: $ESCAPED_PDF2TXT_CONTENT")
# $DIR/hi.sh "$INPUT \nJob description: \n $JOB_DESC_CONTENT \n Candidate 1 Resume: $PDF1TXT_CONTENT \n Candidate 2 Resume: $PDF2TXT_CONTENT "
echo REQUEST
echo $REQUEST
DATA="{ \"model\": \"$MODEL_KEY_NAME\",  \"input\": \"$REQUEST\", \"store\": false }"
echo DATA
echo $DATA

echo $DATA | curl http://localhost:1234/api/v1/chat \
  -H "Authorization: Bearer $LM_API_TOKEN" \
  -H "Content-Type: application/json" --data-binary @- --progress-bar  | grep  -A2 '"type": "message"'  | grep '"content"'
