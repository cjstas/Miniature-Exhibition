extends TileMapLayer

var bubbleSpawner:PackedScene = load("res://src/Creatures/Clean Particle Spawner.tscn")
var feedSpawner:PackedScene = load("res://src/Creatures/Food Particle Spawner.tscn")

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
	"mapPosition": Vector2i(0,0),
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

var creatureSet = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.phase_transition.connect(Callable(self, "_on_phase_transition"))
	Globals.action_on_creature.connect(Callable(self, "_on_creature_update"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func addCreatureData(vector:Vector2i, data):
	creatureSet[vector] = data.duplicate()
	creatureSet[vector]["globalPosition"] = map_to_local(vector)
	creatureSet[vector]["mapPosition"] = vector

func removeCreatureData(vector:Vector2i):
	creatureSet.erase(vector)

func getCreatureData(globalPosition:Vector2):
	return creatureSet[local_to_map(globalPosition)]

func getCreatureBeauty(mapPosition:Vector2i):
	#beauty = CreatureValue - health impairment value
	if !creatureSet.has(mapPosition):
		return 0
	var creature = creatureSet[mapPosition]
	var healthModifier = (creature["clean"] + creature["food"] + creature["anxiety"])
	healthModifier = healthModifier / (creature["maxClean"] + creature["maxFood"] + creature["maxAnxiety"])
	return creature["value"] * healthModifier

func calculateCreatureAnimState(location:Vector2i):
	var creature = creatureSet[location]
	#50% under the max makes the cutoff
	#Extra logic to avoid a random divide by zero error
	var foodratio:float = 0.0
	if creature["food"] != 0:
		foodratio = float(creature["food"] / creature["maxFood"])
	var anxietyratio:float = 0.0
	if creature["anxiety"] != 0:
		anxietyratio = float(creature["anxiety"] / creature["maxAnxiety"])
	var cleanratio:float = 0.0
	if creature["clean"] != 0:
		cleanratio = float(creature["clean"] / creature["maxClean"] )
	
	var threshold: float = 0.5
	var hungry = foodratio < threshold
	var anxious = anxietyratio < threshold
	var dirty = cleanratio < threshold
	
	#This is horrid. Replace it later if you do something with this. Switch case?
	if hungry && anxious && dirty:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["dha"] )
	elif hungry && anxious:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["ha"])
	elif hungry && dirty:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["dh"])
	elif anxious && dirty:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["da"])
	elif hungry:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["h"])
	elif dirty:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["d"])
	elif anxious:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["a"])
	else:
		Globals.Creatures.set_cell(location, creature["stateMap"]["source"],creature["stateMap"]["healthy"])

func calculateCreatureActions(location:Vector2i):
	var creature = creatureSet[location]
	if creature["productionTime"] <= 0:
		spawnResourceAtCreature(location)
		creature["productionTime"] += creature["maxProductionTime"]

func spawnResourceAtCreature(location):
	var newResource = creatureSet[location]["resource"].instantiate()
	add_child(newResource)
	newResource.position = Globals.Floor.map_to_local(location)

func triggerAnxiety(mapPosition):
	for neighbor in get_surrounding_cells(mapPosition):
		if !creatureSet.has(neighbor):
			continue
		#creatureSet[neighbor]["anxiety"] -= 1 #Commented out for the jam

#Events
func _on_phase_transition():
	pass

func _on_creature_update(location, action):
	if !creatureSet.has(location):
		return
	
	match action:
		"feed":
			creatureSet[location]["food"] = creatureSet[location]["maxFood"]
			var feed = feedSpawner.instantiate()
			add_child(feed)
			feed.position = map_to_local(location)
		"brush":
			var bubbles = bubbleSpawner.instantiate()
			add_child(bubbles)
			bubbles.position = map_to_local(location)
			creatureSet[location]["clean"] = creatureSet[location]["maxClean"]
	calculateCreatureAnimState(location)
	

func _update_creatureStats(delta):
	for key in creatureSet:
		var creature = creatureSet[key]
		#This might not work if Godot makes copies for for loops
		creature["clean"] -= delta
		creature["food"] -= delta
		creature["productionTime"] -= delta
		
		if creature["clean"] < 0:
			creature["clean"] = 0
		if creature["food"] < 0:
			creature["food"] = 0
		if creature["productionTime"] < 0:
			creature["productionTime"] = 0
		calculateCreatureActions(key)
		calculateCreatureAnimState(key)
