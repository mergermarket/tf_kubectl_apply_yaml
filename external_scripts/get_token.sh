#!/bin/sh

set -e

eval "$(jq -r '@sh "cluster=\(.cluster)"')"

token="$(aws-iam-authenticator token -i "$cluster" |jq -r '.status.token')"

jq -n --arg token "$token" '{"token":$token}'
