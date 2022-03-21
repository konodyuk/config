#!/bin/bash

# Note: Session X v2.1.6 required: https://www.stayinsession.com/

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Session
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/session.png
# @raycast.packageName Session

# @Documentation:
# @raycast.description Starts a focus session in Session app
# @raycast.author James Lyons
# @raycast.authorURL https://github.com/jamesjlyons

# @raycast.argument1 { "type": "text", "placeholder": "Intent", "optional": true, "percentEncoded": true }
# @raycast.argument2 { "type": "text", "placeholder": "Category", "optional": true }
# @raycast.argument3 { "type": "text", "placeholder": "Minutes duration", "optional": true }

CATEGORY=$(python3 <<EOF
options = [
    "education",
    "general",
    "personal"
    "rest",
    "work",
]
query = "${2}"
def dist(a, b):
    result = 0
    for i, j in zip(a, b):
        result += abs(ord(i) - ord(j))
    return result
def get_closest(q):
    best_ans, best_dist = options[0], 10000
    for candidate in options:
        cur_dist = dist(q, candidate)
        if cur_dist < best_dist:
            best_dist = cur_dist
            best_ans = candidate
    return best_ans
if query:
    print(get_closest(query))
else:
    print("general")
EOF
)

open "session:///start?intent=${1}&categoryName=$CATEGORY&duration=${3}"
