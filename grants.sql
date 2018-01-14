-- Program: grants.sql
-- Purpose: pgloader wrapper script/system to allow rapid database migration iterations from MySQL to Postgresql
-- Author: James Briggs, USA
-- Date: 2018 01 12
-- Env: Postgresql 9.2+
-- Note: this script demonstrates several psql quoting techniques

\set db `echo $DBNAME`
\set pw `echo $USERPW`

set search_path to :db;

drop user if exists :"db";
create user :"db" with password :'pw';
alter role :"db" set search_path TO :"db";

grant usage on schema :"db" to :"db";

grant select, insert, update, delete on all tables in schema :"db" to :"db";
alter default privileges in schema :"db" grant select, insert, update, delete on tables to :"db";

grant usage on all sequences in schema :"db" to :"db";
alter default privileges in schema :"db" grant usage on sequences to :"db";

grant execute on all functions in schema :"db" to :"db";
alter default privileges in schema :"db" grant execute on functions to :"db";

