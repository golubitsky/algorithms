def find_positions
  solutions = []
  [0,1,2,3,4,5,6,7].permutation(8).to_a.each do |position|
    position.each_with_index do |value, index|
      break if check(position, value, index)==false
      solutions << position if index == 7
    end
  end
  solutions.length
end

def check(position, value, index)
  diff = 1
  while value + diff <= 7 || value - diff >= 0
    return false if (index + diff <= 7) && (position[index + diff] == value + diff)
    return false if (index + diff <= 7) && (position[index + diff] == value - diff)
    return false if (index - diff >= 0) && (position[index - diff] == value - diff)
    return false if (index - diff >= 0) && (position[index - diff] == value + diff)
    diff += 1
  end
  true
end

p find_positions
