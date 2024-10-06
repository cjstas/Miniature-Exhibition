extends Node2D

#Brush
var brushFR = 8.0
var brush1 = load("res://assets/Player/brush1.png")
var brush2 = load("res://assets/Player/brush2.png")
var brush3 = load("res://assets/Player/brush3.png")
var brush4 = load("res://assets/Player/brush4.png")

#Feed
var FeedFR = 8.0
var feed1 = load("res://assets/Player/feed1.png")
var feed2 = load("res://assets/Player/feed2.png")
var feed3 = load("res://assets/Player/feed3.png")
var feed4 = load("res://assets/Player/feed4.png")

#Hands
var grab = load("res://assets/Player/grab.png")
var hand = load("res://assets/Player/hand.png")
var hold = load("res://assets/Player/hold.png")
var point = load("res://assets/Player/point.png")

#dynamic variables
var currentIcon = point
var currentHotspot = Vector2(0,0)
var currentFR = 8.0
var currentFrame:int = 0
var animating:bool = false
var animationLoop:Array = []
var timeUntilNextFrame:float = 0.0

var holding
var holdingVisible = false

func _process(delta):
	if animating && animationLoop.size() > 0:
		timeUntilNextFrame -= delta
		if timeUntilNextFrame < 0:
			timeUntilNextFrame = 1.0/currentFR
			currentFrame +=1
			#Loop if necessary
			if currentFrame > animationLoop.size()-1:
					currentFrame = 0
			currentIcon = animationLoop[currentFrame]
			updateCursor()
	if is_instance_valid(holding):
		holding.visible = holdingVisible
		holding.global_position = get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("left_click") && animationLoop.size() > 0:
		animating = true
	elif event.is_action_released("left_click") && animationLoop.size() > 0:
		animating = false
		currentFrame = 0
		currentIcon = animationLoop[0]

func updateCursor():
	Input.set_custom_mouse_cursor(currentIcon, Input.CURSOR_ARROW, currentHotspot)

func setCursorAsBrush():
	animationLoop.clear()
	animationLoop.append_array([brush1, brush2, brush3, brush4])
	currentIcon = animationLoop[0]
	currentFR = brushFR
	animating = false
	currentHotspot = Vector2(16,16)
	updateCursor()


func setCursorAsFeed():
	animationLoop.clear()
	animationLoop.append_array([feed1, feed2, feed3, feed4])
	currentIcon = animationLoop[0]
	currentFR = brushFR
	animating = false
	currentHotspot = Vector2(16,16)
	updateCursor()


func setStaticCursor(cursor):
	animationLoop.clear()
	animating = false
	match cursor:
		"grab": 
			currentIcon = grab
			currentHotspot = Vector2(16,16)
		"hand": 
			currentIcon = hand
			currentHotspot = Vector2(16,16)
		"hold": 
			currentIcon = hold
			currentHotspot = Vector2(16,16)
		"point": 
			currentIcon = point
			currentHotspot = Vector2(12,4)
	updateCursor()

func updateHolding(texture):
	if is_instance_valid(holding):
		holding.texture = texture
