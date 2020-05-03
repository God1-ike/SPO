# frozen_string_literal: true

require './analyzer.rb'

def self.check?
  file = File.new('code.txt')
  d = file.read
  file.close
  d.gsub!(/\s+/, '')

  d.empty?
end

def out(result)
  (0...result.size).each do |i|
    (0...result[i].size).each do |j|
      result[i][j].each { |key, value| puts "#{i}) #{key} => #{value}" }
    end
  end
end

def run
  result = []
  if check?
    puts 'ERROR: empty file'
  else
    file = File.new('code.txt')
    file.each do |line|
      result.push(LexAnalyzer.analyze(line))
    end
    file.close
    out(result)
  end
end

run
