# Convert Packages list to Sqlite db
=====================================

These scripts convert Packages file, eg ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages
to sqlite file.

## Why
=======
1. Ability to easily query the pkgs.
2. Compare pkgs between versions.


## How to
==========
1. `cd /tmp`
2. `git clone git://github.com/insteps/scripts.git`
3. `cd insteps/scripts/debian/wheezy-db`
4. `bash 01-prime-sql-file.sh INFILE OUTFILE`
5. `bash 03-convert-to-sql.sh OUTFILE`
6. `rm -f wheezy.sqlite && sh mkdb.sh`
7. `sqlite3 wheezy.sqlite < OUTFILE`

Note:
  INFILE = eg. <path/to>/ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages
  OUTFILE = /tmp/ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages.sql

This would create the required database wheezy.sqlite.


Hope its useful.
