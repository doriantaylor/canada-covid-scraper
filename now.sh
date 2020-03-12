#!/bin/sh
curl -L https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html | tidy -n -q -asxhtml - | xsltproc $XSLT -
