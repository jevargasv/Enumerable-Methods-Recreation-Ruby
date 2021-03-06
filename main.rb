# rubocop:disable Metrics/MethodLength,Metrics/ModuleLength,Metrics/CyclomaticComplexity,Style/CaseEquality,Metrics/PerceivedComplexity,Lint/RedundantCopDisableDirective,Lint/Syntax

# This module is a creation of the original Enumerable
module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    a = self
    a = *self if is_a? Range
    a.length.times { |i| yield(a[i]) }
    a
  end

  def my_each_with_index
    return to_enum :my_each_with_index unless block_given?

    a = self
    a = *self if is_a? Range
    a.length.times { |i| yield(a[i], i) }
    a
  end

  def my_select
    return to_enum :my_select unless block_given?

    result = []
    my_each { |i| result.push(i) if yield(i) }
    result
  end

  def my_all?(param = nil)
    test_all = true
    if !block_given? && param.nil?
      my_each { |i| test_all = false if [false, nil].include? i }
    elsif block_given? && param.nil?
      my_each { |i| test_all = false unless yield(i) }
    elsif param.is_a? Regexp
      my_each { |i| test_all = false unless i =~ param }
    elsif param.nil?
      my_each do |i|
        test_all = false unless i == true
      end
    elsif param.is_a? Class
      my_each do |i|
        test_all = false unless i.is_a?(param)
      end
    elsif !param.nil?
      my_each { |i| test_all = false unless i === param }
    end
    test_all
  end

  def my_any?(param = nil)
    result = false
    if block_given? && param.nil?
      my_each { |i| return true if yield(i) }
    elsif param.nil?
      my_each do |i|
        return true unless [false, nil].include? i
      end
    elsif param.is_a? Regexp
      my_each { |num| result = true if num =~ param }
    elsif param.is_a? Class
      my_each do |i|
        return true if i.is_a?(param)
      end
    elsif !param.nil?
      my_each { |i| return true if i == param }
    end
    result
  end

  def my_none?(param = nil)
    result = true
    if !block_given? && param.nil?
      result = false if my_any?(param)
    elsif param.is_a? String
      result = false if my_any?(param)
    elsif block_given?
      my_each { |i| result = false if yield(i) }
    elsif param.is_a? Numeric
      result = false if my_any?(param)
    elsif param.is_a? Regexp
      my_each { |num| result = false if num =~ param }
    elsif param.is_a? Class
      my_each { |num| result = false if num.is_a? param }
    end
    result
  end

  def my_count(param = nil)
    count = 0
    unless param.nil?
      length.times { |num| count += 1 if self[num] == param }
    end
    if block_given?
      length.times { |num| count += 1 if yield(self[num]) }
    elsif param.nil?
      return length
    end
    count
  end

  def range_to_arr
    a = self
    a = *self if is_a? Range
    a
  end

  def my_map(&my_proc)
    return to_enum :my_each_with_index unless block_given? || my_proc.is_a?(Proc)

    a = self
    a = range_to_arr if is_a?(Range)
    result_array = []
    if my_proc.is_a? Proc
      a.my_each { |i| result_array.push(my_proc.call(i)) }
      result_array
    elsif block_given?
      a.my_each { |i| result_array.push(yield(i)) }
    end
    result_array
  end

  def my_inject(init = nil, sym = nil)
    mathoperators = ['+', '-', '*', '/', '%', '**']
    init = init.to_sym if mathoperators.include?(init)
    sym = sym.to_sym if mathoperators.include?(sym)
    a = self
    a = *self if is_a? Range
    if init.is_a? Symbol
      total = first
      sym = init.to_sym
      a.each_with_index { |k, i| total = total.send(sym, k) if i.positive? }
      total
    elsif sym.is_a? Symbol
      total = init
      sym = sym.to_sym
      a.each { |k| total = total.send(sym, k) }
      total
    elsif (init.is_a? Numeric) && block_given?
      total = init
      a.each do |i|
        total = yield(total, i)
      end
      total
    elsif block_given? && init.nil?
      total = first
      a.my_each_with_index { |k, i| total = yield(total, k) if i.positive? }
    end
    total
  end
end
def multiply_els(arr)
  arr.my_inject { |total, value| total * value }
end
# rubocop:enable Metrics/MethodLength,Metrics/ModuleLength,Metrics/CyclomaticComplexity,Style/CaseEquality,Metrics/PerceivedComplexity,Lint/RedundantCopDisableDirective,Lint/Syntax
