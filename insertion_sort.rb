#CLRS Introduction to Algorithms; 2.1

def sort(arr)
    j = 1
    while j < arr.length
        key = arr[j]
        i = j - 1
        while i >= 0 && arr[i] > key
            arr[i+1] = arr[i]
            i -= 1
        end
        arr[i+1] = key
        j += 1
    end
    arr
end

arr=[]
6.times{arr << rand(100)}
p sort(arr)
