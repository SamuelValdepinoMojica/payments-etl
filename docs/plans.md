# Plan de Ejecución y Estrategia de Datos

## Estrategia de Particionamiento
Se implementó `PARTITION BY RANGE` en la tabla `txn` basado en el campo `created_at`.
* **Objetivo:** Mejorar el rendimiento de consultas históricas y facilitar el mantenimiento (drops de particiones viejas).
* **Implementación:** Particiones mensuales automáticas.

## Índices
Se crearon índices B-Tree en las columnas `txn_id` y `merchant_id` para optimizar los JOINS más frecuentes en los reportes de conciliación.