# Diseño de Configuración PostgreSQL

Para este entorno de escritura intensiva, se define la siguiente configuración óptima en `postgresql.conf`:

* **shared_buffers:** 256MB. Dimensionado para aprovechar la memoria del contenedor.
* **work_mem:** 16MB. Para permitir ordenamientos en memoria RAM.
* **wal_compression:** on. Crítico para reducir I/O en disco durante cargas masivas.
* **max_wal_size:** 1GB. Para espaciar los checkpoints.