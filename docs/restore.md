# Procedimiento de Backup y Restore

## Backup
El backup se genera ejecutando `pg_dump` desde el interior del contenedor para garantizar compatibilidad de versiones.

```bash
# Comando para generar el backup
docker exec -t postgres_db pg_dump -U db_user -d payments_db > backup_full.sql