#!/bin/bash

ERROR=0

BASE_DIR="$( dirname ${BASH_SOURCE[0]} )"
APP="$( basename ${BASE_DIR} )"
if [ -z "${APP_GRP}" ]; then
	echo "Error - no APP_GRP variable set"
	echo "Please set one by"
	echo "export APP_GRP=groupName"
	echo "command"
	echo "This will be used to read MySQL connection details from .my.cnf file"
	echo "pgloader can't read .my.cnf file yet - https://github.com/dimitri/pgloader/issues/767 "
	ERROR=1
fi
ENV=${APP_GRP}
export MYSQL_GROUP_SUFFIX=${APP_GRP}

if [ ! -f ${HOME}/.pgpass ]; then
	echo "PGPASS file ${HOME}/.pgpass does not exist"
	echo "Please create one as described in"
	echo "https://www.postgresql.org/docs/9.6/static/libpq-pgpass.html"
	ERROR=1
fi

if [ ! -f ${HOME}/.my.cnf ]; then
	echo "MYCNF file ${HOME}/.my.cnf does not exist"
	echo "Please create one as described in"
	echo "https://dev.mysql.com/doc/refman/5.6/en/password-security-user.html"
	echo "https://dev.mysql.com/doc/refman/5.6/en/option-file-options.html#option_general_defaults-group-suffix"
	ERROR=1
else
	export MYSQL_HOST=`     cat ${HOME}/.my.cnf | grep "client${ENV}" -A 5 | grep host     | awk '{print $3}'`
	export MYSQL_PWD=`      cat ${HOME}/.my.cnf | grep "client${ENV}" -A 5 | grep password | awk '{print $3}'`
	export MYSQL_TCP_PORT=` cat ${HOME}/.my.cnf | grep "client${ENV}" -A 5 | grep port     | awk '{print $3}'`
fi

DT=$( date +%Y%m%d-%H%M%S )

