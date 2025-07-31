require_relative '../lib/connect_four'
# mock_grid = [
#           [nil, nil, nil, nil, nil, nil, nil],
#           [nil, nil, nil, nil, nil, nil, nil],
#           [nil, nil, nil, nil, nil, nil, nil],
#           [nil, nil, nil, nil, nil, nil, nil],
#           [nil, nil, nil, nil, nil, nil, nil],
#           [nil, nil, nil, nil, nil, nil, nil]
#         ]

describe ConnectFour do
  describe '#drop' do
    context 'when piece gets dropped in empty grid' do
      subject(:game_drop) { described_class.new }

      it 'drops to lowest available cell' do
        piece = 'red'
        chosen_column = 0
        game_drop.drop(chosen_column, piece)
        expect(game_drop.grid[-1][0]).to eq('red')
      end

      it 'drops to next available cell' do
        piece_one = 'red'
        piece_two = 'black'
        chosen_column = 0
        game_drop.drop(chosen_column, piece_one)
        game_drop.drop(chosen_column,piece_two)
        expect(game_drop.grid[-2][0]).to eq('black')
      end

      it 'drops in middle range column' do
        piece = 'red'
        chosen_column = 4
        game_drop.drop(chosen_column, piece)
        expect(game_drop.grid[-1][4]).to eq('red')
      end
    end
  end

  describe '#horizontal_check' do
    subject(:game_check_h) { described_class.new }
  
    context 'when the group is horizontal' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, 'red', 'red', 'red' , 'red', nil, nil]
        ]
        allow(game_check_h).to receive(:grid).and_return(mock_grid)
      end
      
      it 'returns correct amount when starting from far left' do
        expect(game_check_h.horizontal_check('red', 5, 1)).to eq(4)
      end

      it 'returns correct amount when starting from far right' do
        expect(game_check_h.horizontal_check('red', 5, 4)).to eq(4)
      end

      it 'returns correct amount when starting from middle of group' do
        expect(game_check_h.horizontal_check('red', 5, 2)).to eq(4)
      end
    end

    context 'when there is a gap in the group' do
      before do
        mock_grid = [
          [nil, nil, nil, nil , nil, nil, nil],
          [nil, nil, nil, nil , nil, nil, nil],
          [nil, nil, nil, nil , nil, nil, nil],
          ['red', 'red', 'red', 'black', 'red', 'red', 'black'],
          [nil, nil, nil, nil , nil, nil, nil],
          [nil, nil, nil, nil , nil, nil, nil]
        ]
        allow(game_check_h).to receive(:grid).and_return(mock_grid)
      end

      it 'returns amount on left side of break' do
        expect(game_check_h.horizontal_check('red', 3, 2)).to eq(3)
      end

      it 'returns amount on right side of break' do
        expect(game_check_h.horizontal_check('red', 3, 4)).to eq(2)
      end
    end
  end

  describe '#vertical_check' do
    subject(:game_check_v) { described_class.new }

    context 'when the group is vertical' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_check_v).to receive(:grid).and_return(mock_grid)
      end

      it 'returns correct amount when starting from top' do
        expect(game_check_v.vertical_check('black', 1, 4)).to eq(4)
      end

      it 'returns correct amount when starting from bottom' do
        expect(game_check_v.vertical_check('black', 4, 4)).to eq(4)
      end

      it 'returns correct amount when starting from middle of group' do
        expect(game_check_v.vertical_check('black', 3, 4)).to eq(4)
      end
    end

    context 'when there is a gap in the group' do
      before do
        mock_grid = [
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil]
        ]
        allow(game_check_v).to receive(:grid).and_return(mock_grid)
      end

      it 'returns amount on top side of break' do
        expect(game_check_v.vertical_check('black', 1, 2)).to eq(2)
      end

      it 'returns amount on bottom side of break' do
        expect(game_check_v.vertical_check('black', 3, 2)).to eq(2)
      end
    end
  end

  describe '#diagonal_check' do
    subject(:game_check_d) { described_class.new }

    context 'when the group is diagonal up-right and down-left' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_check_d).to receive(:grid).and_return(mock_grid)
      end

      it 'returns correct amount starting from lowest' do
        expect(game_check_d.diagonal_check('red', 4, 1)).to eq(4)
      end

      it 'returns correct amount starting from highest' do
        expect(game_check_d.diagonal_check('red', 1, 4)).to eq(4)
      end

      it 'returns correct amount when starting from middle of group' do
        expect(game_check_d.diagonal_check('red', 2, 3)).to eq(4)
      end
    end

    context 'when there is a gap and the group is diagonal up-right and down-left' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'black', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          ['red', nil, nil, nil, nil, nil, nil]
        ]
        allow(game_check_d).to receive(:grid).and_return(mock_grid)
      end

      it 'returns amount on lower side of break' do
        expect(game_check_d.diagonal_check('red', 4, 1)).to eq(3)
      end

      it 'returns amount on higher side of break' do
        expect(game_check_d.diagonal_check('red', 1, 4)).to eq(1)
      end
    end

    context 'when the group is diagonal up-left and down-right' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, nil, 'black', nil, nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, nil, 'black', nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_check_d).to receive(:grid).and_return(mock_grid)
      end

      it 'returns correct amount starting from lowest' do
        expect(game_check_d.diagonal_check('black', 4, 5)).to eq(4)
      end

      it 'returns correct amount starting from highest' do
        expect(game_check_d.diagonal_check('black', 1, 2)).to eq(4)
      end

      it 'returns correct amount when starting from middle of group' do
        expect(game_check_d.diagonal_check('black', 3, 4)).to eq(4)
      end
    end

    context 'when there is a gap and the group is diagonal up-left and down-right' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, nil, nil, 'black', nil, nil],
          [nil, nil, nil, nil, nil, 'black', nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_check_d).to receive(:grid).and_return(mock_grid)
      end

      it 'returns amount on lower side of break' do
        expect(game_check_d.diagonal_check('black', 4, 5)).to eq(2)
      end

      it 'returns amount on higher side of break' do
        expect(game_check_d.diagonal_check('black', 1, 2)).to eq(1)
      end
    end
  end

  describe '#won?' do
    subject(:game_won) { described_class.new }

    context 'when the game is won' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_won).to receive(:grid).and_return(mock_grid)
      end

      it 'returns true when winning condition is met' do
        expect(game_won.won?('red', 2, 3)).to be true
      end
    end

    context 'when the game is not won' do
      before do
        mock_grid = [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'black', nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil]
        ]
        allow(game_won).to receive(:grid).and_return(mock_grid)
      end

      it 'returns false when winning condition is not met' do
        expect(game_won.won?('red', 2, 3)).to be false
      end
    end
  end

  describe '#transform_grid' do
    subject(:game_transform) { described_class.new }

    context 'while game is ongoing' do
      before do
        mock_grid = [
            [nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil],
            ['red', nil, 'black', nil, 'black', nil, nil],
            ['red', 'red', 'red', 'black', 'red', nil, nil],
            ['black', 'red', 'black', 'black', 'black', 'red', nil]
          ]
        allow(game_transform).to receive(:grid).and_return(mock_grid)
      end

      it 'returns transformed grid' do
        transformed_grid = [
            ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
            ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
            ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪'],
            ['🔴', '⚪', '⚫', '⚪', '⚫', '⚪', '⚪'],
            ['🔴', '🔴', '🔴', '⚫', '🔴', '⚪', '⚪'],
            ['⚫', '🔴', '⚫', '⚫', '⚫', '🔴', '⚪']
          ]
        expect(game_transform.transform_grid).to eq(transformed_grid)
      end
    end
  end

  describe '#tie?' do
    subject(:game_tie) { described_class.new }

    context 'when grid is full' do
      before do
        mock_grid = mock_grid = [
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1],
            [1, 1, 1, 1, 1, 1, 1]
          ]
        allow(game_tie).to receive(:grid).and_return(mock_grid)
      end
      
      it 'returns true for full grid' do
        expect(game_tie.tie?).to be true
      end
    end

    context 'when grid is not full' do
      before do
        mock_grid = mock_grid = [
              [1, 1, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, nil, 1, 1],
              [1, 1, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1, 1],
              [1, 1, 1, 1, 1, 1, 1]
            ]
        allow(game_tie).to receive(:grid).and_return(mock_grid)
      end

      it 'returns false for grid that is not full' do
        expect(game_tie.tie?).to be(false)
      end
    end
  end
end