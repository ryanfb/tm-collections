#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'

coll = {}

master, subtract = ARGV

CSV.foreach(master, :headers => true) do |row|
  row["id"] = row["id"].to_i.to_s
  row["count"] = row["count"].to_i.to_s
  coll[row["id"]] = row
end

$stderr.puts coll.length

CSV.foreach(subtract, :headers => true) do |row|
  row["id"] = row["id"].to_i.to_s
  coll.delete(row["id"])
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