file_content = File.open('input.sql').read
input = file_content.split("\n")

input.map!(&:to_i)

def module_mass(m)
  val = m / 3 - 2
  if val > 0
    val + module_mass(val)
  else
    0
  end
end

total = input.inject(0) { |sum,x| sum + module_mass(x) }

puts "Total fuel module mass is : #{total}"

