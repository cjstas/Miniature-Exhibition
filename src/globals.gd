extends Node

#Stats
var popularity: int = 5 #5 to start
var basic_resources: int = 0
var expectations: float = 0.6
var money = 0

#HUD
@warning_ignore("unused_signal")
signal selected_creature(creatureData, visible)
var cursor

#Inventory
var objectInHand: Dictionary = {}
var inventoryCreatures = []
var inventoryFloor = {}

#Phase tracking
var isDesignPhase = true
@warning_ignore("unused_signal")
signal phase_transition()

#Passed from the Level
var Floor: TileMapLayer
var Creatures: TileMapLayer
var ActionTimer: Timer

#Action Relations
var default_action: Callable = Callable(Actions, "select")
var selected_action: Callable = default_action
var action_target: Vector2i = Vector2i(0,0)
@warning_ignore("unused_signal")
signal action_on_creature(creature, action)
var collection_spawn: Callable

#Base Values
var EmptyFloorValues: Dictionary = {
	"Atlas" : Vector2i(0, 0),
	"Source" : 2
}

func clearobjectInHand():
	objectInHand.clear()
	cursor.holdingVisible = false
