require "connect4"

def board_empty? board
    board.columns.all? &:empty?
end


describe Board do
    let(:board) { Board.new }

    it "starts out empty" do
        expect(board_empty?(board)).to be true
    end

    describe "#drop" do
        context "given a valid column" do
            (1..7).each do |i|
                it "places a piece in column #{i} (player 1)" do
                    board.drop(i, :player1)
                    expect(board.columns[i-1].first).to eq :player1
                end

                it "places a piece in columns #{i} (places 2)" do
                    board.drop(i, :player2)
                    expect(board.columns[i-1].first).to eq :player2
                end
            end
        end

        context "given an inalid column" do
            [*(-1..0), *(8..10)].each do |i|
                it "does not place a piece in column #{i}" do
                    expect { board.drop(i, :player1) }.to raise_error ColumnOutOfBoard
                end
            end
        end

        context "after dropping in column 4" do
            let(:board) do
                b = Board.new
                b.drop(4, :player1)
                b
            end

            it "is not empty" do
                expect(board_empty?(board)).to be false
            end

            it "is not filled" do
                expect(board.filled?).to be false
            end

            [*(1..3), *(5..7)].each do |i|
                it "does not have a piece in column #{i}" do
                    expect(board.columns[i-1]).to be_empty
                end
            end
        end

        context "after dropping twice in column 7" do
            let(:board) do
                b = Board.new
                b.drop(7, :player2)
                b.drop(7, :player2)
                b
            end

            it "is not filled" do
                expect(board).to_not be_filled
            end

            it "has two pieces in column 7" do
                expect(board.columns[6].size).to eq 2
            end
        end
    end

    describe "#filled?" do
        it "is false for a new board" do
            expect(board).to_not be_filled
        end

        it "is false for a board with several pieces" do
            (1..5).each do |i|
                board.drop(i, :player1)
            end
            (2..5).each do |i|
                board.drop(i, :player2)
            end
            (3..4).each do |i|
                board.drop(i, :player1)
            end

            expect(board).to_not be_filled
        end

        it "is true for a filled board" do
            (1..7).each do |column|
                6.times do
                    board.drop(column, :player1)
                end
            end

            expect(board).to be_filled
        end
    end

end
