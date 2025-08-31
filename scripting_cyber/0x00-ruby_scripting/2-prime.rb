#!/usr/bin/env ruby

require 'prime'

def prime(number)
  return false unless number.is_a?(Integer) && number > 1
  Prime.prime?(number)
end