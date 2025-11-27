extends Node3D

@onready var free_cam_node: Node3D = $"."
@onready var camera_rotation_x_node: Node3D = $CameraRotationY/CameraRotationX
@onready var camera_rotation_y_node: Node3D = $CameraRotationY
@onready var camera_location_z_node: Node3D = $CameraRotationY/CameraRotationX/CameraLocationZ

var middle_mouse_pressed: bool = false
var shift_pressed: bool = false
var right_mouse_pressed: bool = false
var input_dir: Vector2
var MOUSE_SENSITIVITY: float = .005
var WALK_SPEED: float = 5
var fov: float
var zoom: float = 0.5:
	set(new_value):
		zoom =  max(new_value, 0.5)
		#camera_location_z_node.position.z = lerp(camera_location_z_node.position.z, zoom, .1)


var camera_rotation: Vector2:
	set(new_value):
		camera_rotation = new_value
		camera_rotation_x_node.rotation.x = camera_rotation.x
		camera_rotation_y_node.rotation.y = camera_rotation.y



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#zoom = 2
	pass # Replace with function body.

func _process(delta: float) -> void:
	if right_mouse_pressed:
		walk_camera(delta)

func _physics_process(delta: float) -> void:
	camera_location_z_node.position.z = lerp(camera_location_z_node.position.z, zoom, .1)
	print(InputEventMouseMotion)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Mouse_Up"): #zoom in
		zoom -= .2
	if Input.is_action_just_pressed("Mouse_Down"): #zoom out
		zoom += .2
	middle_mouse_pressed = Input.is_action_pressed("Middle_Mouse")
	shift_pressed = Input.is_action_pressed("Shift")
	right_mouse_pressed = Input.is_action_pressed("Right_Mouse")
	input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	#print(input_dir)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and middle_mouse_pressed == true and shift_pressed == false: #mouse camera movement
		camera_rotation.y += (-event.relative.x * MOUSE_SENSITIVITY)
		camera_rotation.x += (-event.relative.y * MOUSE_SENSITIVITY)
		camera_rotation.x = clamp(camera_rotation.x, deg_to_rad(-90), deg_to_rad(90))
		print("rotating")
	if event is InputEventMouseMotion and shift_pressed == true and middle_mouse_pressed == true and right_mouse_pressed == false:
		pan_camera(event)
		print("panning")

func pan_camera(event: InputEvent) -> void:
	var cam_basis = camera_location_z_node.global_basis #gets the global basis of the camera node after the rotations
	var up = cam_basis.y
	var right= cam_basis.x
	var movement = -right * event.relative.x * MOUSE_SENSITIVITY * (zoom / 3) #moves object based on the relative x axis
	movement -= up * -event.relative.y *  MOUSE_SENSITIVITY * (zoom / 3) #moves object based on relative y axis
	global_translate(movement) #moves the camera

func walk_camera(delta) -> void:
	var cam_basis = camera_location_z_node.global_basis #gets the global basis of the camera node after the rotations
	var forward = cam_basis.z
	var right= cam_basis.x
	var movement: Vector3
	movement = forward * input_dir.y * WALK_SPEED * delta
	movement += right * input_dir.x * WALK_SPEED * delta
	print(movement)
	global_translate(movement)
	pass
