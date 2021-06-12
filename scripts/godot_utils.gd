var parent
var scale_x
var scale_y
var scale_z

func _init(parent:Spatial, scale_x:int ,scale_y:int, scale_z:int):
	self.parent = parent
	self.scale_x= scale_x
	self.scale_y= scale_y
	self.scale_z= scale_z

func generate_box(material:SpatialMaterial, x:int=1, y:int=1, z:int=1):
	var static_body = StaticBody.new()
	var colision_shape = CollisionShape.new()
	var box = CSGBox.new() 
	
	static_body.scale.x = self.scale_x 
	static_body.scale.y = self.scale_y
	static_body.scale.z = self.scale_z
	
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
			self.parent.add_child(box)
			x = x - (self.scale_x * 2)
		x = floor_scale_x
		z = z - (self.scale_z * 2)
		
func set_visibility(grid:Array, floor_scale_x:int, floor_scale_z:int):
	var x = floor_scale_x
	var z = floor_scale_z
	var node
	var visibility
	 
	for row in grid:
		for value in row:
			node = self.parent.get_tree().get_nodes_in_group(str(x)+"_"+str(z))[0]
			visibility = node.is_visible()
			
			if value == 0 and visibility:
				node.visible = false
				node.get_children()[0].disabled = true 
			
			if value == 1 and !visibility:
				node.visible = true
				node.get_children()[0].disabled = false 

			x = x - (self.scale_x * 2)
		x = floor_scale_x
		z = z - (self.scale_z * 2)
