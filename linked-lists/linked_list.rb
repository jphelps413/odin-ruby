#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class LinkedList

  class Node
    attr_accessor :next_node
    attr_accessor :value

    def initialize value=nil,next_node=nil
      @value     = value
      @next_node = next_node
    end
  end

  attr_reader :head

  def initialize value
    @head = Node.new value
  end

  def append val
    link = @head
    link = link.next_node until link.next_node.nil?
    link.next_node = Node.new val
    self
  end

  def prepend val
    @head = Node.new val, @head
    self
  end

  def size
    link, size = @head, 0
    while !link.nil? do
      size += 1
      link = link.next_node
    end
    size
  end

  def head
    @head
  end

  def tail # maybe implement a tail member?
    link = @head
    link = link.next_node while !link.next_node.nil?
    link
  end

  def at idx
    link, count = @head, 0
    while count != idx do
      count += 1
      link   = link.next_node
    end
    link
  end

  def pop
    link, tail = @head, self.tail
    link = link.next_node until link.next_node == tail
    link.next_node = nil
    tail
  end

  def find val
    link, index = @head, 0
    while !link.nil? do
      return index if link.value === val
      index += 1
      link   = link.next_node
    end
    nil
  end

  def contains? val
    !find(val).nil?
  end

  def to_s
    runner = @head
    outstr = ""
    while !runner.nil?  do
      outstr += "(#{runner.value})->"
      runner = runner.next_node
    end
    outstr+"nil"
  end

  # Extra Credit

  def insert_at idx, value
    if idx == 0
      prepend value
    else
      there = at idx-1
      return nil if there.nil?
      there.next_node = Node.new value, there.next_node
    end
    self
  end

  def remove_at idx
    if idx == 0
      @head = @head.next_node
    else
      there = at idx-1
      return nil if there.nil?
      there.next_node = there.next_node.next_node
    end
    self
  end

end

if __FILE__ == $0
  # Build a test list.
  my_list = LinkedList.new 'first'
  ['dog','cat','bird','fish','tail'].each {|v| my_list.append v}
  my_list.prepend 'head'

  puts my_list.to_s

  def pass_fail cdx
    cdx ? "PASS":"FAIL"
  end
  [
    ['size',     my_list.size             == 7      ],
    ['head',     my_list.head.value       == 'head' ],
    ['tail',     my_list.tail.value       == 'tail' ],
    ['at',       my_list.at(3).value      == 'cat'  ],
    ['contains', my_list.contains?('head') == true  ],
    ['contains', my_list.contains?('tail') == true  ],
    ['contains', my_list.contains?('dog') == true   ],
    ['contains', my_list.contains?('pig') == false  ],
    ['find',     my_list.find('fish')     == 5      ],
    ['find',     my_list.find('frog')     == nil    ],
  ].each do |name,test|
    printf "Testing %-16s: %s\n", name, pass_fail(test)
  end
  puts

  # pop is destructive, so test it as such.
  pre_size = my_list.size
  printf "Testing #{my_list.to_s}\n"
  printf "Testing %-16s: %s\n", 'pop', pass_fail(my_list.pop.value == 'tail')
  printf "Testing #{my_list.to_s}\n"
  printf "Testing %-16s: %s\n", 'post-pop', pass_fail(my_list.size==pre_size-1)
  printf "Testing #{my_list.to_s}\n"

  # Extra Credit Tests
  my_list.insert_at 4,'cow'
  printf "Testing #{my_list.to_s}\n"
  printf "Testing %-16s: %s\n", 'insert_at', pass_fail(my_list.at(4).value == 'cow')

  my_list.remove_at 4
  printf "Testing #{my_list.to_s}\n"
  printf "Testing %-16s: %s\n", 'remove_at', pass_fail(my_list.at(4).value == 'bird')

end
