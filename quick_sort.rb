def quick_sort(arr)
  return arr if arr.length <= 1
  pivot_start = arr.length / 2
  arr[pivot_start], arr[arr.length - 1] = arr[arr.length - 1], arr[pivot_start]
  i = 0
  pivot_end = 0
  while i < arr.length - 1
    if arr[i] < arr[arr.length - 1]
      arr[i], arr[pivot_end] = arr[pivot_end], arr[i]
      pivot_end += 1
    end
    i += 1
  end
  arr[pivot_end], arr[arr.length - 1] = arr[arr.length - 1], arr[pivot_end]
  return quick_sort(arr[0...pivot_end]) + [arr[pivot_end]] + quick_sort(arr[(pivot_end + 1)...arr.length])
end

arr = []
10.times {arr << rand(100) }
p quick_sort(arr)
