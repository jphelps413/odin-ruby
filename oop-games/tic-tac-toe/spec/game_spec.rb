#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

# Getting anxious to move onto the Rails section, so this is just a hack.
#
require './board'

describe "Tic Tac Toe Testastic" do

  let(:the_board) { Board.new }

  describe "place pieces in cells" do
    it 'fail to set invalid cell 0' do
      expect(the_board.place 'x',0).to be_falsey
    end

    it 'fail to set invalid cell 10' do
      expect(the_board.place 'x',10).to be_falsey
    end

    it 'fail to set invalid piece in valid cell 5' do
      expect(the_board.place 'q',5).to be_falsey
    end

    it 'place invalid letter in valid cell' do
      expect(the_board.place 'x', 1).to be_truthy
    end

    it 'X wins rows and one diagonal' do
      [[1,2,3],[4,5,6],[7,8,9],[1,5,9]].each do |row|
        the_board.reset
        row.each {|c| expect(the_board.place 'x', c).to be_truthy }
        expect(the_board.win_or_draw?).to eql('X')
      end
    end

    it 'O wins columns and the other diagonal' do
      [[1,4,7],[2,5,8],[3,6,9],[3,5,7]].each do |col|
        the_board.reset
        col.each {|c| expect(the_board.place 'o', c).to be_truthy }
        expect(the_board.win_or_draw?).to eql('O')
      end
    end

    it 'nobody wins a draw' do
      the_board.reset
      draw = %w(* X O X X O O O X X)
      (1..9).each {|c| expect(the_board.place draw[c],c).to be_truthy }
      expect(the_board.win_or_draw?).to eql('D')
    end
  end
end
