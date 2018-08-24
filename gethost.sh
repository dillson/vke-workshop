#!/bin/bash
CLUSTER=$1
OUTPUT="$(vke cluster show $1 | grep Address | awk '{print $2}')"
echo $OUTPUT
