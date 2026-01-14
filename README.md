# Local Development Environment

This is a Docker Compose setup to simulate production services locally (MySQL for RDS, MinIO for S3).

## Quick Start (macOS / Linux)

Ensure the script is executable:
```bash
chmod +x setup-dev.sh
```

Run the helper script:
```bash
./setup-dev.sh
```

Or for interactive mode:
```bash
./setup-dev.sh interactive
```

## Services

| Service | Type | Port(s) | Default Credentials |
|:---|:---|:---|:---|
| **MySQL** | RDS Simulation | `3306` | `user` / `password` |
| **MinIO** | S3 Simulation | `9000` (API), `9001` (UI) | `minioadmin` / `minioadmin` |

## Data Seeding

- **MySQL**: Automatically seeded with `scripts/seed-data.sql` on first run.
- **MinIO**: A `create-buckets` container runs automatically to create a public `simulated-bucket`.

