# Reporte Preliminar de Rendimiento

Dado el alcance de la prueba, el análisis de rendimiento se centró en la capacidad de ingesta masiva (Write Throughput) durante el proceso de bootstrap.

## Prueba: Carga Inicial de Datos
* **Escenario:** Inserción de 1,000,000 de registros sintéticos en la tabla `txn`.
* **Método:** Script SQL (`seed.sql`) ejecutado directamente sobre el motor.

## Observaciones
1. **Tiempo de Ejecución:** La carga del millón de registros se completa en aproximadamente 10-15 segundos en un entorno local Dockerizado.
2. **Integridad:** El particionamiento por rangos (`PARTITION BY RANGE`) no mostró degradación significativa en la velocidad de inserción comparado con una tabla plana (heap table).

## Próximos Pasos (To-Do)
Para un entorno de producción, se recomienda ejecutar pruebas formales utilizando:
* **pgbench:** Para simular concurrencia de clientes (lectura/escritura).
* **Escenarios de estrés:** Validar el comportamiento del Worker cuando la cola de RabbitMQ supera los 10k mensajes pendientes.