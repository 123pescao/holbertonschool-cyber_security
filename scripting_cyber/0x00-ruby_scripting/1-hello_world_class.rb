#!/usr/bin/env ruby

class HelloWorld
    def initialize
        @message = "Hello, World!"
    end

    def set_message(msg)
        @message = msg
    end

    def print_hello
        puts @message
    end
end
