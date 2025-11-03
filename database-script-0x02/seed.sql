BEGIN;

-- 1. Users (hosts and guests)
INSERT INTO users (user_id, first_name, last_name, email, phone_number, password_hash, is_host)
VALUES
  (gen_random_uuid(), 'Alice', 'Wanjiru', 'alice.host@example.com', '+254700000001', 'hash_alice', TRUE),
  (gen_random_uuid(), 'Bob', 'Kamau', 'bob.guest@example.com', '+254700000002', 'hash_bob', FALSE),
  (gen_random_uuid(), 'Charlie', 'Otieno', 'charlie.guest@example.com', '+254700000003', 'hash_charlie', FALSE);

-- 2. Addresses
INSERT INTO addresses (street, city, state, country, postal_code)
VALUES
  ('5 Riverside Drive', 'Nairobi', '', 'Kenya', '00100'),
  ('12 Coastal Road', 'Mombasa', '', 'Kenya', '80100');

-- 3. Amenities
INSERT INTO amenities (name) VALUES
  ('Wifi'),
  ('Kitchen'),
  ('Free parking'),
  ('Air conditioning');

-- 4. Properties (owner referenced by owner's email)
INSERT INTO properties (property_id, owner_id, title, description, address_id, city, country, price_per_night)
VALUES
  (
    gen_random_uuid(),
    (SELECT user_id FROM users WHERE email = 'alice.host@example.com'),
    'Cozy Downtown Apartment',
    '1-bedroom apartment in the city center, close to restaurants.',
    (SELECT address_id FROM addresses ORDER BY address_id LIMIT 1),
    'Nairobi',
    'Kenya',
    45.00
  ),
  (
    gen_random_uuid(),
    (SELECT user_id FROM users WHERE email = 'alice.host@example.com'),
    'Beachside Bungalow',
    'Comfortable bungalow with sea view.',
    (SELECT address_id FROM addresses ORDER BY address_id DESC LIMIT 1),
    'Mombasa',
    'Kenya',
    80.00
  );

-- 5. Link amenities to properties
INSERT INTO property_amenities (property_id, amenity_id)
VALUES
  (
    (SELECT property_id FROM properties WHERE title = 'Cozy Downtown Apartment'),
    (SELECT amenity_id FROM amenities WHERE name = 'Wifi')
  ),
  (
    (SELECT property_id FROM properties WHERE title = 'Cozy Downtown Apartment'),
    (SELECT amenity_id FROM amenities WHERE name = 'Kitchen')
  ),
  (
    (SELECT property_id FROM properties WHERE title = 'Beachside Bungalow'),
    (SELECT amenity_id FROM amenities WHERE name = 'Wifi')
  ),
  (
    (SELECT property_id FROM properties WHERE title = 'Beachside Bungalow'),
    (SELECT amenity_id FROM amenities WHERE name = 'Free parking')
  ),
  (
    (SELECT property_id FROM properties WHERE title = 'Beachside Bungalow'),
    (SELECT amenity_id FROM amenities WHERE name = 'Air conditioning')
  );

-- 6. Bookings (two bookings)
INSERT INTO bookings (booking_id, user_id, property_id, start_date, end_date, status)
VALUES
  (
    gen_random_uuid(),
    (SELECT user_id FROM users WHERE email = 'bob.guest@example.com'),
    (SELECT property_id FROM properties WHERE title = 'Cozy Downtown Apartment'),
    '2025-12-01',
    '2025-12-05',
    'confirmed'
  ),
  (
    gen_random_uuid(),
    (SELECT user_id FROM users WHERE email = 'charlie.guest@example.com'),
    (SELECT property_id FROM properties WHERE title = 'Beachside Bungalow'),
    '2026-01-10',
    '2026-01-15',
    'pending'
  );

-- 7. Payments (one paid, one pending)
INSERT INTO payments (payment_id, booking_id, amount, currency, payment_method, paid_at, status)
VALUES
  (
    gen_random_uuid(),
    (SELECT booking_id FROM bookings
       WHERE user_id = (SELECT user_id FROM users WHERE email='bob.guest@example.com')
         AND property_id = (SELECT property_id FROM properties WHERE title='Cozy Downtown Apartment')
    ),
    180.00,
    'USD',
    'card',
    now(),
    'paid'
  ),
  (
    gen_random_uuid(),
    (SELECT booking_id FROM bookings
       WHERE user_id = (SELECT user_id FROM users WHERE email='charlie.guest@example.com')
         AND property_id = (SELECT property_id FROM properties WHERE title='Beachside Bungalow')
    ),
    400.00,
    'USD',
    'mpesa',
    NULL,
    'pending'
  );

-- 8. Reviews (one review by Bob for his completed stay)
INSERT INTO reviews (review_id, booking_id, user_id, property_id, rating, comment)
VALUES
  (
    gen_random_uuid(),
    (SELECT booking_id FROM bookings
       WHERE user_id = (SELECT user_id FROM users WHERE email='bob.guest@example.com')
         AND property_id = (SELECT property_id FROM properties WHERE title='Cozy Downtown Apartment')
    ),
    (SELECT user_id FROM users WHERE email='bob.guest@example.com'),
    (SELECT property_id FROM properties WHERE title='Cozy Downtown Apartment'),
    5,
    'Great location and clean apartment. Host was responsive.'
  );

-- 9. Optional: Seed audit log example
INSERT INTO audit_logs (entity_name, entity_id, action, performed_by, details)
VALUES
  ('property', (SELECT property_id FROM properties WHERE title='Cozy Downtown Apartment'), 'create', (SELECT user_id FROM users WHERE email='alice.host@example.com'), '{"note": "Initial property seed"}');

COMMIT;