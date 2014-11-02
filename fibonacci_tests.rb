def fibcursive(n)
	return 1 if n < 2
	return fibcursive(n - 1) + fibcursive(n - 2)
end

def fibcursive2(n, a=0, b=1)
	return a if n == 0
	return b if n == 1
	return fibcursive2(n - 1, b, a + b)
end

def fiberative_while(n) #using while loop
	return 1 if n == 1 || n == 2
	a = 1; b = 1; result = nil
	i = 3
	while i <= n
		result = a + b
		a = b
		b = result
		i += 1
	end
	result
end
def fiberative_each(n) #using each
	return 1 if n == 1 || n == 2
	a = 1; b = 1; result = nil
	(3..n).each do |i|
		result = a + b
		a = b
		b = result
	end
	result
end

def timer(n = 10)
	t = Time.now
	n.times {yield} if block_given?
	(Time.now - t)/n
end



#test iterative vs recursive v.1 vs recursive v.2
totals = Hash.new(0)
100.times do
	a = timer { fiberative_while(20) }
	b = timer { fibcursive(20) }
	c = timer { fibcursive2(20) }
	case [a,b,c].min
		when a then totals[:fiberative] += 1
		when b then totals[:fibcursive] += 1
		when c then totals[:fibcursive2] += 1
	end
end
puts totals

#test iterative using while vs iterative using each
totals = Hash.new(0)
100.times do
	a = timer { fiberative_while(20) }
	b = timer { fiberative_each(20) }
	if a < b
		totals[:while] += 1
	else
		totals[:each] += 1
	end
end
puts totals

#test how much slower is each compared to while
n = 10000
a = timer(n) { fiberative_while(20) }
b = timer(n) { fiberative_each(20) }
ratio = b/a
puts "In #{n} runs computing fib(20) each takes on average #{ratio.round(2)} times longer than while."
