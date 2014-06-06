module Click
  def locate_click(x, y)
    if y.between?(103,206)
      closest_arrow_and_tile(0, x, y)
    elsif y.between?(207,309)
      closest_arrow_and_tile(1, x, y)
    elsif y.between?(310,412)
      closest_arrow_and_tile(2, x, y)
    elsif y.between?(413,515)
      closest_arrow_and_tile(3, x, y)
    elsif y.between?(516,618)
      closest_arrow_and_tile(4, x, y)
    else
      puts "You are outta bounds. Click in the grid"
    end
  end

  # def tile_from_click(row, x, y)
  #   closest = find_closest_arrow(row, x, y)
  #   if direction_clicked?([x, y], closest[0])
  #     move_in_direction(closest[1], closest[0], closest[2])
  #   end
  # end

  def closest_arrow_and_tile(row, x, y)
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

    column = find_col_in_row(all_coord, closest_arrow)

    tile = @game_board.board[row][column]
    tile_position = [row, column]
    [tile, closest_arrow, tile_position]
  end

  def find_col_in_row(all_coord, arrow_coord)
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

  def arrow_clicked?(mouse_x, mouse_y, arrow_coord)
    (mouse_x - arrow_coord[0]).abs <= 25 && (mouse_y - arrow_coord[1]).abs <= 25
  end

  def play_clicked?(click)
    if @state == :begin
      (click[0] - SCREEN_CENT_WIDTH.abs <= 114) && (click[1] - SCREEN_TOP.abs <= 80)
    else
      false
    end
  end

  def pause_clicked?(click)
    if @state == :running
      (click[0] - SCREEN_CENT_WIDTH.abs <= 114) && (click[1] - SCREEN_TOP.abs <= 80)
    else
      false
    end
  end

  def move_in_direction(tile, arrow_coord, tile_position)
    if tile.center_top == arrow_coord
      surrounding_tile_empty?(:up, tile_position) ? swap_tiles(:up, tile_position) : false #here to disablle arrows return
    elsif tile.center_right == arrow_coord
      surrounding_tile_empty?(:right, tile_position) ? swap_tiles(:right, tile_position) : false
    elsif tile.center_bottom == arrow_coord
      surrounding_tile_empty?(:down, tile_position) ? swap_tiles(:down, tile_position) : false
    elsif tile.center_left == arrow_coord
      surrounding_tile_empty?(:left, tile_position) ? swap_tiles(:left, tile_position) : false
    else
      "Some kinda error. Your tile was #{tile.to_s} and your arrow_coord were #{arrow_coord}."
    end
  end

  def surrounding_tile_empty?(direction, tile_position)
    if direction == :up
      @game_board.board[tile_position[0]-1][tile_position[1]].content == "empty" ? true : false
    elsif direction == :right
      @game_board.board[tile_position[0]][tile_position[1]+1].content == "empty" ? true : false
    elsif direction == :down
      @game_board.board[tile_position[0]+1][tile_position[1]].content == "empty" ? true : false
    elsif direction == :left
      @game_board.board[tile_position[0]][tile_position[1]-1].content == "empty" ? true : false
    end
  end

  def swap_tiles(direction, tile_position)
    tile_content = @game_board.board[tile_position[0]][tile_position[1]].content
    if direction == :up
      @game_board.board[tile_position[0]][tile_position[1]].content = "empty"
      @game_board.board[tile_position[0]-1][tile_position[1]].content = tile_content
    elsif direction == :right
      @game_board.board[tile_position[0]][tile_position[1]].content = "empty"
      @game_board.board[tile_position[0]][tile_position[1]+1].content = tile_content
    elsif direction == :down
      @game_board.board[tile_position[0]][tile_position[1]].content = "empty"
      @game_board.board[tile_position[0]+1][tile_position[1]].content = tile_content
    elsif direction == :left
      @game_board.board[tile_position[0]][tile_position[1]].content = "empty"
      @game_board.board[tile_position[0]][tile_position[1]-1].content = tile_content
    end
  end
end
