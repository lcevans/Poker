
class Hanoi
  attr_reader :peg1, :peg2, :peg3

  def initialize
    @peg1 = [3, 2, 1]
    @peg2 = []
    @peg3 = []
    @pegs = [@peg1, @peg2, @peg3]
  end

  def move(start, finish)
    start_peg = @pegs[start - 1]
    end_peg = @pegs[finish - 1]

    raise ArgumentError, "cant move from empty" if start_peg.empty?

    if end_peg.empty? || end_peg.last > start_peg.last
      end_peg << start_peg.pop
    else
      raise ArgumentError, "something went wrong"
    end
  end

  def render
  end

  def won?
    @peg3.length == 3
  end


end