extends Node2D

@export var JUMP_VELOCITY = -50.
@export var VENTILO_VELOCITY = 10.
@export var VITESSES = [1., 2., 3.]

@onready var bubble = $Bubble

var velocity
signal hurt
#TODO : diminuer la force avec la distance aux ventilo

func change_vitesse(i):
	velocity = JUMP_VELOCITY * (VITESSES[i]/3.)
		
func _physics_process(delta: float) -> void:

	velocity = JUMP_VELOCITY
	# Handle jump.
	if Input.is_action_pressed("1_right"):
		blow(1)
	if Input.is_action_pressed("1_left"):
		blow(-1)
	if Input.is_action_pressed("2_right"):
		blow(2)
	if Input.is_action_pressed("2_left"):
		blow(-2)
	if Input.is_action_pressed("3_right"):
		blow(3)
	if Input.is_action_pressed("3_left"):
		blow(-3)
	if not bubble.is_on_floor():
		bubble.velocity += bubble.get_gravity() * delta
	bubble.move_and_slide()

func blow(i):
	bubble.velocity.x = i * -VENTILO_VELOCITY
	bubble.velocity.y = -VENTILO_VELOCITY + velocity
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		hurt.emit(0)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacles"):
		hurt.emit(1)
