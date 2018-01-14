# pgloader_wrapper
Wrapper or driver script to automate the pgloader ETL utility for instant or iterative database migrations.

Introduction
-----

pgloader_wrapper is a set of script files for a database engineer or DBA to migrate a MySQL database to Postgresql quickly and frequently using [https://pgloader.io/](pgloader):

1. pgloader_wrapper.sh
1. grants.sql
1. pgloader.load

Getting Started
-----

1. install pgloader
1. configure the settings in pgloader_wrapper.sh as documented near the top of file
1. grants.sql has typical Postgresql grants for a web app. Customize as necessary.
1. pgloader.load illustrates advanced settings for migrating a MySQL database to Postgresql 9.2+. Customize as necessary.
1. run: ./pgloader_wrapper.sh
1. look at the logfile in pgloader_wrapper.sh.log

FAQ
-----

I'm familiar with MySQL but not Postgresql. What do I need to know?

- In MySQL, database and schema are the same thing (a directory on disk.) In Postgresql, a database is a logical container for multiple objects like schemas and roles.
- In Postgresql, a user is the same thing as a role (aside from inheritance differences.)
- In MySQL, a unique index is a unique constraint. In Postgresql, a unique constraint's underlying mechanism is a unique index, but the two are considered logically different. UPSERTs require constraints.

Todo
-----

- parameterize database name in pgloader.load like grants.sql

