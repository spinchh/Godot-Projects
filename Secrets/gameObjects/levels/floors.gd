extends TileMap

var aStar:AStar2D
var size:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	#grab size of floors tilemap
	size = self.get_used_rect().size
	#create AStar object and set its size to the tilemap
	aStar = AStar2D.new()
	aStar.reserve_space(size.x * size.y)

#count the number of cells in the tilemap
func getAStarCellID(vCell:Vector2):
	return (vCell.y+vCell.x*self.get_used_rect().size.y)

func aStarStart():
	for i in size.x:
		for j in size.y:
			var idx = getAStarCellID(Vector2(i,j))
			aStar.add_point(idx, map_to_local(Vector2(i,j)
