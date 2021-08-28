var Utils = load("res://scripts/utils.gd")
var RuleSegment = load("res://scripts/rule_segment.gd")
func _init():
	pass
	
func n_nary(number: int, n: int) -> String:
		if number == 0:
			return '0'
		var nums = []
		while number:
			number, r = divmod(number, n) #TODO make it work
			nums.append(str(number % n))
		return nums.invert().join("")


func wolfram_number_to_bin(wolfram_number: int, possible_states: int, colours_count: int) -> Array:
		var wolfram_number_s = n_nary(wolfram_number, colours_count)
		var temp = possible_states - len(wolfram_number_s)
		wolfram_number_s = "0" * temp + wolfram_number_s
		return wolfram_number_s.split("", true).invert()

func generate_rule(wolfram_number: int, neighborhood_size: int = 3, colours: Array = [0, 1]) -> Array:
		var colours_count = len(colours)
		var possible_states =  pow(colours_count, neighborhood_size)
		var rule = []

		var wolfram_number_a = wolfram_number_to_bin(wolfram_number, possible_states, colours_count)
		var i = 0
		for comb in self.Utils.product(colours, neighborhood_size):
			rule.append(self.RuleSegment.new(comb, int(wolfram_number_a[i])))
			i +=1
		return rule
		
func cellular_automata_step_1d(input_list: Array, rules: Array) -> Array:
		var output_list = []
		var width = len(input_list[0])
		var rule_found = false

		for i in range(len(input_list)):
			for rule in rules:
				var neighborhood_size = len(rule.neighborhood)
				var temp = (neighborhood_size - 1) / 2
				var current_neighborhood = []
				
				for j in range((i - temp) % width, (i + temp + 1) % width):
					current_neighborhood.append(input_list[j])

				if current_neighborhood == rule.neighborhood:
					output_list.append(rule.type)
					rule_found = true 
			if !rule_found:
					output_list.append(0)
					rule_found = false
		
		return output_list
		
func generate_grid_random(hight:int,width:int,states:Array=[0,1]) -> Array:
		var grid = []
		var first_row = []
		for i in range(width):
			randomize()
			var rand_int = (randi() % len(states) + 1)
			first_row.append(rand_int) 
		grid.append(first_row)
		
		for j in range(hight - 1):
			var row = []
			for i in range(width):
				row.append(0)
			grid.append(row)
		
		return grid			

func generate_grid_center(hight:int,width:int, states:Array=[0,1]) -> Array:
		var grid = []
		var first_row = []
		for i in range(width):
			first_row.append(0)
		
		first_row[width/2] = states[1]
		grid.append(first_row)
		
		for j in range(hight - 1):
			var row = []
			for i in range(width):
				row.append(0)
			grid.append(row)
		
		return grid	
