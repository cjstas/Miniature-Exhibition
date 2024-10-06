extends CharacterBody2D

@onready var DesignPhaseHud = $HUDs/DesignPhaseHud
@onready var OpenPhaseHud = $HUDs/OpenPhaseHud
@onready var ProgressPhase = $HUDs/ProgressPhase
@onready var Cursor = $Cursor
@onready var Holding = $Cursor/Image
@onready var Camera = $PlayerCamera

var triggerPhaseTransition: Callable
var cameraSpeed = 200.0
var cameraZoom = 1.0

func _ready():
	Globals.cursor = Cursor
	Cursor.setStaticCursor("point")
	Cursor.holding = Holding

func _input(event):
	if event.is_action_pressed("left_click"):
		Globals.selected_action.call(get_global_mouse_position())
	elif event.is_action_released("left_click"):
		Actions.releaseAction()
	elif event.is_action_pressed("right_click"):
		Globals.selected_action = Globals.default_action
		if !Globals.objectInHand.is_empty():
			Globals.inventoryCreatures.append(Globals.objectInHand.duplicate())
			Globals.clearobjectInHand()
		#Hide HUD on deselect
		Globals.selected_creature.emit({}, false)
	elif event.is_action_pressed("zoom_in"):
		cameraZoom += 0.1
		if cameraZoom > 3:
			cameraZoom = 3
		Camera.zoom = Vector2(cameraZoom, cameraZoom)
	elif event.is_action_pressed("zoom_out"):
		cameraZoom -= 0.1
		if cameraZoom < 1:
			cameraZoom = 1
		Camera.zoom = Vector2(cameraZoom, cameraZoom)

func _process(_delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * (cameraSpeed * (1.0/cameraZoom))
	move_and_slide()

func set_phase_transition(callable):
	triggerPhaseTransition = callable

func set_timer(timer:Timer):
	OpenPhaseHud.timer = timer

#Events
func _on_progress_phase_pressed():
	Globals.isDesignPhase = !Globals.isDesignPhase
	Globals.phase_transition.emit()
	Globals.selected_creature.emit({}, false) #Close the Selection HUD
	if (Globals.isDesignPhase):
		DesignPhaseHud.visible = true
		OpenPhaseHud.visible = false
		Globals.default_action = Callable(Actions, "select")
		Globals.selected_action = Globals.default_action
	else:
		DesignPhaseHud.visible = false
		OpenPhaseHud.visible = true
		ProgressPhase.visible = false #we only set visibility when entering this phase. Another menu will make this visible later
		Globals.default_action = Callable(Actions, "select")
		Globals.selected_action = Globals.default_action

func _on_open_phase_end():
	pass
