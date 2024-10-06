extends TileMapLayer

var startDefinition: Dictionary = {
	"Atlas" : Vector2i(2, 0),
	"Source" : 2
}
var endDefinition: Dictionary = {
	"Atlas" : Vector2i(3, 0),
	"Source" : 2
}
var pathDefinition: Dictionary = {
	"Atlas" : Vector2i(1, 0),
	"Source" : 2
}
var AStar: AStarGrid2D = AStarGrid2D.new()

#To do
# Function to call to get the Astar Path (get_point_path(start,end)) (this is to feed the visitors)

# Called when the node enters the scene tree for the first time.
func _ready():
	AStar.region = get_used_rect()
	AStar.cell_size = Vector2i(32,32)
	AStar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	AStar.update()

func getPath():
	var start = getStartLocation()
	var end = getEndLocation()
	return AStar.get_id_path(start, end)

func updateAstar(): #Should happen on phase transition
	for cell in get_used_cells():
		var cellA = get_cell_atlas_coords(cell)
		var cellS = get_cell_source_id(cell)
		if cellA == startDefinition["Atlas"] && cellS == startDefinition["Source"]:
			continue
		elif cellA == endDefinition["Atlas"] && cellS == endDefinition["Source"]:
			continue
		elif cellA == pathDefinition["Atlas"] && cellS == pathDefinition["Source"]:
			continue
		else:
			#update AStar as blocked
			AStar.set_point_solid(cell)
			#Testing Stuff
			#var testingThing = load("res://src/testbox.tscn")
			#var newtestThing = testingThing.instantiate()
			#add_child(newtestThing)
			#newtestThing.position = map_to_local(cell)
	AStar.update()

func getStartLocation():
	for cell in get_used_cells():
		if (get_cell_atlas_coords(cell) == startDefinition["Atlas"] && get_cell_source_id(cell) == startDefinition["Source"]):
			return cell

func getEndLocation():
	for cell in get_used_cells():
		if (get_cell_atlas_coords(cell) == endDefinition["Atlas"] && get_cell_source_id(cell) == endDefinition["Source"]):
			return cell

func getTileBeauty(scenePosition):
	var tilePosition = local_to_map(scenePosition)
	var neighbors = get_surrounding_cells(tilePosition)
	var Creatures = Globals.Creatures
	var beauty = 0
	
	for neighbor in neighbors:
		beauty += Creatures.getCreatureBeauty(neighbor)
	return beauty

func triggerAnxiety(scenePosition):
	var tilePosition = local_to_map(scenePosition)
	Globals.Creatures.triggerAnxiety(tilePosition)
