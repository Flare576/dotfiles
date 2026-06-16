#!/usr/bin/env bash
# omp-atlassian.sh — Multi-instance Atlassian credential resolver
#
# Usage: omp-atlassian.sh <instance> <script.mjs> [args...]
#   instance: rp, asu, or any PREFIX with PREFIX_EMAIL + PREFIX_ATLASSIAN_TOKEN + PREFIX_ATLASSIAN_URL in env
#
# Secrets come from ~/.doNotCommit.d/ — never defined here.
# To add a new instance: add PREFIX_EMAIL, PREFIX_ATLASSIAN_TOKEN, PREFIX_ATLASSIAN_URL to ~/.doNotCommit.d/

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: omp-atlassian.sh <instance> <script.mjs> [args...]" >&2
  exit 1
fi

INSTANCE=$(echo "$1" | tr '[:lower:]' '[:upper:]')
SCRIPT="$2"
shift 2

EMAIL_VAR="${INSTANCE}_EMAIL"
TOKEN_VAR="${INSTANCE}_ATLASSIAN_TOKEN"
URL_VAR="${INSTANCE}_ATLASSIAN_URL"

export ATLASSIAN_EMAIL="${!EMAIL_VAR:?${EMAIL_VAR} not set — add to ~/.doNotCommit.d/}"
export ATLASSIAN_API_TOKEN="${!TOKEN_VAR:?${TOKEN_VAR} not set — add to ~/.doNotCommit.d/}"
export ATLASSIAN_DOMAIN
ATLASSIAN_DOMAIN=$(echo "${!URL_VAR:?${URL_VAR} not set — add to ~/.doNotCommit.d/}" | sed -E 's|https?://||;s|/$||')

exec node "$(dirname "$0")/$SCRIPT" "$@"
