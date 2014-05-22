#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'

coll = {}

ARGV.each do |csv_input|
  $stderr.puts "Parsing #{csv_input} coll..."
  CSV.foreach(csv_input, :headers => true) do |row|
    coll[row["id"]] = row
  end
end

$stderr.puts coll.length

csv_string = CSV.generate do |csv_output|
  first_key, first_value = coll.first
  csv_output << first_value.headers()
  coll.each_value do |row|
    csv_output << row
  end
end

puts csv_string