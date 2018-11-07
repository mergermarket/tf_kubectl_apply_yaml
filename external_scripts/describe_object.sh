#!/bin/bash

set -e

eval "$(jq -r '@sh "type=\(.type) name=\(.name) namespace=\(.namespace)"')"

echo "kubectl describe $type $name --namespace $namespace || echo 'missing'" > output
roles="$(kubectl describe $type $name --namespace $namespace || echo 'missing')"

# Safely produce a JSON object containing the result value.
# jq will ensure that the value is properly quoted
# and escaped to produce a valid JSON string.
jq -n --arg roles "$roles" '{"roles":$roles}'
