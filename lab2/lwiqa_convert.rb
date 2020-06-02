# frozen_string_literal: true

require 'tree'

module LWIQA
  @res = ''
  @lvl = [0, 0]

  def self.id_num(node)
    if node[:key] == 'id'
      "&#{node[:val]}&"
    elsif node[:key] == 'num'
      node[:val]
    end
  end

  def self.add_assign(tree)
    str = ''
    child = tree.children
    str += "#{' ' * tree.content[:lvl]}Q::#{id_num(child[0].content)} := "

    oper = []
    val = []
    child[1].each do |node|
      if node.content.class == String
        oper.push(" #{node.content}")
      else
        val.push(" #{id_num(node.content)}")
      end
    end

    (0...val.size).each do |i|
      str += val[i]
      str += oper[i] unless oper[i].nil?
    end
    puts str
  end

  def self.add_condition(tree)
    chld = tree.children
    val = chld[0].children
    puts "#{' ' * tree.content[:lvl]}Q::IF #{id_num(val[0].content)} #{chld[0].content[:conditional_operator]} #{id_num(val[1].content)}"
  end

  def self.add_var(tree)
    chld = tree.children
    puts "#{' ' * tree.content[:lvl]}Q::#{id_num(chld[0].content)}"
    puts "#{' ' * (tree.content[:lvl] + 2)}A::#{id_num(chld[1].content)}"
    
  end

  def self.convert(tree)
    $stdout = File.open('LWIQA.txt', 'w')
    tree.each do |node|
      if node.content.class == Hash
        if node.content[:oper] == 'int'
          add_var(node)
        elsif node.content[:oper] == 'if'
          add_condition(node)
        elsif node.content[:oper] == 'case'
          add_condition(node)
        elsif node.content[:oper] == 'assign'
          add_assign(node)
        end
      end
    end
  end
end
