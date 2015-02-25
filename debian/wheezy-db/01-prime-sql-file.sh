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
#  make sure the INFILE has 2 new lines at the end
#  INFILE = eg. <path/to>/ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages
#  OUTFILE = /tmp/ftp.de.debian.org_debian_dists_stable_main_binary-i386_Packages.sql

INFILE=$1
OUTFILE=$2

cat ${INFILE} |
sed -n "
  :TOP
  /^Package/,/^SHA256/ {

       /^\s.*/ {
             H
             n
             b TOP
       }

       H

       /^[A-Z][-[:alnum:]]*\:\s/ {
           /^SHA256/ {
                 s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\1\"\)\n/
           }
           /^SHA256/ !{
               /^Package/ {
                     s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/INSERT INTO wheezy_700_i386 \(\"\1\"\,/
               }
               /^Package/ !{
                     s/^\([A-Z][-[:alnum:]]*\)\:\s\(.*$\)/\"\1\"\,/
               }
           }

           p
       }

  }

  /^$/ {
       x
       p
  }

" > ${OUTFILE}

exit;

