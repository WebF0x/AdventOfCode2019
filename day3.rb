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

  def intersection(segment)
    x = x_collision(segment)
    y = y_collision(segment)
    return nil if x.nil? || y.nil?
    Point.new(x, y)
  end

  private

  def x_collision(segment)
    lower = [to.x, from.x].min
    higher = [to.x, from.x].max
    segment_lower = [segment.to.x, segment.from.x].min
    segment_higher = [segment.to.x, segment.from.x].max

    unless lower > segment_higher || higher < segment_lower
      leftmost_collision = [lower, segment_lower].max
      righmost_collision = [higher, segment_higher].min

      if(leftmost_collision.abs < righmost_collision.abs)
        return leftmost_collision
      end
      return righmost_collision
    end
    nil
  end

  def y_collision(segment)
    lower = [to.y, from.y].min
    higher = [to.y, from.y].max
    segment_lower = [segment.to.y, segment.from.y].min
    segment_higher = [segment.to.y, segment.from.y].max

    unless lower > segment_higher || higher < segment_lower
      leftmost_collision = [lower, segment_lower].max
      righmost_collision = [higher, segment_higher].min

      if(leftmost_collision.abs < righmost_collision.abs)
        return leftmost_collision
      end
      return righmost_collision
    end
    nil
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
  attr_accessor :instructions, :steps

  def initialize(instructions)
    reset
    @instructions = instructions
  end

  def next_segment
    if @current_segment.nil?
      here = Point.new(0, 0)
    else
      here = @current_segment.to
    end
    current_instruction = self.next_instruction
    return if current_instruction.nil?
    @current_segment = Segment.new(here, current_instruction)
  end

  def next_instruction
    unless @current_instruction == 0 
      @steps += @instructions[@current_instruction-1].amplitude
    end
    ins = @instructions[@current_instruction]
    @current_instruction += 1
    ins
  end

  def reset
    @steps = 0
    @current_instruction = 0
    @current_segment = nil
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

  origin = Point.new(0,0)
  closest_distance = nil

  seg_i = 0
  seg_tot = wires.first.instructions.size

  until (segment_wire1 = wires.first.next_segment).nil? do
    wires.last.reset
    seg_i += 1
    puts "segment #{seg_i} / segment total: #{seg_tot}"
    until (segment_wire2 = wires.last.next_segment).nil? do
      intersection = segment_wire1.intersection(segment_wire2)
      unless intersection.nil?
        #distance = manathan_distance(origin, intersection)
        steps = wires.first.steps + wires.last.steps + manathan_distance(segment_wire1.from, intersection) + manathan_distance(segment_wire2.from, intersection)
        if (closest_distance == nil || closest_distance > steps) && steps != 0
          closest_distance = steps
        end
      end
    end
  end

  puts "What is the fewest combined steps the wires must take to reach an intersection? #{closest_distance}"

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

def test_segment_intersection_scanning_horizontally
  horizontal_segment = Segment.new(Point.new(3,3), Instruction.new("R7"))
  assert_nil horizontal_segment.intersection(Segment.new(Point.new(2,0), Instruction.new("U8")))
  assert_equal Point.new(3, 3), horizontal_segment.intersection(Segment.new(Point.new(3, 0), Instruction.new("U8")))
  assert_equal Point.new(5, 3), horizontal_segment.intersection(Segment.new(Point.new(5, 0), Instruction.new("U8")))
  assert_equal Point.new(10, 3), horizontal_segment.intersection(Segment.new(Point.new(10, 0), Instruction.new("U8")))
  assert_equal nil, horizontal_segment.intersection(Segment.new(Point.new(11, 0), Instruction.new("U8")))

  horizontal_segment = Segment.new(Point.new(10, 3), Instruction.new("L7"))
  assert_equal nil, horizontal_segment.intersection(Segment.new(Point.new(2,0), Instruction.new("U8")))
  assert_equal Point.new(3, 3), horizontal_segment.intersection(Segment.new(Point.new(3, 0), Instruction.new("U8")))
  assert_equal Point.new(5, 3), horizontal_segment.intersection(Segment.new(Point.new(5, 0), Instruction.new("U8")))
  assert_equal Point.new(10, 3), horizontal_segment.intersection(Segment.new(Point.new(10, 0), Instruction.new("U8")))
  assert_equal nil, horizontal_segment.intersection(Segment.new(Point.new(11, 0), Instruction.new("U8")))
end

def test_segment_intersection_scanning_vertically
  vertical_segment = Segment.new(Point.new(3, 3), Instruction.new("U7"))
  assert_equal nil, vertical_segment.intersection(Segment.new(Point.new(0, 2), Instruction.new("R8")))
  assert_equal Point.new(3, 3), vertical_segment.intersection(Segment.new(Point.new(0, 3), Instruction.new("R8")))
  assert_equal Point.new(3, 5), vertical_segment.intersection(Segment.new(Point.new(0, 5), Instruction.new("R8")))
  assert_equal Point.new(3, 10), vertical_segment.intersection(Segment.new(Point.new(0, 10), Instruction.new("R8")))
  assert_equal nil, vertical_segment.intersection(Segment.new(Point.new(0, 11), Instruction.new("R8")))

  vertical_segment = Segment.new(Point.new(3, 10), Instruction.new("D7"))
  assert_equal nil, vertical_segment.intersection(Segment.new(Point.new(0, 2), Instruction.new("R8")))
  assert_equal Point.new(3, 3), vertical_segment.intersection(Segment.new(Point.new(0, 3), Instruction.new("R8")))
  assert_equal Point.new(3, 5), vertical_segment.intersection(Segment.new(Point.new(0, 5), Instruction.new("R8")))
  assert_equal Point.new(3, 10), vertical_segment.intersection(Segment.new(Point.new(0, 10), Instruction.new("R8")))
  assert_equal nil, vertical_segment.intersection(Segment.new(Point.new(0, 11), Instruction.new("U8")))
end

def all_tests
  test_manathan_distance
  test_point
  test_segment
  test_segment_intersection_scanning_horizontally
  test_segment_intersection_scanning_vertically
end

all_tests
main
