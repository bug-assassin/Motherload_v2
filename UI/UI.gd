extends CanvasLayer
class_name UI

@onready var money_lbl = %Money
@onready var hull_progress = %Hull
@onready var fuel_progress = %Fuel
@onready var inventory_fuel = %FuelInventory
@onready var ore_notification_label = %OreNotificationLabel
@onready var ore_notification_anim = ore_notification_label.get_node("AnimationPlayer")
@onready var inventory_ui = get_node("Inventory")

#TODO, remove this
@onready var tileManager: TileManager = get_node("/root/Node2D/TileMap")


func _ready():
	call_deferred("_setup")

func _setup():
	inventory_ui.visible = false
	update_inventory({})
	
func _input(event):
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible

func update_inventory(inventory: Dictionary):
	var item_list := %SellItemList
	item_list.clear()
	var total = 0
	for i in range(tileManager.minerals.size()):
		var mineral = tileManager.minerals[i]
		var amount = inventory[mineral.type] if mineral.type in inventory else 0
		var mineralTotalValue = amount * mineral.cost
		item_list.add_item(str(amount) + " " + mineral.name + " x " + str(mineral.cost) + " = " + str(mineralTotalValue))
		total += mineralTotalValue
	item_list.add_item("Total: " + str(total))
	item_list.set_item_metadata(-1, total)

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
	
func register_on_sell_clicked(callable):
	%SellAllMinerals.connect("pressed", callable)
