extends KinematicBody2D

var left  = Vector2(-1, 0)
var right = Vector2( 1, 0)
var up    = Vector2(0, -1)
var down  = Vector2(0,  1)

var hasShot = false

const MOVE_SPEED = 120
var run_mult = 1

onready var timer = Timer.new()

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)
	timer.start()

func _fixed_process(delta):
	#Shooting
	if Input.is_action_pressed("shoot") and !self.hasShot:
		shoot()
	
	#Reseting velocity
	var velocity = Vector2()
	
	#Moving left and right
	if Input.is_action_pressed("move_left"):
		velocity += left
		
	elif Input.is_action_pressed("move_right"):
		velocity += right
	
	#Moving up and down
	if Input.is_action_pressed("move_up"):
		velocity += up
	elif Input.is_action_pressed("move_down"):
		velocity += down
	
	velocity *= run_mult
	var motion = (velocity * MOVE_SPEED) * delta
	motion = move(motion)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	pass

func shoot():
	var bullet = load("res://Bullet/Bullet.tscn").instance()
	get_tree().get_root().add_child(bullet)
	bullet.set_pos(self.get_global_pos())
	
	bullet.connect("body_enter", self, "hitEnemy", [ bullet ], CONNECT_ONESHOT)
	hasShot = true
	timer.set_wait_time( 0.5 )
	timer.start()

func hitEnemy(bullet, body ):
	bullet.queue_free()
	print(body.queue_free())

func _on_timer_timeout():
	hasShot = false