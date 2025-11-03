# Database Schema (DDL) — database-script-0x01

## Purpose
This folder contains the SQL DDL for the Airbnb-style project. The `schema.sql` file creates the database structure (tables, constraints, indexes, types, and a sample view) targeted at PostgreSQL.

## Files
- `schema.sql` — PostgreSQL DDL: creates tables `users`, `addresses`, `properties`, `amenities`, `property_amenities`, `bookings`, `payments`, `reviews`, and an `audit_logs` table + `property_summary` view.
- `README.md` — this file.

## Notes & design decisions
- **Postgres**: script uses `uuid` generation via `pgcrypto` (function `gen_random_uuid()`).
  - If your Postgres does not have `pgcrypto`, run:
    ```sql
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";
    ```
- **Primary Keys**: UUIDs for main domain entities to avoid collisions during scaling; `BIGSERIAL` for small lookup tables.
- **Enums**: `booking_status` and `payment_status` provide clearer domain states.
- **Indexes**: Created on common lookup columns (FKs, email, dates).
- **Normalization**: Schema is normalized (3NF): user and owner data are stored in `users`; booking/payment/review separated to avoid redundancy.
- **Optional**: `addresses` table is optional – many systems store address inline but a separate table supports reuse.

## How to run (local Postgres)
1. Create a database if needed:
   ```bash
   createdb alx_airbnb_db
