extends Path2D

#variables
var size = 50
var length = 3
var posX = 100
var posY = 50
var lastNode : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generatePath()

func generatePath() -> void:
	curve.clear_points()
	pointify(posX, posY-size)
	pointify(posX, posY)
	pointify(posX+size, posY-size)
	pointify(posX+size, posY+(size*(length-1)+(size*.1) ) )
	#pointify(posX, posY+(size*length)+(5))
	pointify(posX, posY+(size*(length-1)))

func resetLength(nodes : int) -> void:
	length = nodes
	generatePath()

func pointify(x:float, y:float):
	addNode(Vector2(x,y))

func addNode(coord : Vector2) -> void:
	curve.add_point(coord,Vector2.ZERO, Vector2.ZERO, curve.get_baked_length())
	pass
