#!/bin/bash

git diff --cached --name-only | while read FILE; do

if [[ "$FILE" =~ ^.+(php)$ ]]; then
    if [[ -f $FILE ]]; then
        # php lint
        php -l "$FILE" 1> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tPhp linting error.\e[0m" >&2
            exit 1
        fi

        # phpcs
        ${rootpath}/vendor/bin/phpcs --standard="${rootpath}/Build/Config/phpcs.xml" --encoding=utf-8 -n -p $FILE
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tCode Sniffer error.\e[0m" >&2
            exit 1
        fi

        # phpmd
        ${rootpath}/vendor/bin/phpmd $FILE text ${rootpath}/Build/Config/phpmd.xml --exclude *tests* --minimumpriority 1
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tMess Detector error.\e[0m" >&2
            exit 1
        fi
    fi
fi

# Html checks
if [[ "$FILE" =~ ^.+(tpl\.php|html)$ ]]; then
    if [[ -n $(grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]+\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid attribute.\e[0m" >&2
        grep -E '=\"[\#\$\%\^\&\*\(\)\\/\ ]*\"' $FILE >&2
        exit 1
    fi

    if [[ -n $(grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' $FILE) ]]; then
        echo -e "\e[1;31m\tFound invalid class/id.\e[0m" >&2
        grep -E '(id|class)=\"[a-zA-Z]*[\#\$\%\^\&\*\(\)\\/\ ]+[a-zA-Z]*\"' $FILE >&2
        exit 1
    fi

    # Images must have a alt= attribute *error*
    if [[ -n $(grep -P '(\<img)((?!.*?alt=).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tFound missing image alt attribute.\e[0m" >&2
        grep -P '(\<img)((?!.*?alt=).)*(>)' $FILE >&2
        exit 1
    fi

    # Value fields should not be hard coded *warning*
    if [[ -n $(grep -P '(value=\")((?!\<\?).)*(>)' $FILE) ]]; then
        echo -e "\e[1;31m\tValue field should not be hard coded.\e[0m" >&2
        grep -P '(value=\")((?!\<\?).)*(>)' $FILE >&2
    fi
fi

if [[ "$FILE" =~ ^.+(sh)$ ]]; then
    if [[ -f $FILE ]]; then
        # sh lint
        bash -n "$FILE" 1> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "\e[1;31m\tBash linting error.\e[0m" >&2
            exit 1
        fi
    fi
fi

# Check whitespace end of line in code
if [[ "$FILE" =~ ^.+(sh|js|php|json)$ ]]; then
    if [[ -n $(grep -E ' $' $FILE) ]]; then
        echo -e "\e[1;31m\tFound whitespace at end of line.\e[0m" >&2
        echo grep -E ' $' $FILE >&2
        exit 1
    fi
fi

done || exit $?
