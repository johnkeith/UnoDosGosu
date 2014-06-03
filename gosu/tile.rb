class Tile
  # a tile has an X and a Y position
  # a tile has a letter associated or is empty
  # a tile's content can be changed
  # each tile has a color
  # each tile's color can be conditionally changed

  attr_accessor :x, :y, :content, :color

  def initialize(x, y, content = nil)
    @x = x
    @y = y
    @content = content
    @color = Gosu::Color.new(242, 242, 242)
  end
end
