# Use the official Postgres image as the base
FROM postgres:16

# Copy the SQL files into the initialization directory.
# Postgres executes these in alphabetical order (001 -> 002 -> 003 -> 004).
COPY ./migrations/001_create_users.sql /docker-entrypoint-initdb.d/
COPY ./migrations/002_create_tasks.sql /docker-entrypoint-initdb.d/
COPY ./migrations/003_insert_demo_data.sql /docker-entrypoint-initdb.d/
COPY ./migrations/004_alter_enums_tasks.sql /docker-entrypoint-initdb.d/