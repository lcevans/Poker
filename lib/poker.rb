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

  HAND_RANKS = [:straight_flush, :four_of_a_kind, :full_house, :flush, :straight,
                 :three_of_a_kind, :two_pair, :pair, :high_card].reverse

  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def <=>(other_hand)
    # First compare hand type
    our_hand_rank = HAND_RANKS.index(self.hand_type.first)
    other_hand_rank = HAND_RANKS.index(other_hand.hand_type.first)

    type_comparison = our_hand_rank <=> other_hand_rank
    return type_comparison unless type_comparison == 0

    # Break ties
    @tie_breaker_arr.each_index do |index|
      tie_comparison = @tie_breaker_arr <=> other_hand.tie_breaker_arr
      return tie_comparison unless tie_comparison == 0
    end

    # Still tied in the end
    return 0
  end


  def self.frequency_sort(arr)
    #
    # e.g. [9,7,4,4,9] => [9,9,4,4,7]
    freq_hash = {}
    arr.each do |el|
      freq = arr.count(el)
      freq_hash[el] = freq
    end

    result = []
    freq_hash.each do |k,v|
      result << [k]*v
    end

    result.sort! do |x, y|
      if (y.length <=> x.length) != 0
        y.length <=> x.length
      else
        y.first <=> x.first
      end
    end

    result.flatten
  end

  def hand_type
    @tie_breaker_arr = Hand.frequency_sort(@cards.map(&:rank))

    return [:straight_flush, @tie_breaker_arr] if straight_flush?
    return [:four_of_a_kind, @tie_breaker_arr] if four_of_a_kind?
    return [:full_house, @tie_breaker_arr] if full_house?
    return [:flush, @tie_breaker_arr] if flush?
    return [:straight, @tie_breaker_arr] if straight?
    return [:three_of_a_kind, @tie_breaker_arr] if three_of_a_kind?
    return [:two_pair, @tie_breaker_arr] if two_pair?
    return [:pair, @tie_breaker_arr] if pair?
    return [:high_card, @tie_breaker_arr]
  end

  def straight_flush?
    straight? && flush?
  end

  def flush?
    suits = @cards.map(&:suit)
    suits.count(suits[0]) == 5
  end

  def straight?
    if @tie_breaker_arr == [14,5,4,3,2] # Ace-low straight
      @tie_breaker_arr = [5,4,3,2,1]
      return true
    end
    @tie_breaker_arr.each_index do |index|
      next if index == @tie_breaker_arr.length-1
      current_el_val = @tie_breaker_arr[index]
      return false unless current_el_val == @tie_breaker_arr[index+1].next
    end
    true
  end

  def full_house?
    cond1 = @tie_breaker_arr.count(@tie_breaker_arr[0]) == 3
    cond2 = @tie_breaker_arr.count(@tie_breaker_arr[3]) == 2
    cond1 && cond2
  end

  def four_of_a_kind?
    @tie_breaker_arr.count(@tie_breaker_arr[0]) == 4
  end

  def three_of_a_kind?
    cond1 = @tie_breaker_arr.count(@tie_breaker_arr[0]) == 3
    cond2 = @tie_breaker_arr.count(@tie_breaker_arr[3]) == 1
    cond1 && cond2
  end

  def two_pair?
    pair1 = @tie_breaker_arr.count(@tie_breaker_arr[0]) == 2
    pair2 = @tie_breaker_arr.count(@tie_breaker_arr[2]) == 2
    pair1 && pair2
  end

  def pair?
    pair1 = @tie_breaker_arr.count(@tie_breaker_arr[0]) == 2
    pair2 = @tie_breaker_arr.count(@tie_breaker_arr[2]) == 1
    pair1 && pair2
  end


end



