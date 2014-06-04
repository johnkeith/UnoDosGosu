require_relative 'board'
require 'pry'
require 'gosu'

SCREEN_WIDTH = 721
SCREEN_HEIGHT = 721
CELL_SIZE_X = SCREEN_WIDTH / 7
CELL_SIZE_Y = SCREEN_HEIGHT / 7
TOP_X = CELL_SIZE_X
TOP_Y = CELL_SIZE_Y

class GameWindow < Gosu::Window
  
  attr_accessor :board

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @default_font = Gosu::Font.new(self, "Arial", 48)
    @game_board = Board.new
    self.caption = "UnoDos"
  end

  def button_down(key)
    case key
    when Gosu::MsLeft
      puts "#{mouse_x}, #{mouse_y}"
      find_emtpy
    end
  end

  def needs_cursor?
    true
  end

  # update() is called 60 times per second (by default) 
  # and should contain the main game logic: move objects, 
  # handle collisions, etc.
  def update
  end

  # draw() is called afterwards and whenever the window
  # needs redrawing for other reasons, and may also be 
  # skipped every other time if the FPS go too low. 
  # It should contain the code to redraw the whole screen, 
  # and no logic whatsoever.
  def draw
    white = Gosu::Color.new(0, 0, 0)
    blue_background = Gosu::Color.new(59, 178, 247)
    green_tile = Gosu::Color.new(16, 204, 185)
    
    draw_rect(0,0, SCREEN_WIDTH, SCREEN_HEIGHT, blue_background)

    @game_board.board.each do |row|
      row.each do |tile|
        draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, tile.color)
        draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, Gosu::Color::WHITE)
        # use draw_rot to put image centered on top of coordinates
      end
    end



  end

  def find_emtpy
    empty_space = nil
    while empty_space.nil?
      random_row = rand(5)
      random_col = rand(5)
      if @game_board.board[random_row][random_col].content == nil
        empty_space = [random_row, random_col]
        puts "Found an empty space at #{random_row}, #{random_col}"
        puts "#{@game_board.board[random_row][random_col].content}"
        insert_successful = true
      end
    end
  end

  def insert_tile(row, col)
    letter = @game_board.random_letter
    @game_board[row][col].content = letter
  end

  def draw_rect(x, y, width, height, color)
    draw_quad(x, y, color, x + width, y, color,
            x + width, y + height, color, x, y + height, color)
  end

  def draw_tile_letter(x, y, text, font, color)
    font.draw(text, x, y, 1, 1, 1, color)
  end
end

window = GameWindow.new
window.show

# goal - create basic tile with letter inside that accepts user input
