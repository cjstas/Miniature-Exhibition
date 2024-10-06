extends Button

var objectData


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_ObjectData(data):
	objectData = data
	
	#Set the Icon
	icon = objectData["icon"]

func _on_pressed():
	Globals.clearobjectInHand()
	Globals.objectInHand.merge(objectData)
	Globals.inventoryCreatures.erase(objectData)
	Globals.selected_action = Callable(Actions, "place")
	Globals.cursor.setStaticCursor("hold")
	Globals.cursor.holdingVisible = true
	Globals.cursor.updateHolding(objectData["icon"])
