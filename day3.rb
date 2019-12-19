require "test/unit/assertions"
include Test::Unit::Assertions

#max
def manathan_distance(point1, point2)
  dx = (point1.x - point2.x).abs
  dy = (point1.y - point2.y).abs
  dx + dy
end

#max
class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

#phil
class Segment
  def is_collision?(segment)
    #si meme sens return false
  end
end

#phil
class Wire

  def initialize(instructions)
    @current_instruction = 0
    @instructions = instructions
  end

  def next_segment
    if @current_segment.nil? here = Point.new(0,0)
    else here = @current_segment.end
    @current_segment = Segment.new(here, self.next_instruction)
    return @current_segment
  end

  def next_instruction
    
  end
end

#bix
def init_wires()
  #input => 2 Wire
end

#bix
def main
  #for fil 1, each segment
    #check if fil 2 collides  
end

def test_point
  point = Point.new(2, 3)
  assert_equal 2, point.x
  assert_equal 3, point.y
end

def test_manathan_distance
  assert_equal 0, manathan_distance(Point.new(0,0), Point.new(0,0))

  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(0,3))
  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(3,0))
  assert_equal 3, manathan_distance(Point.new(3,0), Point.new(0,0))
  assert_equal 3, manathan_distance(Point.new(0,3), Point.new(0,0))

  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(0,-3))
  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(-3,0))
  assert_equal 3, manathan_distance(Point.new(-3,0), Point.new(0,0))
  assert_equal 3, manathan_distance(Point.new(0,-3), Point.new(0,0))

  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(1,2))
  assert_equal 3, manathan_distance(Point.new(0,0), Point.new(2,1))
  assert_equal 3, manathan_distance(Point.new(1,2), Point.new(0,0))
  assert_equal 3, manathan_distance(Point.new(2,1), Point.new(0,0))
end

def all_tests
  test_manathan_distance
  test_point
end

all_tests
main
