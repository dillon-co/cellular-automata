class Board
  def initialize(start_point, board_size, ruleset, x_coord=0, y_coord=0, binary_code_size=0)
    @board_size = board_size
    @dead = " "
    @alive = 'o'
    @start_point = start_point
    # @cell_rules = [@dead,@alive,@dead,@alive,@alive,@dead,@alive,@dead]
    # @cell_rules = [@alive,@dead,@dead,@alive,@alive,@dead,@alive,@dead]
    # @cell_rules = [@dead,@alive,@alive,@dead,@dead,@alive,@dead,@alive]
    @cell_types = [
                   ['1','1','1'],
                   ['1','1','0'],
                   ['1','0','1'],
                   ['1','0','0'],
                   ['0','1','1'],
                   ['0','1','0'],
                   ['0','0','1'],
                   ['0','0','0']
                  ]
   @ruleset = make_full_binary_array(ruleset) ### Rule number input as bniary

   @cell_rules = binary_to_alive_or_dead(@ruleset)
   @x_coord = x_coord - 1
   @y_coord = y_coord - 1
   @binary_code_size = binary_code_size
  end

  def binary_to_alive_or_dead(ruleset)
    is_alive_or_dead = ruleset.map do |rule|
      if rule == '1'
        @alive
      elsif rule == '0'
        @dead
      end
    end
    # puts "is alive or dead: #{is_alive_or_dead}"
    return is_alive_or_dead
  end


  def make_full_binary_array(ruleset)
    rules = ruleset.to_s(2).split('')
    while rules.length < 8
      rules.unshift('0')
    end
    rules
  end

  def get_binary_array(cells)
    cells.map do |cell|
      if cell == @alive
        '1'
      elsif cell == @dead
        '0'
      end
    end
  end


  def finished_board
    row_1 = Array.new(@board_size, @dead)

    # 12.times do
    # (1..@board_size-1).each do |i|
    #   puts i
    #   row_1[i] = @alive
    # end
    row_1[@start_point] = @alive
    # end

    generated_board = generate_board(row_1)
    # ys = Array.new(@board_size, xs)
    return generated_board
  end

  def print_board
    fin_board = finished_board
    fin_board.each_with_index do |row, y|
      row.each_with_index do |_, x|
        print fin_board[y][x]
      end
      puts ""
    end
  end

  def generate_board(first_row)
    previous_row = first_row
    # puts previous_row
    board = [first_row]
    (@board_size - 1).times do |row_num|
      # puts "generating row #{row_num}"
      current_row = Array.new(@board_size, @dead)
      current_row.each_with_index do |cell, ind|
        if ind < @board_size - 1 && ind > 0
          upper_3 = [previous_row[ind-1], previous_row[ind], previous_row[ind+1]]
        elsif ind == 0
          upper_3 = [@dead, previous_row[ind], previous_row[ind+1]]
        else
          upper_3 = [previous_row[ind-1], previous_row[ind], @dead]
        end
        current_row[ind] = calculate_dead_or_alive(get_binary_array(upper_3))
      end
      board << current_row
      previous_row = current_row
    end
    board
  end

  # def get_upper_3(previous_row, ind)
  #   if ind == 0
  #     up3 = previous_row[ind..1]
  #   elsif ind == @board_size-1
  #     up3 = previous_row[-2..ind]
  #   else
  #     puts "lol here bro"
  #   end
  #   get_binary_array(up3)
  # end

  def calculate_dead_or_alive(upper_3)
    # puts "step 1 #{upper_3}"
    alive_or_dead = @cell_rules[@cell_types.find_index(upper_3)]
    # puts 'step 2'
    alive_or_dead
  end

  def calculate_hidden_code
    y = @y_coord
    binary_code_as_alive_or_dead = []
    @binary_code_size.times do
      binary_code_as_alive_or_dead << finished_board[y][@x_coord]
      y+= 1
    end
    binary_array = get_binary_array(binary_code_as_alive_or_dead)
    binary_array.reverse.join('').to_i(2)
  end

end

# bl = 50
#
board_size = 100
start_point = board_size / 2
generation_rule = 110
# 256.times do |c|
#   generation_rule = c
#   #
#   # sp = 25
#   puts "#{c}: rule #{generation_rule}"
#   # puts b.calculate_hidden_code
# end
b = Board.new(start_point, board_size, generation_rule, x_coord=32, y_coord=920, binary_code_size=42)
b.print_board

test_board = [
  ["[]","  ","  ","  ","  ","  ","  ","  "],
  ["[]","  ","[]","[]","[]","[]","[]","[]"],
  ["[]","[]","  ","  ","  ","  ","  ","[]"],
  ["  ","[]","  ","[]","[]","[]","  ","[]"],
  ["  ","[]","[]","  ","  ","[]","[]","[]"],
  ["  ","  ","[]","  ","  ","  ","  ","[]"],
  ["[]","  ","[]","  ","[]","[]","  ","[]"],
  ["[]","[]","[]","[]","  ","[]","[]","[]"]
]

puts "\n\n\n\n"


# test_board.each_with_index do |_, y|
#   _.each_with_index do |__, x|
#     print test_board[y][x]
#   end
#   puts ""
# end

puts "testting all boards"


def measure_block(&block)
  t = Time.now.to_f
  yield
  Time.now.to_f - t
end

# duration = measure_block {
#   b.calculate_hidden_code
# }
# puts "Duration: #{duration}"
# (1..256).each do |rule|
#   b = Board.new(sp, bl, rule)
#   puts "Rule numbe: #{rule}"
#   if b.finished_board == test_board
#     b.print_board
#     puts "FOUND A MATCH"
#     puts "RULE # #{rule}"
#   end
# end

###RULE 101 works
