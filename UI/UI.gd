extends CanvasLayer
class_name UI

@onready var money_lbl = %Money
@onready var hull_progress = %Hull
@onready var fuel_progress = %Fuel
@onready var inventory_fuel = %FuelInventory
@onready var ore_notification_label = %OreNotificationLabel
@onready var ore_notification_anim = ore_notification_label.get_node("AnimationPlayer")
@onready var inventory = get_node("Inventory")

func _ready():
	call_deferred("_setup")

func _setup():
	inventory.visible = false
	
func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.visible = !inventory.visible

func update_money(value):
	money_lbl.text = "$" + str(value)

func update_fuel(percentage):
	fuel_progress.value = int(percentage)
	inventory_fuel.value = int(percentage)
	
func update_hull(percentage):
	hull_progress.value = int(percentage)

func notification_ore_picked_up(str: String):
	ore_notification_label.text = str
	ore_notification_anim.play("RESET")
	ore_notification_anim.play("ore_pickup_anim")
