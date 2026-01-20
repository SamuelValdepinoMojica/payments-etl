
source .env
sleep 10
docker exec -e PGPASSWORD=$DB_PASSWORD -i postgres_db psql -U $DB_USER -d $DB_NAME < scripts/seed.sql
sh scripts/queue_kickoff.sh