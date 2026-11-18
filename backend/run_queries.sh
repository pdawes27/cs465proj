#!/bin/bash

DB="financeWebsite.db"

# Reseting database
echo "Removing current Database"
rm -f $DB

# Inserting tables and data
echo "Resetting Database"
sqlite3 "$DB" < ./schema.sql
sqlite3 "$DB" < ./insert_data.sql

# Running queries
echo "Running Queries"
sqlite3 "$DB" < ./queries.sql

# Running Transaction
echo "Running Transaction"
sqlite3 "$DB" < ./transaction.sql
status=$?

if [ "$status" -eq 0 ]; then
    echo "Transaction completed successfully."
else
    echo "Transaction failed."
    echo "Uncommitted changes were rolled back."
fi

echo "Done"