#!/usr/bin/env ruby


require 'digest'

# Check arguments
if ARGV.length != 2
    puts "Usage: #{$0} HASHED_PASSWORD DICTIONARY_FILE"
    exit
end

hashed_password = ARGV[0].downcase.strip
dictionary_file = ARGV[1]

begin
    found = false
    File.foreach(dictionary_file) do |word|
        word.strip!
        next if word.empty?

        # Compute SHA-256 hash
        hash = Digest::SHA256.hexdigest(word)

        if hash == hashed_password
            puts "Password found: #{word}"
            found = true
            break
        end
    end

    puts "Password not found in dictionary." unless found
rescue Errno::ENOENT
    puts "Error: Dictionary file not found."
end