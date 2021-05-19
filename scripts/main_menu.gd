extends Control

onready var box_x = get_node("boxes_properties/box_x")
onready var box_z = get_node("boxes_properties/box_z")
onready var floor_x = get_node("floor_properties/floor_x")
onready var floor_z = get_node("floor_properties/floor_z")

func _ready():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	
	box_x.text =  str(config.get_value("env","box_length"))
	box_z.text =  str(config.get_value("env","box_width"))
	
	floor_x.text = str(config.get_value("env","floor_length"))
	floor_z.text = str(config.get_value("env","floor_width"))





