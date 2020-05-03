# frozen_string_literal: true

module LexAnalyzer
  SYMBOLS = { arithmetic_sign: ['+', '-', '*', '/'],
              assignment_operation: '=',
              conditional_operator: ['<', '>', '==', '!=', '<=', '>='],
              delimiter: ['{', '}', '(', ')', ':'],
              comment: '//',
              end_str: ';' }.freeze
  WORDS = { operator: %w[case switch break default if else],
            type: ['int'] }.freeze
  @key = ''

  def self.analyze(line)
    nex_tok(line)
  end

  def self.is_number?(string)
    true if Float(string)
  rescue StandardError
    false
  end

  def self.symvol?(str)
    SYMBOLS.each do |key, value|
      if value.include?(str)
        @key = key
        return true
      end
    end
    false
  end

  def self.word?(str)
    WORDS.each do |key, value|
      if value.include?(str)
        @key = key
        return true
      end
    end
    false
  end

  def self.nex_tok(data)
    result_line = []
    i = 0
    data.chomp!
    pred_symvol = ''
    while i < data.size
      if data[i] == ' '
        i += 1
        next
      elsif symvol?(data[i])
        tmp = i + 1 < data.size ? data[i] + data[i + 1] : 'is_not_big_symvol'

        if symvol?(tmp)
          result_line.push({ @key => tmp })
          i += 1
          pred_symvol = tmp
        else
          result_line.push({ @key => data[i] })
        end
      else
        if pred_symvol == '//'
          tmp = ''
          while i < data.size
            tmp += data[i]
            i += 1
          end
          result_line.push({ text: tmp })
        else
          tmp = data[i]
          j = i + 1
          while j < data.size && !symvol?(data[j]) && data[j] != ' '
            tmp += data[j]
            j += 1
          end
          i = j - 1
          if word?(tmp)
            result_line.push({ @key => tmp })
          elsif is_number?(tmp)
            result_line.push({ num: tmp })
          else
            result_line.push({ id: tmp })
          end
        end

      end
      i += 1
    end
    result_line
  end
end
