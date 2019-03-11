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

if [ -z "${1}" ]; then
	echo "Command line option is missing"
	echo "Options are:"
	echo "   1. schema - copy schema only"
	echo "   2. data   - copy data only"
	echo "   3. full   - full copy"
	exit 0
fi

case "${1}" in
	schema|data|full)
		CNF="/pgsql/pgloader/${APP}/${APP}-${ENV}-${1}.migrate"
		sed -e "s/\^\^SRC_USER\^\^/${SRC_USER}/g; s/\^\^SRC_HOST\^\^/${SRC_HOST}/g; s/\^\^SRC_DB\^\^/${SRC_DB}/g; s/\^\^DST_USER\^\^/${DST_USER}/g; s/\^\^DST_HOST\^\^/${DST_HOST}/g; s/\^\^DST_DB\^\^/${DST_DB}/g; " "${BASE_DIR}/${APP}/${APP}-envXX-${1}.migrate" > "${BASE_DIR}/${APP}/${APP}-${ENV}-${1}.migrate"
	;;
	*)
		echo "Wrong value for the option"
		echo "Should be schema, data or full"
		exit 0
	;;
esac

${BASE_DIR}/pgloader/build/bin/pgloader \
	--verbose \
	--root-dir ${BASE_DIR}/${APP}/tmp \
	--logfile  ${BASE_DIR}/${APP}/log/pgloader-standard-${DT}.log \
	${CNF} \
	| tee -a ${BASE_DIR}/${APP}/log/pgloader-verbose-${DT}.log

echo 
echo -e "-------------------------------------------------------------------------------------"
echo -e "--------------------------------- Done ----------------------------------------------"
echo -e "----------------------------\t${SRC_DB}\t----------------------------"
echo -e "-------------------------------------------------------------------------------------"
echo
echo "run my2pg-step02-pkeys.sh for PRIMARY KEYS FIX"
echo
echo "run my2pg-step03-export.sh for schema export and compare"
echo

# Clean-up
unset MYSQL_GROUP_SUFFIX
unset MYSQL_HOST
unset MYSQL_PWD
unset MYSQL_TCP_PORT

