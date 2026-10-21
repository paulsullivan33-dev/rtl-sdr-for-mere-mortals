#!/bin/sh
# Fetch the recorded slice of sky this guide decodes:
# testfiles/modes1.bin from the dump1090 project
# (Salvatore Sanfilippo's original Mode S decoder,
# github.com/antirez/dump1090). It is a real
# recording of real 1090 MHz traffic, made with
# rtl_sdr at 2 MHz sample rate, and distributed
# with the decoder so anyone can test without a
# receiver. 713,736 bytes.
#
# Usage: sh fetch-sample.sh [output-file]
# Default output: ./modes1.bin
#
# The expected SHA-256 is checked at the end; if
# upstream ever changes the file, the check says
# so instead of letting a different recording
# quietly take its place in your captures.

set -eu

URL="https://raw.githubusercontent.com/antirez/dump1090/master/testfiles/modes1.bin"
EXPECTED="3a33e16025da8669149c780075950b4e908ca036ea21f9583c113f60d5fb3094"
OUT="${1:-modes1.bin}"

curl -fsSL -o "$OUT" "$URL"
echo "downloaded $OUT"

if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL="$(sha256sum "$OUT" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
    ACTUAL="$(shasum -a 256 "$OUT" | awk '{print $1}')"
else
    echo "no sha256 tool found; check the file by hand against:"
    echo "  $EXPECTED"
    exit 0
fi

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "sha256 matches the recording this guide decodes"
else
    echo "WARNING: sha256 differs from the guide's recording"
    echo "  expected $EXPECTED"
    echo "  got      $ACTUAL"
    exit 1
fi
