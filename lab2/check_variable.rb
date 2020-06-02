# frozen_string_literal: true

require './string.rb'
require 'tree'

module VarChecking
  @errors = []
  @lvl_tmp = 0
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
      @errors.push("неизвестная переменная в строке: #{node.content[:str] + 1}")
    end
  end

  def self.change_lvl(node, id_variable)
    @lvl_tmp = node.content[:lvl] if node.content.key?(:oper)

    id_variable.each do |array|
      id_variable.delete(array) if array.values[0][:lvl] > @lvl_tmp
    end
    id_variable
  end

  def self.in_array?(id_variable, node)
    id_variable.each do |hash|
      if hash.key?(node.content[:val])
        @errors.push("Данная перменная(#{node.content[:val]}) уже объявлена строка: #{node.content[:str]+1}")
        return false
      end
    end
    true
  end

  def self.check(tree)
    id_variable = []
    tree.each do |node|
      if node.content.class == Hash
        if node.content.key?(:type) && in_array?(id_variable, node)
          id_variable.push(getting_date(node.content))
        elsif node.content.key?(:key)
          id_variable = change_lvl(node, id_variable)
          check_array(node, id_variable)
        end
      end
    end
    puts '----------------------', id_variable
    @errors
  end
end
