#!/usr/bin/env ruby

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require 'csv'

tm_dir = ARGV[0]

coll = {}
collref = {}

$stderr.puts "Parsing TM coll..."
CSV.foreach(File.join(tm_dir, "coll.csv"), :headers => false) do |row|
  coll[row[0]] = row
end

$stderr.puts coll.length

$stderr.puts "Parsing TM collref..."
CSV.foreach(File.join(tm_dir, "collref.csv"), :headers => false) do |row|
  if row[15].strip == "1. Actual"
    collref[row[1]] ||= []
    collref[row[1]] << row
  end
end

$stderr.puts collref.length

puts "count,id,title,address"

coll.each do |collection|
  if collref.has_key?(collection[0]) # && (collection[1][37] =~ /^http.*maps.google.*&ll=/)
    puts collref[collection[0]].length.to_s + "," + collection[0] + ",\"" + collection[1][7] + "\"" + ",\"" + collection[1][9].split("\v").map{|a| a.strip}.reject{|a| a =~ /^Tel.:/}.reject{|a| a =~ /^Fax:/}.join(", ") + "\"" # + collection[1][37].sub(/^http.*&ll=/,'').sub(/&.*$/,'')
  end
end