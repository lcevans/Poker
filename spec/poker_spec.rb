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
  it { should respond_to(:hand_type)}

  describe "#add_card" do

    it "should increase the number of cards in hand" do
      card_count_before = hand.cards.count
      hand.add_card(Card.new(:hearts, '5'))
      hand.cards.count.should eq(card_count_before+1)
    end

  end

  describe "#discard_cards" do
    it "Should discard the correct cards" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:spades, 'J'))
      hand.add_card(Card.new(:clubs, '4'))
      hand.add_card(Card.new(:diamonds, '8'))
      hand.add_card(Card.new(:hearts, 'Q'))
      
      hand.discard_cards([0, 1, 3])
      hand.ranks.should == [4, 12]
    end
  end

  describe "#hand_type" do

    it "should identify a four of a kind" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:hearts, 'Q'))

      hand.hand_type.should == :four_of_a_kind
    end

    it "should identify a full house" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:diamonds, '8'))
      hand.add_card(Card.new(:hearts, '8'))
      hand.hand_type.should == :full_house
    end

    it "should identify a straight" do
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '2'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:clubs, '3'))
      hand.add_card(Card.new(:hearts, '4'))

      hand.hand_type.should == :straight
    end

    it "should identify a flush" do
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:spades, 'J'))
      hand.add_card(Card.new(:spades, '8'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:spades, '2'))

      hand.hand_type.should == :flush
    end

    it "should identify a straight-flush" do
      hand.add_card(Card.new(:hearts, 'J'))
      hand.add_card(Card.new(:hearts, 'K'))
      hand.add_card(Card.new(:hearts, '10'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:hearts, 'Q'))

      hand.hand_type.should == :straight_flush
    end

    it "should identify a two-pair" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == :two_pair
    end

    it "should identify a three-of-a-kind" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, '5'))
      hand.add_card(Card.new(:clubs, '5'))
      hand.add_card(Card.new(:spades, '8'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == :three_of_a_kind
    end

    it "should identify a pair" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, 'J'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '7'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.hand_type.should == :pair
    end
  end

  describe "#<=>" do

    let(:straight_hand) { double("straight hand", :hand_type => :straight, :ranks => [9,8,7,6,5]) }
    let(:flush_hand) { double("flush hand", :hand_type => :flush, :ranks => [13,11,5,4,2]) }
    let(:pair) { double("pair hand", :hand_type => :pair, :ranks => [7,7,5,4,3]) }
    let(:two_pair_hand) {double("two pair hand", :hand_type => :two_pair, :ranks => [11,11,10,10,6])}
    let(:another_two_pair_hand) {double("another two pair hand", :hand_type => :two_pair, :ranks => [13,13,7,7,6])}
    let(:another_flush_hand) {double("another flush", :hand_type => :flush, :ranks => [13,10,8,7,6])}

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

  describe "#rearrange_hand" do
    it "should sort higher frequencies first, then higher values" do
      hand.add_card(Card.new(:hearts, '5'))
      hand.add_card(Card.new(:diamonds, '7'))
      hand.add_card(Card.new(:hearts, 'A'))
      hand.add_card(Card.new(:spades, '5'))
      hand.add_card(Card.new(:hearts, '7'))

      hand.rearrange_hand!
      hand.cards.map {|card| card.rank}.should == [7,7,5,5,14]
    end
  end
end

describe Player do

  subject (:player) { Player.new(100) }

  it { should respond_to(:hand) }
  it { should respond_to(:pot) }
  it { should respond_to(:hand) }
  it { should respond_to(:hand) }
  it { should respond_to(:hand) }


  describe "::buy_in" do
    it "should create a player" do
      
    end
  end 
  describe "#" 
  describe "#" 
  describe "#" 

end

describe Game do
  describe "#" 
  describe "#" 
  describe "#" 
  describe "#" 
  describe "#" 

end
