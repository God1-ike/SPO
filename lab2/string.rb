class String
    def contains_a_switch?()  !!(self =~ /switch \( \w* \) \{/) end
    def contains_a_case?()  (self =~ /case \w* :/) end
    def contains_a_break?() (self =~ /break ;/) end
    def contains_a_as_op?() (self =~ /\w* = ([0-9\w]*)( [+-\/*]{1} [0-9\w]*)* ;/) end
    def contains_a_if?() (self =~ /if \( [0-9\w]* (==|<=|>=|>|<) [0-9\w]* \)/) end
    def contains_a_else?() (self =~ /else/) end
    def contains_a_default?() (self =~ /default :/) end
end