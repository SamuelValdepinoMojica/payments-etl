# Tuning de PostgreSQL

Se ajustaron los siguientes parámetros en `postgresql.conf` para una instancia dedicada a escritura intensiva:

* **shared_buffers:** Ajustado para aprovechar la memoria del contenedor sin causar OOM.
* **effective_cache_size:** Configurado para estimar la disponibilidad de caché del sistema operativo.
* **work_mem:** Incrementado para permitir ordenamientos en memoria antes de escribir en disco temporal.
* **wal_compression:** Activado (`on`) para reducir la I/O en disco durante cargas masivas.