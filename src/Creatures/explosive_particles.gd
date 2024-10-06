extends GPUParticles2D

@onready var existence = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	existence.start(lifetime)


func _on_timer_timeout():
	queue_free()
