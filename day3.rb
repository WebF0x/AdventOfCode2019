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

  def ==(o)
    o.class == self.class && o.state == state
  end

  protected

  def state
    [@x, @y]
  end
end

#max
class Segment
  attr_accessor :from, :to

  def initialize(from, instruction)
    @from = from
    @to = get_point_after_instruction from, instruction
  end

  def is_collision?(segment)
    # si meme sens return false
  end

  protected

  def get_point_after_instruction(from, instruction)
    to_x = from.x
    to_y = from.y
    instruction.direction == 'U' && to_y += instruction.amplitude
    instruction.direction == 'D' && to_y -= instruction.amplitude
    instruction.direction == 'L' && to_x -= instruction.amplitude
    instruction.direction == 'R' && to_x += instruction.amplitude
    Point.new(to_x, to_y)
  end
end

#phil
class Wire

  def initialize(instructions)
    @current_instruction = 0
    @instructions = instructions
  end

  def next_segment
    if @current_segment.nil?
      here = Point.new(0, 0)
    else
      here = @current_segment.end
    end
    @current_segment = Segment.new(here, self.next_instruction)
    @current_segment
  end

  def next_instruction
    next_instruction = @instructions[@current_instruction]
    @current_instruction += 1
    next_instruction
  end
end

# Instruction abstraction
class Instruction
  attr_accessor :direction, :amplitude

  # @param [String] returns an instruction
  def initialize(instruction_string)
    @direction = instruction_string[0]
    @amplitude = instruction_string[1..-1].to_i
  end
end

# bix
def main
  # read input file
  input = File.read('input.txt')

  # initialize wires
  wires = []

  # convert input to instructions
  input.each_line do |line|
    instructions = line.split(',')
    instructions.map! do |i|
      Instruction.new(i)
    end

    wires << Wire.new(instructions)
  end

  wires.each do |wire|
    until segment = wire.next_segment.nil? do
      puts segment
    end
  end
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

def test_segment
  # *****
  # *A**B
  # *****
  segment = Segment.new(Point.new(1,1), Instruction.new("R3"))
  assert_equal Point.new(1, 1), segment.from
  assert_equal Point.new(4, 1), segment.to
end

def all_tests
  test_manathan_distance
  test_point
  test_segment
end

all_tests
main
