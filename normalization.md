# Normalization Steps — Airbnb Database (to 3NF)

## Objective
To apply normalization principles to ensure the Airbnb database schema is in **Third Normal Form (3NF)**.  
This process removes redundancy, improves data integrity, and ensures each attribute depends only on the primary key.

---

## 1. First Normal Form (1NF)
### Goal:
Ensure all attributes are **atomic** (no repeating groups or arrays).

### Actions Taken:
- Removed any multi-valued fields such as `amenities`, `phone_numbers`, or `images`.  
  - Example: Instead of storing multiple amenities in one column, created a separate table `property_amenities(property_id, amenity_id)`.
- Ensured each record has a **unique identifier** (Primary Key).
- Ensured all attributes hold only **one value per field**.

### Result:
Each table now has atomic columns and a unique key (e.g., `user_id`, `property_id`, `booking_id`).

---

## 2. Second Normal Form (2NF)
### Goal:
Eliminate **partial dependencies** — no non-key attribute should depend on part of a composite key.

### Actions Taken:
- Identified tables that could have composite keys (e.g., a `booking_payment` table if it used `(booking_id, payment_attempt_id)`).
- Moved non-key attributes that depended only on part of the composite key into their own tables.
  - Example: Created a separate `payments` table where `payment_id` is the primary key and `booking_id` is a foreign key.

### Result:
All non-key attributes now depend on the **whole key**, not just part of it.

---

## 3. Third Normal Form (3NF)
### Goal:
Remove **transitive dependencies** — non-key attributes must not depend on other non-key attributes.

### Actions Taken:
- Removed duplicated user and owner data from the `bookings` and `properties` tables.
  - Example: Removed `owner_name` and `owner_email` from `properties` because they already exist in the `users` table.
- Ensured `property_id` references the `properties` table, and `owner_id` references the `users` table.
- Created `reviews` and `payments` tables separate from `bookings` to isolate unrelated data.

### Result:
All non-key attributes depend **only on the primary key**, ensuring no transitive dependencies.

---

## 4. Final Normalized Tables (in 3NF)
| Table | Primary Key | Key Relationships | Description |
|--------|--------------|-------------------|--------------|
| **users** | user_id | N/A | Stores all user (guest/host) details |
| **properties** | property_id | owner_id → users.user_id | Property details and ownership |
| **bookings** | booking_id | user_id → users, property_id → properties | Guest reservations |
| **payments** | payment_id | booking_id → bookings | Booking payments |
| **reviews** | review_id | user_id → users, property_id → properties, booking_id → bookings | Guest reviews |
| **property_amenities** | (property_id, amenity_id) | property_id → properties | Join table for property amenities |

---

## 5. Benefits After Normalization
- **Reduced redundancy**: No repeated user, owner, or property info across tables.  
- **Improved integrity**: Referential integrity enforced through foreign keys.  
- **Simpler updates**: Update user or property info in one place.  
- **Scalable design**: Easier to extend (add new entities without affecting others).

---

## 6. Summary
The Airbnb database is now in **Third Normal Form (3NF)**:
1. Each column holds atomic values (1NF).  
2. Each non-key attribute depends on the whole key (2NF).  
3. No transitive dependencies — every attribute depends only on the primary key (3NF).  

This ensures a clean, consistent, and efficient relational database schema ready for implementation.

---
