#!/bin/bash

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

SQL_DIR="${BASE_DIR}/${APP}/sql/${DT}.schema.${DST_DB}"
if [ ! -d "${SQL_DIR}" ]; then
	mkdir "${SQL_DIR}"
fi

pg_dump -U ${DST_USER} -h ${DST_HOST} -d ${DST_DB} -s -f ${SQL_DIR}.sql
cat ${SQL_DIR}.sql | sed -z -e 's/\n    ADD/    ADD/g' | grep "PRIMARY KEY" | sort > ${SQL_DIR}.sql.pkey

psql -U ${DST_USER} -h ${DST_HOST} -d ${DST_DB} -Atc "select tablename from pg_tables where schemaname='public'" |\
	while read TBL; do
		echo "Exporting ${DST_DB}/${TBL}"
		pg_dump -U ${DST_USER} -h ${DST_HOST} -d ${DST_DB} -s -f ${SQL_DIR}/${TBL}.sql -t "\"${TBL}\""
	done

