#!/bin/sh
URL=https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html
XSLT=canada-covid.xsl
# we use tidy because we can't guarantee strictly validating xhtml
curl -L $URL | tidy -n -q -asxhtml - | xsltproc $XSLT -
