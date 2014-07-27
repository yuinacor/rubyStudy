def row(index, height)
	return " "*(height - index) + "*"*(index*2 -1)
end

def print_row(height)

	arr = (1...height).to_a

	for i in arr
		puts row(i, height)
	end

	arr.pop

	for i in arr.reverse
		puts row(i,height)
	end
end


height = gets.to_i+1

print_row(height)

