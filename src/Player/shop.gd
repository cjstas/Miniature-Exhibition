extends Control

#Main Panels
@onready var ExpandedPanel = $ExpandedPanel
@onready var CollapsedPanel = $CollapsedPanel

var basicCreatureStats = {
	"maxClean": 30.0,
	"clean": 30.0,
	"maxFood": 40.0,
	"food": 40.0,
	"maxAnxiety": 10.0,
	"anxiety": 10.0,
	"maxProductionTime": 15.0,
	"productionTime": 15.0,
	"resource" : preload("res://src/Creatures/resource_basic.tscn"),
	"resourceName": "basic resource",
	"value" : 5.0,
	"name": "BubbleGum Star",
	"mapPosition": Vector2i(-1,-1),
	"globalPosition": Vector2(0.0,0.0),
	"icon": preload("res://assets/creatures/bubblegumStar/bubblegumStar-icon.png"),
	"Atlas": Vector2(0,0),
	"Source": 2,
	"stateMap" : {
		"source": 2,
		"healthy": Vector2i(0,0),
		"d": Vector2i(0,1),
		"h": Vector2i(0,2),
		"a": Vector2i(0,3),
		"dh": Vector2i(0,4),
		"da": Vector2i(0,5),
		"ha": Vector2i(0,6),
		"dha": Vector2i(0,7),
	}
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Events


func _on_check_button_toggled(toggled_on):
	ExpandedPanel.visible = toggled_on
	CollapsedPanel.visible = !toggled_on


func _on_info_basic_pressed():
	Globals.selected_creature.emit(basicCreatureStats, true)


func _on_buy_basic_pressed():
	if Globals.basic_resources >= 2:
		Globals.basic_resources -=2
		if !Globals.objectInHand.is_empty():
				Globals.inventoryCreatures.append(Globals.objectInHand)
		Globals.clearobjectInHand()
		Globals.objectInHand = basicCreatureStats.duplicate()
		Globals.selected_action = Callable(Actions, "place")
		Globals.cursor.setStaticCursor("hold")
		Globals.cursor.updateHolding(Globals.objectInHand["icon"])
		Globals.cursor.holdingVisible = true
