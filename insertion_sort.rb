#CLRS Introduction to Algorithms; 2.1

def sort(arr)
    j = 1
    while j < arr.length
        key = arr[j]
        i = j
        while i >= 0 && arr[i] > key
            arr[i], arr[i - 1] = arr[i - 1], arr[i]
            i -= 1
        end
        j += 1
    end
    arr
end

arr=[]
6.times{arr << rand(100)}
p sort(arr)
