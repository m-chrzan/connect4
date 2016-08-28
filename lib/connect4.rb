class Game
    attr_reader :status, :current_player

    def initialize
        @status = :continue
        @current_player = :player1
        @board = Board.new
    end

    def drop column
        @board.drop(column, @current_player)
        update_status column
        @current_player = @current_player == :player1 ? :player2 : :player1
    end

    def update_status column
        candidates = @board.get_row_col_diags column
        if candidates.any? { |cand| cand =~ /([12])\1\1\1/ }
            @status = (@current_player.to_s + "won").to_sym
        elsif @board.filled?
            @status = :draw
        end
    end

    def to_s
        @board.to_s
    end
end

class Board
    attr_reader :columns

    def initialize
        @columns = Array.new(7) { |i| [] }
        @pieces = 0
    end

    def drop column, player
        raise ColumnOutOfBoard if !(1..7).include? column
        raise ColumnFilled if @columns[column - 1].size >= 6

        @columns[column - 1].push(player)
        @pieces += 1
    end

    def get_row_col_diags column
        row = @columns[column - 1].size
        row_col_diags = []
        row_col_diags.push construct_row row
        row_col_diags.push construct_column column
        row_col_diags.push construct_nw_diag column, row
        row_col_diags.push construct_ne_diag column, row
        row_col_diags
    end

    def construct_column column
        array_to_sequence @columns[column - 1]
    end

    def construct_row row
        row_pieces = @columns.map { |column| column[row - 1] }
        array_to_sequence row_pieces

    end

    def construct_nw_diag column, row
        diag_pieces = grab_line column, row, -1
        array_to_sequence diag_pieces
    end

    def construct_ne_diag column, row
        diag_pieces = grab_line column, row, 1
        array_to_sequence diag_pieces
    end

    def grab_line column, row, slope
        @columns.map.with_index do |col, col_index|
            row_index = slope * (col_index - column + 1) + row - 1
            if (0..5).include? row_index
                col[row_index]
            else
                nil
            end
        end
    end

    def array_to_sequence array
        string = ""
        array.each do |piece|
            string << (piece_to_number piece)
        end

        string
    end

    def piece_to_number piece
        case(piece)
        when :player1
            "1"
        when :player2
            "2"
        else
            "0"
        end
    end

    def filled?
        @pieces >= 42
    end

    def piece_to_char piece
        case(piece)
        when :player1
            '○'
        when :player2
            '●'
        else
            ' '
        end
    end

    def to_s
        string = " 1 2 3 4 5 6 7 \n"
        (0..5).to_a.reverse.each do |row|
            string << "|"
            @columns.each do |col|
                string << piece_to_char(col[row]) + "|"
            end
            string << "\n"
        end

        string
    end
end

class ColumnOutOfBoard < StandardError
end

class ColumnFilled < StandardError
end
