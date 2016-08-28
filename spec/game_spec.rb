require 'connect4'

describe Game do
    let(:game) { Game.new }

    context "when initialized" do
        it "has not ended" do
            expect(game.status).to eq :continue
        end

        it "is player 1's turn" do
            expect(game.current_player).to eq :player1
        end
    end

    context "after one turn" do
        let(:game) do
            g = Game.new
            g.drop(2)
            g
        end

        it "is player 2's turn" do
            expect(game.current_player).to eq :player2
        end

        it "is not over yet" do
            expect(game.status).to eq :continue
        end
    end

    context "after several turns" do
        let(:game) do
            g = Game.new                            #   1   #
            [4, 3, 5, 6].each { |col| g.drop(col) } #   21  #
            [3, 5, 5, 4].each { |col| g.drop(col) } #   11  #
            [5, 4, 4, 4].each { |col| g.drop(col) } #  221  #
            [4, 3, 5, 2].each { |col| g.drop(col) } #  122  #
            g                                       # 22112 #
        end

        it "is player 1's turn" do
            expect(game.current_player).to eq :player1
        end

        it "is not over yet" do
            expect(game.status).to eq :continue
        end

        it "a piece cannot be played in column 4" do
            expect { game.drop(4) }.to raise_error ColumnFilled
        end

        it "a piece can be played in column 1" do
            game.drop(1)
        end

        it "player 2 wins after two moves" do
            game.drop(1)
            game.drop(3)
            expect(game.status).to eq :player2won
        end

        it "player 1 wins after one move" do
            game.drop(5)
            expect(game.status).to eq :player1won
        end

        it "draw after 26 moves" do
            [1, 1, 1, 1, 1, 1].each { |col| game.drop(col) }
            [3, 2, 2, 2, 3, 2, 3, 2].each { |col| game.drop(col) }
            [7, 6, 7, 7, 6, 6, 7].each { |col| game.drop(col) }
            [7, 6, 7, 6, 5].each { |col| game.drop(col) }

            expect(game.status).to eq :draw
        end
    end
end
