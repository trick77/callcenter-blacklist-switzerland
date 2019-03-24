#!/bin/bash
CLI="/usr/sbin/asterisk -rx"
TMPFILE=$(mktemp /tmp/blacklist.XXXXXX)

curl -s -o ${TMPFILE} https://raw.githubusercontent.com/trick77/callcenter-blacklist-switzerland/master/latest_cc_blacklist.txt
# Add static custom entries with
#cat /etc/callcenter-blacklist/custom-blacklist.txt >> $TMPFILE

if [ "$1" == "-d" ]; then
  echo "Removing all existing blacklist entries..."
  ${CLI}i "database deltree blacklist"
fi

echo "Importing blacklist data..."
cat ${TMPFILE} | while read line; do
  [[ ${line} = \#* ]] && continue
  NUMBER=${line%;*}
  DESC=${line#*;}
  echo "database put blacklist ${NUMBER} \"${DESC}\""
  ${CLI} "database put blacklist ${NUMBER} \"${DESC}\""
done

rm ${TMPFILE}
