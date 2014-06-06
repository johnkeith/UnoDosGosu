#-------------------------------------------------------------------------------------#
#                                                                                     #
#                                     BOARD CLASS                                     #
#                                                                                     #
#-------------------------------------------------------------------------------------#

# Takes of care of filling in board with different tiles containing the letters
#"U", "N", "O", "D", "S". The characteristics of a tile are located in the tile.rb file



require_relative "tile"


class Board
  # a board has many tiles
  # a board must be filled at the start of the game

  attr_accessor :board, :letters

  def initialize
    @board = self.class.build_board
    @letters = ["U","N","O","D","O",
                "U","N","O","O","S",
                "U","N","O","D","S",
                "U","O","O","D","S",
                "O","N","O","D","S"];
  end

  def self.build_board
    board = []
    row_arr = []
    (0..4).each do |row|
      (0..4).each do |col|
        x = TOP_X + (col * CELL_SIZE_X)
        y = TOP_Y + (row * CELL_SIZE_Y)
        row_arr << Tile.new(x, y)
      end
      board << row_arr
      row_arr = []

    end
    board
  end

  def random_letter
    @letters.shuffle.pop
  end

end
