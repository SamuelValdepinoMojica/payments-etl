# 💸 Payments ETL Pipeline

Sistema distribuido de procesamiento de pagos e ingeniería de datos. Implementa una arquitectura de microservicios para la ingesta, encolado (RabbitMQ) y procesamiento transaccional (Worker Python) de altos volúmenes de datos.

## 📋 Descripción del Proyecto

Este proyecto simula un entorno de producción para transacciones financieras. Demuestra:
* Infraestructura como Código (IaC) con Docker Compose.
* Ingeniería de Datos y particionamiento PostgreSQL.
* Sistemas Distribuidos y desacoplamiento con RabbitMQ.
* Automatización de scripts y cargas masivas.

## 🚀 Quick Start (Cómo ejecutarlo)

Sigue estos pasos para levantar toda la arquitectura:

### Paso 1: Configuración
Crea el archivo de variables de entorno copiando el ejemplo:

    cp .env.example .env

### Paso 2: Ejecución Automática
Ejecuta el siguiente comando para levantar contenedores, cargar la base de datos (1M registros) e iniciar el Worker.

En Linux / Mac / Git Bash:

    docker compose up -d && ./scripts/bootstrap.sh

En Windows PowerShell:

    docker compose up -d; sh scripts/bootstrap.sh

> **Nota:** El script automatiza el levantamiento, la carga de datos (seed) y el inicio del flujo de mensajes (kickoff).

## 🏗 Arquitectura del Sistema

| Servicio | Descripción |
| :--- | :--- |
| **db** | PostgreSQL particionado y optimizado para escritura. |
| **rabbitmq** | Broker de mensajería para desacoplar procesos. |
| **worker** | Procesador Python que consume eventos y asegura consistencia ACID. |
| **prometheus** | Recolector de métricas. |
| **grafana** | Visualización de dashboards (Puerto 3000). |

## 📂 Estructura del Repositorio

    /
    ├── compose/           # Infraestructura Docker
    ├── db/                # Configuración y schemas SQL
    ├── etl/               # Código del Worker Python
    ├── scripts/           # Scripts de automatización
    ├── docs/              # Documentación técnica
    ├── .env.example       # Variables de ejemplo
    └── README.md          # Este archivo

## ⚙️ Detalles Técnicos

* **Particionamiento:** Tabla `txn` particionada por rango de fechas.
* **Integridad:** Uso de transacciones atómicas.
* **Resiliencia:** Reconexión automática y manejo de errores.

## 📊 Accesos

* **RabbitMQ:** http://localhost:15672
* **Grafana:** http://localhost:3000