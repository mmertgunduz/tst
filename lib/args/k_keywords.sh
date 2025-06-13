#!/usr/bin/env bash

# Function: keywords
# ------------------
# Extracts and counts meaningful keywords from a given text file by filtering out common 
# stop words, numbers, and trivial tokens. The output is a frequency-sorted list of 
# keywords printed to stdout.
#
# Usage:
#   tst -k, --keywords <filename>
#
# Limitations:
#   Assumes UTF-8 or ASCII input; may not handle multibyte or special Unicode characters properly.
#
# Output:
#   Prints to stdout a list of keywords with their counts, sorted in descending order 
#   of frequency.

keywords() {
    local FILE=$1

    if [ ! -f "${FILE}" ]; then
        msg "cannot access $1, no such file" >&2
        return 1
    fi

    # Define isolation words by reading from .config to exclude from keywords analysis 
    local ISOLATION_FILE="${HOME}/.config/tst/tisolation.txt"

    if [ ! -f "${ISOLATION_FILE}" ]; then
        msg "cannot access tisolation.txt, no such file or wrong permissions " >&2
        return 1
    fi

    local ISOLATION_WORDS
    ISOLATION_WORDS=$(tr '\n' '|' < "$ISOLATION_FILE" | sed 's/|$//')

    # Process the keywords
    tr -s '[:space:]' '\n' < "${FILE}" | \
    sed -e 's/[–—−]/-/g' | \
    sed -E 's/^[[:punct:]\/]+//; s/[[:punct:]\/]+$//' | \
    sed -E 's/[^[:alnum:]\/-]+/ /g' | \
    tr '[:upper:]' '[:lower:]' | \
    grep -Ev -i '\b('"$ISOLATION_WORDS"')\b' | \
    grep -Ev '^[0-9]+$' | \
    grep -Ev '^[a-zA-Z]$' | \
    sed '/^$/d' | \
    sort | \
    uniq -c | \
    sort -nr 

    return 0
}