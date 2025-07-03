#!/bin/sh
set -e

# Source root password from Docker secret
# if [ -f /run/secrets/mysql_db_rootpass ]; then
#   DB_ROOT_PASSWORD=$(cat /run/secrets/mysql_db_rootpass | tr -d '\r\n')
#   export DB_ROOT_PASSWORD
# fi

# Source main app db credentials from split secrets
if [ -f /run/secrets/mysql_app_db_username ]; then
  DB_USERNAME=$(cat /run/secrets/mysql_app_db_username | tr -d '\r\n')
  export DB_USERNAME
fi
if [ -f /run/secrets/mysql_app_db_password ]; then
  DB_PASSWORD=$(cat /run/secrets/mysql_app_db_password | tr -d '\r\n')
  export DB_PASSWORD
fi
if [ -f /run/secrets/mysql_app_db_database ]; then
  DB_DATABASE=$(cat /run/secrets/mysql_app_db_database | tr -d '\r\n')
  export DB_DATABASE
fi

# Source testing db credentials from split secrets
if [ -f /run/secrets/mysql_testing_db_username ]; then
  DB_USER_TESTING=$(cat /run/secrets/mysql_testing_db_username | tr -d '\r\n')
  export DB_USER_TESTING
fi
if [ -f /run/secrets/mysql_testing_db_password ]; then
  DB_PASSWORD_TESTING=$(cat /run/secrets/mysql_testing_db_password | tr -d '\r\n')
  export DB_PASSWORD_TESTING
fi
if [ -f /run/secrets/mysql_testing_db_database ]; then
  DB_DATABASE_TESTING=$(cat /run/secrets/mysql_testing_db_database | tr -d '\r\n')
  export DB_DATABASE_TESTING
fi
