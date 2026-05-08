#!/bin/bash
# kpi-benchmark.sh
# Commands used to measure KPI performance in cloud and non-cloud environments

# ============================================================
# KPI 1 — HTTP RESPONSE TIME
# ============================================================

# Non-cloud — run 20 consecutive requests
for i in $(seq 1 20); do
  curl -o /dev/null -s -w "%{time_total}\n" http://localhost:8000
done

# Cloud — run 20 consecutive requests
for i in $(seq 1 20); do
  curl -o /dev/null -s -w "%{time_total}\n" http://172.24.4.156:8000
done

# ============================================================
# KPI 2 — CPU AND MEMORY UTILISATION
# ============================================================

# Check container CPU and memory usage (single snapshot)
docker stats --no-stream

# Check container CPU and memory usage (live)
docker stats

# ============================================================
# KPI 3 — DEPLOYMENT TIME
# ============================================================

# Non-cloud — measure full docker compose restart time
time docker compose down && docker compose up -d

# Cloud — measure full docker compose restart time (run inside instance)
# ssh ubuntu@172.24.4.156
time docker compose down && docker compose up -d

# ============================================================
# ADDITIONAL — VERIFY DATABASE RECORDS
# ============================================================

# Check record count via Django shell
docker exec -it fit_web_1 python manage.py shell -c \
"from coverage.models import City, Deployment; \
print('Cities:', City.objects.count()); \
print('Deployments:', Deployment.objects.count())"
