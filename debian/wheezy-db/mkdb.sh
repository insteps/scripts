#!/bin/bash

_TABLENAME='wheezy_700_i386'

mk_dpkg_full_table() {
  sqlite3 wheezy.sqlite \
  "CREATE TABLE IF NOT EXISTS ${_TABLENAME} (
     'id' INTEGER PRIMARY KEY, 
     'Architecture' LONGVARCHAR DEFAULT 0 NOT NULL,
     'Breaks' LONGVARCHAR,
     'Bugs' LONGVARCHAR,
     'Build-Essential' LONGVARCHAR,
     'Built-Using' LONGVARCHAR,
     'Conflicts' LONGVARCHAR,
     'Depends' LONGVARCHAR,
     'Description' LONGVARCHAR,
     'Description-md5' LONGVARCHAR,
     'Enhances' LONGVARCHAR,
     'Essential' LONGVARCHAR,
     'Filename' LONGVARCHAR,
     'Gstreamer-Decoders' LONGVARCHAR,
     'Gstreamer-Elements' LONGVARCHAR,
     'Gstreamer-Encoders' LONGVARCHAR,
     'Gstreamer-Uri-Sinks' LONGVARCHAR,
     'Gstreamer-Uri-Sources' LONGVARCHAR,
     'Gstreamer-Version' LONGVARCHAR,
     'Homepage' LONGVARCHAR,
     'Installed-Size' INTEGER DEFAULT 0 NOT NULL,
     'Lua-Versions' LONGVARCHAR,
     'Maintainer' LONGVARCHAR DEFAULT 0 NOT NULL,
     'MD5sum' LONGVARCHAR,
     'Multi-Arch' LONGVARCHAR,
     'Npp-Applications' LONGVARCHAR,
     'Npp-Description' LONGVARCHAR,
     'Npp-File' LONGVARCHAR,
     'Npp-Mimetype' LONGVARCHAR,
     'Npp-Name' LONGVARCHAR,
     'Original-Maintainer' LONGVARCHAR,
     'Origin' LONGVARCHAR,
     'Package' LONGVARCHAR,
     'Pre-Depends' LONGVARCHAR,
     'Priority' LONGVARCHAR,
     'Provides' LONGVARCHAR,
     'Python3-Version' LONGVARCHAR,
     'Python-Version' LONGVARCHAR,
     'Recommends' LONGVARCHAR,
     'Replaces' LONGVARCHAR,
     'Ruby-Version' LONGVARCHAR,
     'Ruby-Versions' LONGVARCHAR,
     'Section' LONGVARCHAR,
     'SHA1' LONGVARCHAR,
     'SHA256' LONGVARCHAR,
     'Size' INTEGER NOT NULL,
     'Source' LONGVARCHAR,
     'Suggests' LONGVARCHAR,
     'Tag' LONGVARCHAR,
     'Version' LONGVARCHAR,
     'Xul-Appid' LONGVARCHAR,

     'hidden' INTEGER DEFAULT 0 NOT NULL
   );
   CREATE UNIQUE INDEX ${_TABLENAME}_package_uniqueindex ON ${_TABLENAME} (Package);
  "
}
mk_dpkg_full_table



