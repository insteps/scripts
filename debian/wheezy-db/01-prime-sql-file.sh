#!/bin/bash
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

