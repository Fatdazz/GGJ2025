extends Node3D

var view_sensitivity = 0.75
var body = 0.0
var pitch = 0.0
var speed = 0.15
const RAY_LENGTH = 1000.

@onready var ray_collider = $gimbal/innergimal/cam/RayCast3D
@onready var cam = $gimbal/innergimal/cam
@onready var world = $".."

func _ready():
	set_process(true)
	#set_fixed_process(true)
	set_process_input(true)
	
#func _enter_tree():
	#cam.make_current()
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(ie):
	#if ie.type == InputEvent.MOUSE_MOTION:
	if ie is InputEventMouseButton and ie.pressed and ie.button_index == 1:
		print(type_string(typeof(ray_collider)))
		if ray_collider.is_colliding():
			print("collide")
			var pos = ray_collider.get_collision_point()
			var norm = ray_collider.get_collision_normal()
			world.paint_uv(pos,norm,Color(190,57,83))
		#var camera3d = $gimbal/innergimal/cam
		#var space_state = get_world_3d().direct_space_state
		#var from = camera3d.project_ray_origin(ie.position)
		#var to = from + camera3d.project_ray_normal(ie.position) * RAY_LENGTH
		#var query = PhysicsRayQueryParameters3D.create(from, to)
		#query.collide_with_areas = true
		#var result = space_state.intersect_ray(query)
		#if !result.is_empty():
		#	print(result)
		#	get_node("/root/world").paint_uv(result["position"], result["normal"], Color(190,57,83))
	if ie is InputEventMouseMotion:
		var sensitivity = view_sensitivity
		set_body_rot(pitch - ie.get_relative().y * sensitivity, body - ie.get_relative().x * sensitivity)

func set_body_rot(npitch, nyaw):
	body = fmod(nyaw, 360)
	pitch = max(min(npitch, 90), -90)
	$gimbal.set_rotation(Vector3(0, deg_to_rad(body), 0))
	$gimbal/innergimal.set_rotation(Vector3(deg_to_rad(pitch), 0, 0))
		
func _process(delta):
	process_camera()
	if Input.is_action_pressed("shoot"):
		#var mousse_position = get_viewport().get_mouse_position()
		#var transform = get_viewport().get_camera().get_global_transform()
		#ray_collider.target_position = cam.project_local_ray_normal(mousse_position)
		ray_collider.force_raycast_update()
		
		if ray_collider.is_colliding():
			#print(ray_collider.get_collider().get_parent())
			var point = ray_collider.get_collision_point()
			var normal = ray_collider.get_collision_normal()
			#print("Ray colliding", point, normal)
			world.paint_uv(point, normal, Color(190,57,83))
		


func process_camera():
	var aim = get_node("gimbal/innergimal").get_global_transform().basis;
	var direction = Vector3();
	if Input.is_key_pressed(KEY_W):
		direction -= aim[2]
	if Input.is_key_pressed(KEY_S):
		direction += aim[2];
	if Input.is_key_pressed(KEY_A):
		direction -= aim[0];
	if Input.is_key_pressed(KEY_D):
		direction += aim[0];
	
	direction = direction.normalized()*speed;
	translate(direction)
