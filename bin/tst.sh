#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Source helper functions
source "$ROOT_DIR/lib/helper/arg_handler.sh"
source "$ROOT_DIR/lib/helper/msg_handler.sh"

# Source argument functions
source "$ROOT_DIR/lib/args/k_keywords.sh"

main() {
    if [ $1 = "-k" ] || [ $1 = "--keywords" ]; then
        keywords "$2"
    fi
}

main "$@"