extends Area2D

@onready var Sprite = $Sprite

var speed = 20
var target:Vector2 = Vector2(0,0)
var happiness:float = 5.0 #they start out with something above zero


var path: Array

func _physics_process(delta):
	global_position = global_position.move_toward(target, delta * speed)
	happiness -= delta * Globals.expectations
	if global_position == target:
		path.pop_front()
		if path.size() > 0:
			target = Globals.Floor.map_to_local(path.front())
		else:
			exit()
	#print(position)

func _enter_tree():
	target = Globals.Floor.map_to_local(path.pop_front())

# Called when the node enters the scene tree for the first time.
func _ready():
	#Pick a random Color
	var animations = Sprite.sprite_frames.get_animation_names()
	Sprite.play(Array(animations).pick_random())

func exit():
	@warning_ignore("narrowing_conversion") #idc enough to round it
	Globals.popularity +=happiness
	#print(happiness) #Debug for balancing
	queue_free()


func _on_body_entered(body):
	#body position is useless because it just gives us the tilemap's location (0,0)
	if body.has_method("getTileBeauty"):
		happiness += body.getTileBeauty(self.global_position)
	if body.has_method("triggerAnxiety"):
		body.triggerAnxiety(self.global_position)
