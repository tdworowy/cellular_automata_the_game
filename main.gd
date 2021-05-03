extends Spatial

const scale_x = 2
const scale_z = 2
const red = Color( 1, 0, 0, 1 )


func generate_box(x:int=1,z:int=1):
	var static_body = StaticBody.new()
	var colision_shape = CollisionShape.new()
	var box = CSGBox.new() 
	
	static_body.scale.x = scale_x 
	static_body.scale.y = 5
	static_body.scale.z = scale_z
	
	static_body.translation.x = x
	static_body.translation.y = 1
	static_body.translation.z = z
	
	var material = SpatialMaterial.new()
	material.albedo_color = red
	box.material = material
	
	colision_shape.set_shape(BoxShape.new())
	colision_shape.add_child(box)
	static_body.add_child(colision_shape)
	return static_body

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var box = generate_box()
	self.add_child(box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
