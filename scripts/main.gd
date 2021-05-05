extends Spatial

var cellular_automata = load("res://scripts/cellular_automata.gd")

const scale_x: int = 2
const scale_z: int = 2
const scale_y: int = 3
const red = Color( 1, 0, 0, 1 )

var floor_scale_x: int
var floor_scale_z: int

var grid_x: int
var grid_z: int

var material: SpatialMaterial

var grid: Array

var counter:int = 0

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
	
	static_body.add_to_group("Boxes")
	
	return static_body

func clear_boxes():
	var boxes = get_tree().get_nodes_in_group("Boxes")
	for box in boxes:
		box.queue_free()

func generate_boxes(grid:Array, floor_scale_x:int, floor_scale_z:int, material):
	var x = floor_scale_x
	var z = floor_scale_z
	for row in grid:
		for value in row:
			if value == 1:
				var box = generate_box(material, x, 3, z)
				self.add_child(box)
			x = x - (scale_x * 2)
		x = floor_scale_x
		z = z - (scale_z * 2)

func _ready():
	material = SpatialMaterial.new()
	material.albedo_color = red
	
	floor_scale_x = $floor.scale.x
	floor_scale_z = $floor.scale.z

	grid_x = floor_scale_x/scale_x
	grid_z = floor_scale_z/scale_z
	
	grid = cellular_automata.generate_grid(grid_x, grid_z, 0.4)
	generate_boxes(grid, floor_scale_x, floor_scale_z, material)

func _process(delta):
	if counter == 200:
		var new_grid =  cellular_automata.update_grid_two_d(grid, grid_x, grid_z, cellular_automata.get_game_of_live_rules())
		
		clear_boxes()
		generate_boxes(new_grid, floor_scale_x, floor_scale_z, material)
		grid = new_grid
		counter = 0
	else:
		counter +=1
