extends CharacterBody2D

var GRAVITY= 9.81
var mass = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Start")
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_pressed("up"):
		velocity.y -= 1 * delta
	elif Input.is_action_pressed("down"):
		velocity.y += 1 * delta
	elif Input.is_action_pressed("left"):
		velocity.x += -1 * delta
		print("LEFT")
	elif Input.is_action_pressed("right"):
		velocity.x += 1 * delta
		
func _physics_process(delta):
	#velocity.y += GRAVITY*delta*mass
	move_and_collide(velocity)
