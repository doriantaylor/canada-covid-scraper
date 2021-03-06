# Canada COVID-19 JSONifier

This script will scrape https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html and retrieve its relevant data as JSON. Uses the Wayback Machine to retrieve historical data, since the Canadian government doesn't seem to be keeping that around. Run `scrape.sh` to dump out the archive, and run `now.sh` to get today's data.

As of 2020-03-12 there are two case data counts: actual and presumed. These will show up as an array. I made _actual_ come first to match up with the scalars.

Note that the numbers for the test results are _only_ those which are conducted directly by Health Canada.

## Dependencies

This is just a shell script which means it glues together:

* curl
* tidy
* xsltproc

## Copyright & License

©2020 [Dorian Taylor](https://doriantaylor.com/)

This software is provided under
the [Apache License, 2.0](https://www.apache.org/licenses/LICENSE-2.0).
