# OpenStack Private Cloud Deployment — 5G Coverage Analytics

> **Academic Assessment** 
---

## Overview

Deployment and evaluation of OpenStack as a private cloud infrastructure
on a MacBook M5 using DevStack within a UTM virtual machine running Ubuntu
24.04 LTS. A real-world 5G coverage analytics application was deployed on
both cloud and non-cloud environments using Docker and Docker Compose with
an automated CI/CD pipeline configured through GitLab.

---

## Environments

| Environment | Method | Hardware |
|-------------|--------|----------|
| Individual (cloud) | DevStack | MacBook M5 — UTM VM — Ubuntu 24.04 |
| Group (cloud) | Kolla-Ansible | Dedicated server |
| Non-cloud | Direct Docker | Ubuntu host |

---

## Network Configuration

| Component | IP |
|-----------|-----|
| Ubuntu VM (host) | 192.168.64.26 |
| OpenStack private network | 10.0.0.0/26 |
| Instance private IP | 10.0.0.45 |
| Instance floating IP | 172.24.4.156 |
| Public network | 172.24.4.0/24 |

---

## Application

5G deployment coverage analytics system built with Django, processing:
- 104,032 cities worldwide
- 145,627 deployment records
- 236 operators

**Stack:**
- Django web server — port 8000
- PostgreSQL 15 database — port 5432
- Docker + Docker Compose
- GitLab CI/CD pipeline

**GitLab Repository:**
https://gitlab.com/irfanessa123/fit/-/blob/5g-app/docker-compose.yml

---

## OpenStack Services Used

| Service | Role |
|---------|------|
| Nova | Compute — VM lifecycle management |
| Neutron | Networking — virtual networks and floating IPs |
| Glance | Image service — Ubuntu 22.04 ARM64 image |
| Keystone | Identity and authentication |
| Horizon | Web dashboard |

---

## Deployment Steps

1. Install DevStack with QEMU configuration
2. Configure Nova CPU mode for ARM64 (cortex-a57)
3. Upload Ubuntu 22.04 cloud image to Glance
4. Create m1.app2 flavour (2 vCPU, 2GB RAM, 10GB disk)
5. Register SSH keypair
6. Launch instance with cloud-config user data
7. Allocate and associate floating IP
8. Configure security groups (ports 22, 8000, ICMP)
9. SSH into instance and deploy application via Docker Compose
10. Import 145,627 records using chunked transactions
11. Configure GitLab CI/CD pipeline for automated deployment

---

## Troubleshooting Resolved

| Issue | Cause | Fix |
|-------|-------|-----|
| Nova CPU error | host-passthrough requires KVM | Set cpu_mode=custom, cortex-a57 |
| OVN floating IP failure after reboot | DevStack networking does not survive reboots | Full DevStack reinstallation |
| SSH authentication failure | cloud-init could not reach metadata service | Pass cloud-config via config-drive |
| Docker Compose compatibility error | v1.29.2 incompatible with new Docker Engine | Remove and recreate containers |
| GitLab CI/CD pipeline failures | YAML syntax and SSH key issues | Iterative debugging over 7 attempts |
| Data import timeout | Single transaction for 145,629 rows | Chunked imports of 5,000 rows per transaction |

---

## KPI Performance Results

### HTTP Response Time

| Metric | Non-Cloud | Cloud |
|--------|-----------|-------|
| Minimum | 0.041s | 0.838s |
| Maximum | 0.096s | 1.070s |
| Average | ~0.044s | ~0.874s |
| Difference | — | ~20x slower |

### CPU Utilisation (idle)

| Container | Non-Cloud | Cloud |
|-----------|-----------|-------|
| Django (fit_web_1) | 0.47% | 13.38% |
| PostgreSQL (fit_db_1) | 0.00% | 8.57% |

### Memory Usage

| Metric | Non-Cloud | Cloud |
|--------|-----------|-------|
| Web RAM | 91.61 MB | 87.48 MB |
| DB RAM | 95.4 MB | 108.2 MB |
| Total available | 11.65 GB | 1.92 GB |

### Deployment Time

| Metric | Non-Cloud | Cloud |
|--------|-----------|-------|
| Real time | 0.869s | 20.719s |
| Difference | — | ~24x slower |

> Performance overhead caused by QEMU software emulation.
> KVM hardware virtualisation was unavailable due to nested
> virtualisation inside UTM on Apple Silicon.

---

## CI/CD Pipeline

- GitLab Runner registered locally
- Two pipeline stages: test and deploy
- Automatic deployment to OpenStack instance on every commit to 5g-app branch
- Pipeline completed successfully in 1 minute 52 seconds

---

## Repository Files

| File | Description |
|------|-------------|
| `README.md` | This file |
| `local.conf` | DevStack configuration file |
| `nova-cpu.conf` | Nova CPU configuration for ARM64 |
| `userdata.yaml` | Cloud-init config for SSH access |
| `kpi-benchmark.sh` | Commands used for KPI measurement |

---

## References

- OpenStack Foundation — https://docs.openstack.org/arch-design/
- DevStack — https://docs.openstack.org/devstack/latest/
- Kolla-Ansible — https://docs.openstack.org/kolla-ansible/latest/
- Docker — https://docs.docker.com/
- GitLab CI/CD — https://docs.gitlab.com/ee/ci/
- QEMU — https://www.qemu.org/docs/master/

---

> **Disclaimer:** This project was completed as part of module CSI_7_FIT
> at London South Bank University. All deployments were conducted within
> controlled virtual environments for educational purposes only.
