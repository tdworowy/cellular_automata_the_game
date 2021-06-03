extends Spatial

var cellular_automata = load("res://scripts/cellular_automata_2d.gd")

var scale_x:float = 2.0
var scale_z:float = 2.0
var scale_y:float = 3.0
const red = Color( 1, 0, 0, 1 )

var floor_scale_x:int
var floor_scale_z:int

var grid_x:int
var grid_z:int

var material:SpatialMaterial
var grid:Array
var rule:Dictionary

onready var current_rule:Label = get_node("current_rule")
onready var menu:Panel = get_node("menu")
onready var floor_:StaticBody = get_node("floor")

onready var game_of_live_button:MenuButton = get_node("menu/game of live")
onready var mazectric_button:MenuButton = get_node("menu/mazectric")
onready var amoeba_button:MenuButton = get_node("menu/amoeba")
onready var twox2_button:MenuButton = get_node("menu/2x2")
onready var live_34_button:MenuButton = get_node("menu/34_live")
onready var coagulations_button:MenuButton = get_node("menu/coagulations")
onready var move_button:MenuButton = get_node("menu/move")
onready var walled_cities_button:MenuButton = get_node("menu/walled_cities")
onready var snowflake_button:MenuButton = get_node("menu/snowflake")
onready var snowflake_rule_line_edit:LineEdit = get_node("menu/snowflake_rule")

onready var pause_button:MenuButton = get_node("menu/pause")


var play:bool = false

func generate_box(material:SpatialMaterial, x:int=1, y:int=1, z:int=1):
	var static_body = StaticBody.new()
	var colision_shape = CollisionShape.new()
	var box = CSGBox.new() 
	
	static_body.scale.x = scale_x 
	static_body.scale.y = scale_y
	static_body.scale.z = scale_z
	
	static_body.translation.x = x
	static_body.translation.y = y
	static_body.translation.z = z
		
	box.material = material
	
	colision_shape.set_shape(BoxShape.new())
	colision_shape.add_child(box)
	static_body.add_child(colision_shape)
	
	static_body.add_to_group(str(x)+"_"+str(z))
	
	return static_body

func generate_boxes(grid:Array, floor_scale_x:int, floor_scale_z:int, material):
	var x = floor_scale_x
	var z = floor_scale_z
	for row in grid:
		for value in row:
			var box = generate_box(material, x, 3, z)
			self.add_child(box)
			x = x - (scale_x * 2)
		x = floor_scale_x
		z = z - (scale_z * 2)
		
func set_visibility(grid:Array, floor_scale_x:int, floor_scale_z:int):
	var x = floor_scale_x
	var z = floor_scale_z
	var node
	var visibility
	 
	for row in grid:
		for value in row:
			node = get_tree().get_nodes_in_group(str(x)+"_"+str(z))[0]
			visibility = node.is_visible()
			
			if value == 0 and visibility:
				node.visible = false
				node.get_children()[0].disabled = true 
			
			if value == 1 and !visibility:
				node.visible = true
				node.get_children()[0].disabled = false 

			x = x - (scale_x * 2)
		x = floor_scale_x
		z = z - (scale_z * 2)

func check_rules_imput():
	if game_of_live_button.pressed:
		current_rule.set_text("Rule: game of live")
		rule = cellular_automata.get_game_of_live_rules()
		game_of_live_button.pressed = false
	
	if mazectric_button.pressed:
		current_rule.set_text("Rule: mazectric")
		rule = cellular_automata.get_mazectric_rules()
		mazectric_button.pressed = false
	
	if amoeba_button.pressed:
		current_rule.set_text("Rule: amoeba")
		rule = cellular_automata.get_amoeba_rules()
		amoeba_button.pressed = false
		
	if twox2_button.pressed:
		current_rule.set_text("Rule: 2x2")
		rule = cellular_automata.get_2x2_rules()
		twox2_button.pressed = false
		
	if live_34_button.pressed:
		current_rule.set_text("Rule: 34 live")
		rule = cellular_automata.get_34_live_rules()
		live_34_button.pressed = false
	
	if coagulations_button.pressed:
		current_rule.set_text("Rule: coagulations")
		rule = cellular_automata.get_coagulations_rules()
		
	if move_button.pressed:
		current_rule.set_text("Rule: move")
		rule = cellular_automata.get_move_rules()
		move_button.pressed = false
	
	if walled_cities_button.pressed:
		current_rule.set_text("Rule: walled cities")
		rule = cellular_automata.get_walled_cities_rules()
		walled_cities_button.pressed = false
		
	if snowflake_button.pressed:
		var snowflake_rule:Array = snowflake_rule_line_edit.text.split_floats(',')
		current_rule.set_text("Rule: Snowflake "+ str(snowflake_rule))
		rule = cellular_automata.generate_snowflake_rule(snowflake_rule)
		snowflake_button.pressed = false
		
	if Input.is_action_pressed("menu"):
		if (menu.is_visible()):
			menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
	if pause_button.pressed:
		play = !play
		print("Pause:" + str(!play)) 
		pause_button.pressed = false
			

func _ready():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	
	scale_x = float(config.get_value("env","box_length"))
	scale_z = float(config.get_value("env","box_width"))
	floor_scale_x = int(config.get_value("env","floor_length"))
	floor_scale_z = int(config.get_value("env","floor_width"))
	floor_.scale.x = floor_scale_x
	floor_.scale.z = floor_scale_z
		
	var snowflake_rule:Array = snowflake_rule_line_edit.text.split_floats(',')
	current_rule.set_text("Rule: Snowflake "+ str(snowflake_rule))
	rule = cellular_automata.generate_snowflake_rule(snowflake_rule)
	
	material = SpatialMaterial.new()
	material.albedo_color = red
	
	grid_x = floor_scale_x/scale_x
	grid_z = floor_scale_z/scale_z
	
	if (config.get_value("env","state") == "random"):
		grid = cellular_automata.generate_grid_random(grid_x, grid_z, 0.1)
	if (config.get_value("env","state") == "center"):
		grid = cellular_automata.generate_grid_center(grid_x, grid_z)
	
	generate_boxes(grid, floor_scale_x, floor_scale_z, material)
	set_visibility(grid, floor_scale_x, floor_scale_z)

func _process(delta):
	check_rules_imput()
	

func _on_Timer_timeout():
		if play:
			var new_grid = cellular_automata.update_grid(grid, grid_x, grid_z, 
			rule)
			set_visibility(new_grid, floor_scale_x, floor_scale_z)
			grid = new_grid
			
