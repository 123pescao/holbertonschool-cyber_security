#!/usr/bin/env ruby

class CaesarCipher
  def initialize(shift)
    @shift = shift
  end

  def encrypt(message)
    cipher(message, @shift)
  end

  def decrypt(message)
    cipher(message, -@shift)
  end

  private

  def cipher(message, shift)
    result_chars = []

    normalized = shift % 26

    message.each_char do |ch|
      if ch =~ /[A-Z]/
        base = 'A'.ord
        offset = ch.ord - base
        new_offset = (offset + normalized) % 26
        result_chars << (base + new_offset).chr
      elsif ch =~ /[a-z]/
        base = 'a'.ord
        offset = ch.ord - base
        new_offset = (offset + normalized) % 26
        result_chars << (base + new_offset).chr
      else
        result_chars << ch
      end
    end

    result_chars.join
  end
end
