static func get_game_of_live_rules() -> Dictionary:
	return {
			"0_3": 1,
			"1_3": 1,
			"1_2": 1
			}
static func get_mazectric_rules() -> Dictionary:
	return {
		"0_3": 1,
		"1_1": 1,
		"1_2": 1,
		"1_3": 1,
		"1_4": 1,
		}
static func get_amoeba_rules() -> Dictionary:
	return {
			"0_3": 1,
			"0_5": 1,
			"0_7": 1,
			"1_1": 1,
			"1_3": 1,
			"1_5": 1,
			"1_8": 1
		}
static func get_2x2_rules() -> Dictionary:
	return {
			"0_3": 1,
			"0_6": 1,
			"1_1": 1,
			"1_2": 1,
			"1_5": 1,
		}
static func get_34_live_rules() -> Dictionary:
	return {
		"0_3": 1,
		"0_4": 1,
		"1_3": 1,
		"1_4": 1
		}
static func get_coagulations_rules() -> Dictionary:
	return {
		"0_3": 1,
		"0_7": 1,
		"0_8": 1,
		"1_2": 1,
		"1_3": 1,
		"1_5": 1,
		"1_6": 1,
		"1_7": 1,
		"1_8": 1,
		}
static func get_move_rules() -> Dictionary:
	return {
		"0_3": 1,
		"0_6": 1,
		"0_8": 1,
		"1_2": 1,
		"1_4": 1,
		"1_5": 1,
		}
static func get_walled_cities_rules() -> Dictionary:
	return {
		"0_4": 1,
		"0_5": 1,
		"0_6": 1,
		"0_7": 1,
		"0_8": 1,
		"1_2": 1,
		"1_3": 1,
		"1_4": 1,
		"1_5": 1,
}
static func generate_snowflake_rule(neighbours_numbers:Array = [1]) -> Dictionary:
	var snowflake_rules = {}

	for neighbours_number in neighbours_numbers:
		snowflake_rules["0"+"_"+ str(neighbours_number)] = 1
		snowflake_rules["1" +"_"+ str(neighbours_number)] = 1
	for i in range(9):
		if !(i in neighbours_numbers):
			snowflake_rules["0"+"_"+ str(i)] = 0
			snowflake_rules["1" +"_"+ str(i)] = 1

	return snowflake_rules

static func generate_grid_random(hight:int, width:int, prob_of_one:float) -> Array:
		var grid = []
		for i in range(hight):
			var row = []
			for j in range(width):
				randomize()
				var rand_int = (randi() % 10)  + 1 
				if rand_int <= int(prob_of_one * 10):
					row.append(1)
				else:
					row.append(0)
			grid.append(row)
		return grid			

static func generate_grid_center(hight:int, width:int) -> Array:
		var grid = []
		for i in range(hight):
			var row = []
			for j in range(width):
				if (i == hight/2 and j == width/2):
					row.append(1)
				else:
					row.append(0)
			grid.append(row)
		return grid	

static func count_colored_neighbours(x:int, z:int, grid_x_axis:int, grid_z_axis:int, grid:Array ) -> int:
	var colored_neighbours = 0
	for i in range((x - 1) % grid_x_axis, (x + 2) % grid_x_axis):
		for j in range((z - 1) % grid_z_axis, (z + 2) % grid_z_axis):
			if grid[i][j] == 1 and i != x and j != z: 
				colored_neighbours += 1
	return colored_neighbours


static func update_grid(grid:Array, grid_x_axis:int, grid_z_asix:int, rules:Dictionary) -> Array:
	var new_grid = grid.duplicate(true)
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			var state = grid[i][j]
			var live_neighbours = count_colored_neighbours(i, j, grid_x_axis, grid_z_asix, grid)
			new_grid[i][j] = rules.get(str(state) +'_' + str(live_neighbours),0) 
	return new_grid
