# Procedimiento de Backup y Restore

## Backup
El backup se genera ejecutando `pg_dump` desde el interior del contenedor para garantizar compatibilidad de versiones.

    docker exec -t postgres_db pg_dump -U db_user -d payments_db > backup_full.sql

## Restore (Recuperación)
Procedimiento para restaurar la base de datos en caso de fallo.

1. Detener el tráfico:
Apagar el worker para evitar inconsistencias durante la restauración.

    docker compose stop worker

2. Ejecutar Restore:
Inyectar el archivo SQL al contenedor.

En Linux / Mac / Git Bash:

    cat backup_full.sql | docker exec -i postgres_db psql -U db_user -d payments_db

En Windows PowerShell:

    Get-Content backup_full.sql | docker exec -i postgres_db psql -U db_user -d payments_db