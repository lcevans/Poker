require 'rspec'
require 'hanoi.rb'
require 'io/console'

describe "Hanoi" do

  subject(:game) { Hanoi.new }

  context "when initialized" do
    it "the first peg should be full" do
      game.peg1.should == [3,2,1]
    end

    it "the other two pegs should be empty" do
      (game.peg2.count + game.peg3.count).should == 0
    end
  end

  describe "#move" do

    it "should allow moving a smaller item onto an empty peg" do
      expect do
        game.move(1,2)
      end.to_not raise_error
    end

    it "should not move anything from an empty peg" do
      expect do
        game.move(2, 3)
      end.to raise_error ArgumentError
    end


    context "after moving two things from the first peg" do
      before(:each) do
        game.move(1,3)
        game.move(1,2)
      end

      it "should update the pegs" do
        game.peg1.should == [3]
        game.peg2.should == [2]
        game.peg3.should == [1]
      end

      context "and another move from peg 3 to peg 2" do

        before(:each) do
          game.move(3,2)
        end

        it "should update the recieving peg" do
          game.peg2.should == [2,1]
          game.peg3.should == []
        end

        it "should not allow moving a larger item onto a smaller item" do
          expect do
            game.move(1,2)
          end.to raise_error ArgumentError
        end

      end
    end
  end

  describe "#won?" do

    before(:each) do
      game.move(1,3)
      game.move(1,2)
      game.move(3,2)
      game.move(1,3)
      game.move(2,1)
      game.move(2,3)
      game.move(1,3)
    end

    it "should return true when all blocks are on final peg" do
      game.won?.should == true
    end
  end

  describe "#render" do

    it "should call puts with a string"

  end

end