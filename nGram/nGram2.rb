class Ngram
	def initialize(target)
		@target = target; end
	def ngrams(n)
		@target.split('').each_cons(n).to_a; end; end
def pick(hash, key)
	return nil if hash[key].length < 1
	arr = []
	hash[key].each { |k, v| v.times { arr << k } }
	arr[rand(0...arr.length)]; end
def get_tri(hash, key1, key2)
	hash["#{key1}#{key2}"].length > 0 ? pick(hash, "#{key1}#{key2}") : pick(hash, "#{key2}"); end
def get_next(hash, key1, key2, key3)
	hash["#{key1}#{key2}#{key3}"].length > 0 ? pick(hash, "#{key1}#{key2}#{key3}") : get_tri(hash, "#{key2}", "#{key3}"); end
print "Enter the filename to import your words:\n  :>"
filename = gets.chomp
freq = Hash.new { |hash, key| hash[key] = Hash.new(0) }; first = []
File.open(filename).each do |line|
	line.downcase!
	first << line[0]
	content = Ngram.new(line.gsub('\n', '#'))
	2.upto(4) do |i|
	arr = content.ngrams(i)
	arr.each do |curr|
		val = curr.delete_at(i - 1)
		freq[curr.join('')][val] += 1; end; end; end
100.times do |i|
	output = first[rand(0...first.length)]
	output += pick(freq, output[output.length - 1]) unless pick(freq, output[output.length - 1]) == nil
	output += get_tri(freq, output[output.length - 2], output[output.length - 1]) unless get_tri(freq, output[output.length - 2], output[output.length - 1]) == nil
	while true do
		case rand(1..2)
		when 1
			get_next(freq, output[output.length - 3], output[output.length - 2], output[output.length - 1]).nil? ? break : output += get_next(freq, output[output.length - 3], output[output.length - 2], output[output.length - 1])
		else
			get_tri(freq, output[output.length - 2], output[output.length - 1]).nil? ? break : output += get_tri(freq, output[output.length - 2], output[output.length - 1]); end; end
	puts "#{i+1}: #{output}" unless output[1] == ' ' || output.length < 5 || output.length > 25 || output[0] == output[1]; end