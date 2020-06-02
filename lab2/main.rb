# frozen_string_literal: true

require 'tree'
require './lex_analyzer.rb'
require './tree_formator.rb'
require './lwiqa_convert.rb'

def self.check?
  file = File.new('code.txt')
  d = file.read
  file.close
  d.gsub!(/\s+/, '')

  d.empty?
end

def out(result)
  (0...result.size).each do |i|
    result[i].each { |key, value| puts "#{i}) #{key} => #{value}" }
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
      # result.pop(1) if result.last.empty?
    end
    file.close
    out(result)
    tree = TreeFormator.format(result)
    LWIQA.convert(tree) if tree.class == Tree::TreeNode
  end
end

run
