class Board
    attr_reader :columns

    def initialize
        @columns = Array.new(7) { |i| [] }
        @pieces = 0
    end

    def drop column, player
        if !(1..7).include? column
            raise ColumnOutOfBoard
        end
        @columns[column - 1].push(player)
        @pieces += 1
    end

    def filled?
        @pieces >= 42
    end
end

class ColumnOutOfBoard < StandardError
end
