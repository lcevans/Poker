require 'rspec'
require 'poker.rb'

describe Card do
  subject(:card) { Card.new(:hearts, "J") }

  it { should respond_to(:suit) }
  it { should respond_to(:rank) }
  it { should respond_to(:number)}

  it "should return the correct rank" do
     card.rank.should == 11
  end
end

describe Deck do
  subject(:deck) { Deck.new}

  it { should respond_to(:shuffle)}
  it { should respond_to(:draw)}

  it "Should have 52 cards" do
    deck.cards.length.should == 52
  end

  it "Should have 13 of each suit" do
    [:hearts,:diamonds,:clubs,:spades].each do |suit|
      deck.cards.select do |card|
        card.suit == suit
      end.count.should == 13
    end
  end

  it "Should have 4 of each number" do
    "23456789JQKA".chars.each do |number|
      deck.cards.select do |card|
        card.number == number
      end.count.should == 4
    end
  end

  describe "#shuffle" do
    it "Should rearrange the deck somehow" do
      cards_before = deck.cards.dup
      deck.shuffle
      cards_after = deck.cards
      cards_after.should_not == cards_before
    end
  end

  describe "#draw" do
    it "Should return a card" do
      deck.draw.should be_a(Card)
    end

    it "Should remove a card from the deck" do
      deck.draw
      deck.cards.count.should == 51
    end
  end
end


describe Hand do
  subject(:hand) { Hand.new }

  it { should respond_to(:add_card) }
  it { should respond_to(:replace_card)}
  it { should respond_to(:hand_type)}
  it { should respond_to(:sort) }

  describe "#add_card" do

    it "should increase the number of cards in hand" do
      card_count_before = hand.cards.count
      hand.add_card(Card.new(:hearts, '5'))
      hand.cards.count.should eq(card_count_before+1)
    end

  end

  describe "#replace_card" do
    it "should not change the size of the hand"
    it "should change the hand"
  end

  describe "#hand_type" do

    it "should identify a four of a kind" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:hearts, 'Q'))

      hand.hand_type.should == [:four_of_a_kind,[5,5,5,5,12]]
    end

    it "should identify a full house" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:diamonds, '8'))
      hand.add_card(Card.new(:hearts, '8'))
      hand.hand_type.should == [:full_house,[5,5,5,8,8]]
    end

    it "should identify a straight" do
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '2'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:clubs, '3'))
      hand.add_card(Card.new(:hearts, '4'))

      hand.hand_type.should == [:straight,[5,4,3,2,1]]
    end

    it "should identify a flush" do
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:spades, 'J'))
      hand.add_card(Card.new(:spades, '8'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:spades, '2'))

      hand.hand_type.should == [:flush,[11,8,7,5,2]]
    end

    it "should identify a straight-flush" do
      hand.add_card(Card.new(:hearts, 'J'))
      hand.add_card(Card.new(:hearts, 'K'))
      hand.add_card(Card.new(:hearts, '10'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:hearts, 'Q'))

      hand.hand_type.should == [:straight_flush,[14, 13, 12, 11, 10]]
    end

    it "should identify a two-pair" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == [:two_pair,[7,7,5,5,14]]
    end

    it "should identify a three-of-a-kind" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:spades, '8'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == [:three_of_a_kind,[5,5,5,8,7]]
    end

    it "should identify a pair" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, 'J'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == [:pair,[7,7,14,11,5]]
    end
  end

  describe "#<=>" do

    let(:straight_hand) { double("straight hand", :hand_type => [:straight,1], :tie_breaker_arr => [9,8,7,6,5]) }
    let(:flush_hand) { double("flush hand", :hand_type => [:flush,1], :tie_breaker_arr => [13,11,5,4,2]) }
    let(:pair) { double("pair hand", :hand_type => [:pair,1], :tie_breaker_arr => [7,7,5,4,3]) }
    let(:two_pair_hand) {double("two pair hand", :hand_type => [:two_pair,1], :tie_breaker_arr => [11,11,10,10,6])}
    let(:another_two_pair_hand) {double("another two pair hand", :hand_type => [:two_pair,1], :tie_breaker_arr => [13,13,7,7,6])}
    let(:another_flush_hand) {double("another flush", :hand_type => [:flush,1], :tie_breaker_arr => [13,10,8,7,6])}

    before(:each) do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, 'K'))
      hand.add_card(Card.new(:hearts, 'K'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:hearts, '7'))
    end

    it "compares a flush and a pair" do
      (hand <=> flush_hand).should == -1
    end

    it "compares a straight and a pair" do
      (hand <=> straight_hand).should == -1
    end

    it "distinguishes between two two-pair hands" do
      (hand <=> two_pair_hand).should == 1
    end

    it "distinguishes between two two-pair hands" do
      (hand <=> another_two_pair_hand).should == -1
    end

    it "ties with itself" do
      (hand <=> hand).should == 0
    end
  end

  # describe "#sort" do
  #   it "..." do
  #     hand.add_card(Card.new(:hearts, '5'))
  #     hand.add_card(Card.new(:diamonds, 'J'))
  #     hand.add_card(Card.new(:hearts, 'A'))
  #     hand.add_card(Card.new(:spades, '7'))
  #     hand.add_card(Card.new(:hearts, '7'))
  #
  #   end
  # end


end