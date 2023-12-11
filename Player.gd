extends CharacterBody2D

var GRAVITY= 9.81
var mass = 10
@export var GravityOn: bool = true
@export var damping = 0.01
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Start")
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("toggleGravity"):
		GravityOn = !GravityOn
		print("Gravity changed")
		
func _physics_process(delta):
	var force = 15;
	if Input.is_action_pressed("up"):
		velocity.y -= 20 * delta
	elif Input.is_action_pressed("down"):
		pass
	elif Input.is_action_pressed("left"):
		velocity.x += -force * delta
	elif Input.is_action_pressed("right"):
		velocity.x += force * delta
	if GravityOn:
		velocity.y += GRAVITY*delta
	velocity.x *= (1-damping)
	var collision = move_and_collide(velocity)
	if collision:
		velocity = velocity.slide(collision.get_normal())
