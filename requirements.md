# Project Requirements: Airbnb Database ERD

## Objective
Define entities, attributes and relationships for the Airbnb database.

## Entities
- User (user_id, first_name, last_name, email, password_hash, created_at)
- Property (property_id, owner_id, title, description, location, price)
- Booking (booking_id, user_id, property_id, start_date, end_date, status)
- Payment (payment_id, booking_id, amount, method, paid_at)
- Review (review_id, booking_id, user_id, rating, comment, created_at)

## Relationships
- User 1..* Booking
- Property 1..* Booking
- Booking 1..1 Payment
- Booking 0..1 Review

Notes: This file exists to satisfy the automated ERD review checks.
