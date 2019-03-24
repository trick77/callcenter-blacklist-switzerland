#!/bin/bash
cli="/usr/sbin/asterisk -rx"
dump=/tmp/blacklist.backup
blacklist=/tmp/latest_cc_blacklist.txt
 
wget -O${blacklist} https://raw.githubusercontent.com/trick77/callcenter-blacklist-switzerland/master/latest_cc_blacklist.txt
 
echo "Dumping old blacklist to $dump"
$cli "database show blacklist" &amp;gt; $dump
 
if [ "$1" == "-d" ]; then
  echo "Removing all existing blacklist entries"
  $cli "database deltree blacklist"
fi
 
cat $blacklist | while read line; do
  [[ $line = \#* ]] &amp;amp;&amp;amp; continue
  number=${line%;*}
  desc=${line#*;}
  echo "database put blacklist $number \"$desc\""
  $cli "database put blacklist $number \"$desc\""
done
