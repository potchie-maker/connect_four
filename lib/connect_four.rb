class ConnectFour
  attr_reader :grid
  
  def initialize(rows = 6, columns = 7, win_condition = 4)
    @grid = Array.new(rows) { Array.new(columns) }
    @win_condition = win_condition
  end

  def play(player_one, player_two)
    puts 'Welcome to Connect Four'
  end

  def print_grid
    transformed_grid = transform_grid
    transformed_grid.each { |row| puts row.join(' | ') }
  end

  def transform_grid
    transformed_grid = grid.map do |row|
      row.map do |piece|
        if piece == 'red'
          '🔴'
        elsif piece == 'black'
          '⬤'
        else
          ' '
        end
      end
    end

    transformed_grid
  end

  def get_column
    choice = gets.chomp
    column = choice.to_i - 1
    column
  end

  def drop(column, piece)
    empty_row = find_empty(column)
    empty_row[column] = piece
  end

  def find_empty(column)
    grid.reverse.each do |row|
      return row if row[column] == nil
    end
    nil
  end

  def won?(color, row, column)
    horizontal_check(color, row, column) >= @win_condition ||
    vertical_check(color, row, column) >= @win_condition ||
    diagonal_check(color, row, column) >= @win_condition
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