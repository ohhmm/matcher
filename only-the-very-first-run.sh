#!/bin/bash

DIR="${1:-.}"

echo "Get LM-Studio installed!"
$DIR/install-lmstudio-server.sh

echo " If LM Studio installed, lets download a model"
$DIR/download-model.sh
