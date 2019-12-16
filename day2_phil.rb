@baseinput = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,19,10,23,1,23,6,27,1,6,27,31,1,13,31,35,1,13,35,39,1,39,13,43,2,43,9,47,2,6,47,51,1,51,9,55,1,55,9,59,1,59,6,63,1,9,63,67,2,67,10,71,2,71,13,75,1,10,75,79,2,10,79,83,1,83,6,87,2,87,10,91,1,91,6,95,1,95,13,99,1,99,13,103,2,103,9,107,2,107,10,111,1,5,111,115,2,115,9,119,1,5,119,123,1,123,9,127,1,127,2,131,1,5,131,0,99,2,0,14,0]
@pointer = 0

def opcode(opcode,pos1,pos2,pos3)
  if opcode == 1
    @input[pos3] = @input[pos1] + @input[pos2]
  elsif opcode == 2
    @input[pos3] = @input[pos1] * @input[pos2]
  elsif opcode == 99
    halt
  else
    raise 'HCF'
  end
end

def halt
  @halt = true
  # result = @input[0]
  # puts "result: #{result}"
  return unless @input[0] == 19_690_720

  puts "Final result: #{100 * @noun * @verb}"
  exit
end

(0..99).each do |a|
  (0..99).each do |b|
    @input = Marshal.load( Marshal.dump(@baseinput))
    @pointer = 0

    @noun = a
    @verb = b

    @input[1] = a
    @input[2] = b

    @halt = false

    begin
      while !@halt
          opcode(@input[@pointer],@input[@pointer+1],@input[@pointer+2],@input[@pointer+3])
          @pointer = @pointer + 4
      end
    rescue
      next
    end

  end
end
