#!/bin/bash


pip install pika --quiet || true


python scripts/queue_kickoff.py