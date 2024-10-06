extends CanvasLayer

@onready var Name = $Background/Contents/Name
@onready var Clean = $Background/Contents/cleanlinessBox/Clean
@onready var Food = $Background/Contents/foodBox/Food
@onready var Stress = $Background/Contents/stressBox/Stress
@onready var Production = $Background/Contents/productionBox/Production
@onready var Produce = $Background/Contents/ProduceBox/Produce
@onready var Value = $Background/Contents/valueBox/Value
@onready var Move = $Background/Contents/MoveButton
@onready var Delete = $Background/Contents/Delete

var stats

func _ready():
	Globals.selected_creature.connect(Callable(self, "_on_creature_selected"))


func _on_creature_selected(creatureStats, HUDVisible):
	stats = creatureStats
	visible = HUDVisible

func _process(_delta):
	#Do nothing if invisible (because no stats)
	if !visible:
		return
	#Display Stats
	Clean.text = str(round(stats["clean"])) + " / " + str(round(stats["maxClean"]))
	Food.text = str(round(stats["food"])) + " / " + str(round(stats["maxFood"]))
	Stress.text = str(stats["maxAnxiety"] - stats["anxiety"])
	Production.text = str(round(stats["productionTime"]))
	Produce.text = stats["resourceName"]
	Value.text = str(stats["value"])
	
	#Enable/disable interaction buttons (keep here for now in case someone keeps selection through phase)
	if !Globals.isDesignPhase || stats["mapPosition"] == Vector2i(-1,-1):
		Move.disabled = true
		Delete.disabled = true
	else:
		Move.disabled = false
		Delete.disabled = false
	
	#set visible
	visible = true

func _on_move_button_pressed():
	Actions.grab(stats["globalPosition"])
	visible = false


func _on_delete_pressed():
	Globals.inventoryCreatures.append(Globals.Creatures.getCreatureData(stats["globalPosition"]))
	Globals.Creatures.set_cell(stats["mapPosition"], -1)
	visible = false
