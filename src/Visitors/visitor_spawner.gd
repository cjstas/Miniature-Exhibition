extends Marker2D

@export var Visitor: PackedScene

var spawning: bool = false
var timeLeft: float = 0.0
var timeUntilNextSpawn: float = 0.0
var popularityLeft: int = 0

var NavArray:Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawning:
		timeLeft-=delta
		timeUntilNextSpawn -= delta
		
		if timeLeft < 0:
			#Do final spawning if needed
			spawnVisitor(popularityLeft)
			popularityLeft = 0
			spawning = false
			return
		if timeUntilNextSpawn < 0:
			spawnVisitor(1)
			popularityLeft -=1
			Globals.money += 10
			timeUntilNextSpawn = timeLeft / popularityLeft

func spawnVisitor(number=1):
	for n in number:
		var newVisitor = Visitor.instantiate()
		newVisitor.path = NavArray.duplicate()
		#newVisitor.position = position
		add_child(newVisitor)
