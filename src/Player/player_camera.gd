extends Camera2D

@export var Tilemap: TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var x = 480.0/(32.0*18.0)
	var y = 270.0/(32.0*10.0)
	set_zoom(Vector2(x, y))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
