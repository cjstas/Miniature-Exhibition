extends Node

#Helper Functions
func getFloorAndCreatureVars(position):
	#Floor Vars
	var floorTileVector = Globals.Floor.local_to_map(position)
	var floorAtlasIdAtLocation = Globals.Floor.get_cell_atlas_coords(floorTileVector)
	var floorSourceIdAtLocation = Globals.Floor.get_cell_source_id(floorTileVector)
	
	#CreatureVars
	var creatureTileVector = Globals.Creatures.local_to_map(position)
	var creatureAtlasIdAtLocation = Globals.Creatures.get_cell_atlas_coords(creatureTileVector)
	var creatureSourceIdAtLocation = Globals.Creatures.get_cell_source_id(creatureTileVector)
	
	return {
		"floorVector" : floorTileVector,
		"floorAtlas" : floorAtlasIdAtLocation,
		"floorSource" : floorSourceIdAtLocation,
		"creatureVector" : creatureTileVector,
		"creatureAtlas" : creatureAtlasIdAtLocation,
		"creatureSource" : creatureSourceIdAtLocation
	}

func releaseAction():
	Globals.ActionTimer.stop()
	for connection in Globals.ActionTimer.timeout.get_connections():
		Globals.ActionTimer.timeout.disconnect(connection["callable"])

#Action functions
func select(position):
	var tileVars: Dictionary = getFloorAndCreatureVars(position)
	#if creature does not exist here, stop
	if (tileVars["creatureSource"] == -1):
		return
	#pass to HUD
	Globals.selected_creature.emit(Globals.Creatures.getCreatureData(position), true)

#region DesignPhase
func grab(position):
	var tileVars: Dictionary = getFloorAndCreatureVars(position)
	#Floor.set_cell(tileVars["floorVector"], tileVars["floorSource"], Vector2(0,0))
	if (tileVars["creatureSource"] != -1):
		Globals.clearobjectInHand()
		var creatureData = Globals.Creatures.getCreatureData(position)
		Globals.objectInHand.merge(creatureData, true)
		Globals.Creatures.removeCreatureData(tileVars["creatureVector"]) #ReBuild Creature Sets
		Globals.Creatures.set_cell(tileVars["creatureVector"], -1)
		Globals.selected_action = Callable(self, "place")
		Globals.cursor.setStaticCursor("hold")
		Globals.cursor.updateHolding(creatureData["icon"])
		Globals.cursor.holdingVisible = true

func place(position):
	var tileVars: Dictionary = getFloorAndCreatureVars(position)
	if ((tileVars["floorAtlas"] != Globals.EmptyFloorValues["Atlas"]) || (tileVars["floorSource"] != Globals.EmptyFloorValues["Source"])):
		print("invalid: Floor Disallows")
		return
	if tileVars["creatureSource"] != -1:
		print("invalid: Space Occupied")
		return
	Globals.Creatures.set_cell(tileVars["creatureVector"], Globals.objectInHand["Source"], Globals.objectInHand["Atlas"])
	Globals.Creatures.addCreatureData(tileVars["creatureVector"], Globals.objectInHand)
	Globals.clearobjectInHand()
	Globals.selected_action = Callable(self, "select")
	Globals.cursor.setStaticCursor("point")

func erase(position):
	var _tileVars: Dictionary = getFloorAndCreatureVars(position)

func none(position):
	var _tileVars: Dictionary = getFloorAndCreatureVars(position)
#endregion

#region OpenPhase
func brush(_position):
	#var tileVars: Dictionary = getFloorAndCreatureVars(position)
	
	#if (tileVars["creatureSource"] != -1): #if there is a creature here, brush it
		#store this tile as our action target
		#Globals.action_target = tileVars["creatureVector"]
		#put brush timing into timer and begin timer
	Globals.ActionTimer.wait_time = 3
	Globals.ActionTimer.start()
	if !Globals.ActionTimer.timeout.is_connected(Callable(self, "_on_brush_complete")):
		Globals.ActionTimer.timeout.connect(Callable(self, "_on_brush_complete"))
	

func feed(_position):
	#var tileVars: Dictionary = getFloorAndCreatureVars(position)
	#if (tileVars["creatureSource"] != -1): #if there is a creature here, brush it
		#store this tile as our action target
		#Globals.action_target = tileVars["creatureVector"]
		#put brush timing into timer and begin timer
	Globals.ActionTimer.wait_time = 2
	Globals.ActionTimer.start()
	if !Globals.ActionTimer.timeout.is_connected(Callable(self, "_on_feed_complete")):
		Globals.ActionTimer.timeout.connect(Callable(self, "_on_feed_complete"))

func collect(position):
	Globals.collection_spawn.call(position)
	Globals.cursor.holdingVisible = false
#endregion

#events
func _on_brush_complete():
	Globals.ActionTimer.timeout.disconnect(Callable(self, "_on_brush_complete"))
	var creature = Globals.Creatures.local_to_map(Globals.cursor.get_global_mouse_position())
	Globals.action_on_creature.emit(creature, "brush")
	brush(Globals.cursor.get_global_mouse_position())

func _on_feed_complete():
	Globals.ActionTimer.timeout.disconnect(Callable(self, "_on_feed_complete"))
	var creature = Globals.Creatures.local_to_map(Globals.cursor.get_global_mouse_position())
	Globals.action_on_creature.emit(creature, "feed")
	feed(Globals.cursor.get_global_mouse_position())
