#/bin/bash

BASE_DIR=`dirname ${BASH_SOURCE[0]}`

cd ${BASE_DIR}

if [ -f my2pg-step00-exports.sh -a -f my2pg-step00-settings.sh ]; then
	source my2pg-step00-exports.sh
	source my2pg-step00-settings.sh
	if [ "${ERROR}" = "1" ]; then
		echo "Error setting variables"
		exit 0
	fi
else
	echo "Exports file \"my2pg-step00-exports.sh\" does not exist"
	echo "Settings file \"my2pg-step00-settings.sh\" does not exist"
	exit 0
fi

PKEY_ALTER_SEL="select pk_rename
from
(
SELECT      table_name, FORMAT('ALTER INDEX IF EXISTS \"%s\" RENAME TO \"%s_pkey\";', constraint_name, table_name) as pk_rename
FROM        information_schema.table_constraints
WHERE       UPPER(constraint_type) = 'PRIMARY KEY'






) as pkeys
ORDER BY    table_name;"

PKEY_ALTER_SQL=$(psql -U ${DST_USER} -h ${DST_HOST} -d ${DST_DB} -Atc "${PKEY_ALTER_SEL}")

#echo ${PKEY_ALTER_SQL}

psql -U ${DST_USER} -h ${DST_HOST} -d ${DST_DB} -Atc "${PKEY_ALTER_SQL}"

