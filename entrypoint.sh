#!/bin/sh

# Wait for the database to be ready
echo "Waiting for postgres..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "PostgreSQL started"

# Run database migrations and update coordinates
python app/base/manage.py migrate
python app/base/manage.py update_coordinates
python app/base/manage.py setup_permissions

# Run the Django development server
exec "$@"
