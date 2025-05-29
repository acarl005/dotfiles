#!/bin/bash

set -e

ARTIST=$(playerctl metadata artist)
TITLE=$(playerctl metadata title)

echo "  ${ARTIST} — ${TITLE}"
