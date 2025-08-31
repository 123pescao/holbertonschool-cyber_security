#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

TASKS_FILE = "tasks.txt"

# Ensure tasks file exists
FileUtils.touch(TASKS_FILE)

# Read tasks from file
def read_tasks
  File.readlines(TASKS_FILE, chomp: true)
end

# Write tasks back to file
def write_tasks(tasks)
  File.open(TASKS_FILE, "w") do |file|
    tasks.each { |task| file.puts(task) }
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", Integer, "Remove a task by index") do |index|
    options[:remove] = index
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

# Perform actions
if options[:add]
  tasks = read_tasks
  tasks << options[:add]
  write_tasks(tasks)
  puts "Task '#{options[:add]}' added."
elsif options[:list]
  tasks = read_tasks
  if tasks.empty?
    puts "No tasks found."
  else
    puts "Tasks:"
    tasks.each_with_index do |task, i|
      puts "#{i + 1}. #{task}"
    end
  end
elsif options[:remove]
  tasks = read_tasks
  index = options[:remove] - 1
  if index >= 0 && index < tasks.size
    removed = tasks.delete_at(index)
    write_tasks(tasks)
    puts "Task '#{removed}' removed."
  else
    puts "Invalid task index."
  end
else
  puts "Use -h for help"
end