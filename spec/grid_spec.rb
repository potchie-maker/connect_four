require_relative '../lib/connect_four'

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
    end
  end

  describe '#horizontal_check' do
    subject(:game_check_h) { described_class.new }
  
    context 'when the group is horizontal' do
      before do
        mock_grid = [
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, 'red', 'red', 'red' ,'red', nil, nil]
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
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil],
          ['red', 'red', 'red', 'black' ,'red', 'red', 'black'],
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil]
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
          [nil, nil, nil, nil ,nil, nil, nil],
          [nil, nil, nil, nil ,'black', nil, nil],
          [nil, nil, nil, nil ,'black', nil, nil],
          [nil, nil, nil, nil ,'black', nil, nil],
          [nil, nil, nil, nil ,'black', nil, nil],
          [nil, nil, nil, nil ,nil, nil, nil]
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
          [nil, nil, 'black', nil , nil, nil, nil],
          [nil, nil, 'black', nil , nil, nil, nil],
          [nil, nil, nil, nil , nil, nil, nil],
          [nil, nil, 'black', nil , nil, nil, nil],
          [nil, nil, 'black', nil , nil, nil, nil],
          [nil, nil, 'red', nil , nil, nil, nil]
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
end