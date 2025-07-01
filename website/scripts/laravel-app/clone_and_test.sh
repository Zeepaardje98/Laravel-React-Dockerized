#!/bin/bash
set -e

# Run the DB clone script as testrunner
su testrunner -c "/usr/local/bin/clone_db_for_testing.sh"

# Run php artisan test as www-data
su www-data -s /bin/sh -c "cd /var/www && php artisan test"