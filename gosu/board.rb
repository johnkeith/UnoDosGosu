require_relative "tile"

class Board
  # a board has many tiles
  # a board must be filled at the start of the game

  attr_accessor :board

  def initialize
    @board = build_board
  end

  def build_board
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

end
