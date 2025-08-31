#!/usr/bin/env ruby


def print_arguments
  if ARGV.length == 0
    puts 'No arguments provided.'
    return
  end

  index = 1
  ARGV.each do |arg|
    puts index.to_s + '. ' + arg
    index += 1
  end
end

if __FILE__ == $0
  print_arguments
end
