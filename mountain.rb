def row(index, height)
	return " "*(height - index) + "*"*(index*2 -1)
end

height = gets.to_i+1

for i in (1...height)
	puts row(i, height)
end

