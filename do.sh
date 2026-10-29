#!/bin/bash

INPUT="Hi"
if [ "$#" -ne 0 ]; then
    INPUT=$@
fi

ollama launch claude --model beam:cloud -- --allow-dangerously-skip-permissions --dangerously-skip-permissions --effort max --no-session-persistence --allowed-tools "*" -p "${INPUT}"
