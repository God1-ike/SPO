# frozen_string_literal: true
require './string.rb'
require 'tree'

module VarChecking
  def getting_date(node)
    # {node.content[:]}
  end

  def self.check(tree)
    id_variable = []
    tree.each do |node|
      if node.content.class == 'Hash' && node.content.has_key?(:type)
        id_variable.push()
      end
      puts node.content
    end
  end
end