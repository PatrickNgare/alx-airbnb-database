# Seed Data — database-script-0x02

## Purpose
This folder contains `seed.sql`, a sample data script to populate the Airbnb-style database created by `database-script-0x01/schema.sql`. The sample data includes multiple users, properties, bookings, payments, amenities and a review to reflect realistic usage.

## How to run
1. Ensure the database has the schema applied:
   ```bash
   psql -d alx_airbnb_db -f database-script-0x01/schema.sql
