# Estrategia de Monitoreo

Se ha diseñado la siguiente regla de alerta crítica para la integración con Prometheus/AlertManager:

## Alerta: PostgresDown
* **Condición:** `pg_up == 0`
* **Duración:** `for: 1m`
* **Severidad:** Crítica.
* **Protocolo:** Requiere reinicio manual del servicio `db` tras inspección de logs.