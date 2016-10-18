def iter(n, d, x)
	print "," if x unless d == 0
	print "#{n / d}" unless d == 0
	iter(d, n % d, true) unless d <= 1; end
print "Enter numerator:\n  :>"
num = gets.chomp.to_i
print "Enter denominator:\n  :>"
den = gets.chomp.to_i
print "#{num}/#{den} is (#{num / den}" unless den == 0
print ";" unless den <= 1 || num % den == 0
iter(den, num % den, false) unless den <= 1
print ")" unless den <= 1