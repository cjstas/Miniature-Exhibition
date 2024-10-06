extends Control

#Main Panels
@onready var ExpandedPanel = $ExpandedPanel
@onready var CollapsedPanel = $CollapsedPanel

#Data Points
@onready var Money = $ExpandedPanel/VBoxContainer/Money/Money
@onready var R1 = $ExpandedPanel/VBoxContainer/Resource1/R1
@onready var Popularity = $ExpandedPanel/VBoxContainer/Popularity/Popularity
@onready var Expectation = $ExpandedPanel/VBoxContainer/Expectation/Expectation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#update variables
	Money.text = str(round(Globals.money))
	R1.text = str(round(Globals.basic_resources))
	Popularity.text = str(round(Globals.popularity))
	Expectation.text = str(round(Globals.expectations))


func _on_check_button_toggled(toggled_on):
	ExpandedPanel.visible = toggled_on
	CollapsedPanel.visible = !toggled_on
