extends Node2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const VENTILO_ANGLE = PI/4
const VENTILO_VELOCITY = -200.

@onready var bubble = $Bubble


# Active ventilo. 1 pour droite, -1 à gauche
# renvoie le vecteur de déplacement
func wind(direction):
	var vec = Vector2(cos(VENTILO_ANGLE), 1.) * direction * VENTILO_VELOCITY

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not bubble.is_on_floor():
		bubble.velocity += bubble.get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("right"):
		#bubble.velocity.y = JUMP_VELOCITY
		bubble.velocity.x *= cos(VENTILO_ANGLE) * VENTILO_VELOCITY
		bubble.velocity.y = VENTILO_VELOCITY
	if Input.is_action_pressed("left"):
		#bubble.velocity = JUMP_VELOCITY
		bubble.velocity.x *= -cos(VENTILO_ANGLE) * VENTILO_VELOCITY
		bubble.velocity.y = VENTILO_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		bubble.velocity.x = direction * SPEED
	else:
		bubble.velocity.x = move_toward(bubble.velocity.x, 0, SPEED)

	bubble.move_and_slide()


	
