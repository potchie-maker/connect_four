class ConnectFour
  attr_reader :grid
  
  def initialize(rows = 6, columns = 7)
    @grid = Array.new(rows) { Array.new(columns) }
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

  def find_win(color, row, column)
    
  end

  def horizontal_check(color, row, column)
    original_piece_count = 1

    # LEFT CHECK

    left_count = 0
    curr_col_left = column - 1

    while curr_col_left >= 0 && grid[row][curr_col_left] == color
      left_count += 1
      curr_col_left -= 1
    end

    # RIGHT CHECK

    right_count = 0
    curr_col_right = column + 1

    while curr_col_right < grid[0].size && grid[row][curr_col_right] == color
      right_count += 1
      curr_col_right += 1
    end

    original_piece_count + left_count + right_count
  end

  def vertical_check(color, row, column)
    original_piece_count = 1

    # UP CHECK
    
    up_count = 0
    curr_row_up = row - 1

    while curr_row_up >= 0 && grid[curr_row_up][column] == color
      up_count += 1
      curr_row_up -= 1
    end

    # DOWN CHECK
    
    down_count = 0
    curr_row_down = row + 1

    while curr_row_down < grid.size && grid[curr_row_down][column] == color
      down_count += 1
      curr_row_down += 1
    end

    original_piece_count + up_count + down_count
  end
end