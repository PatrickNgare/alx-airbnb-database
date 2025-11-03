-- schema.sql
-- Airbnb-style database schema for ALX project (Postgres)
-- Requires: CREATE EXTENSION IF NOT EXISTS "pgcrypto"; (for gen_random_uuid)

-- Enable uuid generation (Postgres)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

--------------------------------------------------------------------------------
-- 1. Users
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100),
  email VARCHAR(255) NOT NULL UNIQUE,
  phone_number VARCHAR(30),
  password_hash TEXT NOT NULL,
  is_host BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);

--------------------------------------------------------------------------------
-- 2. Addresses (optional reusable address table)
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS addresses (
  address_id BIGSERIAL PRIMARY KEY,
  street TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20)
);

--------------------------------------------------------------------------------
-- 3. Properties
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS properties (
  property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  address_id BIGINT REFERENCES addresses(address_id) ON DELETE SET NULL,
  city VARCHAR(100),
  country VARCHAR(100),
  price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_properties_owner ON properties (owner_id);
CREATE INDEX IF NOT EXISTS idx_properties_city ON properties (city);

--------------------------------------------------------------------------------
-- 4. Amenities & join table (many-to-many)
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS amenities (
  amenity_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS property_amenities (
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  amenity_id BIGINT NOT NULL REFERENCES amenities(amenity_id) ON DELETE CASCADE,
  PRIMARY KEY (property_id, amenity_id)
);

--------------------------------------------------------------------------------
-- 5. Bookings
--------------------------------------------------------------------------------
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'cancelled', 'completed');

CREATE TABLE IF NOT EXISTS bookings (
  booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status booking_status DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  CHECK (start_date <= end_date)
);

CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings (user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property ON bookings (property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_dates ON bookings (start_date, end_date);

--------------------------------------------------------------------------------
-- 6. Payments
--------------------------------------------------------------------------------
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');

CREATE TABLE IF NOT EXISTS payments (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
  amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
  currency CHAR(3) DEFAULT 'USD',
  payment_method VARCHAR(50),
  paid_at TIMESTAMP WITH TIME ZONE,
  status payment_status DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_payments_booking ON payments (booking_id);

--------------------------------------------------------------------------------
-- 7. Reviews
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES bookings(booking_id) ON DELETE SET NULL,
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE CASCADE,
  rating SMALLINT CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_reviews_property ON reviews (property_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON reviews (user_id);

--------------------------------------------------------------------------------
-- 8. Example audit/log table (optional, helpful for production)
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS audit_logs (
  log_id BIGSERIAL PRIMARY KEY,
  entity_name VARCHAR(100),
  entity_id TEXT,
  action VARCHAR(50),
  performed_by UUID REFERENCES users(user_id),
  details JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

--------------------------------------------------------------------------------
-- 9. Useful views (optional)
--------------------------------------------------------------------------------
-- View for property summary (aggregates)
CREATE OR REPLACE VIEW property_summary AS
SELECT
  p.property_id,
  p.title,
  p.city,
  p.country,
  p.price_per_night,
  p.owner_id,
  COALESCE(avg(r.rating), 0)::numeric(3,2) AS avg_rating,
  COUNT(r.review_id) AS review_count
FROM properties p
LEFT JOIN reviews r ON r.property_id = p.property_id
GROUP BY p.property_id, p.title, p.city, p.country, p.price_per_night, p.owner_id;


