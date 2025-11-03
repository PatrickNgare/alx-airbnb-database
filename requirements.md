# Project Requirements: Airbnb Database ER Diagram

## Objective
To design the Entity Relationship Diagram (ERD) for the Airbnb database system.

## Entities
1. **User**
   - user_id (PK)
   - first_name
   - last_name
   - email
   - phone_number
   - created_at

2. **Property**
   - property_id (PK)
   - owner_id (FK → User)
   - title
   - description
   - location
   - price
   - created_at

3. **Booking**
   - booking_id (PK)
   - user_id (FK → User)
   - property_id (FK → Property)
   - start_date
   - end_date
   - status

4. **Payment**
   - payment_id (PK)
   - booking_id (FK → Booking)
   - amount
   - payment_method
   - paid_at

5. **Review**
   - review_id (PK)
   - user_id (FK → User)
   - property_id (FK → Property)
   - rating
   - comment
   - created_at

## Relationships
- A **User** can make many **Bookings**
- A **Property** can have many **Bookings**
- Each **Booking** has one **Payments**
- A **User** can write many **Reviews**
- A **Property** can have many **Reviews**

---

<!-- CI trigger: Mon, Nov  3, 2025  5:53:40 PM -->

<!-- ci-trigger: Mon, Nov  3, 2025  6:00:13 PM -->
