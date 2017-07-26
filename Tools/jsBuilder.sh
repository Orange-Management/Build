#!/bin/bash

echo "" > ${OUT}
for i in "${SRC[@]}"
do
    cat $i >> ${OUT}
    echo "" >> ${OUT}
done

# Remove spaces at end of line
sed -i -e 's/[[:blank:]]*$//g' ${OUT}
# Make single line
sed -i -e ':a;N;$!ba;s/\n/ /g' ${OUT}
# Remove multiple spaces
sed -i -e 's/  */ /g' ${OUT}
# Remove double js initialization
sed -i -e 's/(function *(jsOMS) *{ *"use strict";//g' ${OUT}
sed -i -e 's/} *(window.jsOMS = window.jsOMS || {}));//g' ${OUT}

echo "(function(jsOMS){\"use strict\";$(cat ${OUT})}(window.jsOMS = window.jsOMS || {}));" > ${OUT}