#!/bin/sh
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
# @category  sh, sed, awk, grep
# @author    V.Krishn <vkrishn4@gmail.com>
# @copyright Copyright (c) 2019 V.Krishn <vkrishn4@gmail.com>
# @license   GPL
# @link      http://github.com/insteps/scripts
# 
## 

# NOTE:
#  1. 
#

. ../../../bash/inc/color.inc
# . ../../../bash/inc/date.inc

PROGRAM=get-irclog
VERSION=0.0.1

NOW=$(date +%Y%m%d-%H%M%S-%s)
MONTHLY=$(date +%Y-%m)
URL=https://dev.alpinelinux.org/irclogs/
LOGTYPE='devel linux commits docs'
_tmpf='/tmp/_tmp_alpine.log'

SVGColors="aliceblue antiquewhite aqua aquamarine beige bisque
           blanchedalmond blue blueviolet brown burlywood cadetblue
	   chartreuse chocolate coral cornflowerblue crimson cyan
	   darkcyan darkgoldenrod darkgrey darkgreen darkkhaki darkmagenta
	   darkolivegreen darkorange darkorchid darkred darksalmon
	   darkseagreen darkslateblue darkturquoise darkviolet deeppink
	   deepskyblue dimgray dodgerblue firebrick floralwhite forestgreen
	   fuchsia gainsboro ghostwhite gold goldenrod gray green greenyellow
	   honeydew hotpink indianred khaki lavenderblush lawngreen
	   lemonchiffon lightblue lightcoral lightcyan lightgoldenrodyellow
	   lightgreen lightgrey lightpink lightsalmon lightseagreen
	   lightskyblue lightslategray lightsteelblue lime limegreen magenta
	   maroon mediumaquamarine mediumblue mediumorchid mediumpurple
	   mediumseagreen mediumslateblue mediumspringgreen mediumturquoise
	   mediumvioletred mintcream mistyrose moccasin navajowhite 
	   oldlace olive olivedrab orange orangered orchid palegoldenrod
	   palegreen paleturquoise palevioletred papayawhip peachbuff peru
	   pink plum powderblue purple red rosybrown royalblue saddlebrown
	   salmon sandybrown seagreen seashell sienna silver skyblue slateblue
	   slategray snow springgreen steelblue tan teal thistle tomato
	   turquoise violet wheat white whitesmoke yellow yellowgreen
	   "

header='
<!DOCTYPE html><html><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
';
style=$(cat <<EOT
<style type="text/css">
body { font-family:Arial,Helvetica,sans-serif;
       font-size: 1em; background-color: black; }
ul { width: 98%; margin: 0px; padding: 0px; }
ul li { padding: 3px; list-style: none; list-style-type: none;
        margin: 0px; padding: 0px; border: 1px solid black; clear: both; }
ul li span:first-child, 
ul li span:nth-child(2) {
  white-space: nowrap; font-weight: bold; font-size: .8em;
  color: yellowgreen; text-align: center; height: 1.2em;
  float: left; padding: 2px; width: 100pt;
}
ul li span:nth-child(2) { width: 90pt; }
li:nth-child(even) { background-color: #282828; }
ul li span:last-child { color: beige; display: block; margin: 0px 0px; }
@media (max-width: 640px) {
  ul li span:nth-child(3) { display: block; clear: both; padding-left: 12px; }
}
</style>
</head>
EOT
);
body='
<body>
<ul>
';
footer='</ul></body></html>';

al_get_irclog() {
    file=${URL}"%23alpine-$log-$MONTHLY.log";
    echo -ne "${cLIGHTGRAY}${cbBROWN}>>>${cNORMAL} "
    echo "------------------------------"
    wget -c $file
}

_al_irclog2html() {
    sed -i \
        -e 's|&|\&amp;|g' \
        -e 's|>|\&gt;|g' \
        -e 's|<|\&lt;|g' \
        -e 's|^|<li><span>|' \
        -e 's|gt\; |gt; </span><span>|' \
        -e 's|$|</span></li>|' \
        ${_tmpf}

    num=1
    lnames=$(awk '{print $3}' ${_tmpf} | sort | uniq )
    maxname=$(echo $lnames | wc -w)
    # handle populous chatty channel
    if [ $maxname -gt 120 ]; then SVGColors="${SVGColors} ${SVGColors}"; fi
    if [ $maxname -gt 240 ]; then SVGColors="${SVGColors} ${SVGColors}"; fi
    if [ $maxname -gt 480 ]; then SVGColors="${SVGColors} ${SVGColors}"; fi
    for name in ${lnames}; do
        _name=${name}
        name=$(echo $name | sed -E 's|\[|\\[|g') # sed > v4.4 or busybox > v1.27
        name=$(echo $name | sed -E 's|\^|\\^|g')
        name=$(echo $name | sed -E 's/\|/\\|/g')
        color=$(echo $SVGColors | awk -v num=$num '{print $num}')
        _colorstr="</span><span style='color:${color}'>"
        sed -E -i "s|^(<li><span>2[0-9\-]+{9}) ([0-9\:]+{8}) (${name})|\1 \2 ${_colorstr}\3|" \
            ${_tmpf}
        num=$(($num+1))
    done
}

al_irclog2html() {
    _al_irclog2html
    _outf=$(echo ${_CURRLF} | cut -b2-).html
    # _outf=/path/to/htdocs/${_outf}

    echo -e "${cGREEN}>>> creating ... ${cRED}$_outf${cNORMAL}"
    rm -f ${_outf}; touch $_outf
    echo ${header} > ${_outf}
    title='<title>alpine-irclog-'${1}'</title>';
    echo ${title} >> ${_outf}
    echo ${style} >> ${_outf}
    echo ${body} >> ${_outf}
    cat ${_tmpf} >> ${_outf}
    echo $footer >> ${_outf}
}

usage() {
    echo -e ${cGREEN}
    cat <<-__EOF__
        usage: get-irclogs [yyyy-mm]

        Download IRC logs from Alpine Linux, and
        create a html format of the log

        yyyy-mm - format eg. 2019-01
__EOF__
    echo -e ${cNORMAL}
    exit 1
}

if [ "$1" ]; then #format eg. 2019-01
    _m=$(echo "$1" | grep -E '^[0-9\-]{7}')
    if [ ! "$_m" = '' ]; then MONTHLY=$_m; fi
fi

if [ "$1" = "help" ]; then
    usage
else
    echo -e ${cbCYAN}${cYELLOW}${NOW}' '${cNORMAL}
    for log in ${LOGTYPE}; do
        _CURRLF="#alpine-$log-$MONTHLY.log"
        al_get_irclog
        if [ ! -f ${_CURRLF} ]; then continue; fi
        echo -e "${cGREEN}>>> processing temp log:${cNORMAL} ${_tmpf}"
        echo '' > ${_tmpf}
        cp ${_CURRLF} ${_tmpf}
        al_irclog2html "$log-$MONTHLY"
    done;
fi

