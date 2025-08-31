#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  if uri.scheme == 'https'
    http.use_ssl = true
  end

  request = Net::HTTP::Post.new(uri.request_uri)
  request['Content-Type'] = 'application/json'
  request.body = JSON.generate(body_params)

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
    url = ARGV[0]
    params = {}
    post_request(url, params)
  else
    puts 'Usage: 8-post.rb URL'
  end
end
