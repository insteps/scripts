#!/bin/bash
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
