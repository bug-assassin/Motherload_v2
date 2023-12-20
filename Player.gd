extends CharacterBody2D

var GRAVITY= 9.81
var mass = 10
@export var damping = 0.01
@onready var tilemap: TileManager = get_node("/root/Node2D/TileMap")
# Called when the node enters the scene tree for the first time.
@onready var UI: UI = get_node("/root/Node2D/UI")
@onready var player_raycaster: RayCast2D = get_node("RayCast2D")
@onready var PlayerDmgAnim: AnimationPlayer = get_node("PlayerDmgAnim")

var inventory = {}

func get_mineral_amount_in_inventory(mineral: TileManager.MineralType):
	if mineral in inventory:
		return inventory[mineral]
func set_mineral_amount_in_inventory(mineral: TileManager.MineralType, amount):
	if not (mineral in inventory):
		inventory[mineral] = 0
	inventory[mineral] += amount
	UI.update_inventory(inventory)

#await get_tree().create_timer(cooldown).timeout
var hull = 100
var fuel = 100
var fuelDrainRate = 5
var is_moving: bool = false
var money = 10

func _ready():
	call_deferred("_setup")

func _setup():
	UI.update_fuel(fuel)
	UI.update_money(money)
	UI.register_on_sell_clicked(on_sell_minerals_clicked)

func on_sell_minerals_clicked():
	var total = 0
	for i in range(tilemap.minerals.size()):
		var mineral = tilemap.minerals[i]
		var amount = inventory[mineral.type] if mineral.type in inventory else 0
		var mineralTotalValue = amount * mineral.cost
		total += mineralTotalValue
	money += total
	inventory = {}
	UI.update_inventory(inventory)
	UI.update_money(money)

func _process(delta):
	if is_moving:
		fuel -= fuelDrainRate * delta
		UI.update_fuel(fuel)

var collisionLoc = []
func _draw():
	for col in collisionLoc:
		draw_rect(Rect2(to_local(col), Vector2(5, 5)), Color.GREEN)

var handlingDrill = false
var collisionRID = null
var collisionTime = 0
var collisionDur = 1
var originalPos = null
func _physics_process(delta):
	if handlingDrill:
		collisionTime += delta
		var percent = collisionTime / collisionDur * 100
		position = lerp(originalPos, tilemap.get_tile_origin(collisionRID), percent / 100)
		if percent >= 100:
			on_tile_mined(tilemap.get_tile_mineral(collisionRID), tilemap.get_tile_hardness(collisionRID))
			collisionTime = 0
			handlingDrill = false
			tilemap.delete_tile(collisionRID)
			$CollisionShape2D.disabled = false
		return
	var force = 15;
	var action_pressed = false
	if Input.is_action_pressed("up"):
		velocity.y -= 20 * delta
	elif Input.is_action_pressed("down"):
		action_pressed = true
		pass
	elif Input.is_action_pressed("left"):
		velocity.x += -force * delta
		action_pressed = true
	elif Input.is_action_pressed("right"):
		velocity.x += force * delta
		action_pressed = true
	is_moving = action_pressed
	velocity.y += GRAVITY*delta
	velocity.x *= (1-damping)
	
	var collision = move_and_collide(velocity)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		if Constants.DEBUG:
			collisionLoc.append(collision.get_position())
			self.queue_redraw()
		
	#player_raycaster.cast_to = Vector2.DOWN
	#player_raycaster.force_raycast_update()
	var is_on_ground = player_raycaster.is_colliding()
	if collision and action_pressed and ((collision.get_collider().light_mask & 1)) and is_on_ground:
		var shouldDel = false
		if collision.get_position() and Input.is_action_pressed("down") and collision.get_angle() == 0:
			shouldDel = true
		elif collision.get_position() and Input.is_action_pressed("left") and collision.get_angle() != 0:
			shouldDel = true
		elif collision.get_position() and Input.is_action_pressed("right") and collision.get_angle() != 0:
			shouldDel = true
		if shouldDel:
			$CollisionShape2D.disabled = true
			collisionRID = collision.get_collider_rid()
			originalPos = position
			collisionDur = 0.5 + int(sqrt(tilemap.get_tile_hardness(collisionRID)) / 6.0)
			handlingDrill = true

func on_tile_mined(mineral: TileManager.Mineral, type_hardness):
	if mineral.type != TileManager.MineralType.DIRT:
		set_mineral_amount_in_inventory(mineral.type, 1)
		UI.notification_ore_picked_up("1 " + mineral.name)

func on_dmg_taken(dmg):
	hull -= dmg
	if hull <= 0:
		print("Dead")
		
	PlayerDmgAnim.play("RESET")
	PlayerDmgAnim.play("anim_player_dmg")
