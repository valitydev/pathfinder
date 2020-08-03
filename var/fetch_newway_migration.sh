#!/bin/bash
set -e
ROOT_DIR="$(pwd)"
OUT_FILE="${1}"

[ -z "${OUT_FILE}" ] && exit 127

OUT_PATH="$ROOT_DIR/$OUT_FILE"

if test -f "$OUT_PATH"; then
    echo "$OUT_PATH already exists."
    exit 127
fi

git clone https://github.com/rbkmoney/newway.git tmp/newway
cd tmp/newway/src/main/resources/db/migration

for FILENAME in V?_*.sql; do
    echo -e "\n-- $FILENAME --\n" >> "$OUT_PATH"
    cat "$FILENAME" >> "$OUT_PATH"
done

for FILENAME in V??__*.sql; do
    echo -e "\n-- $FILENAME --\n" >> "$OUT_PATH"
    cat "$FILENAME" >> "$OUT_PATH"
done

cd $ROOT_DIR
rm -rf tmp
