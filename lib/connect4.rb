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
end

class ColumnOutOfBoard < StandardError
end

class ColumnFilled < StandardError
end
