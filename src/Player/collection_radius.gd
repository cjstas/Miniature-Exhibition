extends Node2D

var lifespan = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if lifespan > 0:
		lifespan -= 1
		return
	queue_free()


func _on_area_2d_area_entered(area):
	#kill the area
	area.queue_free()
	#increment our resources
	Globals.basic_resources +=1
	print("resource Collected")
