
def never_decrease?(password, max=9)
  if(password == 0) 
    return true 
  end
  digit = password % 10
  if digit > max 
    return false
  end
  return never_decrease?(password / 10, digit)
end

def two_adjacent?(password, last=nil)
  if(password == 0) 
    return false
  end
  digit = password % 10
  if last == digit
    return true
  end
  return two_adjacent?(password / 10, digit)
end

def subsequent(password)
  password += 1
end

minimum = 206938
maximum = 679128

current = minimum
password_count = 0

until current > maximum do
  if never_decrease?(current) && two_adjacent?(current)
    puts current
    password_count += 1
  end
  current = subsequent(current)
end

puts password_count
