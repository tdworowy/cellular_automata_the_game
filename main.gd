extends Spatial

const scale_x = 2
const scale_z = 2
const red = Color( 1, 0, 0, 1 )


func generate_grid(x:int,z:int, prob_of_one:float):
	var grid = []
	for i in range(x):
		var row = []
		for j in range(z):
			randomize()
			var rand_int = rand_range(1,10) 
			if rand_int <= int(prob_of_one * 10):
				row.append(1)
			else:
				row.append(0)
		grid.append(row)
	return grid			
	

func generate_box(material:SpatialMaterial,x:int=1,y:int=1,z:int=1):
	var static_body = StaticBody.new()
	var colision_shape = CollisionShape.new()
	var box = CSGBox.new() 
	
	static_body.scale.x = scale_x 
	static_body.scale.y = 5
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
	
	var grid = generate_grid(floor_scale_x/scale_x, floor_scale_z/scale_z, 0.3)
	var x = floor_scale_x
	var z = floor_scale_z
	for row in grid:
		for value in row:
			if value == 1:
				var box = generate_box(material,x,1,z)
				self.add_child(box)
			x = x - (scale_x * 2)
		x = floor_scale_x
		z = z - (scale_z * 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
