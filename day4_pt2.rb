
def never_decrease?(password, max=9)
  return true if password == 0
  digit = password % 10
  return false if digit > max
  return never_decrease?(password / 10, digit)
end

def true_two_adjacent?(password, last=nil, count=1)
  return count == 2 if password == 0
  digit = password % 10
  if(last == digit)
    count += 1
  else
    return true if count == 2
    count = 1
  end
  return true_two_adjacent?(password / 10, digit, count)
end

# puzzle input
minimum = 206938
maximum = 679128

current = minimum
password_count = 0

until current > maximum do
  if never_decrease?(current) && true_two_adjacent?(current)
    puts current
    password_count += 1
  end
  current += 1
end

puts password_count
