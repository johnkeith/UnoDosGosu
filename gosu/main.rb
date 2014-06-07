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
BEGIN_DOTS = SCREEN_CENT_WIDTH - 130
SCREEN_TOP = 48
SCREEN_BOTTOM = SCREEN_HEIGHT - 80
#switch this to change timer start
START_FROM = 0
#for colored dots
RADIUS = 13
#colors
BG_BLUE = Gosu::Color.new(18,134,219)
DARK_BLUE = Gosu::Color.new(36,28,119)
YELLOW = Gosu::Color.new(255, 180, 38)
TEAL = Gosu::Color.new(11, 161, 94)

GREY = Gosu::Color.new(92,109,126)

#COLORED DOTS SPECIFIC COLOR
UFOGREEN = Gosu::Color.new(0, 107, 3)
AUSTRALIANMINT= Gosu::Color.new(244, 252, 171)
BLUE = Gosu::Color.new(8, 29, 165)
STRAWBERRY = Gosu::Color.new(191, 13, 126)

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
                :time, :counter, :pause_button, :pause_timer, :second_state

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @default_font = Gosu::Font.new(self, "Impact", 56)
    @game_board = Board.new
    self.caption = "UnoDos"
    @timer = TimerDown.new
    @pause_timer = PauseTimer.new
    @color_dot = Gosu::Image.new(self, Circle.new(RADIUS), false)
    @color_img = Gosu::Image.new(self, "assets/red_circle.png", false)
    @time = ""

    @board_bg = Gosu::Image.new(self, "assets/board_bg.png", false)
    @white_tile = Gosu::Image.new(self, "assets/white_tile.png", false)
    @green_tile = Gosu::Image.new(self, "assets/green_tile.png", false)
    @yellow_tile = Gosu::Image.new(self, "assets/yellow_tile.png", false)
    @arrow_up = Gosu::Image.new(self, "assets/up_arrow.png", false)
    @arrow_right = Gosu::Image.new(self, "assets/right_arrow.png", false)
    @arrow_left = Gosu::Image.new(self, "assets/left_arrow.png", false)
    @arrow_down = Gosu::Image.new(self, "assets/down_arrow.png", false)
    @play_button = Gosu::Image.new(self, "assets/play_up.png",false)

    @pause_button = Gosu::Image.new(self, "assets/pause_up.png",false)


    @state = :begin
    @second_state = :initial
    @counter = 0
  end

  def button_down(key)
    case key
    when Gosu::MsLeft
      arrow_and_tile = locate_click(mouse_x, mouse_y)
      if arrow_and_tile != nil && arrow_clicked?(mouse_x, mouse_y, arrow_and_tile[1])
        move_in_direction(arrow_and_tile[0], arrow_and_tile[1], arrow_and_tile[2])
        full_words = @game_board.find_words
        @game_board.colorize_words(full_words)
      end
      if play_clicked?([mouse_x, mouse_y])
        puts "The mouse clicked at #{mouse_x}, #{mouse_y}"
        @state = :running
        3.times {insert_tile(find_emtpy)}
      # elsif pause_clicked?([mouse_x, mouse_y])
      #   @second_state = :paused
      end
    when Gosu::KbEscape
      abort
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
    @board_bg.draw(103, 103, 1, 1, 1)
    #draw white dots
    draw_back_dots

    #draw play button
    if @state == :begin
      draw_play_butt
      #draw_pause_butt
    end


    if @second_state == :paused
      draw_pause_dots
      # if draw_pause_dots == :finished
      #   @state = :running
      # end
    end

    #draw color dots over white dots every second
    if @state == :running
      #draw_pause_butt
      draw_color_dots
    end


    # if @state == :playing
    #   draw_pause_butt
    # end
    # if @state == :paused
    #   draw_pause_dots
    #   #@state = :running
    # end

   @game_board.board.each_with_index do |row, row_idx|
      row.each_with_index do |tile, col_idx|
        if tile.content != "empty"
          # draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, GREY)
          if tile.color == "Green"
            @green_tile.draw(tile.x, tile.y, 2, 1, 1)
          elsif tile.color == "Yellow"
            @yellow_tile.draw(tile.x, tile.y, 2, 1, 1)
          end
          
          draw_tile_letter(tile.center[0] - 10, tile.center[1] - 33, tile.content, @default_font, Gosu::Color::WHITE)
          # draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, TEAL)
          begin
            if surrounding_tile_empty?(@game_board.board, :up, [row_idx, col_idx])
              @arrow_up.draw_rot(tile.center_top[0], tile.center_top[1], 3, 0)
            end
            if surrounding_tile_empty?(@game_board.board, :right, [row_idx, col_idx])
              @arrow_right.draw_rot(tile.center_right[0], tile.center_right[1], 3, 0)
            end
            if surrounding_tile_empty?(@game_board.board, :left, [row_idx, col_idx])
              @arrow_left.draw_rot(tile.center_left[0], tile.center_left[1], 3, 0)
            end
            if surrounding_tile_empty?(@game_board.board, :down, [row_idx, col_idx])
              @arrow_down.draw_rot(tile.center_bottom[0], tile.center_bottom[1], 3, 0)

            end
          rescue StandardError => e
            puts "e"
          end
        else
          @white_tile.draw(tile.x, tile.y, 2, 1, 1)
          # draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, tile.color)
          # draw_rect(tile.x + 2, tile.y + 2, CELL_SIZE_X - 4, CELL_SIZE_Y - 4, Gosu::Color::WHITE)
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
    # width_increment = BEGIN_DOTS
    # NUM_WHITE_DOTS.times do
    #   @color_dot.draw_rot(width_increment += 60, SCREEN_BOTTOM, 1, 0, 0, 0,
    #                      1, 1, AUSTRALIANMINT,:default)
    # end
  end

  def draw_pause_dots
    pause_time = @pause_timer.update_time
    puts pause_time

    board = @game_board.board

    if (pause_time == "Time: 01" || pause_time == "Time: 02" || pause_time == "Time: 03" ||
        pause_time ==  "Time: 04"|| pause_time == "Time: 05")

       @color_dot.draw_rot(board[0][4].center[0] + 90, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 02" || pause_time == "Time: 03" || pause_time == "Time: 04" ||
        pause_time ==  "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 90, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 90, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 03" || pause_time == "Time: 04" || pause_time == "Time: 05")

       @color_dot.draw_rot(board[0][4].center[0] + 90, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 90, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[2][4].center[0] + 90, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 04" || pause_time == "Time: 05")
       @color_dot.draw_rot(board[0][4].center[0] + 90, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[1][4].center[0] + 90, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[2][4].center[0] + 90, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
       @color_dot.draw_rot(board[3][4].center[0] + 90, board[3][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end
    if (pause_time == "Time: 05")
      @color_dot.draw_rot(board[0][4].center[0] + 90, board[0][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
      @color_dot.draw_rot(board[1][4].center[0] + 90, board[1][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
      @color_dot.draw_rot(board[2][4].center[0] + 90, board[2][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
      @color_dot.draw_rot(board[3][4].center[0] + 90, board[3][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)

      @color_dot.draw_rot(board[4][4].center[0] + 90, board[4][4].center[1], 1, 0, 0, 0,
                           1, 1, YELLOW,:default)
    end

    if (pause_time == "Time: 06")
      :finished
    end
  end

  def draw_pause_butt
    @pause_button.draw_rot(SCREEN_CENT_WIDTH + 50, SCREEN_TOP, 1, 0)
  end

  def draw_play_butt
    @play_button.draw_rot(SCREEN_CENT_WIDTH + 12, SCREEN_TOP + 15, 1, 0)
  end

  def draw_color_dots
      @time = @timer.update_time


      if (time == "Time: 01" || time == "Time: 02" || time == "Time: 03")
        # @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, UFOGREEN, :default)
        @color_img.draw_rot(BEGIN_DOTS + 85, SCREEN_BOTTOM + 10, 3, 0)
      end
      if (time == "Time: 02" || time == "Time 03")
        # @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, UFOGREEN, :default)
        # @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, STRAWBERRY, :default)
        @color_img.draw_rot(BEGIN_DOTS + 85, SCREEN_BOTTOM + 10, 3, 0)
        @color_img.draw_rot(BEGIN_DOTS + 130, SCREEN_BOTTOM + 10, 3, 0)

      end
      if (time == "Time: 03")
        # @color_dot.draw_rot(BEGIN_DOTS + 60, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, UFOGREEN, :default)
        # @color_dot.draw_rot(BEGIN_DOTS + 120, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, STRAWBERRY, :default)
        # @color_dot.draw_rot(BEGIN_DOTS + 180, SCREEN_BOTTOM, 1, 0, 0, 0,
        #                     1, 1, BLUE, :default)
        @color_img.draw_rot(BEGIN_DOTS + 85, SCREEN_BOTTOM + 10, 3, 0)
        @color_img.draw_rot(BEGIN_DOTS + 130, SCREEN_BOTTOM + 10, 3, 0)
        @color_img.draw_rot(BEGIN_DOTS + 175, SCREEN_BOTTOM + 10, 3, 0)

        # THIS IS WHERE TILES ARE GENERATED EVERY 3 SECONDS
        @counter += 1
        if @counter.between?(58, 61)
          @counter = 0
          insert_tile(find_emtpy)
          full_words = @game_board.find_words
          @game_board.colorize_words(full_words)
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
    font.draw(text, x, y, 3, 1, 1, color)
  end
end

window = GameWindow.new
window.show

# goal - create basic tile with letter inside that accepts user input
