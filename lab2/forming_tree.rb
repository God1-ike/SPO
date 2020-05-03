require 'tree'
    # # Сперва создаем корневой узел. Обратите внимание, что каждый узел обязательно должен иметь имя и (не обязательно) некоторое содержимое.
    # root_node = Tree::TreeNode.new('ROOT', 'Содержимое ROOT')

    # # Теперь добавим дочерние узлы. Запомните, что вы можете создавать "цепочки" вложенности любой длины (глубины вложенности).

    # root_node << Tree::TreeNode.new('CHILD1', 'Child1 Content') << Tree::TreeNode.new('GRANDCHILD1', 'GrandChild1 Content')
    # root_node["CHILD1"] << Tree::TreeNode.new('GRANDCHILD2', 'GrandChild1 Content' )
    # root_node["CHILD1"] << Tree::TreeNode.new('GRANDCHILD3', 'GrandChild1 Content' )
    # root_node << Tree::TreeNode.new('CHILD2', 'Child2 Content')

    # # Давайте выведем представление нашего дерева на стандартном устройстве вывода (stdout). Это используется прежде всего в целях дебагинга.
    # root_node.print_tree
module TreeFormator
  def node_create(data)
    
  end
  

  def self.format(data)
    (0...data.size).each do |i|
        (0...data[i].size).each do |j|
          data[i][j].each { |key, value| puts "#{i}) #{key} => #{value}" }
        end
      end
  end
end