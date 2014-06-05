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
SCREEN_TOP = 42
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

FIRST_TIMER = Gosu::Color.new(36, 214, 23)
SECOND_TIMER = Gosu::Color.new(246, 255, 10)
THIRD_TIMER = Gosu::Color.new(49, 0, 155)
FOURTH_TIMER = Gosu::Color.new(160, 17, 27)


#--------------------------------------------------------------------------#
class GameWindow < Gosu::Window

  attr_accessor :board, :default_font, :timer, :color_dot, :timer_to_display, :image, :play_button, :state,
                :time, :counter

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    @default_font = Gosu::Font.new(self, "Arial", 48)
    @game_board = Board.new
    self.caption = "UnoDos"
    @timer = TimerDown.new
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
        if play_clicked?([mouse_x, mouse_y])
          puts "The mouse clicked at #{mouse_x}, #{mouse_y}"
          @state = :running
        end
    end
  end

  def needs_cursor?
    true
  end

  def find_closest_arrow(row, x, y)
    all_coord = []

    @game_board.board[row].each do |tile|
      all_coord << tile.center_top
      all_coord << tile.center_bottom
      all_coord << tile.center_right
      all_coord << tile.center_left
    end

    closest_arrow = all_coord.inject do |sum, value|
      distance_sum = Gosu::distance(x, y, sum[0], sum[1])
      distance_val = Gosu::distance(x, y, value[0], value[1])
      distance_sum < distance_val ? sum : value
    end

    p "The closest arrow is at #{closest_arrow}"

    tile_index = find_tile_index(all_coord, closest_arrow)
    tile = @game_board.board[row][tile_index]

    [closest_arrow, tile]
  end

  def find_tile_index(all_coord, arrow_coord)
    index = all_coord.find_index(arrow_coord)
    if index.between?(0,3) then 0
    elsif index.between?(4,7) then 1
    elsif index.between?(8,11) then 2
    elsif index.between?(12,15) then 3
    elsif index.between?(16,19) then 4
    else
      "You're numbers are wacky."
    end
  end

  def direction_clicked?(click, arrow_coord)
    (click[0] - arrow_coord[0]).abs <= 25 && (click[1] - arrow_coord[1]).abs <= 25
  end

   def play_clicked?(click)
    (click[0] - SCREEN_CENT_WIDTH.abs <= 114) && (click[1] - SCREEN_TOP.abs <= 80)
  end



  def move_in_direction(tile, arrow_coord)
    p tile
    p arrow_coord
    if tile.center_top == arrow_coord
      p "move_up"
    elsif tile.center_left == arrow_coord
      p "move_left"
    elsif tile.center_bottom == arrow_coord
      p "move_down"
    elsif tile.center_right == arrow_coord
      p "move_right"
    else
      "Some kinda error. Your tile was #{tile.to_s} and your arrow_coord were #{arrow_coord}."
    end
  end

  def move_right(tile)
  end

  def tile_from_click(row, x, y)
    closest = find_closest_arrow(row, x, y)
    if direction_clicked?([x, y], closest[0])
      # selected = @game_board.board[row].select do |tile|
      #   tile.center_top == closest || tile.center_left == closest ||
      #   tile.center_right == closest || tile.center_bottom == closest
      # end
      # move_in_direction(selected, closest)
      move_in_direction(closest[1], closest[0])
    end
  end

  def determine_row_clicked(x, y)
    if y.between?(103,206)
      tile_from_click(0, x, y)
    elsif y.between?(207,309)
      tile_from_click(1, x, y)
    elsif y.between?(310,412)
      tile_from_click(2, x, y)
    elsif y.between?(413,515)
      tile_from_click(3, x, y)
    elsif y.between?(516,618)
      tile_from_click(4, x, y)
    else
      puts "You are outta bounds. Click in the grid"
    end
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

    #draw white dots
    draw_white_dots
    #draw color dots over white dots every second
    if @state == :running
      draw_color_dots
    end

    #draw play button
    if @state == :begin
      draw_play_butt
    end

   @game_board.board.each do |row|
      row.each do |tile|
        if tile.content != nil
          draw_rect(tile.x, tile.y, CELL_SIZE_X, CELL_SIZE_Y, TEAL)
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

  def find_emtpy
    empty_space = nil
    while empty_space.nil?
      random_row = rand(5)
      random_col = rand(5)
      if @game_board.board[random_row][random_col].content == nil
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

  def draw_white_dots
    width_increment = BEGIN_DOTS
    4.times do
      @color_dot.draw_rot(width_increment += 60, SCREEN_BOTTOM, 1, 0, 0, 0,
                         1, 1, Gosu::Color::WHITE,:default)
    end
  end

  def draw_play_butt
    @play_button.draw_rot(SCREEN_CENT_WIDTH, SCREEN_TOP, 1, 0)
  end

  def draw_color_dots
       @time = @timer.update_time
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

        @counter += 1
        puts @counter
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
