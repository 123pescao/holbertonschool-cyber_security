#!/usr/bin/env ruby

require 'open-uri'
require 'uri'
require 'fileutils'

def download_file(url, local_path)
  puts 'Downloading file from ' + url + '...'

  uri = URI.parse(url)

  dir = File.dirname(local_path)
  unless Dir.exist?(dir)
    FileUtils.mkdir_p(dir)
  end

  content = URI.open(uri, 'rb') { |io| io.read }
  File.open(local_path, 'wb') { |f| f.write(content) }

  puts 'File downloaded and saved to ' + local_path + '.'
end

if __FILE__ == $0
  if ARGV.length != 2
    puts 'Usage: 9-download_file.rb URL LOCAL_FILE_PATH'
  else
    url_arg = ARGV[0]
    path_arg = ARGV[1]
    begin
      download_file(url_arg, path_arg)
    rescue StandardError => e
      puts 'Error: ' + e.message
    end
  end
end
