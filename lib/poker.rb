class Card
  attr_reader :suit, :number
  def initialize(suit, number)
    @suit = suit
    @number = number
  end

  def rank
    ['2','3','4','5','6','7','8','9','10','J','Q','K','A'].index(@number) + 2
  end
end


class Deck
  attr_reader :cards

  def initialize
    @cards = []
    create_cards
    shuffle
  end

  def create_cards
    numbers = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
    suits = [:hearts, :spades, :clubs, :diamonds]

    (0..51).each do |i|
      number_index, suit_index = i.divmod(4)
      @cards << Card.new(suits[suit_index], numbers[number_index])
    end
  end

  def shuffle
    @cards.shuffle!
  end

  def draw
    @cards.pop
  end
end


class Hand
  attr_reader :cards, :tie_breaker_arr

  HAND_ORDER = [:high_card, :pair, :two_pair, :three_of_a_kind, :straight, :flush, 
                :full_house, :four_of_a_kind, :straight_flush]

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def discard_cards(indicies)
    cards_to_delete = indicies.map {|index| @cards[index]}
    cards_to_delete.each {|card| @cards.delete(card)}
  end

  def <=>(other_hand)
    rearrange_hand!

    # First compare hand type
    our_hand_value = HAND_ORDER.index(hand_type)
    other_hand_value = HAND_ORDER.index(other_hand.hand_type)

    type_comparison = (our_hand_value <=> other_hand_value)
    return type_comparison unless type_comparison == 0

    # Break ties
    tie_comparison = (ranks <=> other_hand.ranks)
    tie_comparison
  end

  def ranks
    @cards.map(&:rank)
  end

  def suits
    @cards.map(&:suit)
  end

  def rearrange_hand!
    freq_of_rank = Hash.new(0)
    @cards.each { |card| freq_of_rank[card.rank] +=1 }
    @cards.sort_by! { |card| [freq_of_rank[card.rank], card.rank]}.reverse!

    # Handle the Ace-low straight where the Ace should be at the end of the array.
    if ranks == [14,5,4,3,2] then
      @cards.rotate!
    end
  end

  def hand_type
    rearrange_hand!

    return :straight_flush if straight_flush?
    return :four_of_a_kind if four_of_a_kind?
    return :full_house if full_house?
    return :flush if flush?
    return :straight if straight?
    return :three_of_a_kind if three_of_a_kind?
    return :two_pair if two_pair?
    return :pair if pair?
    return :high_card
  end

  def straight_flush?
    straight? && flush?
  end

  def flush?
    suits.count(suits[0]) == 5
  end

  def straight?
    return true if ranks == [5,4,3,2,14]

    all_unique = (ranks.uniq.length == 5) 
    span_length_four = ((ranks.first - ranks.last) == 4)
    all_unique && span_length_four
  end

  def full_house?
    triple = (ranks.count(ranks[0]) == 3)
    pair = (ranks.count(ranks[3]) == 2)
    triple && pair
  end

  def four_of_a_kind?
    ranks.count(ranks[0]) == 4
  end

  def three_of_a_kind?
    triple = (ranks.count(ranks[0]) == 3)
    no_pair = (ranks.count(ranks[3]) == 1)
    triple && no_pair
  end

  def two_pair?
    pair1 = (ranks.count(ranks[0]) == 2)
    pair2 = (ranks.count(ranks[2]) == 2)
    pair1 && pair2
  end

  def pair?
    pair1 = (ranks.count(ranks[0]) == 2)
    no_pair2 = (ranks.count(ranks[2]) == 1)
    pair1 && no_pair2
  end
end



