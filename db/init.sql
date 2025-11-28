CREATE TABLE IF NOT EXISTS hl7_raw_messages (
    id SERIAL PRIMARY KEY,
    received_at TIMESTAMP DEFAULT NOW(),
    raw_message TEXT NOT NULL
);