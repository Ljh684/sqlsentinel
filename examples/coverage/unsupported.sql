COMMENT ON TABLE users IS 'owned by the account service';
ALTER TABLE users DROP CONSTRAINT users_email_key;
