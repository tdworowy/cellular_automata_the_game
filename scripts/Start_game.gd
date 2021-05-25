extends Button

onready var box_x:LineEdit = get_node("../boxes_properties/box_x")
onready var box_z:LineEdit = get_node("../boxes_properties/box_z")
onready var floor_x:LineEdit = get_node("../floor_properties/floor_x")
onready var floor_z:LineEdit = get_node("../floor_properties/floor_z")


func load_level(config):
	config.set_value("env","box_length", box_x.text)
	config.set_value("env","box_width", box_z.text)
	
	config.set_value("env","floor_length", floor_x.text)
	config.set_value("env","floor_width", floor_z.text)
	config.save("settings.cfg")

	get_tree().change_scene("res://main.tscn")
	
func _ready():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	connect("pressed",self,"load_level",[config])

