class Array
  def my_uniq
    uniq_elements = []

    self.each do |el|
      uniq_elements << el unless uniq_elements.include?(el)
    end
    uniq_elements
  end

  def two_sum
    pairs = []

    self.each_index do |index1|
      self.each_index do |index2|
        next if index2 <= index1
        pairs << [index1, index2] if self[index1] + self[index2] == 0
      end
    end
    pairs
  end
end

