# frozen_string_literal: true

require 'tree'
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

    # # Сперва создаем корневой узел. Обратите внимание, что каждый узел обязательно должен иметь имя и (не обязательно) некоторое содержимое.
    # root_node = Tree::TreeNode.new('ROOT', 'Содержимое ROOT')

    # # Теперь добавим дочерние узлы. Запомните, что вы можете создавать "цепочки" вложенности любой длины (глубины вложенности).

    # root_node << Tree::TreeNode.new('CHILD1', 'Child1 Content') << Tree::TreeNode.new('GRANDCHILD1', 'GrandChild1 Content')
    # root_node["CHILD1"] << Tree::TreeNode.new('GRANDCHILD', 'GrandChild1 Content')
    # root_node << Tree::TreeNode.new('CHILD2', 'Child2 Content')

    # # Давайте выведем представление нашего дерева на стандартном устройстве вывода (stdout). Это используется прежде всего в целях дебагинга.
    # root_node.print_tree

  end
end

run
