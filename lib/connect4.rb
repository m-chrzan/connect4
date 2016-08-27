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

    def filled?
        @pieces >= 42
    end
end

class ColumnOutOfBoard < StandardError
end

class ColumnFilled < StandardError
end
