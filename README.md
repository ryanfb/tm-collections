Geographic distribution of texts/collections in [Trismegistos](http://www.trismegistos.org/). Circle position is location of the collection, circle size corresponds to the number of texts recorded as currently held by that collection. You can pan/zoom inside the map for more detail.

Construction
------------
Mike Bostock's [Let's Make a Map](http://bost.ocks.org/mike/map/) and [Let's Make a Bubble Map](http://bost.ocks.org/mike/bubble-map/) tutorials were immensely helpful in learning how to create this visualization.

Data is from a private Trismegistos CSV data dump, from which the collection sizes and addresses are extracted and output to another CSV (`tm-collections-addresses-clean.csv`). The addresses were then [geocoded](http://en.wikipedia.org/wiki/Geocoding) in multiple steps:

 * The addresses CSV (`tm-collections-addresses-clean.csv`) was loaded into Google Fusion Tables with the address column set to a "location" type, then a map visualization was created to geocode the column and enable KML download. Unfortunately, the KML from this doesn't have point coordinates associated with it, so it was opened in Google Earth and re-exported to add point coordinates. `kml2csv.xsl` then turns this back into a CSV (`tm-collections-addresses-geocoded.csv`).
 * Also unfortunately, the "Fusion Tables KML->Google Earth KML" process doesn't associate points to all the same features that Fusion Tables will geocode and display on a map. `geocode-addresses.rb` was written as a simple script to pipe addresses through the raw Google Geocoding API. Since the API has a limit of 2500 requests per day, I don't want to re-geocode addresses I already have a point for, so I wrote `subtract-csv.rb` to subtract `tm-collections-addresses-geocoded.csv` from `tm-collections-addresses-clean.csv` and make `tm-collections-addresses-nongeocoded.csv`. The geocoded results of this are stored in `tm-collections-addresses-geocoded-remainder.csv`.
 * We might have some incorrectly-geocoded addresses, so `tm-collections-manually-geocoded.csv` lets us record these.
 * `merge-geocode-csv.rb` merges `tm-collections-addresses-geocoded.csv`, `tm-collections-addresses-geocoded-remainder.csv`, and `tm-collections-manually-geocoded.csv` to make the final `tm-collections-geocoded.csv`.

This is all also semi-automated/documented in the `Makefile`.