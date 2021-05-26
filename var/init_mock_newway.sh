#!/bin/bash
set -e

NEWWAY_DIR="${1:-/var/newway}"

for FILENAME in ${NEWWAY_DIR}/src/main/resources/db/migration/V?_*.sql; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -a -q -f $FILENAME
done

for FILENAME in ${NEWWAY_DIR}/src/main/resources/db/migration/V??__*.sql; do
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -a -q -f $FILENAME
done
