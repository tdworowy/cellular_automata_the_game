extends Spatial

var CellularAutomata = load("res://scripts/cellular_automata_1d.gd")
var GodotUtils =  load("res://scripts/godot_utils.gd")
var godot_utils
var cellular_automata

var scale_x:float = 2.0
var scale_z:float = 2.0
var scale_y:float = 3.0

var floor_scale_x:int
var floor_scale_z:int

var grid_x:int
var grid_z:int
var grid:Array
var rule:Array

var menu_visible:bool = false

onready var current_rule:Label = get_node("current_rule")
onready var menu:Panel = get_node("menu")
onready var floor_:StaticBody = get_node("floor")

onready var pause_button:MenuButton = get_node("menu/pause")

var play:bool = false

func check_rules_imput():
	if pause_button.pressed:
		play = !play
		print("Pause:" + str(!play)) 
		pause_button.pressed = false
			

func _ready():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	godot_utils = GodotUtils.new(self, scale_x, scale_y, scale_z)
	cellular_automata = CellularAutomata.new()
	
	scale_x = float(config.get_value("env","box_length"))
	scale_z = float(config.get_value("env","box_width"))
	floor_scale_x = int(config.get_value("env","floor_length"))
	floor_scale_z = int(config.get_value("env","floor_width"))
	floor_.scale.x = floor_scale_x
	floor_.scale.z = floor_scale_z
		
	current_rule.set_text("PlaceHolder")
	rule = cellular_automata.generate_rule(90)
	
	grid_x = floor_scale_x/scale_x
	grid_z = floor_scale_z/scale_z
	
	if (config.get_value("env","state") == "random"):
		grid = cellular_automata.generate_grid_random(grid_x, grid_z)
	if (config.get_value("env","state") == "center"):
		grid = cellular_automata.generate_grid_center(grid_x, grid_z)
	
	godot_utils.generate_materials()
	godot_utils.generate_boxes(grid, floor_scale_x, floor_scale_z)
	godot_utils.set_visibility(grid, floor_scale_x, floor_scale_z)
	grid = grid[0]

func _input(ev):
	if ev is InputEventKey and Input.is_action_pressed("menu"):
		if (menu_visible):
			menu.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if (!menu_visible):
			menu.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		
		menu_visible = !menu_visible

func _process(delta):
	check_rules_imput()	

func _on_Timer_timeout():
		if play:
			var new_grid = cellular_automata.update_grid(grid, grid_x, grid_z, 
			rule)
			godot_utils.set_visibility_row(new_grid, floor_scale_x, floor_scale_z)
			grid = new_grid
			
			floor_scale_z = floor_scale_z - (scale_z * 2)
			

