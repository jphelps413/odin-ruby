#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class BinaryTree

  class Node
    attr_reader   :value
    attr_accessor :left, :right # :parent necessary?

    def initialize value=nil
      @value = value
      @left  = nil
      @right = nil
    end
  end

  def initialize
    @root = nil
  end

  def add leaf, tree
    return leaf if tree.nil?
    if leaf.value < tree.value
      tree.left.nil? ? tree.left = leaf : add(leaf,tree.left)
    else
      tree.right.nil? ? tree.right= leaf : add(leaf,tree.right)
    end
    leaf
  end

  def build_tree values
    @root = Node.new values[0]
    values.each_with_index do |value,index|
      add Node.new(value), @root if index > 0
    end
  end

  def breadth_first_search value, queue=[@root]
    until queue.empty?
      node = queue.shift # queues are shifty
      return node if node.value == value
      queue.push node.left  unless node.left.nil?
      queue.push node.right unless node.right.nil?
    end
    nil
  end

  def depth_first_search value, stack=[@root]
    until stack.empty?
      node = stack.pop # stacks are poppy
      return node if node.value == value
      stack.push node.right unless node.right.nil?
      stack.push node.left  unless node.left.nil?
    end
    nil
  end

  def dfs_rec value, tree=@root
    return tree if tree.value == value
    leaf = dfs_rec(value, tree.left) unless tree.left.nil?
    return leaf unless leaf.nil?
    leaf = dfs_rec(value, tree.right) unless tree.right.nil?
    return leaf unless leaf.nil?
    nil
  end
end

# Only run the embedded guess quality testing here.
if __FILE__ == $0
  btree = BinaryTree.new
  btree.build_tree [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].shuffle

  def pass_fail cdx
    cdx ? 'PASS':'FAIL'
  end
  puts
  [
    ['breadth find', (btree.breadth_first_search 8).value == 8 ],
    ['breadth nope', (btree.breadth_first_search 999).nil?     ],
    ['depth   find', (btree.depth_first_search 8).value == 8   ],
    ['recurse find', (btree.dfs_rec 1).value == 1              ],
    ['recurse find', (btree.dfs_rec 324).value == 324          ],
    ['recurse nope', (btree.dfs_rec 99).nil?                   ],
  ].each do |name,test|
    printf "Testing %-16s: %s\n", name, pass_fail(test)
  end
  puts
end
