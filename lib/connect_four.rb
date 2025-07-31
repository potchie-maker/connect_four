require_relative 'player'

class ConnectFour
  attr_reader :grid
  
  def initialize(rows = 6, columns = 7, win_condition = 4)
    @rows = rows
    @columns = columns
    @grid = Array.new(@rows) { Array.new(@columns) }
    @win_condition = win_condition
  end

  def play(player_one, player_two)
    puts "Welcome to Connect Four!\n\n"

    loop do
      print_grid

      # PLAYER 1 TURN
      
      puts "\n\nPlayer 1, choose from columns 1 though #{@columns}."
      player_one_col_choice = get_column(player_one)
      player_one_dropped_row = drop(player_one_col_choice, player_one.color)
      print_grid

      if won?(player_one.color, player_one_dropped_row, player_one_col_choice)
        puts "\n\n#{player_one.name} Won!!!!!\n\n"
        break
      end

      # PLAYER 2 TURN
      
      puts "\n\nPlayer 2, choose from columns 1 though #{@columns}."
      player_two_col_choice = get_column(player_two)
      player_two_dropped_row = drop(player_two_col_choice, player_two.color)

      if won?(player_two.color, player_two_dropped_row, player_two_col_choice)
        print_grid
        puts "\n\n#{player_two.name} Won!!!!!\n\n"
        break
      end

      if tie?
        print_grid
        puts "\n\nThe game ended in a tie!"
        break
      end
    end
  end

  def print_grid
    puts "\n\n"
    puts "1    2    3    4    5    6    7\n\n"
    transformed_grid = transform_grid
    transformed_grid.each { |row| puts row.join(' | ') }
  end

  def transform_grid
    transformed_grid = grid.map do |row|
      row.map do |piece|
        if piece == 'red'
          '🔴'
        elsif piece == 'black'
          '⚫'
        else
          '⚪'
        end
      end
    end

    transformed_grid
  end

  def get_column(player)
    loop do
      puts "\n\n"

      choice = gets.chomp
      valid_input = verify_input(1, @columns, choice.to_i) if choice.match?(/^\d+$/)
      chosen_col = valid_input.to_i - 1
      return chosen_col if valid_input && grid[0][chosen_col].nil?

      puts "\n\nColumn does not exist, #{player.name} please enter number in range of 1 and #{@columns}.\n\n"
      print_grid
    end
  end

  def verify_input(first_col, last_col, input)
    return input if input.between?(first_col, last_col)
  end

  def drop(column, piece)
    empty_row = find_empty(column)
    return nil unless empty_row
    grid[empty_row][column] = piece
    empty_row
  end

  def find_empty(column)
    (@rows - 1).downto(0) do |row|
      return row if grid[row][column].nil?
    end
    nil
  end

  def won?(color, row, column)
    horizontal_check(color, row, column) >= @win_condition ||
    vertical_check(color, row, column) >= @win_condition ||
    diagonal_check(color, row, column) >= @win_condition
  end

  def tie?
    grid.flatten.any?(nil) ? false : true
  end

  def horizontal_check(color, row, column)
    return 0 unless grid[row][column] == color

    original_piece_count = 1

    # COLUMN LEFT CHECK

    left_count = 0
    curr_col_left = column - 1

    while curr_col_left >= 0 && grid[row][curr_col_left] == color
      left_count += 1
      curr_col_left -= 1
    end

    # COLUMN RIGHT CHECK

    right_count = 0
    curr_col_right = column + 1

    while curr_col_right < grid[0].size && grid[row][curr_col_right] == color
      right_count += 1
      curr_col_right += 1
    end

    original_piece_count + left_count + right_count
  end

  def vertical_check(color, row, column)
    return 0 unless grid[row][column] == color

    original_piece_count = 1

    # ROW UP CHECK
    
    up_count = 0
    curr_row_up = row - 1

    while curr_row_up >= 0 && grid[curr_row_up][column] == color
      up_count += 1
      curr_row_up -= 1
    end

    # ROW DOWN CHECK
    
    down_count = 0
    curr_row_down = row + 1

    while curr_row_down < grid.size && grid[curr_row_down][column] == color
      down_count += 1
      curr_row_down += 1
    end

    original_piece_count + up_count + down_count
  end

  def diagonal_check(color, row, column)
    return 0 unless grid[row][column] == color

    original_piece_count = 1

    # UP AND RIGHT CHECK
    
    up_right_count = 0
    curr_row_up_right = row - 1
    curr_col_up_right = column + 1

    while curr_row_up_right >= 0 && curr_col_up_right < grid[0].size && grid[curr_row_up_right][curr_col_up_right] == color
      up_right_count += 1
      curr_row_up_right -= 1
      curr_col_up_right += 1
    end

    # DOWN AND LEFT CHECK
    
    down_left_count = 0
    curr_row_down_left = row + 1
    curr_col_down_left = column - 1

    while curr_row_down_left < grid.size && curr_col_down_left >= 0 && grid[curr_row_down_left][curr_col_down_left] == color
      down_left_count += 1
      curr_row_down_left += 1
      curr_col_down_left -= 1
    end

    # UP AND LEFT CHECK
    
    up_left_count = 0
    curr_row_up_left = row - 1
    curr_col_up_left = column - 1

    while curr_row_up_left >= 0 && curr_col_up_left >= 0 && grid[curr_row_up_left][curr_col_up_left] == color
      up_left_count += 1
      curr_row_up_left -= 1
      curr_col_up_left -= 1
    end

    # DOWN AND RIGHT CHECK
    
    down_right_count = 0
    curr_row_down_right = row + 1
    curr_col_down_right = column + 1

    while curr_row_down_right < grid.size && curr_col_down_right < grid[0].size && grid[curr_row_down_right][curr_col_down_right] == color
      down_right_count += 1
      curr_row_down_right += 1
      curr_col_down_right += 1
    end

    [original_piece_count + up_right_count + down_left_count, original_piece_count + up_left_count + down_right_count].max
  end
end