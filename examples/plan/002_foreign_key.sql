ALTER TABLE ledger
  ADD CONSTRAINT ledger_users_fk
  FOREIGN KEY (user_id) REFERENCES users(id);
