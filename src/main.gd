extends Node2D

@onready var Creatures = $Creatures
@onready var Floor = $Floor
@onready var Player = $Player
@onready var ActionTimer = $ActionTimer
@onready var OpenPhaseTimer = $OpenPhaseTimer
@onready var VisitorSpawner = $VisitorSpawner

@export var collectionRadius: PackedScene

var updateTiming = 0.5
var deltaSinceUpdate = 0
var peopleSinceUpdate = 0
var maxVisitingTime = 120 #2 minutes

var checkForVisitors = false
var creatureUpdates = false

var navigationArray: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	#Pass The Tilemaps and Timer to the Global Variables
	Globals.Floor = Floor
	Globals.Creatures = Creatures
	Globals.ActionTimer = ActionTimer
	Globals.collection_spawn = Callable(self, "spawn_collection_radius")
	
	
	#Pass the Phase Calls to the Player (for HUD updates)
	Player.set_phase_transition(Callable(self, "transition_phase"))
	Globals.phase_transition.connect(Callable(self, "transition_phase"))
	Player.set_timer(OpenPhaseTimer)
	
	#Add our starting guy
	Globals.inventoryCreatures.append(Globals.Creatures.basicCreatureStats)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if checkForVisitors:
		if !doVisitorsExist():
			#if no more visitors we don't need to check for them anymore
			checkForVisitors = false
			creatureUpdates = false
			#Unide the phase transition button
			Player.ProgressPhase.visible = true
	if creatureUpdates:
		deltaSinceUpdate += delta
		if deltaSinceUpdate > updateTiming:
			Creatures._update_creatureStats(deltaSinceUpdate)
			deltaSinceUpdate = 0
	

func doVisitorsExist():
	return VisitorSpawner.get_child_count() > 0

func spawn_collection_radius(spawnPosition):
	var collecter = collectionRadius.instantiate()
	add_child(collecter)
	collecter.position = spawnPosition

func transition_phase():
	if !Globals.isDesignPhase:
		creatureUpdates = true
		Floor.updateAstar()
		navigationArray = Floor.getPath()
		beginSpawnVisitors()
	else:
		Player.ProgressPhase.visible = true
	#Testing stuff
	#var testingThing = load("res://src/testbox.tscn")
	#for vector in Floor.getPath():
		#var newtestThing = testingThing.instantiate()
		#add_child(newtestThing)
		#newtestThing.position = Floor.map_to_local(vector)

func beginSpawnVisitors():
	#Variables we need before we get started
	var currentPopularity = Globals.popularity
	#Set the Global Popularity to zero now that we have a copy
	Globals.popularity = 0
	var timeForSpawning = maxVisitingTime
	if (currentPopularity*5) < timeForSpawning:
		timeForSpawning = currentPopularity*5
	#Set the Time for Spawning (This controls the HUD and when we start checking for phase transition (if no more visitors))
	OpenPhaseTimer.wait_time = timeForSpawning + 1
	OpenPhaseTimer.start()
	#Set the SpawningVariables
	VisitorSpawner.popularityLeft = 1
	if currentPopularity > 0:
		VisitorSpawner.popularityLeft = currentPopularity
	VisitorSpawner.position = Floor.map_to_local(navigationArray.front())
	VisitorSpawner.NavArray = navigationArray.duplicate()
	VisitorSpawner.spawning = true
	VisitorSpawner.timeLeft = timeForSpawning


func _on_open_phase_timer_timeout():
	checkForVisitors = true
