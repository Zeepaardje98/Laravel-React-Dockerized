#!/bin/bash

# Usage: ./run_tests.sh [testing|integration] [filter]
# Examples:
#   ./run_tests.sh testing                  # Run all tests in testing environment
#   ./run_tests.sh integration              # Run all tests in integration environment
#   ./run_tests.sh testing AuthenticationTest # Run only AuthenticationTest
#   ./run_tests.sh testing --filter=login  # Run only tests with "login" in the name
#   ./run_tests.sh                         # Run all tests

TEST_TYPE="$1"
FILTER="$2"

# Start the environment and run tests
echo "Running tests in $TEST_TYPE environment..."
./run_env.sh test $TEST_TYPE

# Determine container names based on test type
APP_CONTAINER="laravel_app_$TEST_TYPE"

# Build test command with optional filter
TEST_CMD="php artisan test"
if [ ! -z "$FILTER" ]; then
    TEST_CMD="$TEST_CMD --filter=$FILTER"
fi

# Wait for database to be ready (only for integration tests)
if [ "$TEST_TYPE" = "integration" ]; then
    echo "Waiting for database to be ready..."
    until docker exec laravel_db_integration mysqladmin ping -h localhost -u admin -ppassword --silent; do
        echo "Database not ready yet, waiting..."
        sleep 2
    done
    echo "Database is ready!"
fi

# Run tests in the appropriate container
case $TEST_TYPE in
    "testing"|"integration")
        docker exec $APP_CONTAINER $TEST_CMD
        ;;
    *)
        echo "Invalid test type: $TEST_TYPE"
        echo "Usage: ./run_tests.sh [testing|integration] [filter]"
        exit 1
        ;;
esac

echo "Tests completed!" 