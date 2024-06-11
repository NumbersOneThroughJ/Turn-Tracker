extends Node2D

#editor variabls
@export var speed : float
@export var topNode : Node2D
@export var TurnTemplate : Node2D

#variables
var PathFollow2D_arr : Array
var temp : PathFollow2D
var progress : float
var nodeCount : int
var size : int = 50
var doTurns : int
var turnIDRef : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doTurns = 0
	progress = 0
	PathFollow2D_arr = getfollowers()
	nodeCount = PathFollow2D_arr.size()
	generateCurve()

func setFirst(texture : Texture2D) -> int:
	topNode.get_children()[0].get_children()[0].texture = texture
	turnIDRef[1] = topNode
	return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if doTurns>0:
		progress+=speed*delta
		if(progress>=1):
			doTurns -=1
			progress = 0
			for x in range(0, PathFollow2D_arr.size()-1):
				swapToPath(PathFollow2D_arr[x], PathFollow2D_arr[x+1])
			swapToPath(PathFollow2D_arr[PathFollow2D_arr.size()-1],PathFollow2D_arr[0]) 
		for path in PathFollow2D_arr:
			path.progress_ratio =progress

func addTurn(texture : Texture2D) -> int:
	nodeCount+=1
	var addedNode : Node2D = TurnTemplate.duplicate()
	addedNode.position.y = (nodeCount-2)*(size)
	addedNode.get_children()[0].get_children()[0].texture = texture
	addedNode.visible = true
	add_child(addedNode)
	PathFollow2D_arr.push_back(addedNode.get_children()[0])
	generateCurve()
	return nodeCount

func remTurn(id : int) -> void:
	if nodeCount>1:
		nodeCount-=1
		var removeID = getPathFollow2D_arrIndex(id)
		if(removeID == 0):
			swapParents(PathFollow2D_arr[0], PathFollow2D_arr[1])
			PathFollow2D_arr.remove_at(1)
		else:
			PathFollow2D_arr.remove_at(removeID)
		generateCurve()

func getPathFollow2D_arrIndex(id : int):
	var target = turnIDRef[id]
	return PathFollow2D_arr.find(target)

func generateCurve():
	topNode.resetLength(get_children().size())

func getfollowers() -> Array:
	var returnArr = []
	var children = get_children()
	for child in children:
		if(child.get_children().size() ==1):
			returnArr.append(child.get_children()[0])
	return returnArr

func swapToPath(PF_Destin : PathFollow2D, PF_Origin : PathFollow2D):
	var child = PF_Origin.get_children()[0]
	child.reparent(PF_Destin, false)

func swapParents(PF_1 : PathFollow2D, PF_2 : PathFollow2D):
	swapToPath(PF_1, PF_2)
	swapToPath(PF_2, PF_1)

func queueTurn() -> void:
	doTurns+=1

func finished() -> bool:
	return doTurns==0
