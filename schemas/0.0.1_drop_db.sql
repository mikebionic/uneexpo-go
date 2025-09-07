\c postgres;

DROP DATABASE IF EXISTS db_uneexpo;
CREATE DATABASE db_uneexpo;
\c db_uneexpo;
CREATE EXTENSION IF NOT EXISTS pgcrypto;