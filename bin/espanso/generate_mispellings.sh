#!/usr/bin/env bash

curl -s "https://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings/For_machines" -o list_of_mispellings_full_page.html

sed -n '/<pre>/,/<\/pre>/p' list_of_mispellings_full_page.html >list_of_mispellings.html

xmllint --html --xpath '//pre/text()' list_of_mispellings.html | sed -e 's|-&gt;|:|g' >list_of_mispellings.txt

cat list_of_mispellings.txt | tr -s '\n' | sort | uniq >sorted_list_of_mispellings.txt

while read -r trigger; do
  echo $trigger
  sed -i.bu "/$trigger/I d" sorted_list_of_mispellings.txt
done <unwanted_mispelled_words.txt

echo "name: mispellings" >mispellings.yml
echo "parent: default" >>mispellings.yml
echo "" >>mispellings.yml
echo "matches:" >>mispellings.yml

while IFS=: read -r trigger replace || [ -n "$trigger" ]; do
  if [ -n "$trigger" ]; then
    echo "  - trigger: \"$trigger\"" >>mispellings.yml
    echo "    replace: \"$replace\"" >>mispellings.yml
    echo "    propagate_case: true" >>mispellings.yml
    echo "    word: true" >>mispellings.yml
  fi
done <sorted_list_of_mispellings.txt

rm sorted_list_of_mispellings.txt
rm sorted_list_of_mispellings.txt.bu
rm list_of_mispellings_full_page.html
rm list_of_mispellings.html
rm list_of_mispellings.txt
