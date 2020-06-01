# frozen_string_literal: true

require './string.rb'
require 'tree'

module VarChecking
  @errors = []
  def self.chec_id(key, val, i)
    if key.to_s.include?('id')
      @errors.push("не валидное название переменной в строке: #{i + 1}") unless val.contains_a_id?
    end
  end

  def self.getting_date(node)
    chec_id(node[:key], node[:val], node[:str])
    { (node[:val]).to_s => { key: node[:key], lvl: node[:lvl] } }
  end

  def self.check_array(node, id_variable)
    if node.content[:key] == 'id'
      id_variable.each do |array|
        return 0 if array.key?(node.content[:val])
      end
      @errors.push("неизвестная переманная в строке: #{node.content[:str] + 1}")
    end
  end

  def self.check(tree)
    id_variable = []
    tree.each do |node|
      if node.content.class == Hash && node.content.key?(:type)
        id_variable.push(getting_date(node.content))
      elsif node.content.class == Hash && node.content.key?(:key)
        check_array(node, id_variable)
      end
    end
    @errors
  end
end
