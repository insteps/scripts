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
# @category  Bash, Sed
# @author    V.Krishn <vkrishn4@gmail.com>
# @copyright Copyright (c) 2015 V.Krishn <vkrishn4@gmail.com>
# @license   GPL
# @link      http://github.com/insteps/scripts
# 
## 

# NOTE:
#  1. make sure the INFILE has 2 new lines at the end
#    INFILE = /tmp/ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages.sql
#  2. THEN sqlite3 wheezy.sqlite < INFILE (do not use .import)
#

INFILE=$1

sed -i -e " \
   /^[A-Z][-[:alnum:]]*\:\s/ {
       s/\"/\"\"/g
       /^SHA256/ {
             s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\2\"\)\;\n/
       }
       /^SHA256/ !{
           /^Package/ {
                 s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/VALUES \(\"\2\"\,/
           }
           /^Package/ !{
               /^Tag/ {
                     s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\2/
                     :TAG
                     N
                     /\n\s/ {
                          b AA
                     }
                     /\n\s/ !{
                           s/\n\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\,\n\"\2\"\,/
                     }
               }
               /^Tag/ !{
                     s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\2\"\,/
               }
           }
       }
   }

   #workarounds
   # s/^\(\s.*\)\([a-z]\)$/\1\2\"\,/
   /^\s/d 

   /^$/d

   :AA
      /\n\s/ {
          s/\n/@@/
          b TAG
      }

" ${INFILE}

exit;
