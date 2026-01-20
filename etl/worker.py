import os
import time
import json
import pika
import psycopg2

# Configuracion de entorno
DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "payments_db")
DB_USER = os.getenv("DB_USER", "db_user")
DB_PASS = os.getenv("DB_PASSWORD", "db_password")
RABBIT_HOST = os.getenv("RABBITMQ_HOST", "rabbitmq")
QUEUE_NAME = 'etl_queue'

def get_db_connection():
    return psycopg2.connect(host=DB_HOST, database=DB_NAME, user=DB_USER, password=DB_PASS)

def callback(ch, method, properties, body):
    txn_id = None
    try:
        # 1. Leer mensaje
        message = json.loads(body)
        txn_id = message.get('txn_id')
        print(f"[INFO] Processing txn_id: {txn_id}", flush=True)

        # 2. Actualizar DB
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("UPDATE txn SET status = 'finished' WHERE txn_id = %s", (txn_id,))
        conn.commit()
        cur.close()
        conn.close()

        print(f"[INFO] txn_id {txn_id} updated successfully", flush=True)

    except Exception as e:
        print(f"[ERROR] Failed to process txn_id {txn_id}: {e}", flush=True)

    # 3. Confirmar a RabbitMQ
    ch.basic_ack(delivery_tag=method.delivery_tag)

def main():
    print("[INFO] Waiting for RabbitMQ...", flush=True)
    time.sleep(10)

    # Conexion RabbitMQ
    connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBIT_HOST))
    channel = connection.channel()
    channel.queue_declare(queue=QUEUE_NAME, durable=True)

    print("[INFO] Worker started. Waiting for messages.", flush=True)

    # Consumo de mensajes
    channel.basic_qos(prefetch_count=1)
    channel.basic_consume(queue=QUEUE_NAME, on_message_callback=callback)
    channel.start_consuming()

if __name__ == '__main__':
    main()