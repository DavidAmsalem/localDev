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

**Note**: The script will attempt to start Docker Desktop for you if it is not running.

## Services

| Service | Type | Port(s) | Default Credentials |
|:---|:---|:---|:---|
| **MySQL** | RDS Simulation | `3306` | `user` / `password` |
| **MinIO** | S3 Simulation | `9000` (API), `9001` (UI) | `minioadmin` / `minioadmin` |

## Data Seeding

- **MySQL**: Automatically seeded with `scripts/seed-data.sql` on first run.
- **MinIO**: A `create-buckets` container runs automatically to create a public `simulated-bucket`.

## Verification (Python)

You can run the tests manually if needed:

## Test Script
```bash
./test.sh
```

This script will:
1. Check for Python/Pip.
1. Install dependencies: `pip install -r tests/requirements.txt`
2. Run MySQL check: `python tests/test_mysql.py`
3. Run MinIO check: `python tests/test_minio.py`


You can also verify the services using the provided Python scripts in `tests/`:

