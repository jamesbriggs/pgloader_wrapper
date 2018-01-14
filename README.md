# pgloader_wrapper
Wrapper or driver script to script pgloader for instant or iterative database migrations.

Introduction
-----

pgloader_wrapper is a set of script files for a database engineer or DBA to migrate a MySQL database to Postgresql quickly and frequently using pgloader:

# pgloader_wrapper.sh
# grants.sql
# pgloader.load

Getting Started
-----

# install pgloader
# configure the settings in pgloader_wrapper.sh as documented near the top of file
# grants.sql has typical Postgresql grants for a web app. Customize as necessary.
# pgloader.load illustrates advanced settings for migrating a MySQL database to Postgresql 9.2+. Customize as necessary.
# run: ./pgloader_wrapper.sh
# look at the logfile in pgloader_wrapper.sh.log

FAQ
-----

I'm familiar with MySQL but not Postgresql. What do I need to know?

- In MySQL, database and schema are the same thing (a directory on disk.) In Postgresql, a database is a container for multiple objects like schemas and roles.
- In Postgresql, a user is the same thing as a role (aside from minor differences in inheritance.)
- In MySQL, a unique index is a unique constraint. In Postgresql, a unique constraint's underlying mechanism is a unique index, but they are considered different. UPSERTs require constraints.

Todo
-----

- parameterize database name in pgloader.load like grants.sql

