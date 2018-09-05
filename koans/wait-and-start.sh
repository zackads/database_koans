#!/usr/bin/env ash

export PGPASSWORD=$POSTGRES_PASSWORD
while ! psql --username $POSTGRES_USER --host $POSTGRES_HOST --port $POSTGRES_PORT -c 'SELECT 1' $POSTGRES_DB; do
  echo 'Waiting for db';
  sleep 3;
done

bundle exec rerun -- ruby start.rb

