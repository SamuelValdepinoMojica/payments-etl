import os
import json
import random
import pika

RABBIT_HOST = os.getenv("RABBITMQ_HOST", "localhost")
QUEUE_NAME = 'etl_queue'

def main():
    try:
        connection = pika.BlockingConnection(pika.ConnectionParameters(host=RABBIT_HOST))
        channel = connection.channel()
        channel.queue_declare(queue=QUEUE_NAME, durable=True)

        ids = [random.randint(1000, 9999) for _ in range(5)]
        print(f"Sending {len(ids)} test events...")

        for txn_id in ids:
            message = {"txn_id": txn_id, "step": "stage"}
            
            channel.basic_publish(
                exchange='',
                routing_key=QUEUE_NAME,
                body=json.dumps(message),
                properties=pika.BasicProperties(delivery_mode=2)
            )
            print(f" [x] Sent txn_id: {txn_id}")

        connection.close()

    except Exception as e:
        print(f"Error connecting to RabbitMQ: {e}")

if __name__ == "__main__":
    main()