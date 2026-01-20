# Monitoreo y Alertas

Se define la siguiente regla crítica en Prometheus para la disponibilidad de la DB:

## Alerta: PostgresDown
* **Condición:** `pg_up == 0` (La métrica de conexión cae a 0).
* **Duración:** `for: 1m` (Si persiste más de 1 minuto).
* **Severidad:** Crítica.
* **Acción:** Revisar logs del contenedor `db` y reiniciar el servicio.