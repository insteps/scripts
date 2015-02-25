#!/bin/bash
##
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
# @category  Bash
# @author    V.Krishn <vkrishn4@gmail.com>
# @copyright Copyright (c) 2015 V.Krishn <vkrishn4@gmail.com>
# @license   GPL
# @link      http://github.com/insteps/scripts
# 
## 

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



