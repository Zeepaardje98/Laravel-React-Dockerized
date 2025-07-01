#!/bin/bash

# Hardcoded database connection variables (TEMPORARY. REMOVE LATER)
DB_HOST=db
DB_PORT=3306
DB_DATABASE=laravel_app_db
DB_USERNAME=admin
DB_PASSWORD=password

# Drop and recreate the test database
# mysql -h "db" -P "3306" -u "admin" -p"password" -e "DROP DATABASE IF EXISTS \`laravel_app_db_testing\`;"
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "DROP DATABASE IF EXISTS \`${DB_DATABASE}_testing\`;"
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" -e "CREATE DATABASE \`${DB_DATABASE}_testing\`;"

# Dump the main database schema (and optionally data) and import into test database
mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_DATABASE" | mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "${DB_DATABASE}_testing"
