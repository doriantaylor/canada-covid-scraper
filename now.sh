#!/bin/sh
URL=https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html
curl -L $URL | tidy -n -q -asxhtml - | xsltproc $XSLT -
