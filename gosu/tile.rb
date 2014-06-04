class Tile
  # a tile has an X and a Y position
  # a tile has a letter associated or is empty
  # a tile's content can be changed
  # each tile has a color
  # each tile's color can be conditionally changed

  # currently each tile is 103 x 103
  attr_accessor :x, :y, :content, :color

  def initialize(x, y, content = nil)
    @x = x
    @y = y
    @content = content
    @color = Gosu::Color.new(242, 242, 242)
    @center_top = [@x + (CELL_SIZE_X / 2),@y]
    @center_left = [@y + (CELL_SIZE_Y / 2),@x]
    @center_bottom = [@x + (CELL_SIZE_X / 2),@y + (CELL_SIZE_Y / 2)]  
    @center_right = [@x + CELL_SIZE_X, @y + (CELL_SIZE_Y / 2)]
  end
end
