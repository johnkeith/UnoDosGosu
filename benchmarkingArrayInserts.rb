require 'benchmark'
each_index.select
test_board = [[" ","4","4","2"],
              ["4","2","2"," "],
              ["2","2"," ","2"],
              ["4"," ","4","8"]]

def insertRandomly(board)
  two_or_four = rand.round == 0 ? 4 : 2
  insert_successful = false
  while !insert_successful
    random_position_one = rand(board.length)
    random_position_two = rand(board.length)
    if board[random_position_one][random_position_two] == " "
      board[random_position_one][random_position_two] = two_or_four.to_s
      insert_successful = true
    end
  end
  #board
  board[random_position_one][random_position_two] = " "
end

def insertLessRandomly(board)
  two_or_four = rand.round == 0 ? 4 : 2
  random_direction = rand.round == 0 ? true : false
  insert_successful = false
  while !insert_successful
    random_position_one = rand(board.length)
    empty_space = nil
    empty_space = board[random_position_one].find_index do |item|
      item == " "
    end
    if empty_space != nil
      board[random_position_one][empty_space] = two_or_four.to_s
      insert_successful = true
    end
  end
  #board
  board[random_position_one][empty_space] = " "
end

def insertByIndex(board)
  two_or_four = rand.round == 0 ? 4 : 2
  empty_spaces = []
  board.each_with_index do |row, row_index|
    row.each_with_index do |column, col_index|
      empty_spaces << [row_index, col_index] if column == " "
    end
  end
  select_empty = empty_spaces.sample
  board[select_empty[0]][select_empty[1]] = two_or_four
  board[select_empty[0]][select_empty[1]] = " "
end

time = Benchmark.realtime do 
  1000000.times do
    insertRandomly(test_board)
  end
end
puts "The time it took to insert at randomly choosen spots was:#{time*1000}"

# ###

time02 = Benchmark.realtime do 
  1000000.times do
    insertLessRandomly(test_board)
  end
end
puts "The time it took to insert using a random line was:#{time02*1000}"

time03 = Benchmark.realtime do 
  1000000.times do
    insertByIndex(test_board)
  end
end
puts "The time it took to insert using no randomness at all was:#{time03*1000}"
