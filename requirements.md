# AirBnB Clone Database Requirements

## Project Overview
Build a database schema for an AirBnB-like property rental platform.

## Core Entities
- User (guests, hosts, admins)
- Property
- Booking
- Payment
- Review
- Message

## Technical Requirements
- UUID primary keys for all entities
- Proper foreign key relationships
- Data validation constraints
- Timestamp tracking
- Enum types for status fields
- Indexing for performance

## Business Rules
- Users can have different roles (guest, host, admin)
- Properties belong to hosts
- Guests can book properties
- Payments are linked to bookings
- Users can review properties they've booked
- Users can message each other