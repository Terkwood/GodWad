extends Area

var mFloor
var normal
var active = false
var myFloor = null
var scaleFactor = 1
var targetLines = null
var floorComponents = []
var map
var linedeftype = -1
var tag  = ""


func _ready():
	
	
	var linedeftype = get_meta("linedeftype")
	if(get_parent().get_class() == "StaticBody"):
		tag = get_parent().get_child(1).get_meta("tag")
	else:
		tag = get_parent().get_meta("tag")
	
	
	map = get_parent().get_parent().get_parent().get_parent()

		
	
	scaleFactor = map.scaleFactor
	var targets = []
	
	
	var tagSectorsNum = map.getSectorsFromTag(get_parent(),tag)
	#if tag!= 0: 
	#	tagSectorsNum = map.get_meta("tagToSectorsDict")[tag]
	#else:
	#	var sides = map.get_meta("allSideDefs")
	#	var oSide = map.getChildMesh(get_parent()).get_meta("oSide")
	#	var targetSide = sides[oSide]
	##	
	#	tagSectorsNum = [targetSide["sector"]]

	for i in tagSectorsNum:
		var sec = map.getSector(i)
		var targetSides = map.getNeighbourSides(sec)#map.getAllSectorSides(sec)
		var fAndC = map.getSectorFloorAndCeil(sec)
		targets.append({"sector":sec,"sides":targetSides,"floor":fAndC["floor"],"ceil":fAndC["ceil"] })
	
	
	self.connect("body_entered",self,"body_entered")
	
	
	if targets.empty():
		return 
	

	for i in targets:
		if i["sector"].get_node_or_null("floorComponent")!= null:
			floorComponents.append( i["sector"].get_node("floorComponent"))
			continue
		var floorComponent = Spatial.new()
		floorComponent.set_script(load("res://addons/godwad/interactables/floorComponent3.gd"))
		floorComponent.walls = i["sides"]
		floorComponent.theFloor = i["floor"]
		floorComponent.theCeil = i["ceil"]
		floorComponent.name = "floorComponent"
		floorComponents.append(floorComponent)
		floorComponent.scaleFactor = scaleFactor
		floorComponent.nieghbourSectors = map.getNeighbourSectors( i["sector"])
		floorComponent.map = map
		floorComponent.linedeftype = linedeftype
		i["sector"].add_child(floorComponent)
	

func body_entered(body):
	if body.get_class() != "StaticBody":
		for i in floorComponents:
			if i != null:
				i.active = true
				print("hit floor")

