
def add_binary(a, b)
    a.reverse!
    b.reverse!
    if a.length > b.length
        max = a
        min = b
    else
        max = b
        min = a
    end
    result = ''
    carry = false
    i = 0
    while i < max.length
        if min[i] == nil
            if carry == true && max[i] == 1
                result << "0"
                carry = true
            elsif carry == true && max[i] == 0
                result << "1"
                carry = false
            elsif carry == false
                result << max[i]
            end
        elsif min[i] == "0" && max[i] == "0"
            result << "0" if carry == false
            result << "1" if carry == true
            carry = false
        elsif (min[i] == "1" && max[i] == "0") || (min[i] == "0" && max[i] == "1")
            if carry == true
                result << "0"
            elsif carry == false
                result << "1"
            end
        elsif min[i] == "1" && max[i] == "1"
            if carry == true
                result << "1"
            elsif carry == false
                result << "0"
                carry = true
            end
        end
        i += 1
    end
    result << "1" if carry == true
    result.reverse
end

a = rand(10)
b = rand(10)
p (a + b).to_s(2)
p add_binary(a.to_s(2), b.to_s(2))
