extends Node2D

@export var JUMP_VELOCITY = -200.
@export var VENTILO_VELOCITY = 50.
@export var VITESSES = [1., 2., 3.]
@onready var bubble = $Bubble

signal hurt
#TODO : diminuer la force avec la distance aux ventilo

func change_vitesse(i):
	JUMP_VELOCITY = -200. * VITESSES[i]
		
func _physics_process(delta: float) -> void:

	var vec = Vector2(0,0)
	# Handle jump.
	if Input.is_action_pressed("1_right"):
		change_vitesse(0)
		blow(1)
	if Input.is_action_pressed("1_left"):
		change_vitesse(0)
		blow(-1)
	if Input.is_action_pressed("2_right"):
		change_vitesse(1)
		blow(1)
	if Input.is_action_pressed("2_left"):
		change_vitesse(1)
		blow(-1)
	if Input.is_action_pressed("3_right"):
		change_vitesse(2)
		blow(1)
	if Input.is_action_pressed("3_left"):
		change_vitesse(2)
		blow(-1)
	if not bubble.is_on_floor():
		bubble.velocity += bubble.get_gravity() * delta
	bubble.move_and_slide()

func blow(i):
	bubble.velocity.x = i * -VENTILO_VELOCITY
	bubble.velocity.y = -VENTILO_VELOCITY + JUMP_VELOCITY
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		hurt.emit(0)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacles"):
		hurt.emit(1)
