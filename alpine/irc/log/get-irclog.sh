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
# @category  sh, sed, awk
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
_tmpf='/tmp/_tmp_alpine.log'
rm -f ${_tmpf}; touch ${_tmpf}
echo -e ${cbCYAN}${cYELLOW}${NOW}' '${cNORMAL}

SVGColors="aliceblue antiquewhite aqua aquamarine azure beige bisque blanchedalmond blue blueviolet brown burlywood cadetblue chartreuse chocolate coral cornflowerblue crimson cyan darkblue darkcyan darkgoldenrod darkgrey darkgreen darkkhaki darkmagenta darkolivegreen darkorange darkorchid darkred darksalmon darkseagreen darkslateblue darkturquoise darkviolet deeppink deepskyblue dimgray dodgerblue firebrick floralwhite forestgreen fuchsia gainsboro ghostwhite gold goldenrod gray green greenyellow honeydew hotpink indianred khaki lavenderblush lawngreen lemonchiffon lightblue lightcoral lightcyan lightgoldenrodyellow lightgreen lightgrey lightpink lightsalmon lightseagreen lightskyblue lightslategray lightsteelblue lime limegreen magenta maroon mediumaquamarine mediumblue mediumorchid mediumpurple mediumseagreen mediumslateblue mediumspringgreen mediumturquoise mediumvioletred mintcream mistyrose moccasin navajowhite navy oldlace olive olivedrab orange orangered orchid palegoldenrod palegreen paleturquoise palevioletred papayawhip peachbuff peru pink plum powderblue purple red rosybrown royalblue saddlebrown salmon sandybrown seagreen seashell sienna silver skyblue slateblue slategray snow springgreen steelblue tan teal thistle tomato turquoise violet wheat white whitesmoke yellow yellowgreen"

header='
<!DOCTYPE html><html><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
';
title='<title>alpine-irclog</title>';
style=$(cat <<EOT
<style type="text/css">
body { font-family:Arial,Helvetica,sans-serif; font-size: 1em; }
ul { width: 98%; margin: 0px; padding: 0px; background-color: black; }
ul li { padding: 3px; list-style: none; list-style-type: none;
        margin: 0px; padding: 0px; border: 1px solid black; }
ul li span:first-child, 
ul li span:nth-child(2) {
  white-space: nowrap; font-weight: bold; font-size: .8em;
  color: yellowgreen; text-align: center; height: 1.2em;
  float: left; padding: 2px; width: 100pt;
}
ul li span:nth-child(2) { width: 90pt; }
li:nth-child(odd) { background-color: black; }
li:nth-child(even) { background-color: #232323; }
ul li span:last-child { color: beige; display: block; margin: 0px 0px; }
</style>
</head>
EOT
);
body='
<body>
<ul>
';
footer='</ul></body></html>';

if [ "$1" ]; then MONTHLY=$1; fi #format eg. 2019-01

al_get_irclog() {
    for log in devel linux commits; do
        file=${URL}"%23alpine-$log-$MONTHLY.log";
        echo -e "${cLIGHTGRAY}${cbBROWN}>>>${cNORMAL} ------------------------------"

        wget -c $file
        _CURRLF="#alpine-$log-$MONTHLY.log"
        if [ -f ${_CURRLF} ]; then
            al_irclog2html ${_CURRLF} ${_tmpf}
        fi

    done;
}

al_irclog2html() {
        _CURRLF="#alpine-$log-$MONTHLY.log"
        if [ -f ${_CURRLF} ]; then
            cp ${_CURRLF} ${_tmpf}; else continue
        fi

        num=0;
        lnames=$(awk '{print $3}' ${_CURRLF} | sort | uniq )
        for name in ${lnames}; do
            _name=${name}
            sed -E -i -e "s|${name}|__${num}${_name}|g" ${_tmpf}
            num=$(($num+1))
        done

        _logfile="$1"; _tmpf=$2;
        _outf=$(echo ${_logfile} | cut -b2-).html
        # _outf=/path/to/htdocs/${_outf}

        echo -e "${cGREEN}>>> creating ... ${cRED}$_outf${cNORMAL}"
        rm -f ${_outf}
        touch $_outf

        echo ${header} > ${_outf}
        echo ${title} >> ${_outf}
        echo ${style} >> ${_outf}
        echo ${body} >> ${_outf}

        echo -e "${cGREEN}>>> processing temp log:${cNORMAL} ${_tmpf}"
        sed -i \
            -e 's|&|\&amp;|g' \
            -e 's|>|\&gt;|g' \
            -e 's|<|\&lt;|g' \
            -e 's|^|<li><span>|' \
            -e 's|gt\; |gt;</span><span>|' \
            -e 's|$|</span></li>|' \
            ${_tmpf}
        sed -E -i -e "s|([0-9]) &lt;(\w)|\1 __120\&lt;\2|" \
            ${_tmpf} #handle quirks
        sed -E -i -e "s|([0-9]) &lt;(\[)|\1 __120\&lt;\2|" \
            ${_tmpf} #handle quirks

        _colorstr="<span style="
        sed -E -i -e "s|([0-9]) (__[0-9])|\1</span>${_colorstr}\2|" \
            ${_tmpf}

        num=0
        for color in ${SVGColors}; do
            str="style=__${num}"
            num=$(($num+1))
            sed -E -i -e "s|${str}&lt|style=\'color\:${color}\'\>\&lt|g" \
                ${_tmpf}
        done
        cat ${_tmpf} >> ${_outf}
        echo $footer >> ${_outf}

}

usage() {
echo -e ${cGREEN};
    cat <<-__EOF__
        usage: get-irclogs

        Download IRC logs from Alpine Linux, and
        create a html format of the log
__EOF__
echo -e ${cNORMAL};
    exit 1
}

if [ "$1" = "help" ]; then
    usage
else
    al_get_irclog
fi

