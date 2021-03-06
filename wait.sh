#!/usr/bin/env ash

export PGPASSWORD=$POSTGRES_PASSWORD

echo 
echo

echo "Starting workshop REPL (https://github.com/dbcli/pgcli)"

echo
echo

echo "#     #                         #######                      "
echo "##   ##   ##   #####  ######       #    ######  ####  #    # "
echo "# # # #  #  #  #    # #            #    #      #    # #    # "
echo "#  #  # #    # #    # #####        #    #####  #      ###### "
echo "#     # ###### #    # #            #    #      #      #    # "
echo "#     # #    # #    # #            #    #      #    # #    # "
echo "#     # #    # #####  ######       #    ######  ####  #    # "

echo
echo

while ! psql --username $POSTGRES_USER --host $POSTGRES_HOST --port $POSTGRES_PORT -c 'SELECT 1' $POSTGRES_DB; do
  echo 'Waiting for db';
  sleep 3;
done

pgcli $DB_URL

