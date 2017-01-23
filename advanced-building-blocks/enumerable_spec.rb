#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'enumerable'

describe Enumerable do
  abc = %w(ant bear cat)

  describe '.my_all?' do
    context "using #{abc} array for tests" do
      it 'all words are 3 characters or more in length' do
        expect(abc.my_all? {|w| w.length >= 3} ).to be_truthy
      end

      it 'not all words are 4 characters or more in length' do
        expect(abc.my_all? {|w| w.length >= 4} ).to be_falsey
      end
    end
  end

  describe '.my_any?' do
    context "using #{abc} array for tests" do
      it 'any words are 3 characters or more in length' do
        expect(abc.my_any? {|w| w.length >= 3}).to be_truthy
      end

      it 'any words are 4 characters or more in length' do
        expect(abc.my_any? {|w| w.length >= 4}).to be_truthy
      end
    end
  end

  describe '.my_none?' do
    context "using #{abc} array for tests" do
      it 'there are no words that are 5 characters in length' do
        expect(abc.my_none? {|w| w.length == 5}).to be_truthy
      end

      it 'some words are 4 characters or more in length' do
        expect(abc.my_none? {|w| w.length >= 4}).to be_falsey
      end
    end
  end

  describe '.my_count' do
    nums = [1,2,4,2]
    context "using #{nums} array for tests" do
      it 'there are 4 numbers in the array' do
        expect(nums.my_count).to eql(4)
      end

      it 'there are two 2\'s in the array' do
        expect(nums.my_count(2)).to eql(2)
      end

      it 'there are three even numbers in the array' do
        expect(nums.my_count {|n| n%2 == 0}).to eql(3)
      end
    end
  end

  describe '.my_map' do
    context "using a range of (1..4) for map testing" do
      it 'each number in the range should be squared' do
        expect((1..4).my_map{|i|i*i}).to eql([1,4,9,16])
      end

      it 'map a four element array of the word cat' do
        expect((1..4).my_map{'cat'}).to eql(%w(cat cat cat cat))
      end
    end
  end

  describe '.my_inject' do
    context "using a range of (5..10) for injection testing" do
      it 'sum the numbers in the range using :+ to equal 45' do
        expect((5..10).my_inject(:+)).to eql(45)
      end

      it 'sum the numbers in the range using a block to equal 45' do
        expect((5..10).my_inject{|s,n|s+n}).to eql(45)
      end

      it 'multiply the numbers in the range using :* to equal 151200' do
        expect((5..10).my_inject(:*)).to eql(151200)
      end

      it 'multiply the numbers in the range using a block to equal 151200' do
        expect((5..10).my_inject{|p,n|p*n}).to eql(151200)
      end
    end
  end
end
