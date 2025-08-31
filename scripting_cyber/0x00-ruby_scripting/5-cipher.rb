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
    message.chars.map do |char|
      if char =~ /[A-Z]/   # uppercase
        (((char.ord - 'A'.ord + shift) % 26) + 'A'.ord).chr
      elsif char =~ /[a-z]/ # lowercase
        (((char.ord - 'a'.ord + shift) % 26) + 'a'.ord).chr
      else
        char # punctuation, spaces, digits unchanged
      end
    end.join
  end
end