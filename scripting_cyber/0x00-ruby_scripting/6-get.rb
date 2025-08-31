#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

def get_request(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme == 'https'
    http.use_ssl = true
  end

  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)

  status_line = response.code.to_s + ' ' + response.message.to_s
  puts 'Response status: ' + status_line
  puts 'Response body:'

  body = response.body
  begin
    parsed = JSON.parse(body)
    puts JSON.pretty_generate(parsed)
  rescue JSON::ParserError
    puts body
  end
end

if __FILE__ == $0
  if ARGV.length >= 1
    get_request(ARGV[0])
  else
    puts 'Usage: 6-get.rb URL'
  end
end
