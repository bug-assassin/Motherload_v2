extends CanvasLayer
class_name UI

@onready var money_lbl = %Money
@onready var hull_progress = %Hull
@onready var fuel_progress = %Fuel
@onready var ore_notification_label = get_node("Control/OreNotificationLabel")
@onready var ore_notification_anim = get_node("Control/OreNotificationLabel/AnimationPlayer")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_money(value):
	money_lbl.text = "$" + str(value)

func update_fuel(percentage):
	fuel_progress.value = int(percentage)
func update_hull(percentage):
	hull_progress.value = int(percentage)

func notification_ore_picked_up(str: String):
	ore_notification_label.text = str
	ore_notification_anim.play("RESET")
	ore_notification_anim.play("ore_pickup_anim")
