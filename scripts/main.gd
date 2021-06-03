extends Spatial

var cellular_automata = load("res://scripts/cellular_automata_2d.gd")
var Utils =  load("res://scripts/utils.gd")
var utils = null

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

var menu_visible = false

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
	
	if pause_button.pressed:
		play = !play
		print("Pause:" + str(!play)) 
		pause_button.pressed = false
			

func _ready():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	utils = Utils.new(self, scale_x, scale_y, scale_z)
	
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
	
	utils.generate_boxes(grid, floor_scale_x, floor_scale_z, material)
	utils.set_visibility(grid, floor_scale_x, floor_scale_z)

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
			utils.set_visibility(new_grid, floor_scale_x, floor_scale_z)
			grid = new_grid
			

