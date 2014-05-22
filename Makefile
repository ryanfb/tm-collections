all: earth.json tm-collections-geocoded.csv
	open index.html

node_modules:
	npm install .

build/ne_110m_admin_0_countries.zip:
	mkdir -p $(dir $@)
	wget -O $@ "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/$(notdir $@)"

build/ne_110m_admin_0_countries.shp: build/ne_110m_admin_0_countries.zip
	unzip -od $(dir $@) $<
	touch $@

build/countries.json: build/ne_110m_admin_0_countries.shp node_modules
	node_modules/.bin/topojson \
		-o $@ \
		--projection='width = 960, height = 600, d3.geo.mercator() \
			.translate([width / 2, height / 2])' \
		--simplify=.5 \
		--filter=none \
		-- countries=$<

tm-collections-geocoded.csv: tm-collections-addresses-geocoded.csv
	./merge-geocode-csv.rb $^ > $@

tm-collections-addresses-geocoded.csv: tm-collections-addresses-geocoded.kml
	saxon -xsl:kml2csv.xsl -s:$< -o:$@

earth.json: build/countries.json node_modules
	node_modules/.bin/topojson-merge \
		-o $@ \
		--in-object=countries \
		--out-object=earth \
		-- $<

clean:
	rm -f build/*