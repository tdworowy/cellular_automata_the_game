extends Spatial



var cellular_automata = load("res://scripts/cellular_automata.gd")

const scale_x = 2
const scale_z = 2
const scale_y = 3
const red = Color( 1, 0, 0, 1 )

var grid_x:int
var grid_z:int

var grid:Array

func generate_box(material:SpatialMaterial,x:int=1,y:int=1,z:int=1):
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
	
	return static_body

func _ready():
	
	var material = SpatialMaterial.new()
	material.albedo_color = red
	
	var floor_scale_x = $floor.scale.x
	var floor_scale_z = $floor.scale.z

	grid_x = floor_scale_x/scale_x
	grid_z = floor_scale_z/scale_z
	
	grid = cellular_automata.generate_grid(grid_x, grid_z, 0.3)
	var new_grid =  cellular_automata.update_grid_two_d(grid,grid_x,grid_z,cellular_automata.get_game_of_live_rules())
	
	var x = floor_scale_x
	var z = floor_scale_z
	for row in grid:
		for value in row:
			if value == 1:
				var box = generate_box(material,x,3,z)
				self.add_child(box)
			x = x - (scale_x * 2)
		x = floor_scale_x
		z = z - (scale_z * 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var new_grid =  cellular_automata.update_grid_two_d(grid,grid_x,grid_z,cellular_automata.get_game_of_live_rules())
	#TODO generate new elements
	grid = new_grid
