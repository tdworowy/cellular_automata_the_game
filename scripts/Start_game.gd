extends Button


func load_level():
	get_tree().change_scene("res://main.tscn")
	
func _ready():
	connect("pressed",self,"load_level")


# TODO find the way to get values from main menu available in next scene
