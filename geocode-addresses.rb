#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'
require 'geokit'

coll = {}

$stderr.puts "Parsing collections..."
CSV.foreach(ARGV[0], :headers => true) do |row|
  coll[row["id"]] = row
end

$stderr.puts coll.length

csv_string = CSV.generate do |csv_output|
  csv_output << %w{count id title longitude latitude elevation}
  coll.each_value do |row|
    $stderr.puts "Geocoding #{row.inspect}"
    address = row["address"]
    geoloc = Geokit::Geocoders::GoogleGeocoder.geocode(address)
    $stderr.puts geoloc.inspect
    if geoloc.success
      csv_output << [row["count"],row["id"],row["title"],geoloc.lng,geoloc.lat,0]
    end
    sleep(1)
  end
end

puts csv_string