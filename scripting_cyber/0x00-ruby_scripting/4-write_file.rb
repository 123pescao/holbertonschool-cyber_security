#!/usr/bin/env ruby

require 'json'

def load_json_array(path)
  text = File.read(path)
  data = JSON.parse(text)
  if data.is_a?(Array)
    return data
  end
  return [data]
end

def merge_json_files(file1_path, file2_path)
  src = load_json_array(file1_path)
  dst = load_json_array(file2_path)

  src.each do |obj|
    dst << obj
  end

  json_out = JSON.pretty_generate(dst)
  File.write(file2_path, json_out)
end
