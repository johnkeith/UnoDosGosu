require_relative 'board'
require_relative 'timer_classes'
require_relative 'color_dots'
require_relative 'click'
require_relative 'pause_timer'
require 'pry'
require 'gosu'
require 'rubygems'


#-------------------------------------------------------------------------------------------------#
#                                                                                                 #
#                                                CONSTANTS                                        #
#                                                                                                 #
#-------------------------------------------------------------------------------------------------#

SCREEN_WIDTH = 721
SCREEN_HEIGHT = 721
CELL_SIZE_X = SCREEN_WIDTH / 7
CELL_SIZE_Y = SCREEN_HEIGHT / 7
TOP_X = CELL_SIZE_X
TOP_Y = CELL_SIZE_Y
SCREEN_CENT_WIDTH = SCREEN_WIDTH / 2
BEGIN_DOTS = SCREEN_CENT_WIDTH - 134
SCREEN_TOP = 48
SCREEN_BOTTOM = SCREEN_HEIGHT - 80
#switch this to change timer start
START_FROM = 0
#for colored dots
RADIUS = 13
#colors
BG_BLUE = Gosu::Color.new(59,178,247)
DARK_BLUE = Gosu::Color.new(36,28,119)
YELLOW = Gosu::Color.new(241, 247, 121)
TEAL = Gosu::Color.new(34, 193, 167)
UNO_DOS =

#COLORED DOTS SPECIFIC COLORS
GREEN = Gosu::Color.new(36, 214, 23)
YELLOW = Gosu::Color.new(246, 255, 10)
BLUE = Gosu::Color.new(49, 0, 155)
RED = Gosu::Color.new(160, 17, 27)

#NUMBER OF WHITE DOTS
NUM_WHITE_DOTS = 3



#-------------------------------------------------------------------------------------------------#
#                                                                                                 #
#                                                  MAIN                                           #
#                                                                                                 #
#-------------------------------------------------------------------------------------------------#
class GameWindow < Gosu::Window
  include Click
  attr_accessor :board, :default_font, :timer, :color_dot, :timer_to_display, :image, :play_button, :state,
                :time, :counter, :pause_button, :pause_timer

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @default_font = Gosu::Font.new(self, "Impact", 56)
    @game_board = Board.new
    self.caption = "UnoDos"
    @timer = TimerDown.new
    @pause_timer = PauseTimer.new
    @color_dot = Gosu::Image.new(self, Circle.new(RADIUS), false)
    @time = ""

    @arrow_up = Gosu::Image.new(self, "assets/up_arrow.png", false)
    @arrow_right = Gosu::Image.new(self, "assets/right_arrow.png", false)
    @arrow_left = Gosu::Image.new(self, "assets/left_arrow.png", false)
    @arrow_down = Gosu::Image.new(self, "assets/down_arrow.png", false)
    @play_button = Gosu::Image.new(self, "assets/playbutton.png",false)


    @state = :begin
    @counter = 0
  end

  def button_down(key)
    case key
    when Gosu::MsLeft
      arrow_and_tile = locate_click(mouse_x, mouse_y)
      if arrow_and_tile != nil && arrow_clicked?(mouse_x, mouse_y, arrow_and_tile[1])
        move_in_direction(arrow_and_tile[0], arrow_and_tile[1], arrow_and_tile[2])
      end
      if play_clicked?([mouse_x, mouse_y])
        puts "The mouse clicked at #{mouse_x}, #{mouse_y}"
        @state = :running
        3.times {insert_tile(find_emtpy)}
      end
      if pause_clicked?([mouse_x, mouse_y])
        @state = :paused
      end
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


