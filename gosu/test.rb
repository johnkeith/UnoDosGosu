ar = [[[0, 0], [1, 0], [2, 0]], [[0, 3], [0, 4], [0, 2]]]
ar.count
ar.each do |word|
  word.each do |coords|
    puts "#{coords}"
    coords.each do |tile|
      puts "#{tile[0]}, #{tile[1]}"
    end
  end
end

