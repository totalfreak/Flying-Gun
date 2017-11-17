extends RigidBody2D


func _ready():
	set_fixed_process(true)


func _fixed_process(delta):
	self.set_linear_velocity(Vector2(200, 0))