#-----------------------------------------------------------------------------------------------#
#                                                                                               #
#                                              MAIN DRAW                                        #
#                                                                                               #
#-----------------------------------------------------------------------------------------------#
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

    #draw white dots
    draw_back_dots

    #draw play button
    if @state == :begin
      draw_play_butt
    end

    #draw color dots over white dots every second
    if @state == :running
      draw_pause_butt
      draw_color_dots
    end

    if @state == :paused
      draw_pause_dots
      @state = :running
    end


   @game_board.board.each do |row|
      row.each do |tile|
        if tile.content != "empty"
          draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, Gosu::Color::WHITE)
          draw_text(tile.center[0] - 12, tile.center[1] - 30, tile.content, @default_font)
          draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, TEAL)
          # @arrow_up.draw_rot(tile.center_top[0], tile.center_top[1], 1, 0)
          # @arrow_right.draw_rot(tile.center_right[0], tile.center_right[1], 1, 0)
          # @arrow_left.draw_rot(tile.center_left[0], tile.center_left[1], 1, 0)
          # @arrow_down.draw_rot(tile.center_bottom[0], tile.center_bottom[1], 1, 0)
        else
          draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, tile.color)
          draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, Gosu::Color::WHITE)
        end
        # draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, tile.color)
        # draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, Gosu::Color::WHITE)
        # use draw_rot to put image centered on top of coordinates
      end
    end
  end
#------------------------------------------------------------------------------------------------#
  def find_emtpy
    empty_space = nil
    while empty_space.nil?
      random_row = rand(5)
      random_col = rand(5)
      if @game_board.board[random_row][random_col].content == "empty"
        empty_space = [random_row, random_col]
        # puts "Found an empty space at #{random_row}, #{random_col}"
        # puts "#{@game_board.board[random_row][random_col].content}"
        # insert_successful = tru
      end
    end
    empty_space
  end

  def insert_tile(coords)
    letter = @game_board.random_letter
    @game_board.board[coords[0]][coords[1]].content = letter
  end
#------------------------------------------------------------------------------------------------#
#                                                                                                #
#                                       DRAW    METHODS                                          #
#                                                                                                #
#------------------------------------------------------------------------------------------------#
  def draw_back_dots
    width_increment = BEGIN_DOTS
    NUM_WHITE_DOTS.times do
      @color_dot.draw_rot(width_increment += 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                         1, 1, YELLOW,:default)
    end
  end

  def draw_pause_dots
    pause_time = @pause_timer.update_time
    board = @game_board.board

    if (pause_time == "Time: 01" || pause_time == "Time: 02" || pause_time == "Time: 03" ||
        pause_time ==  "Time: 04"|| pause_time == "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 103, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 02" || pause_time == "Time: 03" || pause_time == "Time: 04" ||
        pause_time ==  "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 103, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 103, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 03" || pause_time == "Time: 04" || pause_time == "Time: 05")

       @color_dot.draw_rot(board[0][4].center[0] + 103, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 103, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[2][4].center[0] + 103, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 04" || pause_time == "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 103, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 103, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[2][4].center[0] + 103, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[3][4].center[0] + 103, board[3][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 103, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 103, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[2][4].center[0] + 103, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[3][4].center[0] + 103, board[3][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)

       @color_dot.draw_rot(board[4][4].center[0] + 103, board[4][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end

  end

  def draw_pause_butt
    @pause_button.draw_rot(SCREEN_CENT_WIDTH, SCREEN_TOP, 1, 0)
  end

  def draw_play_butt
    @play_button.draw_rot(SCREEN_CENT_WIDTH, SCREEN_TOP, 1, 0)
  end

  def draw_color_dots
      @time = @timer.update_time


      if (time == "Time: 01" || time == "Time: 02" || time == "Time: 03")
        @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
      end
      if (time == "Time: 02" || time == "Time 03")
        @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
        @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
      end
      if (time == "Time: 03")
        @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
        @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
        @color_dot.draw_rot(BEGIN_DOTS + 180, SCREEN_BOTTOM, 1, 0, 0, 0,
                            1, 1, BLUE, :default)
        @counter += 1
        if @counter.between?(58, 61)
          @counter = 0
          insert_tile(find_emtpy)
        end
      end
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
