extends Control

#Main Panels
@onready var ExpandedPanel = $ExpandedPanel
@onready var CollapsedPanel = $CollapsedPanel

@onready var itemList = $ExpandedPanel/ItemList
var creatureButton = load("res://src/Creatures/creatureButton.tscn")

var currentData = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#only update if new data
	if currentData != Globals.inventoryCreatures:
		updateInventory()

func updateInventory():
	#Clear existing children
	for child in itemList.get_children():
		child.queue_free()
	currentData.clear()
	currentData.append_array(Globals.inventoryCreatures)
	for item in currentData:
		var button = creatureButton.instantiate()
		button.set_ObjectData(item)
		itemList.add_child(button)
		

#Events


func _on_check_button_toggled(toggled_on):
	ExpandedPanel.visible = toggled_on
	CollapsedPanel.visible = !toggled_on
