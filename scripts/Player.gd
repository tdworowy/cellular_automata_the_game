extends KinematicBody

var move_speed:float = 40

var min_look_angle:float = -90
var max_look_angle:float = 90
var sensitivity:float = 7
var velocity:Vector3 = Vector3()
var mouse_delta: Vector2 = Vector2()

onready var camera: Camera = get_node("Camera")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.x = 0
	velocity.z = 0
	var input:Vector3 = Vector3()
	if Input.is_action_pressed("forward"):
		input.y+=1
	if Input.is_action_pressed("back"):
		input.y-=1	
	if Input.is_action_pressed("left"):
		input.x+=1		
	if Input.is_action_pressed("right"):
		input.x-=1		
	if Input.is_action_pressed("up"):
		input.z+=1		
	if Input.is_action_pressed("down"):
		input.z-=1		
	input.normalized();
	
	var forward = global_transform.basis.z;
	var right = global_transform.basis.x;
	var up = global_transform.basis.y;
	
	var relativeDirection = (forward * input.y + right * input.x + input.z * up);
	velocity.x = relativeDirection.x * move_speed
	velocity.z = relativeDirection.z * move_speed
	velocity.y = relativeDirection.y * move_speed	
	
	velocity = move_and_slide(velocity, Vector3.UP);
	
func _process(delta):
	camera.rotation_degrees.x -= mouse_delta.y * sensitivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_look_angle, max_look_angle)
	rotation_degrees.y -= mouse_delta.x * sensitivity * delta
	mouse_delta = Vector2()

func _input(event):
	if event is InputEventMouseMotion	:
		mouse_delta = event.relative
