# frozen_string_literal: true

require 'tree'

module VarChecking
  def self.check(tree)
    tree.each { |node| 
      puts node.content }
  end
end
