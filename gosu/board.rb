#-------------------------------------------------------------------------------------#
#                                                                                     #
#                                     BOARD CLASS                                     #
#                                                                                     #
#-------------------------------------------------------------------------------------#

# Takes of care of filling in board with different tiles containing the letters
#"U", "N", "O", "D", "S". The characteristics of a tile are located in the tile.rb file

require_relative "tile"
require_relative "click"

class Board
  include Click
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

# all assume starting x and y is an "O"
  def word_up?(x, y)
  end

  def word_down?(x, y)
    @board[x + 1][y].content == "N" && @board[x + 2][y].content == "U"
  end

  def word_left?(x, y)
  end

  def word_right?(x, y)
  end

  def word_center_vert?(x, y)
    @board[x + 1][y].content == "S" && @board[x - 1][y].content == "D" ||
    @board[x + 1][y].content == "D" && @board[x - 1][y].content == "S"
  end

  def word_center_horz?(x, y)
  end

  def find_words
    words = {}
    @board.each_with_index do |row, row_idx|
      o_idx_in_row = row.each_index.select do |index|
        row[index].content == "O"
      end

      if !o_idx_in_row.empty?
        puts "#{o_idx_in_row}"
        begin
          if row_idx == 0
            if col_idx == 4
              #check down
              #check left
            elsif col_idx == 3
              #check down
              #check left
              #check center horz
            elsif col_idx == 2
              #check down
              #check left
              #check right
              #check center horz
            elsif col_idx == 1
              #check down
              #check right
              #check center horz
            elsif col_idx == 0
              # check_down
              # check_right
            end
          # elsif row_idx == 1
          #   if col_idx == 3 || col_idx == 4
          #     #check down
          #     #check left
          #     #check center
          #   else
          #     # check_down
          #     # check_right
          #     #check center
          #   end
          # elsif row_idx == 2
          #   if col_idx == 3 || col_idx == 4
          #     #check down
          #     #check left
          #     #check up
          #     #check center
          #   else
          #     # check_down
          #     # check_right
          #     # check up
          #     #check center
          #   end
          # elsif row_idx == 3
          #   if col_idx == 3 || col_idx == 4
          #     #check left
          #     #check up
          #     #check center
          #   else
          #     # check_right
          #     # check up
          #     #check center
          #   end
          # elsif row_idx == 4
          #   if col_idx == 3 || col_idx == 4
          #     #check left
          #     #check up
          #   else
          #     # check_right
          #     # check up
          #   end
        end
        rescue StandardError => e
        end




        # o_idx_in_row.each do |col_idx|
        #   words[row_idx] = []
        #   # if you are at teh far right side of the board, don't look right, only check left
        #   if col_idx < row.length - 1 
        #     if surrounding_tile_empty?(@board, :right, [row_idx, col_idx])
        #       next
        #     elsif col_idx - 1 >= 0 && row[col_idx + 1].content == "S"
        #       if row[col_idx - 1].content == "D"
        #         words[row_idx] << [[row_idx, col_idx-1], [row_idx, col_idx], [row_idx, col_idx+1]]
        #       end
        #     elsif col_idx - 1 >= 0 && row[col_idx + 1].content == "D"
        #       if row[col_idx - 1].content == "S"
        #         words[row_idx] << [[row_idx, col_idx-1], [row_idx, col_idx], [row_idx, col_idx+1]]
        #       end
        #     elsif col_idx + 2 < row.length && row[col_idx + 1].content == "N"
        #       if row[col_idx + 2].content == "U"
        #         words[row_idx] << [[row_idx, col_idx], [row_idx, col_idx+1], [row_idx, col_idx+2]]
        #       end
        #     else
        #       next
        #     end
        #   #check two spaces to left
        #   else
        #     if surrounding_tile_empty?(@board, :left, [row_idx, col_idx])
        #       next
        #     elsif row[col_idx - 1].content == "N" && row[col_idx - 2].content == "U"
        #       words[row_idx] << [[row_idx, col_idx], [row_idx, col_idx-1], [row_idx, col_idx-2]]
        #     end
        #   end

          # if you are at the far rgight side, check left two spaces

          # if row_idx < @board.length - 1
          #   puts "There is an O at #{row_idx}, #{col_idx}"
          #   if surrounding_tile_empty?(@board, :down, [row_idx, col_idx])
          #     next
          #   elsif row_idx + 1 < @board.length && row_idx - 1 >= 0 &&
          #         @board[row_idx + 1][col_idx].content == "S"
          #     if @board[row_idx - 1][col_idx].content == "D"
          #       words[row_idx] << [[row_idx - 1, col_idx], [row_idx, col_idx], [row_idx + 1, col_idx]]
          #     end
          #   elsif row_idx + 1 < @board.length && row_idx - 1 >= 0 &&
          #         @board[row_idx + 1][col_idx] == "D"
          #     if @board[row_idx - 1][col_idx].content == "S"
          #       words[row_idx] << [[row_idx - 1, col_idx], [row_idx, col_idx], [row_idx + 1, col_idx]]
          #     end
          #   elsif row_idx + 2 < @board.length && @board[row_idx + 1][col_idx].content == "N"
          #     if @board[row_idx + 2][col_idx].content == "U"
          #        words[row_idx] << [[row_idx, col_idx], [row_idx, col_idx+1], [row_idx, col_idx+2]]
          #     end
          #   else
          #     next
          #   end
          #   #if you are at the bottom of the board, only check two spaces up
          # else
          #   if surrounding_tile_empty?(@board, :up, [row_idx, col_idx])
          #     next
          #   elsif @board[row_idx - 1][col_idx].content == "N" && @board[row_idx - 2][col_idx].content == "U"
          #     words[row_idx] << [[row_idx, col_idx], [row_idx-1, col_idx], [row_idx-2, col_idx]]
          #   end
          # end
        # end
      end
    end
    p words
    return words
  end
 def colorize_words(words)
    # @board.each_with_index do |row, row_idx|
    #   row.each_with_index do |col, col_idx|
    #     puts "I'm changing #{row_idx}, #{col_idx} to Green"
    #     @board[row_idx][col_idx].color == "Green"
    #   end
    # end
    
    words.each do |key, value|
      value.each do |words|
        words.each do |coords|
          @board[coords[0]][coords[1]].color = "Yellow"
          @board[coords[0]][coords[1]].locked = true
        end
      end
    end
  end


  def score_board
  end

end
