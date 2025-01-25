extends StaticBody2D

@export var VITESSE_ROTATION = 5.
@export var POWER = 0.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if VITESSE_ROTATION > 0.:
		$Sprite2D.rotate((VITESSE_ROTATION*2.*PI)/10. + delta)
 # Replace with function body.
