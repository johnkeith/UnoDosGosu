require_relative 'board'
require_relative 'timer_classes'
require_relative 'color_dots'
require 'pry'
require 'gosu'
require 'rubygems'


#-----------------------------------CONSTANTS-----------------------------#
SCREEN_WIDTH = 721
SCREEN_HEIGHT = 721
CELL_SIZE_X = SCREEN_WIDTH / 7
CELL_SIZE_Y = SCREEN_HEIGHT / 7
TOP_X = CELL_SIZE_X
TOP_Y = CELL_SIZE_Y
SCREEN_CENT_WIDTH = SCREEN_WIDTH / 2
BEGIN_DOTS = SCREEN_CENT_WIDTH - 164
SCREEN_BOTTOM = SCREEN_HEIGHT - 80
#switch this to change timer start
START_FROM = 0
#for colored dots
RADIUS = 16
#colors
BG_BLUE = Gosu::Color.new(59,178,247)
DARK_BLUE = Gosu::Color.new(36,28,119)
YELLOW = Gosu::Color.new(241, 247, 121)
TEAL = Gosu::Color.new(34, 193, 167)

FIRST_TIMER = Gosu::Color.new(234, 161, 172)
SECOND_TIMER = Gosu::Color.new(216, 28, 78)
THIRD_TIMER = Gosu::Color.new(178, 30, 92)
FOURTH_TIMER = Gosu::Color.new(170, 0, 48)



#--------------------------------------------------------------------------#
class GameWindow < Gosu::Window

  attr_accessor :board, :default_font, :timer, :color_dot, :timer_to_display

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @default_font = Gosu::Font.new(self, "Arial", 48)
    @game_board = Board.new
    self.caption = "UnoDos"
    @timer = TimerDown.new
    @color_dot = Gosu::Image.new(self, Circle.new(RADIUS), false)
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

    draw_white_dots
    #draw color dos over white dots every second
    draw_color_dots

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

  def draw_white_dots
    width_increment = BEGIN_DOTS
    4.times do
      @color_dot.draw_rot(width_increment += 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                         1, 1, Gosu::Color::WHITE,:default)
    end
  end

  def draw_color_dots

    time = @timer.update_time

    if (time == "Time: 01" || time == "Time: 02" || time == "Time: 03" || time == "Time: 04")
      @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, FIRST_TIMER, :default)
    end
    if (time == "Time: 02" || time == "Time 03" || time == "Time: 04")
      @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, FIRST_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, SECOND_TIMER, :default)
    end
    if (time == "Time: 03" || time == "Time: 04")
      @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, FIRST_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, SECOND_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 180, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, THIRD_TIMER, :default)
    end
    if (time == "Time: 04")
      @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, FIRST_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, SECOND_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 180, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, THIRD_TIMER, :default)
      @color_dot.draw_rot(BEGIN_DOTS + 240, SCREEN_BOTTOM, 1, 0, 0, 0,
                          1, 1, FOURTH_TIMER, :default)
    end
  end



  def draw_timer_centered
    @timer_to_display = @timer.update_time
    x = (SCREEN_WIDTH - default_font.text_width(@timer_to_display)) / 2
    y = SCREEN_BOTTOM
    draw_text(x, y, @timer_to_display, default_font)
  end

  def draw_text(x, y, text, font)
    font.draw(text, x, y, 1, 1, 1, Gosu::Color::BLACK)
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
