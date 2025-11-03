# Project Requirements: Airbnb Database ER Diagram

## Objective
Create an Entity-Relationship Diagram (ERD) for an Airbnb-style system that models users, properties, bookings, payments and reviews. The ERD should identify entities, attributes (with primary keys and foreign keys), and relationships including cardinalities.

## Scope
This ERD covers:
- User accounts and roles
- Property listings and ownership
- Bookings / reservations lifecycle
- Payments associated with bookings
- Reviews left by users for properties

## Entities & Attributes
1. **User**
   - user_id (PK, UUID / integer)
   - first_name
   - last_name
   - email (unique)
   - phone_number
   - password_hash
   - created_at (timestamp)
   - is_host (boolean)

2. **Property**
   - property_id (PK)
   - owner_id (FK → User.user_id)
   - title
   - description
   - address
   - city
   - country
   - price_per_night
   - created_at

3. **Booking**
   - booking_id (PK)
   - user_id (FK → User.user_id)         # guest who made the booking
   - property_id (FK → Property.property_id)
   - start_date
   - end_date
   - status (e.g., pending, confirmed, cancelled)
   - created_at

4. **Payment**
   - payment_id (PK)
   - booking_id (FK → Booking.booking_id)
   - amount
   - currency
   - payment_method
   - paid_at (timestamp)
   - status

5. **Review**
   - review_id (PK)
   - booking_id (FK → Booking.booking_id) — optional but recommended to ensure only verified guests review
   - user_id (FK → User.user_id)          # reviewer
   - property_id (FK → Property.property_id)
   - rating (int)
   - comment (text)
   - created_at

## Relationships & Cardinalities
- **User** (1) — (M) **Booking**  
  A user (guest) can make many bookings; each booking is made by a single user.

- **Property** (1) — (M) **Booking**  
  A property can have many bookings over time; each booking is for one property.

- **Booking** (1) — (1) **Payment**  
  Each booking may have one primary payment record (or 0..1 if you allow unpaid bookings).

- **User** (1) — (M) **Property** (as owner)  
  A user can own (list) many properties; each property has one owner.

- **User** (1) — (M) **Review**  
  A user can write many reviews; each review is written by one user.

- **Property** (1) — (M) **Review**  
  A property can have many reviews; each review is about one property.

- **Booking** (0..1) — (1) **Review** (optional)  
  Prefer linking reviews to bookings to ensure only actual guests can review.

## Additional Notes
- Use UUIDs or integer auto-increment for PKs depending on DB engine.
- Enforce uniqueness on `User.email`.
- Add indexes on FK columns (`owner_id`, `user_id`, `property_id`, `booking_id`) for performance.
- Consider `status` enums for booking/payment states.
- If supporting multiple payment attempts per booking, change Booking-Payment to 1..*.

