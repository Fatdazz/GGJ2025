extends Node3D


@export var Bullet:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var pos = event.get_position()
		var b = Bullet.instantiate()
		add_child(b)
		b.set_position(event.position)
		#b.transform = $Cannon/Muzzle.global_transform
		b.velocity = -b.transform.basis.z * b.muzzle_velocity
