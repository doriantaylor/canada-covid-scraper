#!/bin/sh
DATES=dates.csv
URI=https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html
XSLT=canada-covid.xsl

# date sequence was created by seq and awk
# curl: -L is to follow Location header
# tidy: -n means no entities, -q means quitcher bitchin

for date in `cat $DATES`
do curl -L https://web.archive.org/web/$date/$URI | tidy -n -q -asxhtml - | xsltproc $XSLT - | tee $date.json
done
