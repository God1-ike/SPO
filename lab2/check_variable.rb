# frozen_string_literal: true

require './string.rb'
require 'tree'

module VarChecking
  @errors = []
  @lvl_tmp = 0
  
  # проверка на правлиьность назввании перемнной
  def self.chec_id(key, val, i)
    if key.to_s.include?('id')
      @errors.push("не валидное название переменной в строке: #{i + 1}") unless val.contains_a_id?
    end
  end

  # сохраненние данных о созданной переменной
  def self.getting_date(node)
    chec_id(node[:key], node[:val], node[:str])
    { (node[:val]).to_s => { key: node[:key], lvl: node[:lvl] } }
  end

  # проверка на то объявлена ли переменная или нет
  def self.check_array(node, id_variable)
    if node.content[:key] == 'id'
      id_variable.each do |array|
        return 0 if array.key?(node.content[:val])
      end
      @errors.push("неизвестная переменная в строке: #{node.content[:str] + 1}")
    end
  end

  # контроль уровня объявленной переменной
  def self.change_lvl(node, id_variable)
    if node.content.has_key?(:lvl)
      @lvl_tmp = node.content[:lvl]
      id_variable.each do |array|
        id_variable.delete(array) if array.values[0][:lvl] > @lvl_tmp
      end
    end
    id_variable
  end

  # проверка на повторное объявление переменной
  def self.in_array?(id_variable, node)
    id_variable.each do |hash|
      if hash.key?(node.content[:val])
        @errors.push("Данная перменная(#{node.content[:val]}) уже объявлена строка: #{node.content[:str]+1}")
        return false
      end
    end
    true
  end

  # свновной метод
  def self.check(tree)
    id_variable = []
    tree.each do |node|
      p node.content
      if node.content.class == Hash
        id_variable = change_lvl(node, id_variable)
        if node.content.key?(:type) && in_array?(id_variable, node)
          id_variable.push(getting_date(node.content))
        elsif node.content.key?(:key)
          
          check_array(node, id_variable)
        end
      end
    end
    puts '----------------------', id_variable
    @errors
  end
end
