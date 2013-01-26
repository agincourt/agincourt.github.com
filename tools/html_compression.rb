#!/usr/bin/env ruby

require 'fileutils'

class Document
  attr_accessor :path, :file
  
  # class methods
  def self.list(path)
    Dir.glob("#{path}/**/*.html").map { |path|
      path
      Document.new(path)
    }
  end
  
  # 
  def self.process(paths)
    puts "Beginning compression"
    paths.each(&:process)
    puts ""
    puts "Complete!"
  end
  
  # run the process on all the files
  def self.run(path)
    process(list(path))
  end
  
  # instance methods
  def initialize(path)
    self.path = path
  end
  
  def file
    self.file ||= File.new(@path)
  end
  
  def process
    # check the file is writable
    print "X" and return unless File.writable?(path)
    print "."
    
    self.content = content.gsub(/\n\t/, " ").gsub(/>\s*</, "><")
  end
  
  def content
    data = ''
    f = File.open(path, 'r') 
    f.each_line do |line|
      data += line
    end
    data
  end
  
  def content=(doc)
    File.open(path, 'w') {|f| f.write(doc) }
  end
end

puts "HTML compressor v1"

if ARGV.size > 1
  # load the path
  path = ARGV[1]
  # run the processing
  Document.run(path)
else
  puts "You should use the format:"
  puts "ruby #{__FILE__} --path /path/to/dir"
end