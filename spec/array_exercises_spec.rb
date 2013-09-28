require 'rspec'
require 'array_exercises.rb'

describe Array do

  describe "#my_uniq" do
    it "should remove duplicate elements" do
      [1,2,3,4,4,4].my_uniq.should == [1,2,3,4]
    end

    it "should handle empty arrays" do
      [].my_uniq.should == []
    end

    it "should not modify uniq arrays" do
      [1,2,3].my_uniq.should == [1,2,3]
    end

    it "should not mutate the object" do
      array = [1,2,3,4,4]
      array.my_uniq
      array.should == [1,2,3,4,4]
    end

  end

  describe "#two_sum" do

    it "returns an array of arrays" do
      [-1, 0, 2, -2, 1].two_sum[0].should be_a(Array)
    end

    it "handles an empty array" do
      [].two_sum.should == []
    end

    it "handles an array with no pairs" do
      [1,2,3,4].two_sum.should == []
    end

    it "handles an array with a single pair" do
      [1,2,3,4,-1].two_sum.should == [[0, 4]]
    end

    it "handle an array with multiple pairs" do
      [-1, 0, 2, -2, 1].two_sum.should == [[0, 4], [2, 3]]
    end

  end
end