#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

module Enumerable
  # As stated in step 1 of the task, irb/pry is really helpful when trying to
  # figure out the the proper return types from these methods. For example,
  # after loading this script and defining an Array or Hash variable,
  # invoking var.each and var.my_each should return the same results, with
  # or without a block. Of course this is really helpful too:
  #           http://ruby-doc.org/core-2.4.0/Enumerable.html
  def my_each
    return self.to_enum(__method__) unless block_given?
    for o in self
      yield(o)
    end
  end

  def my_each_with_index
    return self.to_enum(__method__) unless block_given?
    i = 0
    self.my_each {|o| yield(o,i); i+= 1}
  end

  def my_select
    return self.to_enum(__method__) unless block_given?
    if self.is_a? Hash
      out = Hash.new
      self.my_each {|k,v| out[k]=v if yield(k,v)}
    else
      out = Array.new
      self.my_each {|o| out << o if yield(o)}
    end
    out
  end

  def my_all?
    return self.my_all?{|o|o} unless block_given?
    self.my_each {|o| return false if !yield(o)}
    true
  end

  def my_any?
    return self.my_any?{|o|o} unless block_given?
    for o in self
      res = yield(o)
      return true if (!res.nil?&&res)
    end
    false
  end

  # TODO: This should just use my_any?, right?
  def my_none?
    if block_given?
      self.my_each {|o| return false if yield(o)}
      true
    else
      truths = 0
      self.my_each {|o| truths +=1 if o}
      truths == 0
    end
  end

  # Should probably issue a warning if a count AND a block are passed in.
  def my_count n = nil
    if block_given?
      truths = 0
      self.my_each {|o| truths += 1 if yield(o)}
      truths
    elsif n.nil?
      self.length
    else
      my_count {|x| x==n}
    end
  end

  # Accepts a proc or a block.
  def my_map p=nil
    return self.to_enum(__method__) unless (block_given?||!p.nil?)
    out = [] # map always returns arrays
    self.my_each {|v| out << (p.nil? ? yield(v) : p.call(v))}
    out
  end

  # This particular problem forces one to wrap their head around symbols
  # and how to go about using them to invoke methods.
  def my_inject *args, &block
    # See http://ruby-doc.org/core-2.4.0/Enumerable.html#inject regarding memo
    memo = nil
    case args.length
    when 0
      # raise LocalJumpError, "no block given" unless block_given?
      self.my_each {|ele| memo = memo.nil? ? ele : block.call(memo,ele)}
    when 1
      if block_given?
        memo = args[0] # unspecified initial value memo gets first element
        self.my_each {|ele| memo = block.call(memo,ele)}
      else
        op = arg_sym_check args[0]
        self.my_each {|ele| memo = memo.nil? ? ele : memo.send(op,ele)}
      end
    when 2 # Could be needs DRY'd, but I find this more readable.
      memo = args[0]
      op   = arg_sym_check args[1]
      self.my_each {|ele| memo = memo.send(op,ele)}
    else
      # Exception is modeled directly from Enumberable#inject output.
      raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0..2)" if args.length > 2
    end
    memo
  end

  private
  # Added this with intentions of sanitizing input, but not really necessary.
  def arg_sym_check op
      raise TypeError, "#{op} is not a symbol nor a string", "my_inject" unless
                           op.is_a?(Symbol) || op.is_a?(String)
      op
  end
end

# For testing injection by hand. Optional parameter to control which
# injection approach to test.
def multiply_els ary, injector=1
  case injector
  when 1 then ary.my_inject(:*)
  when 2 then ary.my_inject {|x,y|x*y}
  else        ary.my_inject(ary.pop,:*)
  end
end

def map_proc_block
  puts ((1..10).my_map Proc.new {|x|x*x}).join(', ') # with a Proc
  puts ((1..10).my_map          {|x|x*x}).join(', ') # with a Block
end

# I should have taken the time to setup rspec - oh well.
#
# These tests are based on http://ruby-doc.org/core-2.4.0/Enumerable.html
#
[
  ['all? 1', (%w[ant bear cat].my_all? { |word| word.length >= 3 }),  true ],
  ['all? 2', (%w[ant bear cat].my_all? { |word| word.length >= 4 }),  false],
  ['all? 3', ([nil, true, 99].my_all?),                               false],
  ['any? 1', (%w[ant bear cat].my_any? { |word| word.length >= 3 }),  true ],
  ['any? 2', (%w[ant bear cat].my_any? { |word| word.length >= 4 }),  true ],
  ['any? 3', ([nil, true, 99].my_any?),                               true ],
  ['none? 1',(%w{ant bear cat}.my_none? { |word| word.length == 5 }), true ],
  ['none? 2',(%w{ant bear cat}.my_none? { |word| word.length >= 4 }), false],
  ['none? 3',([].my_none?),                                           true ],
  ['none? 4',([nil].my_none?),                                        true ],
  ['none? 5',([nil, false].my_none?),                                 true ],
  ['none? 6',([nil, false, true].my_none?),                           false],
  ['count 1',([1,2,4,2].my_count == 4),                               true ],
  ['count 2',([1,2,4,2].my_count(2) == 2),                            true ],
  ['count 3',([1,2,4,2].my_count{|x| x%2==0} == 3),                   true ],
  ['map 1',  ((1..4).my_map{|i|i*i} == [1,4,9,16]),                   true ],
  ['map 2',  ((1..4).my_map{'cat'}  == ['cat','cat','cat','cat']),    true ],
  ['injct 1',((5..10).my_inject(:+) == 45),                           true ],
  ['injct 2',((5..10).my_inject{|s,n|s+n} == 45),                     true ],
  ['injct 3',((5..10).my_inject(:*) == 151200),                       true ],
  ['injct 4',((5..10).my_inject{|p,n|p*n} == 151200),                 true ],
].my_each {|name,res,exp| printf "%8s: %s\n", name, res == exp ? 'PASS':'FAIL ***'}
