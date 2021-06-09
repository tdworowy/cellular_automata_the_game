class RuleSegment:
	func _init( neighborhood: Array, type: int):
		self.neighborhood = neighborhood
		self.type = type


static func n_nary(number: int, n: int) -> String:
	if number == 0:
		return '0'
	var nums = []
	while number:
		nums.append(str(number % n))
	return nums.invert().join("")


static func wolfram_number_to_bin(wolfram_number: int, possible_states: int, colours_count: int) -> Array:
	var wolfram_number_s = n_nary(wolfram_number, colours_count)
	var temp = possible_states - len(wolfram_number_s)
	wolfram_number_s = "0" * temp + wolfram_number_s
	return wolfram_number_s.split("", true).invert()

static func product(a:Array, repeat:int = 1) -> Array:
	#TODO implement it
	return []

static func generate_rule(wolfram_number: int, neighborhood_size: int = 3, colours: Array = [0, 1]) -> Array:
	var colours_count = len(colours)
	var possible_states =  pow(colours_count, neighborhood_size)
	var rule = []

	var wolfram_number_a = wolfram_number_to_bin(wolfram_number, possible_states, colours_count)
	var i = 0
	for comb in product(colours, neighborhood_size):
		rule.append(RuleSegment.new(comb, int(wolfram_number_a[i])))
		i +=1
	return rule
	
static func cellular_automata_step_1d(input_list: Array, rules: Array) -> Array:
	var output_list = []
	var width = len(input_list[0])

	for i in range(len(input_list)):
		for rule in rules:
			var neighborhood_size = len(rule.neighborhood)
			var temp = (neighborhood_size - 1) / 2
			var current_neighborhood = []
			
			for j in range((i - temp) % width, (i + temp + 1) % width):
				current_neighborhood.append(input_list[j])

			if current_neighborhood == rule.neighborhood:
				output_list.append(rule.type)
			else:
				output_list.append(0)
	
	return output_list
