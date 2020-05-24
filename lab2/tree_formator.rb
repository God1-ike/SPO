# frozen_string_literal: true

require 'tree'
require './string.rb'

module TreeFormator
  @lvl = []
  @if_counter = []
  @errors = []
  @switch_value

  def self.check_syntax(data, i)
    return 0 if ((data[i][:delimiter_1] == '}' && data[i].size == 1) || data[i].empty?)

    str = ''
    data[i].each do |_key, value|
      str += value + ' '
    end
    p str
    unless str.contains_a_switch? || str.contains_a_case? || str.contains_a_as_op? ||
           str.contains_a_if? || str.contains_a_break? || str.contains_a_else? || str.contains_a_default?
      @errors.push("invalid command string: #{i + 1}")
    end
  end

  # переход к последнему детскому узлу, у даном узле
  def self.down_poz(poz)
    poz.children[-1]
  end

  # переход к родителю данного узла
  def self.up_poz(poz)
    poz.parent
  end

  # перебор токенов в строке, и формирования для узлов для чисел и переменных
  def self.search_variable(data, i, poz)
    data[i].each do |key, value|
      if key.to_s.include?('id') || key.to_s.include?('num')
        poz << Tree::TreeNode.new("variable: #{value}", { key: value })
      end
    end
  end

  # проверка на то является ли условие if с большим блоком или маленьким,
  # в соответсвии формируется данные в временной переменной
  def self.opening_curly(data, i)
    if data[i].value?('{')
      @lvl.push(poz: 'more', compl: false)
      @if_counter.push(false)
    elsif data[i].value?('if') || data[i].value?('else')
      @lvl.push(poz: 'one', compl: false)
      @if_counter.push(false)
    end
  end

  # проверка на то, была ли открывающая скобка, и является ли она последней
  # если да то смещает положение на узел выше и удаляет историю ковычек
  def self.clouse_delimeter(poz, data, i)
    if @lvl.empty?
      @errors.push("Отсутствует открывающаяся ковычка для строки: #{i + 1}")
    elsif @lvl.last[:poz] == 'more'
      poz = up_poz(poz)
      @lvl.pop(1)
      @if_counter.pop(1)
      poz = up_poz(poz) unless data[i].value?('else')
    else
      @errors.push("Ошибка в строке #{i + 1}, отсутствует операция ")
    end
    poz
  end

  # если посленее условие было без ковычек, и оно было выполнено, то чистит
  # историю данного условия, иначе помещает как выполенео
  def self.one_string_compl(poz, data, i)
    if @lvl.last[:poz] == 'one'
      if @lvl.last[:compl]
        poz = up_poz(poz)
        @lvl.pop(1)
        poz = up_poz(poz) unless data[i].value?('else')
      else
        @lvl.last[:compl] = true
      end
    end
    poz
  end

  # расставляет приоритеты для арифметичеких знаков
  def self.prior(value)
    if value == ('+' || '-')
      0
    else
      1
    end
  end

  # добавляет в дерево элемент, в зависимости от того, является ли она узлом или нет
  def self.add_variable_arifmetic(i, values)
    if values[i].class == Tree::TreeNode
      values[i]
    else
      Tree::TreeNode.new("variable(#{i}): #{values[i]}", values[i])
    end
  end

  # запись в виде делерво арифметической операции
  def self.arifmetic(data, i, _poz)
    arithmetic_sign = []
    values = []
    data[i].each do |key, value|
      if key.to_s.include?('arithmetic_sign')
        arithmetic_sign.push({ value: value, prior: prior(value) })
      end
      values.push(value) if key.to_s.include?('id') || key.to_s.include?('num')
    end
    i = 0
    values.delete_at(0)
    while i < arithmetic_sign.size
      if arithmetic_sign[i][:prior] == 1
        tmp_poz = Tree::TreeNode.new("operation: #{arithmetic_sign[i][:value]}", arithmetic_sign[i][:value])
        tmp_poz << add_variable_arifmetic(i, values)
        tmp_poz << add_variable_arifmetic(i + 1, values)

        arithmetic_sign.delete_at(i)
        values.delete_at(i + 1)
        values[i] = tmp_poz
      else
        i += 1
      end
    end

    i = 0
    while i < arithmetic_sign.size
      tmp_poz = Tree::TreeNode.new("operation: #{arithmetic_sign[i][:value]}", arithmetic_sign[i][:value])
      tmp_poz << add_variable_arifmetic(i, values)
      tmp_poz << add_variable_arifmetic(i + 1, values)

      arithmetic_sign.delete_at(i)
      values.delete_at(i + 1)
      values[i] = tmp_poz
    end
    values[0]
  end

  def self.search_num_or_id(data, i)
    if data[i].key?(:num_0)
      data[i][:num_0]
    elsif data[i].key?(:id_0)
      data[i][:id_0]
    end
  end

  # Основной код программы, который рекурсивно проверяет, что происходит в строке
  # формирует в зависимости от этого ствою часть деревакги
  def self.node_create(data, i, poz)
    return -1 if i == data.size
    poz = clouse_delimeter(poz, data, i) if data[i].value?('}')
    opening_curly(data, i)
    check_syntax(data, i)
    poz = one_string_compl(poz, data, i) unless @lvl.empty?
    if data[i].empty?
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'if'
      poz << Tree::TreeNode.new("if(#{i + 1})", 'if')
      poz = down_poz(poz)
      poz << Tree::TreeNode.new("Compare: #{data[i][:conditional_operator]}",
                                { conditional_operator: data[i][:conditional_operator] })
      poz = down_poz(poz)
      search_variable(data, i, poz)
      poz = up_poz(poz)
      poz << Tree::TreeNode.new('if-body', 'if-body')
      poz = down_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'else'
      poz << Tree::TreeNode.new('else-body', 'else-body')
      poz = down_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i].key?(:type)
      poz << Tree::TreeNode.new("#{data[i][:type]}(#{i})", data[i][:type])
      poz = down_poz(poz)
      search_variable(data, i, poz)
      node_create(data, i + 1, poz)
    elsif data[i].key?(:assignment_operation)
      poz << Tree::TreeNode.new("assign(#{i})", 'assign')
      poz = down_poz(poz)
      poz << Tree::TreeNode.new("variable(#{i}): #{data[i][:id_0]}", data[i][:id_0])
      tmp = arifmetic(data, i, poz)
      poz << if tmp.class == String
               Tree::TreeNode.new("values(#{i}): #{tmp}", tmp)
             else
               tmp
             end
      poz = up_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'switch'
      poz << Tree::TreeNode.new("switch(#{i})", 'switch')
      data[i].each do |key, value|
        if key.to_s.include?('id') || key.to_s.include?('num')
          @switch_value = { value: value, str: i }
        end
      end
      poz = down_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'case'
      poz << Tree::TreeNode.new("case(#{i})", 'case')
      poz = down_poz(poz)
      poz << Tree::TreeNode.new('Compare: ==', '==')
      poz = down_poz(poz)
      poz << Tree::TreeNode.new("variable(#{@switch_value[:str]}): #{@switch_value[:value]}",
                                @switch_value[:value])
      poz << Tree::TreeNode.new("variable(#{i}): #{search_num_or_id(data, i)}", search_num_or_id(data, i))
      poz = up_poz(poz)
      poz << Tree::TreeNode.new('case-body', 'case-body')
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'default'
      poz << Tree::TreeNode.new("default(#{i})", 'case')
      poz = down_poz(poz)
      poz << Tree::TreeNode.new('default-body', 'default-body')
      poz = down_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i][:operator] == 'break'
      poz = up_poz(poz)
      node_create(data, i + 1, poz)
    elsif data[i].value?('}')
      node_create(data, i + 1, poz)
    else
      @errors.push("неизвестная операция в строке: #{i + 1}")
    end
  end

  def self.format(data)
    root_node = Tree::TreeNode.new('ROOT', 'Содержимое ROOT')
    node_create(data, 0, root_node)
    if @errors.empty?
      root_node.print_tree
    else
      puts @errors
    end
  end
end
