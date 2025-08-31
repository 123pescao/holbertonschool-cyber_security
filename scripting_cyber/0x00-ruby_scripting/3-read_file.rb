#!/usr/bin/env ruby


require 'json'

def count_user_ids(path)
  data = JSON.parse(File.read(path))

  counts = Hash.new(0)
  data.each do |item|
    uid = nil
    if item.is_a?(Hash)
      if item.key?('userId')
        uid = item['userId']
      elsif item.key?(:userId)
        uid = item[:userId]
      end
    end
    if uid
      counts[uid] += 1
    end
  end

  keys = counts.keys.compact.sort
  keys.each do |uid|
    puts "#{uid}: #{counts[uid]}"
  end
end

if __FILE__ == $0
  path = ARGV[0]
  if path.nil?
    path = 'file.json'
  end
  count_user_ids(path)
end