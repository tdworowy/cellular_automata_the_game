var parent:Spatial
var scale_x:int
var scale_y:int
var scale_z:int
var materials:Array = []
const red = Color( 1, 0, 0, 1 )
const green = Color( 0, 1, 0, 1 )
const blue = Color( 0, 0, 1, 1 )
const black = Color( 0, 0, 0, 1 )
const gold = Color( 1, 0.84, 0, 1 )
const purple = Color( 0.63, 0.13, 0.94, 1 )

const colors:Array = [red,green,blue,black,gold,purple]

func _init(parent:Spatial, scale_x:int, scale_y:int, scale_z:int):
	self.parent = parent
	self.scale_x= scale_x
	self.scale_y= scale_y
	self.scale_z= scale_z


func generate_materials(states:Array=[0,1]):
	for state in states:
		var material = SpatialMaterial.new()
		material.albedo_color = colors[state]
		materials.append(material)
	
	
func generate_box(x:int=1, y:int=1, z:int=1):
	var static_body = StaticBody.new()
	var colision_shape = CollisionShape.new()
	var box = CSGBox.new() 
	
	static_body.scale.x = self.scale_x 
	static_body.scale.y = self.scale_y
	static_body.scale.z = self.scale_z
	
	static_body.translation.x = x
	static_body.translation.y = y
	static_body.translation.z = z
	
	colision_shape.set_shape(BoxShape.new())
	colision_shape.add_child(box)
	static_body.add_child(colision_shape)
	
	static_body.add_to_group(str(x)+"_"+str(z))
	
	return static_body

func generate_boxes(grid:Array, floor_scale_x:int, floor_scale_z:int):
	var x = floor_scale_x
	var z = floor_scale_z
	for row in grid:
		for value in row:
			var box = generate_box(x, 3, z)
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
			set_visibility_row(row,x,z)
		x = floor_scale_x
		z = z - (self.scale_z * 2)
		
func set_visibility_row(row:Array,x:int,z:int):
		var node
		var visibility
		for value in row:
			node = self.parent.get_tree().get_nodes_in_group(str(x)+"_"+str(z))[0]
			visibility = node.is_visible()
			
			if value == 0 and visibility:
				node.visible = false
				node.get_children()[0].disabled = true 
			
			if value !=0 and !visibility:
				node.visible = true
				node.get_children()[0].get_children()[0].material = materials[value - 1] # performece problems
				node.get_children()[0].disabled = false 
			x = x - (self.scale_x * 2)
