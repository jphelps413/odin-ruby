#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'caesar_cipher'

describe '#caesar_cipher' do
  describe '"What a string!" rotated 5' do
    it 'returns Bmfy f xywnsl!' do
      expect( caesar_cipher('What a string!', 5)).to eql('Bmfy f xywnsl!')
    end
  end

  describe '"wxyz abcd" rotated 4' do
    it 'returns: abcd efgh' do 
      expect( caesar_cipher('wxyz abcd', 4)).to eql('abcd efgh')
    end
  end

  describe '"abcd efgh" rotated -4' do
    it 'returns: wxyz abcd' do 
      expect( caesar_cipher('abcd efgh', -4)).to eql('wxyz abcd')
    end
  end

  describe '"unrotated" rotated 0' do
    it 'return: unrotated' do
      expect( caesar_cipher('unrotated',0)).to eql('unrotated')
    end
  end

end
