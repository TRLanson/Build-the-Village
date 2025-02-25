GDPC                                                                            '   D   res://.import/House-Sheet.png-e3771758ad86dba735b51e0d4b34d0f2.stex  �      L      Ӑ�����s*�սD   res://.import/Icons-Sheet.png-544080bdde24ed153b2ebc44f00f7619.stex  �      \       ff�7�~��?h����@   res://.import/Pixel.png-72ed007d271547e4302ff7b4f772f12a.stex   �6     F       oS�E��l�Ȳ���	��H   res://.import/Villagers-Sheet.png-f88969992cad568e327ee4a198c385bc.stex �B     �      �W%~6g �YV����D   res://.import/background.jpg-58f6528e73f93f0ca6a67982ab436354.stex  P�      ��     ��\�������U�M@   res://.import/checks1.png-41d892b29a54d08e4d86082a36d8956d.stex j     P       $g;Y~yh�����ܨ�@   res://.import/checks2.png-3af718c4df2eda9566f49340406a755b.stex  m     v       ^*0k���$`pb�r��mD   res://.import/green_pic.png-b67d3bacde5f2ddbe3fd1e3ef7a115ec.stex   �9     F       ��\��_�H Z-h�qs}@   res://.import/ground.png-a50b8922e8f0846677c2afa8b873914a.stex  `p     �
      U%u�eO��Ө� @<   res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex�Y     �      &�y���ڞu;>��.p@   res://.import/red_pic.png-f1d915e9cd6cda28ba65ddb614a11952.stex �<     F       �/= �Eg���o��=D   res://.import/white_pic.png-a09d9a27b4b42898047bd6cfc92e5526.stex   �?     F       6)���d�,���&   res://Scripts/GameManager.gd�             ,䲈l�O��C\�4-��$   res://Scripts/Grid/GridInteract.gd  �!      �      =���8O��Օl9�]   res://Scripts/ToDoList.gd   �)      �      �7J\
͕yVZֻ��    res://Scripts/label_colour.gd   02      �       ���#9=q�g.
����   res://Start.tscn03      �Z      �j@�.�;��Zeu98   res://ToDo.tscn  �      �      �mw��[�8��a� ���0   res://assets/Envrioment/House-Sheet.png.import  P�      �      �Qpg	�ӹ؋�El0   res://assets/Envrioment/Icons-Sheet.png.import  ��      �      A�u�,Vް)*B�&u�m0   res://assets/Envrioment/background.jpg.import   @g     �      �ǒS2��S[�d~B&,   res://assets/Envrioment/checks1.png.import  `j     �      ]��οP��a�iv#��,   res://assets/Envrioment/checks2.png.import  �m     �      �afby�~I��T�jKx,   res://assets/Envrioment/ground.png.import   P{     �      Ӌī���[߄��
$   res://assets/Font/Hack-Regular.ttf  ~     ��     ٫(����v3h�+y$   res://assets/Random/Pixel.png.import 7     �      ����SMe����'(   res://assets/Random/green_pic.png.import:     �      �,�*+0�����ܼ�(   res://assets/Random/red_pic.png.import   =     �      ���̻��P�j��4#(   res://assets/Random/white_pic.png.import0@     �      �o5�EHL�λ�: �(   res://assets/Villagers-Sheet.png.import �F     �      �����dv��18��$   res://assets/themes/Hack_font.tres  `I     �       �ޔ�Um:��~Ȁ�N(   res://assets/themes/button_question.tres J     7       T�¡[V;���8�=�_$   res://assets/themes/new_theme.tres  `J     c      �$j�E�JiZ��s�a   res://assets/villager0.tscn �L     I      ��x�x+M�m�q'   res://assets/villager_0.gd   T     �      ���d1��+�j�ZxR   res://default_env.tres   Y     �       um�`�N��<*ỳ�8   res://icon.png  `b     �      G1?��z�c��vN��   res://icon.png.import   �_     �      ��fe��6�B��^ U�   res://project.binaryPo     �      $��������ZV��extends Node


# Declare member variables here. Examples:
const X_SIZE = 992
const Y_SIZE = 576

const GRID_INTERACT_SCRIPT = preload("res://Scripts/Grid/GridInteract.gd")
const GRID_BLOCK_SIZE = 32

const MENU_BUTTON_WIDTH = 80
const MENU_BUTTON_HEIGHT = 100

# Game State Variables
var sensorGrid = []
var tileGrid = []
var selected = Vector2(0, 0)

# Node references
var tileMap
var contextMenu
var label

# Preloading villagers for when they will be spawned in
const villager_base = preload("res://assets/villager0.tscn")

# Random number gen 
var rand = RandomNumberGenerator.new()

#Nodes
onready var vill_node = get_node("vills")

# Inventory
var Inventory = {
	"points"    : 10,
	"population": 1,
	"gold"      : 100,
	"wood"      : 20,
	"stone"     : 20
} # TODO: ADD FOOD


var menuItems

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize Inventory Menu
	menuItems = {
		"points"    : get_node("/root/Node/InventoryRect/Points"),
		"population": get_node("/root/Node/InventoryRect/Population"),
#		"gold"      : get_node("/root/Node/InventoryRect/Gold"),
#		"stone"     : get_node("/root/Node/InventoryRect/Stone"),
#		"wood"      : get_node("/root/Node/InventoryRect/Wood")
	}
	
	rand.randomize()
	
	self.connect("_die_die_die",self,"_on_Node__die_die_die")
	
	tileMap = get_node("/root/Node/TileMap")
	contextMenu = get_node("/root/Node/ContextMenu")
	label = get_node("/root/Node/Label")
#	print(tileMap.cell_tile_origin)
	# Populate sensorGrid with GridInteracts
	for i in range(X_SIZE/GRID_BLOCK_SIZE + 1):
		sensorGrid.append([])
		tileGrid.append([])
		for j in range(Y_SIZE/GRID_BLOCK_SIZE + 1):
			tileGrid[i].append(tileMap.get_cell(i, j))
			
			var newNode = ColorRect.new()
			newNode.set_position(Vector2(i*GRID_BLOCK_SIZE, j*GRID_BLOCK_SIZE))
			newNode.set_script(GRID_INTERACT_SCRIPT)
			newNode.posx = i
			newNode.posy = j
			newNode.set_name("GRID " + str(i) + ", " + str(j))
			newNode._set_variables((tileGrid[i][j] in [6, 7, 11]), true, (tileGrid[i][j] in [6, 7, 11]), 1 + 4*int(tileGrid[i][j] in [15, 16, 19]) + 2*int(tileGrid[i][j] in [17, 18, 20, 21]), tileGrid[i][j], [["stone", 5*int(tileGrid[i][j] != -1), 1]], [])
			add_child(newNode)
			sensorGrid[i].append(newNode)
			
			
	contextMenu.visible = false
	Inventory["points"] += 1
	# TODO: PREPROCESS THE CELLS IN TILEGRID TO SHOW WHAT RESOURCES, ETC THEY HAVE



func _grid_pressed(posx, posy):
#	print(sensorGrid[posx][posy].difficultyMultiplier)
#	print(posx, ", ", posy)
	selected = Vector2(posx, posy)
	contextMenu.visible = true
	contextMenu.set_position(Vector2(min(get_viewport().get_mouse_position().x, X_SIZE - MENU_BUTTON_WIDTH), min(get_viewport().get_mouse_position().y, Y_SIZE - MENU_BUTTON_HEIGHT)))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for key in menuItems:
		menuItems[key].text = key + ": " + str(Inventory[key])
	




func _on_CancelButton_pressed():
	contextMenu.visible = false


func _on_BuildButton_pressed():
	if(Inventory["points"] > 10):
		var building = int(rand.randf_range(0,2))
		# 0: log house
		# 1: aparement
		# 2: Brick house
		#idfk why this works like this
		# adding buildings breaks this
		building = 0
		if(building == 0):
			tileMap.set_cell(selected.x,selected.y,26)
		Inventory["points"] -= 10
#		if(building == 1):
#			tileMap.set_tile(selected.x,selected.y,28)
#		if(building == 2):
#			tileMap.set_tile(selected.x,selected.y,26)

func _on_HarvestButton_pressed():
	# TODO: PICK RANDOM ITEM FROM SELECTED RESOURCE YIELDS
	var yield_r = sensorGrid[selected.x][selected.y].resources[0]
	if(sensorGrid[selected.x][selected.y].harvestable == false):
		label.text = "That block cannot be harvested!"
		label.modulate.a = 1
		return
	if(yield_r == null):
		return
	if(Inventory["points"] < yield_r[2]*sensorGrid[selected.x][selected.y].difficultyMultiplier):
		label.text = "Not enough points."
		label.modulate.a = 1
		return
	Inventory["points"] -= yield_r[2]*sensorGrid[selected.x][selected.y].difficultyMultiplier
	Inventory[yield_r[0]] += yield_r[1]
	sensorGrid[selected.x][selected.y].health -= 1
	label.text = "Successfully harvested resource. It has been damaged."
	label.modulate.a = 1
	if(sensorGrid[selected.x][selected.y].health == 0):
#		print("Destroy Block!") #to do: destroy block!
		tileMap.set_cell(selected.x, selected.y, -1)
		sensorGrid[selected.x][selected.y+1].harvestable = true
		sensorGrid[selected.x][selected.y+1].buildable = true
		sensorGrid[selected.x][selected.y].harvestable = false
		sensorGrid[selected.x][selected.y].buildable = false
		for neighbour in sensorGrid[selected.x][selected.y].associatedNeighbours:
			tileMap.set_cell(neighbour.x, neighbour.y, -1)
			sensorGrid[neighbour.x][neighbour.y+1].harvestable = true
			sensorGrid[neighbour.x][neighbour.y+1].buildable = true
			sensorGrid[neighbour.x][neighbour.y].harvestable = false
			sensorGrid[neighbour.x][neighbour.y].buildable = false
	
	contextMenu.visible = false



func _on_Node__add_points(points):
	var new_vill = villager_base.instance()
	vill_node.add_child(new_vill)
	Inventory["points"] += points
	var text = str(points)
	label.text = "You got " + text + " points!"
	label.modulate.a = 1

	
func _on_Node__die_die_die():

	
	var children = vill_node.get_children()
	var child_2_die = rand.randi_range(0,children.size())
	children[child_2_die].queue_free()
extends ColorRect


# Signals
signal grid_pressed(x, y)

# Declare member variables here. Examples:
var posx : int
var posy : int

var gameManager

# Block properties
var buildable  : bool
var surveyable : bool
var harvestable: bool
var difficultyMultiplier : int 
var health = 3 # Takes three hits to kill

var blockType : int 		# TODO: CREATE ENUM FOR BLOCK TYPES
var resources : Array 		# Each element is of the form ["RESOURCE_NAME", numberOfResources, baseCostInPoints]
var resourceYields : Array	# EXAMPLE: (RESOURCE_ID, 3600 seconds)

var associatedNeighbours : Array # Neighbours to delete upon destruction. Array of Vector2()s


# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = get_node("/root/Node/GameManager")
	
	color = Color(color.r, color.g, color.b, 0) 			# transparent
	rect_size = Vector2(40, 40)
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("gui_input", self, "_on_mouse_pressed")
	connect("grid_pressed", gameManager, "_grid_pressed")

func _set_variables(buildable_v, surveyable_v, harvestable_v, difficultyMultiplier_v, blockType_v, resources_v, resourceYields_v):
	buildable = buildable_v
	surveyable = surveyable_v
	harvestable = harvestable_v
	difficultyMultiplier = difficultyMultiplier_v
	blockType = blockType_v
	resources = resources_v
	resourceYields = resourceYields_v

func _on_mouse_entered():
	color = Color(color.r, color.g, color.b, 93.0/255.0) 	# not transparent
															# In the future, stop hardcoding this! Make a variable.
	#print("here")

func _on_mouse_exited():
	color = Color(color.r, color.g, color.b, 0) 			# transparent
	
	#print("not here")
	
func _on_mouse_pressed(event):
	if(event is InputEventMouseButton and event.button_index == 1 and event.pressed): # If the sprite is left-clicked
		emit_signal("grid_pressed", posx, posy)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
    extends Node

onready var list_not_done = get_node("ToDoList")
onready var list_done = get_node("FinishedList")
onready var new_thing = get_node("TextEdit")
onready var timers_master = get_node("timers")
onready var empty_box = preload("res://assets/Envrioment/checks1.png")
onready var checked_box = preload("res://assets/Envrioment/checks2.png")
onready var Points = get_node("/root/Node/InventoryRect/Points")
var identifier_arr
var identifier_num = int(0)
var rng = RandomNumberGenerator.new()
var gameManager

signal _die_die_die(points)
signal _add_points(points)
# totally not a reference to reaper... *flash backs*


# Called when the node enters the scene tree for the first time.
func _ready():
	gameManager = get_node("/root/Node/GameManager")
	rng.randomize()

func _on_ItemList_item_activated(index):
	var data = list_not_done.get_item_metadata(index-1)
#	print(data)

	if(list_not_done.get_item_text(index) != "Make The Todo List"):
		list_done.add_item(list_not_done.get_item_text(index), checked_box, false)
		list_not_done.remove_item(index)
		#Only add points if the timer exists
		if is_instance_valid(data[0]):
			emit_signal("_add_points", int(rng.randf_range(1, 5)))
#			print("WHY")
	
	#deleting da timer
	if is_instance_valid(data[0]):
		# Add points here
		data[0].queue_free()
	else:
		pass
	


func _on_ItemList_item_selected(index):
	pass # Replace with function body.


func _on_Button_pressed():
#	print("Hello world")
	var new_item = new_thing.get_line(0)
	var text = new_item.split(",")
	if(text.size() > 1):
		var times = text[1].split(":")
		list_not_done.add_item(text[0], empty_box, true)
		var timer := Timer.new()
		timers_master.add_child(timer)
		timer.wait_time = (int(times[0])*60*60 + int(times[1])*60)
		timer.one_shot = true
		timer.start()
		var q = int(0)
		for i in get_node("timers").get_children():
			i.connect("timeout",self,"_on_timer_timeout",[i])
			list_not_done.set_item_metadata(q, [i])
			q += 1
		new_thing.text = ""
	
func _on_timer_timeout(which):
	emit_signal("_die_die_die")
#	print("die")
	which.queue_free()

func _on_ItemList_item_activated2():
	pass # Replace with function body.


func _on_ItemList_item_selected2():
	pass # Replace with function body.
  extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate.a = 0


func _physics_process(delta):
	self.modulate.a -= 0.001
       [gd_scene load_steps=27 format=2]

[ext_resource path="res://Scripts/Grid/GridInteract.gd" type="Script" id=1]
[ext_resource path="res://Scripts/GameManager.gd" type="Script" id=2]
[ext_resource path="res://assets/Villagers-Sheet.png" type="Texture" id=3]
[ext_resource path="res://assets/Envrioment/ground.png" type="Texture" id=4]
[ext_resource path="res://assets/villager0.tscn" type="PackedScene" id=5]
[ext_resource path="res://ToDo.tscn" type="PackedScene" id=6]
[ext_resource path="res://Scripts/label_colour.gd" type="Script" id=7]
[ext_resource path="res://assets/Envrioment/background.jpg" type="Texture" id=8]
[ext_resource path="res://assets/Envrioment/House-Sheet.png" type="Texture" id=9]

[sub_resource type="ConvexPolygonShape2D" id=2]
points = PoolVector2Array( 0, 10, 32, 10, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=3]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=4]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=5]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=6]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=7]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=8]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=9]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=10]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=11]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=12]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=13]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=14]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=18]
points = PoolVector2Array( 0, 10, 32, 10, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=16]
points = PoolVector2Array( 0, 10, 32, 10, 32, 32, 0, 32 )

[sub_resource type="ConvexPolygonShape2D" id=17]
points = PoolVector2Array( 0, 0, 32, 0, 32, 32, 0, 32 )

[sub_resource type="TileSet" id=1]
0/name = "Villagers-Sheet.png 0"
0/texture = ExtResource( 3 )
0/tex_offset = Vector2( 0, 0 )
0/modulate = Color( 1, 1, 1, 1 )
0/region = Rect2( 0, 0, 32, 32 )
0/tile_mode = 1
0/autotile/bitmask_mode = 0
0/autotile/bitmask_flags = [  ]
0/autotile/icon_coordinate = Vector2( 0, 0 )
0/autotile/tile_size = Vector2( 32, 32 )
0/autotile/spacing = 0
0/autotile/occluder_map = [  ]
0/autotile/navpoly_map = [  ]
0/autotile/priority_map = [  ]
0/autotile/z_index_map = [  ]
0/occluder_offset = Vector2( 0, 0 )
0/navigation_offset = Vector2( 0, 0 )
0/shape_offset = Vector2( 0, 0 )
0/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
0/shape_one_way = false
0/shape_one_way_margin = 0.0
0/shapes = [  ]
0/z_index = 0
1/name = "Villagers-Sheet.png 1"
1/texture = ExtResource( 3 )
1/tex_offset = Vector2( 0, 0 )
1/modulate = Color( 1, 1, 1, 1 )
1/region = Rect2( 32, 0, 32, 32 )
1/tile_mode = 0
1/occluder_offset = Vector2( 0, 0 )
1/navigation_offset = Vector2( 0, 0 )
1/shape_offset = Vector2( 0, 0 )
1/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
1/shape_one_way = false
1/shape_one_way_margin = 0.0
1/shapes = [  ]
1/z_index = 0
2/name = "Villagers-Sheet.png 2"
2/texture = ExtResource( 3 )
2/tex_offset = Vector2( 0, 0 )
2/modulate = Color( 1, 1, 1, 1 )
2/region = Rect2( 64, 0, 32, 32 )
2/tile_mode = 0
2/occluder_offset = Vector2( 0, 0 )
2/navigation_offset = Vector2( 0, 0 )
2/shape_offset = Vector2( 0, 0 )
2/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
2/shape_one_way = false
2/shape_one_way_margin = 0.0
2/shapes = [  ]
2/z_index = 0
3/name = "Villagers-Sheet.png 3"
3/texture = ExtResource( 3 )
3/tex_offset = Vector2( 0, 0 )
3/modulate = Color( 1, 1, 1, 1 )
3/region = Rect2( 96, 0, 32, 32 )
3/tile_mode = 0
3/occluder_offset = Vector2( 0, 0 )
3/navigation_offset = Vector2( 0, 0 )
3/shape_offset = Vector2( 0, 0 )
3/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
3/shape_one_way = false
3/shape_one_way_margin = 0.0
3/shapes = [  ]
3/z_index = 0
4/name = "Villagers-Sheet.png 4"
4/texture = ExtResource( 3 )
4/tex_offset = Vector2( 0, 0 )
4/modulate = Color( 1, 1, 1, 1 )
4/region = Rect2( 0, 0, 32, 32 )
4/tile_mode = 0
4/occluder_offset = Vector2( 0, 0 )
4/navigation_offset = Vector2( 0, 0 )
4/shape_offset = Vector2( 0, 0 )
4/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
4/shape_one_way = false
4/shape_one_way_margin = 0.0
4/shapes = [  ]
4/z_index = 0
5/name = "ground.png 5"
5/texture = ExtResource( 4 )
5/tex_offset = Vector2( 0, 0 )
5/modulate = Color( 1, 1, 1, 1 )
5/region = Rect2( 96, 0, 32, 32 )
5/tile_mode = 1
5/autotile/bitmask_mode = 0
5/autotile/bitmask_flags = [  ]
5/autotile/icon_coordinate = Vector2( 0, 0 )
5/autotile/tile_size = Vector2( 32, 32 )
5/autotile/spacing = 0
5/autotile/occluder_map = [  ]
5/autotile/navpoly_map = [  ]
5/autotile/priority_map = [  ]
5/autotile/z_index_map = [  ]
5/occluder_offset = Vector2( 0, 0 )
5/navigation_offset = Vector2( 0, 0 )
5/shape_offset = Vector2( 0, 0 )
5/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
5/shape = SubResource( 14 )
5/shape_one_way = false
5/shape_one_way_margin = 1.0
5/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 14 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
5/z_index = 0
6/name = "ground.png 6"
6/texture = ExtResource( 4 )
6/tex_offset = Vector2( 0, 0 )
6/modulate = Color( 1, 1, 1, 1 )
6/region = Rect2( 0, 0, 32, 32 )
6/tile_mode = 0
6/occluder_offset = Vector2( 0, 0 )
6/navigation_offset = Vector2( 0, 0 )
6/shape_offset = Vector2( 0, 0 )
6/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
6/shape = SubResource( 18 )
6/shape_one_way = false
6/shape_one_way_margin = 1.0
6/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 18 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
6/z_index = 0
7/name = "ground.png 7"
7/texture = ExtResource( 4 )
7/tex_offset = Vector2( 0, 0 )
7/modulate = Color( 1, 1, 1, 1 )
7/region = Rect2( 32, 0, 32, 32 )
7/tile_mode = 0
7/occluder_offset = Vector2( 0, 0 )
7/navigation_offset = Vector2( 0, 0 )
7/shape_offset = Vector2( 0, 0 )
7/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
7/shape = SubResource( 16 )
7/shape_one_way = false
7/shape_one_way_margin = 1.0
7/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 16 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
7/z_index = 0
8/name = "ground.png 8"
8/texture = ExtResource( 4 )
8/tex_offset = Vector2( 0, 0 )
8/modulate = Color( 1, 1, 1, 1 )
8/region = Rect2( 64, 0, 32, 32 )
8/tile_mode = 0
8/occluder_offset = Vector2( 0, 0 )
8/navigation_offset = Vector2( 0, 0 )
8/shape_offset = Vector2( 0, 0 )
8/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
8/shape = SubResource( 17 )
8/shape_one_way = false
8/shape_one_way_margin = 1.0
8/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 17 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
8/z_index = 0
9/name = "ground.png 9"
9/texture = ExtResource( 4 )
9/tex_offset = Vector2( 0, 0 )
9/modulate = Color( 1, 1, 1, 1 )
9/region = Rect2( 128, 32, 32, 32 )
9/tile_mode = 0
9/occluder_offset = Vector2( 0, 0 )
9/navigation_offset = Vector2( 0, 0 )
9/shape_offset = Vector2( 0, 0 )
9/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
9/shape_one_way = false
9/shape_one_way_margin = 0.0
9/shapes = [  ]
9/z_index = 0
10/name = "ground.png 10"
10/texture = ExtResource( 4 )
10/tex_offset = Vector2( 0, 0 )
10/modulate = Color( 1, 1, 1, 1 )
10/region = Rect2( 96, 0, 32, 32 )
10/tile_mode = 0
10/occluder_offset = Vector2( 0, 0 )
10/navigation_offset = Vector2( 0, 0 )
10/shape_offset = Vector2( 0, 0 )
10/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
10/shape_one_way = false
10/shape_one_way_margin = 0.0
10/shapes = [  ]
10/z_index = 0
11/name = "ground.png 11"
11/texture = ExtResource( 4 )
11/tex_offset = Vector2( 0, 0 )
11/modulate = Color( 1, 1, 1, 1 )
11/region = Rect2( 128, 0, 32, 32 )
11/tile_mode = 0
11/occluder_offset = Vector2( 0, 0 )
11/navigation_offset = Vector2( 0, 0 )
11/shape_offset = Vector2( 0, 0 )
11/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
11/shape = SubResource( 2 )
11/shape_one_way = false
11/shape_one_way_margin = 1.0
11/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 2 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
11/z_index = 0
12/name = "ground.png 12"
12/texture = ExtResource( 4 )
12/tex_offset = Vector2( 0, 0 )
12/modulate = Color( 1, 1, 1, 1 )
12/region = Rect2( 160, 0, 32, 32 )
12/tile_mode = 0
12/occluder_offset = Vector2( 0, 0 )
12/navigation_offset = Vector2( 0, 0 )
12/shape_offset = Vector2( 0, 0 )
12/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
12/shape = SubResource( 3 )
12/shape_one_way = false
12/shape_one_way_margin = 1.0
12/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 3 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
12/z_index = 0
13/name = "ground.png 13"
13/texture = ExtResource( 4 )
13/tex_offset = Vector2( 0, 0 )
13/modulate = Color( 1, 1, 1, 1 )
13/region = Rect2( 192, 0, 32, 32 )
13/tile_mode = 0
13/occluder_offset = Vector2( 0, 0 )
13/navigation_offset = Vector2( 0, 0 )
13/shape_offset = Vector2( 0, 0 )
13/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
13/shape = SubResource( 4 )
13/shape_one_way = false
13/shape_one_way_margin = 1.0
13/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 4 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
13/z_index = 0
14/name = "ground.png 14"
14/texture = ExtResource( 4 )
14/tex_offset = Vector2( 0, 0 )
14/modulate = Color( 1, 1, 1, 1 )
14/region = Rect2( 224, 0, 32, 32 )
14/tile_mode = 0
14/occluder_offset = Vector2( 0, 0 )
14/navigation_offset = Vector2( 0, 0 )
14/shape_offset = Vector2( 0, 0 )
14/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
14/shape = SubResource( 5 )
14/shape_one_way = false
14/shape_one_way_margin = 1.0
14/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 5 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
14/z_index = 0
15/name = "ground.png 15"
15/texture = ExtResource( 4 )
15/tex_offset = Vector2( 0, 0 )
15/modulate = Color( 1, 1, 1, 1 )
15/region = Rect2( 256, 0, 32, 32 )
15/tile_mode = 0
15/occluder_offset = Vector2( 0, 0 )
15/navigation_offset = Vector2( 0, 0 )
15/shape_offset = Vector2( 0, 0 )
15/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
15/shape = SubResource( 6 )
15/shape_one_way = false
15/shape_one_way_margin = 1.0
15/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 6 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
15/z_index = 0
16/name = "ground.png 16"
16/texture = ExtResource( 4 )
16/tex_offset = Vector2( 0, 0 )
16/modulate = Color( 1, 1, 1, 1 )
16/region = Rect2( 288, 0, 32, 32 )
16/tile_mode = 0
16/occluder_offset = Vector2( 0, 0 )
16/navigation_offset = Vector2( 0, 0 )
16/shape_offset = Vector2( 0, 0 )
16/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
16/shape = SubResource( 7 )
16/shape_one_way = false
16/shape_one_way_margin = 1.0
16/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 7 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
16/z_index = 0
17/name = "ground.png 17"
17/texture = ExtResource( 4 )
17/tex_offset = Vector2( 0, 0 )
17/modulate = Color( 1, 1, 1, 1 )
17/region = Rect2( 320, 0, 32, 32 )
17/tile_mode = 0
17/occluder_offset = Vector2( 0, 0 )
17/navigation_offset = Vector2( 0, 0 )
17/shape_offset = Vector2( 0, 0 )
17/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
17/shape = SubResource( 8 )
17/shape_one_way = false
17/shape_one_way_margin = 1.0
17/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 8 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
17/z_index = 0
18/name = "ground.png 18"
18/texture = ExtResource( 4 )
18/tex_offset = Vector2( 0, 0 )
18/modulate = Color( 1, 1, 1, 1 )
18/region = Rect2( 352, 0, 32, 32 )
18/tile_mode = 0
18/occluder_offset = Vector2( 0, 0 )
18/navigation_offset = Vector2( 0, 0 )
18/shape_offset = Vector2( 0, 0 )
18/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
18/shape = SubResource( 9 )
18/shape_one_way = false
18/shape_one_way_margin = 1.0
18/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 9 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
18/z_index = 0
19/name = "ground.png 19"
19/texture = ExtResource( 4 )
19/tex_offset = Vector2( 0, 0 )
19/modulate = Color( 1, 1, 1, 1 )
19/region = Rect2( 384, 0, 32, 32 )
19/tile_mode = 0
19/occluder_offset = Vector2( 0, 0 )
19/navigation_offset = Vector2( 0, 0 )
19/shape_offset = Vector2( 0, 0 )
19/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
19/shape = SubResource( 10 )
19/shape_one_way = false
19/shape_one_way_margin = 1.0
19/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 10 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
19/z_index = 0
20/name = "ground.png 20"
20/texture = ExtResource( 4 )
20/tex_offset = Vector2( 0, 0 )
20/modulate = Color( 1, 1, 1, 1 )
20/region = Rect2( 448, 0, 32, 32 )
20/tile_mode = 0
20/occluder_offset = Vector2( 0, 0 )
20/navigation_offset = Vector2( 0, 0 )
20/shape_offset = Vector2( 0, 0 )
20/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
20/shape = SubResource( 11 )
20/shape_one_way = false
20/shape_one_way_margin = 1.0
20/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 11 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
20/z_index = 0
21/name = "ground.png 21"
21/texture = ExtResource( 4 )
21/tex_offset = Vector2( 0, 0 )
21/modulate = Color( 1, 1, 1, 1 )
21/region = Rect2( 416, 0, 32, 32 )
21/tile_mode = 0
21/occluder_offset = Vector2( 0, 0 )
21/navigation_offset = Vector2( 0, 0 )
21/shape_offset = Vector2( 0, 0 )
21/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
21/shape = SubResource( 12 )
21/shape_one_way = false
21/shape_one_way_margin = 1.0
21/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 12 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
21/z_index = 0
22/name = "ground.png 22"
22/texture = ExtResource( 4 )
22/tex_offset = Vector2( 0, 0 )
22/modulate = Color( 1, 1, 1, 1 )
22/region = Rect2( 96, 32, 32, 32 )
22/tile_mode = 0
22/occluder_offset = Vector2( 0, 0 )
22/navigation_offset = Vector2( 0, 0 )
22/shape_offset = Vector2( 0, 0 )
22/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
22/shape_one_way = false
22/shape_one_way_margin = 0.0
22/shapes = [  ]
22/z_index = 0
23/name = "ground.png 23"
23/texture = ExtResource( 4 )
23/tex_offset = Vector2( 0, 0 )
23/modulate = Color( 1, 1, 1, 1 )
23/region = Rect2( 64, 32, 32, 32 )
23/tile_mode = 0
23/occluder_offset = Vector2( 0, 0 )
23/navigation_offset = Vector2( 0, 0 )
23/shape_offset = Vector2( 0, 0 )
23/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
23/shape_one_way = false
23/shape_one_way_margin = 0.0
23/shapes = [  ]
23/z_index = 0
24/name = "ground.png 24"
24/texture = ExtResource( 4 )
24/tex_offset = Vector2( 0, 0 )
24/modulate = Color( 1, 1, 1, 1 )
24/region = Rect2( 480, 0, 32, 32 )
24/tile_mode = 0
24/occluder_offset = Vector2( 0, 0 )
24/navigation_offset = Vector2( 0, 0 )
24/shape_offset = Vector2( 0, 0 )
24/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
24/shape = SubResource( 13 )
24/shape_one_way = false
24/shape_one_way_margin = 1.0
24/shapes = [ {
"autotile_coord": Vector2( 0, 0 ),
"one_way": false,
"one_way_margin": 1.0,
"shape": SubResource( 13 ),
"shape_transform": Transform2D( 1, 0, 0, 1, 0, 0 )
} ]
24/z_index = 0
26/name = "House-Sheet.png 26"
26/texture = ExtResource( 9 )
26/tex_offset = Vector2( 0, 0 )
26/modulate = Color( 1, 1, 1, 1 )
26/region = Rect2( 128, 12, 64, 52 )
26/tile_mode = 0
26/occluder_offset = Vector2( 0, 0 )
26/navigation_offset = Vector2( 0, 0 )
26/shape_offset = Vector2( 0, 0 )
26/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
26/shape_one_way = false
26/shape_one_way_margin = 0.0
26/shapes = [  ]
26/z_index = 0
28/name = "House-Sheet.png 28"
28/texture = ExtResource( 9 )
28/tex_offset = Vector2( 0, 0 )
28/modulate = Color( 1, 1, 1, 1 )
28/region = Rect2( 0, -4, 44, 68 )
28/tile_mode = 0
28/occluder_offset = Vector2( 0, 0 )
28/navigation_offset = Vector2( 0, 0 )
28/shape_offset = Vector2( 0, 0 )
28/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
28/shape_one_way = false
28/shape_one_way_margin = 0.0
28/shapes = [  ]
28/z_index = 0
29/name = "House-Sheet.png 29"
29/texture = ExtResource( 9 )
29/tex_offset = Vector2( 0, 0 )
29/modulate = Color( 1, 1, 1, 1 )
29/region = Rect2( 68, -4, 60, 68 )
29/tile_mode = 0
29/occluder_offset = Vector2( 0, 0 )
29/navigation_offset = Vector2( 0, 0 )
29/shape_offset = Vector2( 0, 0 )
29/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )
29/shape_one_way = false
29/shape_one_way_margin = 0.0
29/shapes = [  ]
29/z_index = 0

[node name="Node" type="Node"]

[node name="ParallaxBackground" type="ParallaxBackground" parent="."]
follow_viewport_enable = true

[node name="ParallaxLayer" type="ParallaxLayer" parent="ParallaxBackground"]
motion_mirroring = Vector2( 1024, 0 )

[node name="Sprite" type="Sprite" parent="ParallaxBackground/ParallaxLayer"]
position = Vector2( 512, 300 )
texture = ExtResource( 8 )

[node name="Label" type="Label" parent="."]
margin_top = 192.0
margin_right = 195.0
margin_bottom = 236.0
script = ExtResource( 7 )

[node name="ColorRect" type="ColorRect" parent="."]
visible = false
margin_top = 560.0
margin_right = 40.0
margin_bottom = 600.0
rect_min_size = Vector2( 40, 40 )
color = Color( 0.490196, 0.490196, 0.490196, 0.364706 )
script = ExtResource( 1 )

[node name="TileMap" type="TileMap" parent="."]
tile_set = SubResource( 1 )
cell_size = Vector2( 32, 32 )
format = 1
tile_data = PoolIntArray( 786437, 27, 0, 786442, 25, 0, 851968, 11, 0, 851999, 7, 0, 852000, 7, 0, 917504, 12, 0, 917505, 6, 0, 917506, 6, 0, 917507, 6, 0, 917508, 6, 0, 917509, 6, 0, 917510, 6, 0, 917511, 6, 0, 917512, 6, 0, 917513, 6, 0, 917514, 6, 0, 917515, 6, 0, 917516, 6, 0, 917517, 6, 0, 917518, 6, 0, 917519, 6, 0, 917520, 6, 0, 917521, 6, 0, 917522, 6, 0, 917523, 6, 0, 917524, 6, 0, 917525, 6, 0, 917526, 6, 0, 917527, 6, 0, 917528, 6, 0, 917529, 6, 0, 917530, 6, 0, 917531, 6, 0, 917532, 6, 0, 917533, 6, 0, 917534, 6, 0, 917535, 8, 0, 917536, 8, 0, 983040, 23, 0, 983041, 23, 0, 983042, 18, 0, 983043, 17, 0, 983044, 18, 0, 983045, 17, 0, 983046, 18, 0, 983047, 17, 0, 983048, 18, 0, 983049, 17, 0, 983050, 17, 0, 983051, 18, 0, 983052, 17, 0, 983053, 18, 0, 983054, 18, 0, 983055, 17, 0, 983056, 18, 0, 983057, 17, 0, 983058, 17, 0, 983059, 18, 0, 983060, 18, 0, 983061, 18, 0, 983062, 17, 0, 983063, 17, 0, 983064, 17, 0, 983065, 18, 0, 983066, 17, 0, 983067, 18, 0, 983068, 17, 0, 983069, 17, 0, 983070, 18, 0, 983071, 18, 0, 1048576, 23, 0, 1048577, 23, 0, 1048578, 16, 0, 1048579, 15, 0, 1048580, 16, 0, 1048581, 15, 0, 1048582, 15, 0, 1048583, 15, 0, 1048584, 16, 0, 1048585, 15, 0, 1048586, 15, 0, 1048587, 16, 0, 1048588, 16, 0, 1048589, 16, 0, 1048590, 15, 0, 1048591, 15, 0, 1048592, 16, 0, 1048593, 16, 0, 1048594, 15, 0, 1048595, 15, 0, 1048596, 16, 0, 1048597, 16, 0, 1048598, 15, 0, 1048599, 16, 0, 1048600, 15, 0, 1048601, 16, 0, 1048602, 16, 0, 1048603, 15, 0, 1048604, 16, 0, 1048605, 15, 0, 1048606, 16, 0, 1048607, 15, 0, 1114112, 23, 0, 1114113, 23, 0, 1114114, 23, 0, 1114115, 23, 0, 1114116, 23, 0, 1114117, 23, 0, 1114118, 23, 0, 1114119, 23, 0, 1114120, 23, 0, 1114121, 23, 0, 1114122, 23, 0, 1114123, 23, 0, 1114124, 23, 0, 1114125, 23, 0, 1114126, 23, 0, 1114127, 23, 0, 1114128, 23, 0, 1114129, 23, 0, 1114130, 23, 0, 1114131, 23, 0, 1114132, 23, 0, 1114133, 23, 0, 1114134, 23, 0, 1114135, 23, 0, 1114136, 23, 0, 1114137, 23, 0, 1114138, 23, 0, 1114139, 23, 0, 1114140, 23, 0, 1114141, 23, 0, 1114142, 23, 0, 1114143, 23, 0, 1179648, 23, 0, 1179649, 23, 0, 1179650, 23, 0, 1179651, 23, 0, 1179652, 23, 0, 1179653, 23, 0, 1179654, 23, 0, 1179655, 23, 0, 1179656, 23, 0, 1179657, 23, 0, 1179658, 23, 0, 1179659, 23, 0, 1179660, 23, 0, 1179661, 23, 0, 1179662, 23, 0, 1179663, 23, 0, 1179664, 23, 0, 1179665, 23, 0, 1179666, 23, 0, 1179667, 23, 0, 1179668, 23, 0, 1179669, 23, 0, 1179670, 23, 0, 1179671, 23, 0, 1179672, 23, 0, 1179673, 23, 0, 1179674, 23, 0, 1179675, 23, 0, 1179676, 23, 0, 1179677, 23, 0, 1179678, 23, 0, 1179679, 23, 0 )

[node name="GameManager" type="Node" parent="."]
script = ExtResource( 2 )

[node name="vills" type="Node" parent="GameManager"]

[node name="Node" parent="GameManager/vills" instance=ExtResource( 5 )]

[node name="ContextMenu" type="Node2D" parent="."]
position = Vector2( 208, 88 )

[node name="CancelButton" type="Button" parent="ContextMenu"]
margin_right = 80.0
margin_bottom = 20.0
text = "Cancel"

[node name="BuildButton" type="Button" parent="ContextMenu"]
margin_top = 24.0
margin_right = 80.0
margin_bottom = 44.0
text = "Build"

[node name="InventoryRect" type="ColorRect" parent="."]
margin_right = 1024.0
margin_bottom = 64.0
color = Color( 0.184314, 0.184314, 0.184314, 0.756863 )

[node name="Points" type="Label" parent="InventoryRect"]
margin_left = 64.0
margin_top = 16.0
margin_right = 120.0
margin_bottom = 30.0
text = "Points: 1"

[node name="Population" type="Label" parent="InventoryRect"]
margin_left = 176.0
margin_top = 16.0
margin_right = 260.0
margin_bottom = 30.0
text = "Population: 1"

[node name="Gold" type="Label" parent="InventoryRect"]
visible = false
margin_left = 312.0
margin_top = 16.0
margin_right = 368.0
margin_bottom = 30.0
text = "Gold: 1"

[node name="Stone" type="Label" parent="InventoryRect"]
visible = false
margin_left = 432.0
margin_top = 16.0
margin_right = 488.0
margin_bottom = 30.0
text = "Stone: 1"

[node name="Wood" type="Label" parent="InventoryRect"]
visible = false
margin_left = 568.0
margin_top = 16.0
margin_right = 624.0
margin_bottom = 30.0
text = "Wood: 1"

[node name="Node" parent="." instance=ExtResource( 6 )]

[connection signal="pressed" from="ContextMenu/CancelButton" to="GameManager" method="_on_CancelButton_pressed"]
[connection signal="pressed" from="ContextMenu/BuildButton" to="GameManager" method="_on_BuildButton_pressed"]
[connection signal="_add_points" from="Node" to="GameManager" method="_on_Node__add_points"]
[connection signal="_die_die_die" from="Node" to="GameManager" method="_on_Node__die_die_die"]
     [gd_scene load_steps=12 format=2]

[ext_resource path="res://Scripts/ToDoList.gd" type="Script" id=1]
[ext_resource path="res://assets/Font/Hack-Regular.ttf" type="DynamicFontData" id=2]
[ext_resource path="res://assets/themes/Hack_font.tres" type="DynamicFont" id=3]

[sub_resource type="StyleBoxFlat" id=7]
bg_color = Color( 1, 1, 1, 0.341176 )

[sub_resource type="StyleBoxFlat" id=8]
bg_color = Color( 1, 1, 1, 0.341176 )

[sub_resource type="VisualScript" id=1]
data = {
"base_type": "Shader",
"functions": [ {
"data_connections": [  ],
"function_id": -1,
"name": "f_312843592",
"nodes": [  ],
"scroll": Vector2( -115.133, -97.0953 ),
"sequence_connections": [  ]
} ],
"is_tool_script": false,
"signals": [  ],
"variables": [  ],
"vs_unify": true
}

[sub_resource type="Shader" id=2]
code = "shader_type canvas_item;
void fragment()
{
  COLOR = texture(TEXTURE, UV); //read from texture
	COLOR.b = 1.0;
	COLOR.g = 1.0;
	COLOR.r = 1.0; //set blue channel to 1.0
}"
script = SubResource( 1 )

[sub_resource type="ShaderMaterial" id=3]
shader = SubResource( 2 )

[sub_resource type="DynamicFont" id=4]
font_data = ExtResource( 2 )

[sub_resource type="DynamicFontData" id=5]
font_path = "res://assets/Font/Hack-Regular.ttf"

[sub_resource type="DynamicFont" id=6]
font_data = SubResource( 5 )

[node name="Node" type="Node"]
script = ExtResource( 1 )

[node name="ToDoList" type="ItemList" parent="."]
margin_left = 536.0
margin_top = 64.0
margin_right = 778.0
margin_bottom = 256.0
custom_colors/font_color = Color( 0, 0, 0, 1 )
custom_fonts/font = ExtResource( 3 )
custom_styles/bg = SubResource( 7 )
items = [ "Make The Todo List", null, false ]

[node name="FinishedList" type="ItemList" parent="."]
margin_left = 784.0
margin_top = 64.0
margin_right = 1026.0
margin_bottom = 256.0
custom_colors/font_color = Color( 0.0823529, 0.0823529, 0.0823529, 1 )
custom_fonts/font = ExtResource( 3 )
custom_styles/bg = SubResource( 8 )
items = [ "Finished items", null, false ]
__meta__ = {
"_editor_description_": ""
}

[node name="Label" type="Label" parent="."]
material = SubResource( 3 )
margin_top = 64.0
margin_right = 250.0
margin_bottom = 85.0
custom_fonts/font = SubResource( 4 )
text = "Adding Things To The List
Format:'Task,[hours]:[min]'"

[node name="TextEdit" type="TextEdit" parent="."]
margin_top = 112.0
margin_right = 248.0
margin_bottom = 152.0

[node name="Button2" type="Button" parent="."]
margin_left = 64.0
margin_top = 158.0
margin_right = 186.0
margin_bottom = 183.0
custom_fonts/font = SubResource( 6 )
text = "Add To List"

[node name="timers" type="Node" parent="."]

[connection signal="item_activated" from="ToDoList" to="." method="_on_ItemList_item_activated"]
[connection signal="item_selected" from="ToDoList" to="." method="_on_ItemList_item_selected"]
[connection signal="item_activated" from="FinishedList" to="." method="_on_ItemList_item_activated2"]
[connection signal="item_selected" from="FinishedList" to="." method="_on_ItemList_item_selected2"]
[connection signal="pressed" from="Button2" to="." method="_on_Button_pressed"]
   GDST�   @             0  WEBPRIFF$  WEBPVP8L  /��ⶶm%���C�OH���D�Knc�V���{ȐQ0hQ��]/�ض͜�VMi7��ƶE��  ���$M^��*��3��t�3X���4����E�d?S �.��zjn���:�q' 4^V �n �����@��_T$�J9����y@��9�O@f{�O��u�e�>���&b�,�/���.�l/�x����X��Hڱ>!@Z�O���d)����%
��"����X(�86�( ]���m�y\fr�tX�+������g�������D�v�9A	�����_��ߒ�_�k��ڽn����_�b����nHg5߂��ԶSS�u
gg�t|xx�u�5{J�6:�P�l{#��N[:gtA]�(ˀ�*��X[k�𝾛@0�F ޽�������*P�a-��t���!>����UF����@e�A!��䜁 >���*L��ᆨ_ ��9���wܐk��Y-,�� �e�%�H�� תW7WIW�"D��\�R��m[��  ]��α��42<-���ᬸ����Tݕ�1� u%����L�ewڏ�����j�T�V�Uy����;x��F���S�*�0���b;�YV\H�ry��o�77:�"�����P�>s_D�~1MV�Q���K�E��H�C2�р����Sc;M3��K�j4�z{MIpCOJH/Psi�I�Z��T����#'��ST[C�kǨ%�"l�XL����������%0��EP�����؁\BsH�Wu�D�G��B� ��D"#: V$aÂ�?o��b-.m���,CDPcT�$�@cacc���&iU1!�N�I�#M9�_Bz�N�N�1 �F"�$���
U8Q8im6���IM���Ď�ER�ka��D��ûUJӖ
iU	} |S�WK�a'm�FI�>��y��e2%.�S��.������F���p���گ��{o�MNfD��ٌ}�����u���D,`nt]N�
�ߟ���1�����#v0������r�f�>e[�`p�@(��`�u�b��������'�[,��*wR
�Ȱ��C�����RKx�A+���И*�F�NS:�9ɀ�VVVY�sG�.L�ɗ����ib"1���$a0䈉
-4��$؂v�%5ī�>Jg'`_�X�@i��U
�B��.g>w��9|�������Sd�ߗDN����Y���>��,�P��{�ю�2p�J��3k�IOE�\$��U�h&7�_@-�BO5��?���ߑ��zT�Ww��ٗ=so�[�,���Ѹ^�=d�q'�s���u'D��d�'���qg2�B��5�X������@�)0]C4�3t�E�����0o1_� �1t��#�FcoX����Ap�`�m�z�xlb�-(���1�p\�c�ϝ�)t���+A7�>4��?d�fB^�(M@��0�q}����ED'��1�m1�/FD����D7�b:���+T����p���I-�Ȩűd�c�u|O��X�5Q�{8f/�=X��k�W���^��>�LmcG-�     [remap]

importer="texture"
type="StreamTexture"
path="res://.import/House-Sheet.png-e3771758ad86dba735b51e0d4b34d0f2.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/House-Sheet.png"
dest_files=[ "res://.import/House-Sheet.png-e3771758ad86dba735b51e0d4b34d0f2.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
      GDST                @   WEBPRIFF4   WEBPVP8L(   /� 0��?��xP�F
$}��������� ��I�    [remap]

importer="texture"
type="StreamTexture"
path="res://.import/Icons-Sheet.png-544080bdde24ed153b2ebc44f00f7619.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/Icons-Sheet.png"
dest_files=[ "res://.import/Icons-Sheet.png-544080bdde24ed153b2ebc44f00f7619.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
      GDST   X            �� WEBPRIFF�� WEBPVP8L�� /�Õ �P�$Ir#Y�~w���s:D�Z�b#9+���>P̸K*�>z���z��G��.wy��G��o����~��|��Q���#o~Q���Gq��.�Z���*lVE��v��i+��{lW:��v���ml޲0���}��٨���0��ڍ{�{�1�w�m;�{�y��1��c��pw��Ұ�8j$ɑ�m ����T#Ivm[4X��0��o���l�&�$GJ��� '�< �E�� �(	" !2HBF�#y� � � ��9B��<B�sORD B@�*Dc`m�R�0D d| �`��9�_@�c �_y���C~ � \�" z�2F9c<jPF	����8�8`ǁ��l<D �r@0~��� ���8`�����A����y���Վ��X@�c��R�"��������#d 	A�@ �������"���@Ȁh�ڇ�HB�&�����9�Pd(E$�L3) @D	��RB(!v ����F���!�	�H�1E$�� �<� ���(��!!�P  � 4�e��2m	R��G={�"b�TT�JuL���0�4�鬥����J��,oy3���S�TK�|֜M-]w��5��,oޞsUZ�gM�Rg�KOs��j�H�lS6L�����0ЕL ���M��0Dq|�:���w1/�cևc���c�`��䗁¦�
�6�`�dۖ%I������T����{�e�*9��K3Uf"���= ��Df��g��$I�$� ���{T�����wd���
��$ɒ$ɶ�Y,��u���+�]*n�[i�u]���۶]��m��1�Z H)Lfw�3����O���3#$� ֚c�RHP��"2���$ɒ$ɶ�Y�"�{������}��ΌpSa�-I�%I�m��g�}.����
e��mE�E��쾁� ��ok��6�m��~R�#��j�������ӱ�{VfX���)�	�T�'I�eۖ$	�e�����Q��u��Kķ$I�$I��������W�]a,�@�$)�ED�9vY?�۶m�Mm�J���$Cc�un��}����cK�ՒC��d060�|K�dI�d[�"����vV���oI�,I�l�Ţf����}��te	���m��M�r� x��O���p-C�^9 ck �񎜂��r�6�Z��v��*c��@LG�nNP�U�b"Qq&t�L�FT��7ȴ�3����R�7��<��@  �F Z�B�=�J�I.Z��%�}z� 97�����u�p�Er��������Sy����A�����Pcڄ���@e�:��������ϧ��>�L�&�����)���|�y��G����e������ǯ����{��&>���l���~D#  ����P�}��0� �Ž�~o~�c�u����Uz�R?C�;ġ�.@]~$�[�}p([��#���?���������dk;�O&j���A{��5g6�7�S lm���^��jQ� �'� � �{�X$�� �M���:����sZ�c|��
���s�B]�N���O 
� -�(�4Z���緈�c,��u�d�n�e��B >d=�W� ��zJ�a {<�	.�R� =6��媵=5p� �y���F
@�p��J�HP�Ȥ�F��lZ΋%�M��QB��P2p-���* �(H �Qm[Ta���q������R�d?ܚq����������AuS����yNevU[���[! ��s�l�AlE���q�,sA��E7�Y����!�G*�@�j��V�O�vy��_L&7�����_��%���q� PX�̻)  �A( ��~4�����~�Xp�&/j���?R��O�ny���<0X ܠ��*9�.�c^�4N�0X����K�\���4�c��*�h �
  }�G���@���D?nL��@�Ң�7�o^�h0��U�}�.J�����#CP��n��/�Dr�h�P@ ��f�40�6�r�z�4vCV����[n[ �E�    ��\ z�����gsA[��B����nC캠�BI'��/2$i/�������� ��j�ZZl�@/>�
�ݸ�-�j00����Vu]��f��4�����O>��":6�e+�8�+Z?��'?��e�n��WsP�Wݵ˃��ؔ�qh������[-Qo[K�H@�a�ha^	6���4��i7��0 ��g�5l,h�.?���v������	�V>�w��ǅ� ��Wx�8�*�y����uf���!��n� ����mlo>i �M�k�	�	D@�� ��Ӌ� ���dk�`?�Zr�:�M� �v��B-}����	��A ЀH���fC��ph�p�9swїًM讥�?`x��[n
7���)��@/pX��~%` �Ո ��!V`#�I; T�hZ�W��{��`V��0S��i�cҋ�}��	��@��f3HF�imt������ۇo��wЊRH�$3L�L2z���/�S�*h����'X�U���v�ǁf�nf\��Y]O��C�(��(5�h��q�f}���4�Ol�)����7@�>�L��?�?�����C���
���wx,]@�e��wd=�������8	q
�X��%�ʊ�Ux�_l�E	� �! * h�U  ���9 ��V��p�A!@�@9Ba0��/�Ģ�` �M��"���:�y�����Ƣ�c�Cد�X���?Zq���
 t  D��؈�\M�H�x�֚PL�+`��l�b2=q�K���� � �[灉 ���"���� \� �h�+ E�b�:-���IC�9�+~�n���������{��A�:�	�n�F0�fu�~T���R�)�D�����u�l�.��l2��� ��� P����R�Z��Y�Vv�2���y;h�۴�gd/*
���\�q������?=�]�s&��P�o�'xw�ȏ���4	�a��,Ы����N��jgftĈ
�FԒ�]!���@�H� �-@��i�T�n�Ͱp����@wJm�p��n_��b_�<�A5��`l=r�� ;Ϟ�$z��QC�����hI��#��+<���^�∕\i�� ` �@P�>���B�]X7�Q�U/<��F�ړx d#�*��2%��h�B&q� �XՔ�Y�V �YaSO���`�����11 �}�# x��p-%y�\�|��s��}41y��O���g!2p����_��o��j^=`��aR�������~L:����Y�J\���C�էh%��j�~��囑�? ��Pk	ا�`�a���6`�<�.Vx��n�\�x]�{�������������w���|�8F�������;�(��� Rq`
��@$	XAذa�7?����2-O!Tcy�p� �@�i  � Q�7��6jk��'U Z\��F�GC��NW[ H�E��{u��^z�M}2����V���{�"�7
��*��lF[ 
@!j�K� l�<?Ն.p��> ���@A˥��q�1�xk�5��qM�1�w�gbƊƂ#�IA������ʽB�L���m���*n���/��<�E,\���A�� �V_�^������O|��V'�u���1��ݧ���T�7�i}��k�`(/��H�d	��@eIV:Y� W�M H��l��^Ț�����m�k�\z�)5��V@-��\a�)�Il�Ǜ����[�0��Z (����"����O�������5� �a�W����&��~�U�p,Q�#�S �NN�d�z�tm�  ���d�T:j5>$�0(�j �#`QO xTk��Om? �*�с�d3 ��@�f@5�������O�E�R[ @���&^� �������� PP�����G�w����|�-_�,!t�x\�gu��ѻ.��7�
sW%��^� ڧ  (`���C? \�Մ�b�<�\ @r~a���z��s���S[(�~���i��<a��G�;
֩yF�x�?�)/7�NL��3�	eS}�}�����{@�s��FkZ�u���?���q�=̛x�������&�������N��|���8>��$�<Y�9L3�0�@`h�`Q�w$ �^�݃٠���2ӽ�����Kn�!0  D����:������ ��e�q��p>��&n2�\/���|�w��ү�6�X�2+����wׇ��b��M�vпڮgK{��H%�Z @���� l>ڲU  [�`�\�%�G��(f3�hi`�p�q��G�(�uO�_���,�?�����Z  �q����{���=>�Rl�YB��� ���ZF� �H���Շ j
�@�#�8J�`�@K������(�{q��l� � ���2W,R??�������[Ro�iXؽ��I�]���$U׀�������׿�?�-�?�d�̘���Ȍn�k"D� if I����'��}��n�c��.[�� �P%�ѕ~�NE�`���v  `�5����`�	_ f�d���=�)ꞵw�/��V�X*��P���>B��S�$�R�l���ę�l��ۊ&��6z���3�k�  4 j�j�f����O~r�Q{c?/S�-PG i�o�������R�ݶ8���0 .�����fP �
P��й������R$I��� �?��yg�J��N�h�O�d��}>�|�����˻~��c=�������5X،/�=|����sy/7�=D��ۉP=@ >ƇBY�"��W0�9��J2|a]�%1�AA�<!�#� tA��тd�ۻ���{�?�i�[����
vI��k�@�"�[ �ڿ���_�n�������~�1cdW�O]����0XCy�B������������F��5ot�� @��Z���#�F�yx=����.�B��xj��Fh;/��Ag��o	�z �*}>�  (�_C���V�s��ȡ���,��)�7j�6������'����u�l=���~��e��f�2� * �;�@;���X�Z x>3 J�1	P-�! ]'�;�M7C�"���v�虵3��n~� ��ɟ{���o��.�_.��1���W��?����w�7�W����'q�3�����h����P�Z{�}@2C�� rY?�CB��˴�U@�d@f�s���D�yF?ϴn��~��z��������zCƔ
��Ĉ���_$����˾yL9Qf	�̃���>��sv�������������{��������oy�(
Pu   v�����M	  �T �x�	���FU�P @��e�4>,�� ����$�޵�o�^�%F4�o'l7�Y�
���O�?��?[�W��x���ݏ��$��%�� ��!���7�0�U� &�RB��7% `!�ΤG��X�׾��0ruӽ�͵��)Dng��r���C�*�R�� �$4�D����g��w�f�|�Q�|52���p�����\�.0{\�(?��=6��?(�  �O`T�磖�G[Q  D"(�?v�u�0�\�2q��������0zE���,������ܮ��|��m'�ٟ�cJƠ� g��,� W��@�MY���T�y�|'<������N��y�X,��BfE����1����F����j]�y��Ѣ�����>�i!�j��D<Kr�N0`7�f�Q����۬�=e=
ȇ�Z��b���1dh;];�] fk(��8���6a�Ѝ���*���O�m����� @�?����:�l.d�@ 0'f��;�B�E��l�  БЋ��H�o��r����njCA�w�1+�|�Yj��f��#w��s7�����o.?>����q�ضGk�o��
���:%��hc�Rm� �Z� � @U�h�9������sدW�K�
�>�/�������R���������sBY"�J٠��������雑�-��W�P ��lc�U`qv/�^ug �@�wF0|�
(�r�e`�� 0h���;���D��\?^.��cޯ.����-�P�j��g�,~�!��
�P����h��UV��; �?@}rOG8��#E�  �k�>�n�����r[TB�� �c��	@��uI*;����6�S���@�c(�� �K3�[ԅ.�[�	܊�<EN�0 ��������]�h�' 4�L�F-`{cK�U�Q�������|Z�A�c����qC �A��B����W��o靧���q�[���fl�������ȿ�+Gf �����g 	��1x������g�O �� (�R�
 ��N��=�.��Nd/kb*�������У�������.�K�k���7���흯{?�����'�3v��42� �w��
��������"Fϖ�P��H�n"�b �ځ�G[1Y�G���z񪫋n¶��`T)� <�� @u7�?�
 ��c��]��v׭B�6�E�w�Mh#�P���"��
a� ���a��ڲٮ��j�uΉ{dؠ��g�k�H���a����P�  �������-|�%��,o��uT�ߦ�������L�!@&�  }���|�[n��7ի����~}-PP��x��*��oFL��׾cAg�C �A��#H����>��7�����rHZ��f�GA�@�� 	ƶ���z���(�*��#�~�����_���oai��w+ИP^bŋȑU��xaϑ32pG?#U^�p/�e�-�Nm6M�X脈/:�9 %5v���� p8��¸�#! h�ja�����ٲde�A���| 
h�|��0>� j  �ϗB�+M3���T(D�� U�`��^@�Pf+�t[/y7�BLa�69��.�I8�����!h��{��l����O�h��86����վ'_@x��O�����L�r�no���70�����]�}0#�R��2&� ��"  ��[4oc��M��r���u{syݯ�~�����018
 ����N�g��ٻ6�;�T�O�� �\/��l��|��s�aպmڐ_�<׋��#dL�
�lM�D�  ` C,� �f��V\�#ih�$9������c�8���x�Kx�xG��\aRx!/V Ԯ\��A��n&�2�[��-�~�h�S@!�4Bw�?�.�$�u%(� &� �b��X�@Ug$ٺ�ybk�	�� ��L�  @��օ*Y�����N���]�F@���������y�f)�h(�*��*x��g�S�9�����j���Z�t�I�jq�|��P��+x�޸���G}�$�>6��   ��'�Z\v 0>�+:�]�v����&-醺���6����˘��ޥ�Es��<}�-z
z�Z=2gAe�Aذ$�8q ��G-��������>n���ϟ�=� (+H�VD`�� �rֺ�tj��[u����&-B3n(�@ @7��m?n��ͦ�#�.hhhi���c���а��AL��:%V ��̂@���+B� ���*P��0�
CU������
m�X���� ��Y����!(р]�e�vʥ���i�ej 0���(��^�	����g�z����������ҝk�\/ZB�	�6�azY�2���՝�l�zP7���wt���{`ub0�Lƻz��G�������^뛏��|��7�W^y�;b�y�]�Yp�W`_?_f��_�+��~��ɿҷ���7����%�KC�Oy����{*A|��p0�s�?�#
��� 1� ����4٩'�@d������+C
�@p���;�v0o��؏�o�������	@�� �$�z��5����+��r��/���VE����Ɓ�d�����U
B$�a�lD���:�=���޶_�;�'�-�����__��_��}������֍��|�O���{�����   �� b j����~ܟ���;���������Bˡ9����-������z�@!
�|�?|����|���@Pm�����M��emF|Q\�v#��W����f/0�B��A@��EąX�66{SdR�T#��(��`�����a�g�s-���rV߫�7W嬻�nw`Z$ ~Tj0X��k�0@W�ڰ1Isi};'�a<����u{p��`�  1����l��6aPCSC%��ޛ���o��,wM.�aA ���x�P�+ԛ��-3��B��|���? AHh:x�di��TS���߼������$���?D{ 8�]���z�ws�vk�j ��[)̅7���K���>Q�~G�q�N�e`H��C�L�*��8�h{�U�~�_�������j$�NT��������{��� n2X B ��n��6����8?:Z'ΓXn�`� �_���d�� ��[��zV@ ��[�	SWZ�F���V.�ڱҖ�kp������������;��}'��@X�1��r���^��A?Wo\(v�V��w���Y�!�&r{o[^:�ʙ��:�����\�����㧿�\+�H�"��D�> �>]�mB�j�6��U���4�̊��iC �� �?С��px��.`�Z�#Jdk^�v^���p< ����y|�V�(߇[����2�A ���>��]>3Q�(��eI�Wo��9"�$�uπ�`��|^��q����	�k�PK�@�����ܑ{�b�Ӽy,��ֺ͡[+CbC�|�q�?����I2 �P}��M�i �{P� ��6a�}ov� �*� nl2��Y��>/��aڈ+h�#�d���������E����/��: ���B����V�����4�ܥ'���{�߯� @�7.3�-�_���|YF>�8���7�j��>��Y���M3��/�ɞ�ix�3څ�������&[B��st*4��M��G �N_�a	�6�C�����l���w��2h� q~5$i|9���V�r�o8�; I �>OnT.����� i�$��G��o֧�7KJ�)ط�w�?-
D\[�!���8?�gD����M�n���Y��h7�[�k�Ű��(�  ��f�X���q�q�����c�bq��x� ��k��{�e
 v7Շ^��1�� ���#@�������7����f�+ݵ�ӱxR��;�ڌ�SؚO�A�tv:,~UJ��}9�@�ݟ!C[�lO����	����^õ^�N���k�A��D��P�0AǞkW~����=�]>�5�BL7�漑����4� ����XҕenaP�v��̙	U&d
\H���ٹ��B�?��pw	�|����9���g����9������	p@/ �ʜ��&�s}��}.�F>� ��0�@V�T�!FJ�^�z����O�~u�Rh<� `�=��Tz䠀��
�1�!r$�O��~�^EZ{1�X�;t�yNֶ�ü{�Yآ�����5RG�y���|����ot��A
 ( ��Հ����%�� ��]ﱰUb����g�# [�p��u!����exe�h��⪍ �c5�W~�L�"���ZE��;�@��g����U�^�nZo��vn2�`�fk�� @����[�  �0�@�����X?Q�.]Ը|��dlB'/�|@u'\��nee���M6<MTz�Đ�y���sƻ���y�w�}�m�Hi�kǻ=���%��WogG@� ��A�Vm���SO�����?~-�	0��%nօ;� �i<�3 v�p;�>��)��_�S��Ny�;[���x��fO���9�_BN1�P��α_��!�_���Bo.�\o�I�[�������y�~��- �%�o�~�ʼ�K�{��  d.�����C@mc_�����p�F�v�'��ahslu�� ��`b��I���G�yz�Q�YS-@�/|����˼�� ��<�����Ԃ�bkji��T��Ym5A�͸�����?;|��1ж�|_B9_�A���t ����jфN�(u.��3���I�s�e�UV��H�!K�;���D������/���������dv���|۝�DE x�����
��r�������4waӞy@��,�j� |C1�;�Ŗ[>�����M�P(�}�;��* �@=���ɿ�{����� i �����e3�\����s��x���r�tsy��o��"B����o�hv@_i��d7�+��"��>�j@�5m����(^�l���_E1��$:YCkKH�ZSLi�����rZ4qG*Ӎ�*�hOP� \ ؆f՝ ��h-�列\O	A5��Ʉ   � �*ْ�F��>�[����U��A��(��uK�M+���z���n�)PE�4WhC,m�.Z�}��c�&�D8_�~�������r�|�|�Mw2����L`���	�����`$9��V s�fB�C��7m5h����O������{��c��#���}���C��b��:b@.,4	8�v����L�r���E[� �Y��|�{�l|n���q�  U���	�؇�I����MV)6cB��@0�l�j�&J@K�[�I�d����ˎэ�AB��Q��Z�	;p�KE�8�n����0��$3����#���� ��c� [��"n�T�@7lza� �$ dH��t�-�t�V�| �.��u�2��-`P��l�*OLW����h�,��>y�{�a�q��*���o��7��̽���d9�P$tzG@ ���2�(av��=�+[����.��  ��w����iv���|�w�np^��U׷Iƅ)����}�d9� �oو�}���}�wsG�0�}`��% c��D@�.(� �>��)-TJg�]���۱M�l4� ���mw��n>��_��.�Kn��~~�G���۸k�@�h���T+G�z �1k�~������  ��!���/n��5�3ۛ�U h��Z}�+�@+���o � )�����1��R��h��%�+d'@S5Q�w~�ϡh�Q��c<RZ�n��Q�v�+��j�c��"�8 � G)��w2Q�ٮ�N%�:��B�q��3C��
��Q�C+�e�N�D�|�p�;���>�G���y�vB"��qi66
���	��C��저��^��0;;3�
tZoX~XI�<4�d�3��_�x�E2�[@<���(�w��2�z���}S�7����A\� `�=�M��o��O�R W 0,Ϋ5!
"X`l���7��]���o��w����>���2(l���om����Mo^��@�7~Ą&�sP.��Y��
+P�W����2 (Ă 	��p�̊�q��,~6,l�@I&�(6!�a?�v���!r~��JW���Ө0;P�P  ���i 0�fu �'t�)�^�Y�&��|��sq��yƃ[����1&I�B�`�	��}:�%Y V�õ}���Py���ۏ/����
񜭽o��8M��i�����1� ��]{wµ�.����Yݚ�0g֯Y�$x��l��7Sh�C ���E��������l�+��dS)7}���M9[�����@p��؈�"qlҩO��� \�b��J�^U�l�_�ޏ��Ͽ�݋m~� �OMƇWh@����ÿ�d��-�k�%�(��g   �P�TmF�g̍��e_��A��������/��x��.��mp+��n��S�?��L��9.��U7zO�`�o�de��)���-���i<�@�'Z�dKR�[t�㲆����=�\E����/���}�77�ˌ񘃉S( Y�<��$�������N��U�xKgf�&��P?ćX� \@y����k�>��Q �@Y�,�=s�^o6�( ᱡy��mM���\e�S��Ծ_�~������7}xC>_=�V6lQ�e��L{���sQ��g�#b�>���Ce`�x��#]�W�̎)wa#�=�5��_��9}������o|��%�Ӷ����+z�1���̡c���ɉ����"l^k�7�
}|H�Ђ�����/Ď{š;m�H8����������?��_�oZp���O������u����lc�	,�h�a������FQ��"��@A�q�g3g� 0�٠�0�~����^�X?����rMЉ�/T�~Qߺ\��?��; ���I!��������}~�a�aT�U��� �a�P���e�t6���'�M�Eb]�DP�x�<j籿���LQ���vxDħX�BT�
Ɋ� �H�$��r�d����!�n$�C^�g�M�@v ������f^��4������q��F�&<t�(Y�.\�Ѵ�*�9g pp��y2T�c8��J�s<W�1h@�8q�iP�������o{���ŏ��:-ǆ���U#�*o{Q�0F��~����.��rT�9R��ւ}�mli �����'�'\moX�^d�7������ i.�R�|������?��q�} �� �7����>�ڳ]�;�1�t��F�7&�]�ˡF�0F��9 �*  ��T���]�Wg�u��c/��w�zc5Fh�{V��u� �� ��s�"�����6w�aLG7�x�P<� [��-Vᕌq��R ��:)�yy���Xh��A���@�G@y�`ݱ������m]Z^��ҷ�e�uq�>,�m2  ��;�2��n`qK�g����s=�]|~�l �Go�"�J��%2�"�I�����P��oћ�Jmf�r�ЉI�Y;$b�0d���B������˟����l{+0���O�t�%���Eh���8w���Ji:r��v4�A��ev��c՞���B����������x�½���C��������q���b��Ѭ�`Mm��>Ϙ}�Y� �%��5�a��1՞�����P��T� ���� �wT@Ŏq?�H�5������8/V�(�0z�䒼�K}U+�O������&D�`�  }��G$�`��q�w�) @���?������ۼ>��<����O;m;>�W���}�G�Wha�qa�].t�$H���DA�,�d�G�����^�:��&��#�	�
 �\�mM��G}0n��WD
t�D/�i�;�
�A�W0 &މ��$I~��:}��͎{Yf�/u��/>`L<�h� ��K� &���?�s�[}.��Z4h��>�V�u��6���G-��&S!m�����g3��h">r� _�k��K`�k!���o;2
S�c��XƸ3?_2 _� /�6���M�y������T���g�������eV�q�����J��u�{�T�� ��9V-_9�20h P�(D��M.Fe�Q�1~�� ��Jɦ��>˗�6��Vx~)���?~������1��U���h�]J�M=T���`�*�ѵ.@�
���\��E}�- �u������2�q���7��8����z��.ގ]�$�Y	>�p��m�� *� rI63:����L�p7#ɬ���4��kS�b�ȽNm3�aJ�^��� �Ib����<ߕO���#s\� 8C����O�R2 �8�-#�щ�������9�3�?���r��qS�0�E��`����8�22��A#6�&�Y����++� {�i� �hk��(d��-*��R�GUd\� ��6{���=f:�%���o�����_��&�V{���	�7ޡ�=�A���;�R���$0�fл�)��x�@��$�[��	��@8�`Z�Eq��  kȴ���7��#BM�6�+X��UUAw� �<���Q�t�Zx0�·c<�<�g�	��| ��@���@ �=�V�s�����H#iK�@B��P��[�}��(��BP�m��M��~����z�7�O=� hx�s\@��	$m\/(|	i���˼��d���f� "�B��	�i����������ߗߛ��e��.��E���ʤ�0�յ�&g@G���-j�:��~7�������<o�m�z�\Q�Mw}S�	��x�$ ���W#�u�M��fs�v�$>��]�qZ!^F��CT�ml�8��:������b.��8�1*� -'��D���2��f�
�N��_���w����f�$t�Y � �v�5�'�h�x-ϱ���;���\$�\nv ���a��N�3P`��q <���O6� Q3�BB:�c�y��6\iy���������T0�z?�U,�*��$�F�6 �3�=�ܡ��/��~μ
P[��Uv�4 X Т� u��\5h vk0�8���{� ʲi@lQ���~g=Af<�$�I�F#�6t��p����"WB$ه�&E።F�WΗ�o�߼ЅL�.�U�� � 4��f^���O��%�@���-�:���mҤ����a)�5���� �1�z���l�%��ၭ�`Am"�L�*"��`���l���Bj	ݡ��[�	 �6�6�}��/B&�;]�C���5W����σ�7 @f�t���� ��7��vA��$L&R�̅ ˹٘�|/�=�A0��d ��O�� �oB�>��Q����2�}�������~V�U�]����� �<��Q,U@�1^-U `�F 1~r��� ��fE- ��Q��y���G!	
<����|?P�Z( x �� �s/��m9_*I �mI [  �dl6�ulB��/gfo�����&[w'^<��IoSS��n��J�~Ef��F���y��nnł"�A�[ӑW��5SҦ�Z�	M1(B������O"�uC� ��u��F�<����d�=V�������3�]?;���pX ���dr�_,�v���b�f��3=�Cz����F�%n��F
�C��4�åO���5�ԡTȅ� �e�ؠ� {h�����ޜ=�~�?w�P���/��<�PE��� ��x��B���7
m �� (�*�@�	��g�0� �sM�ϔ��-j�Zn�&o>|<� ���.ւ�	-_�h�^�j���������nLn�:�}�d� �M��Bv�L�Ch���H}6��s��.i<H];_��A5��yQ�LW=��t̛��Э��fҨ*Dͨ��P��~m�F̨@�u�(�f�K��<��2�7]�?��Uz�$���?d7͓�A�	�)^[��^+PpU����L`��Q=�}�}��]��8�E�4��@�4�>�|��i��$9�p ��+��K�}�h����xe��J���&_�/2���^����g���h���� ��V�����L����Y؟�h � ����R<���ȡ��TV���x��P�a'�(J!j��" [C�����|ҽ���]ঈ0�}	
 @Eh0o�j0;���/�7����Į`�n�+fV�r��p0߇�F!@��~<w������n&dw|W��y�͸pM�� ��di3Wm�!)�<����2�=��BPZ���@�̸�͈��K=h�����2��y�SM��۠��f��������_k�C�o7� ��Ħx��n�y�����cW�f�����k73�0Me��&�jpsa��@@��|��|��p�����H�{�f�]�[u�K�}�lqz�޲�{�Y�5Xx��{S���ub�4ğ/L�}��J%�?�S�N<�  Pba����T �PϴX(x�:�e����#)��`��>;�F/�
����al���%n���w��&`�� l��5�Eb
������������t�� �wH yEBs��=�3n���i��t� �o�'�D�+�'�ןt�j�܆5]���	:Z�8����� :���9El�gt���E+׺~��D/[?]ֳE�nMb'p��{�^�W ʱ���]��=�� ���zD������ܚe	������؎O���#4� �@s�b��䗟�}�( �|���f6����s3eN�q�/s<�G�ܫP�/�2�5Hkz�ȹĚ���5lĬQx�7�c�Qů�ϳQkG��I�� ��
Ex� ���?r��y��@?%�`O<(����(   �b ����7��������_ޔe]tm�h� 2y_$�.'l]�Ud����7��Ho ��z��Ϥl�	���4t�5���Y,�\;�3O���L>@� @ %�C�X�6A
i7ǩ��+0Q��ȧ�Dlm���\ ��p�j��V���Gy�?���3C��(����.�i�S���<�f�1�ڽ�͠����q5Cn0��� �kaL��立� ��X	 ��4 �/fؗ]�@���'���r.�g��W���\n�����Ca�Rf 0hm � KV6%7�a6��W������g��A`ri��h��@�x�G[�  ����q��~���2��B7q Q ���>�0 ��cD��f��������{�T3���7a[N�/�yZ�����˗ۅ��o@�b�%�\�^��A���*0<@�7Y�;�{��f6yΗ��d4��@hP) ���%M�#��-�ۡ߾�{����yӭ_�+ �@��h���;�m���Ϝ��{l��5u���,p5,]��x��_#h����,L��!aK\��9\��[��q?7n�k��h@��Gb�{3�`[�>0�&��:��}s����3*}��KF_���y���9��J$�1�c�3�f���;�/d=x�:����{�S���X��'m<��l���Sr���Do���sp���5h���y���E?�L�Ο���U�v�����7��(X���y.���"��M�}�~n���Hl7 ��� !�x�/��d���e���;_솻�Ɍ��P �w�����t[���֗����]�D�)& Ҁ��B��톻j h�	�0�ݍ%�ԃd:�l�w��Jw�G��CY���ݵ��g�§�E�"/�M�T�;[���������k���z�+�k�%����qӚ��7]����]�M ى)� n%23���x{�������?�X��M���u�L�W��_����o�M�7��kn��3���y>���ꫛ�D7�<�,/�����Y;0�A ��̩x �f�,��������2���xu�x���@O��[�S�`;(,�dF�q^�~�K�|��?^w���x?���X��:m1�u������W
wry��c�q�Y�ė���j^�,�zI?��&����.�0�%t[�(�f�)�@n�}SǦ�8�@� ��n y G6��q8����,�k{�^z�3��t���(5'�j���"N�p���۠�u�1��Q�~Pj��i�(P`�@�-Y��<���rL_a�6���f@;Έj����?�y��v�[�������8J��0z�U�"��/�y�כ���m �qGA�\�H�����M.J>cI������x���{
t6���9�Sr6
�*����Le+;w(���&������x~v�Q׼9������}�Oz�Iܨ��MUa��7�K���� A �� 7�E��p9���&`{SS1  v���� 7 �muӭ���Ee~٢@�w��M۽e:�v�Br4� �/@��K��� 4��
��M>o" � }��F�~�?���6zE��F-F��
�xZ-<ـ;ٲ��
Q!�%5�Y��h�<��=  �pc��;%39�G�ymG���PnfZ�3MEk�.��O��v��ܘJ�؅��h�,m0���|y^�/����i�S7m� �Ɏ�|��ww�y�;՗��43�Vc��BgfϷ���;��! ����~UA�u��֘�7�F�ԃ���i<?��ˮ9�[������\?������i��D\ �9r���@EP ���    A��b�hLl?�'�k6��@�Yvc�	��, tv�y�^����2�:;����p�e�ׯ��L8�}��|�H�7w�� �OXv��m_�ν���{��wHN�QPl ��n����x�Y4�a-���S�B�Y��J�{ f�`�D�-s涌�7_�^�sg�A{��@���\O�m���sTq@&�'�G�������Đ?�o�l�^�KSw��yN�E!�H=��8�Wי�o�}���-�瞟�t�
��9�����e �ZK@L�% 1�d�zs��F�=z�3��y������8r���������7��� ��g��9 .��0 �������w���n���7@�s� p3v@ ��G�sp�4Hv���k�����qQY�oމd� ��<�%{ʳ���zp �W�/�H�]�]���irWH�@v>L�"�C���!�#��\��Կԟy����ԥ�@�
T(��11d���ۃJ��xZ���c�ң" ;�h[��0QM43Bu���=k��]I�)F�nt����5q��d���m�6n@���w��|�si.��{��&"mҗ��� �dRO�r�|`_MV��}�/l�$�瑿�#�h7� 6
V`�� �
���p�����0����k�-* _� �.��𵠗��z�ܜ��������4d����l�j>�<�E@�P��Zg|Z�9B�GpT�H   �_q�;gDJ���;�]�۾��խ2׻�: ��$�^�/��T J�{�h	}����RHk���]	|���"o��m�=������]��V�e�E� U)�!H��1���\�r6�lU�* V �}�D��\q�ht�[����Ǽ���f���W���f�n8�3j��>����m�@�6�7$����<���ޭ��� ��M�Z�| B��ƙ�@��ܥ���o��]o|Q0Ua��ǯ�K��L$�|�Tuv ��i\m �}2��5�%��)Ty����ǀ�U _��-���������-������Z�>Zke��z��ͪٵ�UK�j��>:�`� @���sb0	� -� ��/�����Mf ���&){�y�y�[�M�${���G$Ib��M��)��U �����w�)� ��ݠ���;� `�#+j(p�@�G�^	&�x�����7��,Ъ�G�#�b��,��0�� �H^�ՙ�j��:^�� �Pն�`��Ľ@j��<�3m����Ҟ1p��|�A�.�����A&�+�>Oj�t�n�:8� �=�#�B=���w����8U`v'mi�A�t�Bn �8�.�/L@Ѫ�A�,�?�}gHD�q�5�ln�0��PjGA���݄Ir]{��Kn	���Ah�. �]��f_u�wF���M`�,�U���?�����N�W�$ �V2p���Pܞ�=��F�Y��B��}��WJ��&���b�s����Ynt%��J�3�>oV��� (Tk�	K�[f�cڹ����B��F��V<��D�(3��4�&��6ݺLm-pw$�x:_��g���7�)�mB��$�Л�q�& нy3��O��y�΍n�a�@!
�f�^d�j�%�@ 4ܨY<����͕~��-�"�\��������R䇮���n�� �q�� �ӆ;�*E�����ds'���m��wH����^��v/U_pw���&�#0�R� 렬���I� X� ��(�������� d��! ����\a�ܤ��9��:wa����Wn�p��7@�����q�]��#`0�実���/��rY$'�Y��߰f�@�4Kj2�6ud �` ���s�6vl @h�]$� �{�J��?��kB�
 `�)�ܲ�5���z������Y��&W�<qϔ�x��� o�x������tο��'c%���Q�lV�$ @���!R��Ds�)n�����\~g~�\t�}����jw-���$��%�m�������[���>�d����%�L���[n���GUiHCk�b'H����&	��t�;�=�
�}frኗ���2�s�_=�⛉�d�e��-_�����:/ f�4�)4�7�f�[������a�w��4G�|��p+���( �����n��������.z��d�ώ��Y�Z���E��cOEB@����JP���� x�%�|�ȁѸ���N��n�?�uݯ�tZ�w{>�8oy����������I�Y�OU���n���d�g�Ϙ��'�h ҹچ+�V��pk�C$. ���@BL��%rX!(ɴ����.o��@�yo�-󢾯�rb�&7g��K�Ύf�A�%�0���»�K����  ��Z ,A@7��?������	��Л��Q�����)�ӔPS�G�X`6 ⒇f�Z�E
��.�	��$W|Ax� T�\�-o����l[���'7t��e-�`=j�8o�}�)��5 ���4Yw	�B� �v_�� �D&�7����������u�.�k�7�7�����o���t���]�B�D�E!������n���Zs!�d�ͬo얘~�[~�kNe�3���-�E�n�����嚿�|� t������z;�>u��d�@�Yn%�f��q�������=��qe_����DO��4�7E  @�
 ^��Z�Y@f��L�Q�	����� ��I�mS`�6q�Lo��q3O<�@�bW��yP7��<vP?�d�U��@�d�H�3z!S�)���ɨf�l|c��w�9L�Ad���l棻0;Ѻ@�6�
(W]�g�|@��=4��\�~�w]��.�^�ٝs��]|9�F�����1(������f��n(�k�b _��97�-��^�t�܅e��~��@W�����?{��0�/B����K-����N�a�t�.h(�܂̽U�~>Q�T��-�x���������غ �/�w��`�	!�Eu��]��_�ݽ^�1'�R�l�����f#X���}K�[�����f��d=�/���֞:w���`Ad@�1�u�6¥���H�����+?G�$
�ʮ���F�}�nt�>��0�� �P4U�{ޥF����3�"MK��]{��P���~}=�Qh�Kd6� y��4��t�>D��N�I�%��$m:���4�#�@h�7M�w�H�2�9ߌ*q&�����b�ªL6����F��YY� q��q�h����7�ֳ��)V��16u�  �@/��epvAk �"H�+>�7�.e� s@zT�xo�x�?<ؖ�r� ��*(.%u=��q�?�a�S˟\�<�z}�W7Fa@L'�A����`�ы��?���d���D���u^�l���7��f[_��|ߕ�0�D|!['��x�s~����W�V�����INKk~5�-))��8R�֞k�y�y�3^f2�ע���]������޹�5�9&T�ZJ}o�k|��F�@��݀.(8EM��aR���]_E�kҵ{@5��h��;;�5# ��06�]X�����-D끛m�ށ9��m���}�y r'Tݿ,n��b�L钢�����63z`Ǘ�t�8(P@މx�Ը�l"�.��@���{��2��=�>� �t���̠�d,���_���M���8�z����߀N� ���e�*p N` �MF�� BA4�\-R~�4�kV`��g��^~s� �/`q���l�����Y���k��:�I�����=��V'vv���q�D�I�v��e���MX~?����s�w�s�=�עF�Z^C6�W����b���w�?oF?�j
��m�p�Aз�������9�:�v�۴ Q �B
�8-��@�@س�\�)�0 �8���no3jf�o��i��Dms�u?t�޿ 𡂩�λ��8���T�0��F���m�,��كz�}��e�S	�տAP�w�����|�_��0��R��OT��ۅ΀["�;�٣�l�I���,w�j��L��drǅ�� (ޱ\([0Fw�9qGe6���=�m��@� �E_�.`..�0�yܤ�Ð�\{��p��u��޽�Qww~��k�V� ����f�qv�D�M4�� �ή��P �|�{��'Z 1��g?f���-J��N
�h�̉ZM�<�^{���a�~����#,Rs��'q2�t ���Lz�\���;���O�}˽��Jp��H��+�Q��|Sr3;�E�]� "\@Q�/ZznOK���uZ=�����i�!��So@ä>��h
nz�v�;�����{�=�җ4�*|�:�"��J�fҎ}�e��������sF�A�P��uS��B ���-Q�*a{
C{�}��~�@u�j� ��M� ���p��l�H8rp����/z����&�I����y�I"��*�t�.nn<En&�P_@y7r+�����s&1ܖ������:�s�l ��}�$�v�u�v� �&�m�\�k�����γ�ʇ���7ۜ������?���H.�qSY��$>,�λ�M޾>xFOm�O����X ʝwGF'�Ҳ@�tJpm�HB�����=�����o�h�º�F�d�U�ѐ��sן\�?��������Hm�_��:�:u�oo"��.�~u���-��]�:@Ζ�ߌ=�L�z�6 ��oLo�d�"�@WB������8��x���t�w�w�%o��y�4����M�ӡ��G˟��I��3�P���
��@'�������7S��}�I,8 ���h?�j��I=$GZ�&8z��f��X�L9:�:�J��$R��կ����E��2%R)�;���ށ` &�Tv;����G�N���  %�'��QX���S�.[*���8��۾xq&��b����߼_|q�^�7H2�)�YW&h3ad�sX�v�ǯ�V��:-�j��Fٶ] ��ȃ ��2�Xh�[ (>���[������wxm��֬d&,�
4Ph���?\~n�7��ۚ�W�&1F[0� �/���o��f����;�ֿ����HV���}���~ɹ%���
{�v/0���"��n:yfr��a,��Ov&��n��v�w��[�=���U_|x����F��R��H��0
A�%9x�i`��(��}����@B>�|1&^(L���B�>dW���[�p���^ �͐ r���D��	ɒ&�j���dt�L�qD�ܵsI��>3u��콫�X�ե  L@�q��}���!ڍ�ސ,m���D�(��C@u �"F�'�vb���v�	 ��;������7܋g{�@вw����=��G�q�n��s��:������ ����W�$���W
D�I��TK%��P~���|iEm����֣�V)@,�tExԍ��A�s9�o�����׎�u.lw��N9x7ķ����J��$9��<������k\|uNV��Aq\���M�T��/�<g���e��)�� =(L�����P��������:u^���H��
@I�ɎY�H.���[����������zzD�/��o�;�-��s��4�0m�ӵ�0�B��^?2�6a�	�0!�����U܆b�I�y0�p�*��1WN{{�7��U<�ۤqI�BpB�ٲAuO/{d� ͠�dy��QDZ'����0�7�!b�n'��!�gg��d�J�fۻ22�3��T2��;Dz�;}�lQ�afy3�0��<��;Q�+.+Z����5�)s�����T��B` ����cw��{t�~���_�N��ҍ1 ��Y[7K$V�X�����?�۹�c=�y��>� ��� h �u����������+y��ϱ�Զ�*/<u�`�!A��|.�s9/G���o��>���������k��P�a��t���<�;߯����O�cm=�J%*�;���a">tZ<�v������W7%�m  3w���A�7B��%�]�cN� e�5Ա�VB�D���IC ������_v�,�ݸE|��p�Ҧɛ��-}�-�`��q��y iq�$�b�\p�p�j A�h����8Ѷ6>t A|~V�&$I�� 2r�θg�Nx�, m���~��H�@fx ���9�r��33��tp91���ogc2o��/�'����dW�N��-�\�7&�ұ�M��ٺک}��=�類�k�� �Y;�d� ��k{���\��]tb�e |J �   @�,K��&�Oh9m���F�l��I܄f"�m�9����2�u����w�B��8��3p���u.��w�'��"W��Ws���`���  �� �� ��� �q��_�'G��ڰF�����p��|�Xpg�ӳ&�.P	���tvZ'��
�UP
h�'����%����j7ߞ?o����`�z ���w) �ҝ�K�Y�2���W�L��Xu�9�ӈ�z��zy���Ӥ^l�� �}�W_q��&��.��!�xU�������$|d���@�����^D  ZhI����y�A��l�~�d�C���ᕍ�s%6O&ѓy&�q1�	g6�@] އl�/@ H6G�SROؓ&���#Z�L���R���l]�+�@��7-�)�	�L��$d���f��6A���u�p��M��<��,��\Tj��)=��Ң��	���h�@ �] �M4 j�h�]XX1zq�9,@�4J2�z��>���;��}~�湜k[�G_��(��C�T�7�.��wn>�;��j[R�/	NZ^���A .���dR����:�:��qd.X��
����YB�jE��q��G�P�s~��S:[����K�^^�.7d}�'T���m��|}�KH%d��-�2��']w��9�G�e���˵�Mu}�p�L}�[��~\u4�|rӻ+y� i w>��DOX����>�or��fw 7�/7%����,�AhL@@���g"��M��	�`��Ls_l!���(�A�9Ô�D�~�����Y� ^���K_��fg#,�Nǌs�B���� ��w�ΊB˩�'�4�v�MB�A#���h[�@3��5�	�<�ip�B�d=dp��L�Y��ݲ����A�j@6�#m��ߣ��7�ۘm�6��0�Ϥ  ��<#.  ���H ���`bם@*@�� ����r.g�\������p���͹  �/\�������YI9'��|"7w��^�4��m��!�h��  N��B	НFk�7�W.2�mrJI���L���� h��m?���<��>�L˳\����K�@q+�u��d� ��� T�;���KZ�������B6�� �]�X�
�]����@S����O�a4�I��}���"�y���/\����udW5V�ŏ n�\����6&����+ `�+����,_���5s�"���e����s�������ؕfH�;O��Ns��֞��D
	K'��m��&[wr6�m����"��f^�:��_'11��{X�Wۀ���Wȴ4�����)�)M#�}� �봢*@o�ʞ�@�vgb���Mu�`'�@#����Q���Ǣ�sy�\w���^��z���h�����<6�q�_�2 ��� @ �\���uà�4HAu�@k'�ϮC 4��S@�ԣ�F U�Ex|=��P�KQ]nӿ)��,�U��#�Νp١C�w�"��-�D�
�mP��L��2$3'r��t�Yn�� #��ڂ-w�!�f� 9؝�Q�������&�f��W�a8 0p|&��������,`�$�~�����Ҋ�o�8=�K�:o�����3�L\l�s��鶝 &M������y�R �\�/?��;��E�?�F�u�F ������$�0�R"^BZ��$ !#�-�@��R��l�	Ʉ�߻�@�n��e1� �aT;u����)�ϨO� B+p�π�� �(��,p d�&�b��戠 p$Ah��4c-(��|��<W��ë��׿�����_�h�8_DC�����p�}�df0����(
��� ���@�Ƭ���qhY'b t� 8�e��ٞ�BikEc�!�k�-�:3e� ����� ���c���E�BBVA  ���ܽ��A�g`MJ@��@T��2M�4d�z�I�5o^ŕl0�����63��>
�|�B� R-D��	10���\z���;�2�x"���1DD@+�VϘ���!+DX��8��.A������|~�k�7-S(L\��ͽ����3���ɲ�b�t�iv�\�_�mݞ.�� �L�x��5��_�wU���@-��,8��R0�]�;W�e��\B��$��Nj�&X���:��@�%��� �;z����c�:9���x����T}����}��b���G��h �})Ё�Ja	806�F�@�)*�F��@L�yO>N��N9���_����x�~�x�{�8�(ɹ8�����D凫z���,+n����g'�ED�B{�B��՗moE��Ac6Φ+8A��]Vw�$lP�4�	��A�\� �Q�v�e�j���o�o7�[�Cr�d'��܈���A+ԁd���:�@�dotI�w���n�8 [fJBg=T��d�v�� ���M�=Gr�KS��8$4{��6����W�h憌? �#��� �V���	a�
;��ǹ�����Ç|:׿}~�����*̈�����E�̑>6M���EƵ%U��}��N���x��43ߝĹ�#���_�8�b��dq��i�ٸA|�&諾��p(���9|������~��$K z��xm(`�w���@H��f���'��;)4h(�\v���ۜ�zrRd�
�y� ��[�.�U� �˺��5l�h.�����܇�������ۻ����pzv:�o
���tv,	uN̨���6R؊�H>s  �"n����I��jLs_��� =?H�0� Y%��O�U�1��U2�<���7��y��o���0S��������o����&) ��X�n/8��Z
�P ���t<r��L�i����U�̟�n|�O�u���r���G�7�n�:o����N��*NWr�!�<*��M`�y�
v ��� @� ��l1/��ϒ7�\�s��NUL�����Z�'"���?W&"��r�[�u���u�r=-��Mh��ϵ�������x��	 E�M�D��Õ��h:ŕ[}�6)� ��v@�X�P��?�����&�Pş"�{�f^^nK��kr�9�j8�O@����=�nG&��X��%��ȁ=�lu;�_����D@�  �E�C��Vbr�-���vx�u�>�ԬGd� f�N��Q� a����7���+Y@ �݄"iy���b�j*�d?a�mo<�e���jX�5*�`
|��
 ��<���|����N���g`�+lF��m}�I����Zy!HYh  �i��q�<��\Ϥ��	i�n$��|s� �-y�aj0���q �b�.��On�uq�|;���^���o�o���pK�.|�`{���BO�z5	6K�sc,�&�*���l�&��ZZt����;z��7�!�qA�@mm!�S/A� Zp}0|%0p%����ˀ
<Rmj���f~�����Ҧ'�"�{
�:fa��@�O�X���u�G�
PU �W=Ԃ��i�J ���/ 
 � HXx���`}Z O�� j�)�����y�����c�f&$�gR`��/�%40h�H�9�29�Vu.�f���\����D�6��nW�q8{��|�FD� t _ �J7�Xp�w����2r  .@A �>���~� �v�9�  R����=3'5W��9���ľ��` z� `�(!Cď�Kc�N���u�@0������/0K�����b����8Z�ų�����i��Ĺ�5���~S �" �\[�Q[�OXr� B`{��ӂ�ǌZ"��HжJn��%z � ����EWX�h�P���@�EǷ�o���$"H���~� � ��H��U�ɓ�/Mx����g�ЯL$��;/�};;
����e%o l; \�����o�p �/�\�ٗ�a�K<�x|���l?�k=��^�(p��������e�)w����c"���M 6�&��]��q}��9�_�>/�6}����+a���xa��aKO���`!����Nc� Y��MєH��]���[  *pS ��!�]�6T[\r ��e����Hv���Q�Hn8C $���
$-,@���9E9ZR`��|A�	 ���ހ�J_�8�i��Zc�D��^W��^C�e��\�m� ��P�~����ѷ+
 ���>�lx�x�����2�	MD�W� �]�v�5�e^�#��������``74Y�'���
�=*����Asj� @�y��+��Nt����_D>�;֙A�k����5I�0N���
:���h=�|�˶ ��! �`�!ꀽ5�o�|�4��2A��� �( � n����q� t&?ڽ�+ҝć�ߥ����ф��M��
�zU"�'�@n��N�zǯ��;e�A�^�'\�oH��~��m���� �;9lz��b �����헽�|����n;SQ�a�F�p��|����#z�v ٸ�E�hkΧ @��G�X��x�sq�����w|�@���V���	�h��>�J&����GE�> z{{�
�	x����U�U�  �6vA�����O����O�YoP������6g�Р�� ��#��_~�&��82(0'A:_��t��=�x=Ѳ�� " "����u7���^��gܻ.hdT_\X Pv;u�|C 0(J�a���x��`5�A ��������e*�qHhh0@��1� .J���^���:�D%P�P*�#��s�Z���H�G8A@l���h F';�+X|sn���@H�N�������~֒k<�x�� ��y�Td�F,��LT�ƨ @޻w����.���_i@ ����<���W`Gߪk�r3_iJ� 8� ���?% ��q�C>_ay`
���~�ć!
�^�d���wx`�:���M$uX�i�
����9j^������?��hhx�I՗�������r����� h  `k�1�Vo]J�|��Ow�A��r>��Ԯ�åʥDU m���������,���]įf)0���7�T�&bّw�?s�����L�����z��p��R�R �u�T��K�xn��&`[��h �/�� V(AГ� Y�iM��j�P�Q7������|`|B P��}`䶜{����2��]@����j- ?�������  �]�ޅ�ouÖ38uÎ~%5�MmOK�/�Hw͊ؚu1�����P���(rՆ>a��,Ӻ�-"�<>�3�#���Y�5�Oߤ}�N\��>h0S�D3
��� x��n�0���1�NB�c1 e��+fovr+ͤ����]��5ǎ)�F~']r�G|�SD �2��7��4>�v�Sv�*@�D�@�z`e���6�=�NL$��ͫ�`َ0�lO*~�;r<�ob6�h/r�
�q�B��.��tJ �sq3��PՃs�4w�cr�C�`�zuٱ71�B]Xm��ю���w�ݺ��`4�M��	�^��L����.=jľ&՗���9�p%�[T��Q���w�Ň�q�������Y�"thP^������g�|b,t��^��
�5�Ƣ-B��Tw�M8 �����ṱ�؛)����,������"f�OL�b8���. @�����IqTTF�Qt���T�ݻ쵩:þ{,����w8�ώ����W>�8�������7v�z~����컾/!n��%|�P*�7[f�����җI���R'm�/��Kn��`J � �w���W����`X�uZPm!=�Ժ�A
IU���+Gj?S�����k���עYzwVZ?t,v&y�+� �z9��ٳ˥�ֽ#��[��=�:w�V��43��ܶ/E��.y.��P�M��93���b��  з	�����NѤ�ά�5M�>������@v���S~���l������٫�(�t�~��z�t�c��( ���Z �rd���B�CN �^֝d� �>��t�vwV�,J�.� z��t��B��v�d�~6�|@�i�ww�ds��x�M��~�r�@�.J�i5
L`�|�\�? �y'���|JCh��_	�����_��d&�gqQ�\��W�@���d�b�o��{w����;�����S�K�XL�2 �|ΨP ���d6�sP�����l�ZjU�Ş@l�w,_�!B���N�V�mn�����:�,ߺA���u�%��k��}�w{Cxm������~�������g����%�(_pl�/( x�{������A��.�>�#{��pSԼz;W���ҿi��X���2�#[74����{(袠�V��l[]T��=q�j[�=�dWh�ޯ�6�-_}p��J�ހ����L��$�~�R�y��nrK׷���hͬ{k���ej�`$�)�G�f*���m�1w��E�$ݔ� ��.�\  @U���
` ��  #��xПܞ�{����o�1nݟ�´)Q��s������[�D������W��ۻ��?��'�'^n\4 P(����6��胱9���v��� d�(P Ǿ�mv88��:��C�9o���{��k�.?���0}����!w:GZ� 2���|@���O/	�"� M1��{��ۚ�ґ�{c�'gzl���:��V`��/6��s�ž�����O�mO�?R�츹���� @{��t;dfu+a�cN�"3��,�[�AU�Uh���]*߮^�Q��-��m���/�Ǎ$R:>������g����O�-���??�F{�'�8�/J��|̗>O^ai �<v���|�=mz��,;�����gQ�k�����(� ��~*�k4.�O4PNf�Qc!�|��_�|���k�x�X�e��`{ۙl0��G�C(�V�x����!9�w�o���$ ( ��ϰU�/��zD��n����r.��t�E�T�O����ֽ��f��n$	  ���g杧k�{a����~&���`E���C��yw˱��@@������9�< ��%�� ���p��1���Zc$�&O����p���ɸ�+���Ş�t�%�g����'�� j_��Lh}}��G>�7�����2��:s�Ŷz����۷)҉c~��z@6A  ,�jI34H�<����-h����^z�E)`��}�P`AK�C��om��8�;^�r������ϧ��ü�
Y]q �)��P^�\��_���{���Y~��x���[�y	up�������i:�;W��~�s���9�H#&�q����7醦o:��L&��o��o��eQ�����K�;�֖ >At��pP�Hpn���R+ʰQ<�l���N��P�S���s:q.`��ʕ�\AY ��9���������MםE���~��~���ݵ�~��$�4����w��2��z j�=���������G�ۿ��/4��	��5�d�������w�;���q�خ�^�Tۙ�� [�e���&	ILQmQx���� x1�E@-0D��"��ڎ�Z>���G�eBd�uDT�kR��U+�a����,H{���+f�� z�`OnT٭w��ө{H��s���ȑ��P�-�"J�}��G
�,��w8��t�م+s�j?��A�Ci��N��ԝl�,�y����~�P (��(""[�Ͽ���:�������9�{��������۞�7�|.� �  � � � 7w��%~�ߌ�Y�hcn�N���0H�zw�}���w�;��E���  ን�^�D����"�7�-T���W�5w��i�ɠe�Cǀ5�����uП�������;ўo�vz�����)�2j�&�(�ѼԶ�e{P�a�����x��@� �ٙ���� � �+����|t ��� ؏��%x���9�%�k���yc��A��|�G4[[eM�(罨���7���w����s���n~d�����������H!���o���#w�`S{`���戇�$�#�o�r�1�Bh.�%�n�%'
��FwS�1���]{3X�#���\u���4a���X�s[�ݛe�!d���!Q]?$?oq�X�Z�]���hpm Hf/�6�U����;@���f�q3o�q^��3�.��q�d̬^�1����ݾ� aR RT����ڶ?N��-�1Aa��)�����)^|�I��ck~�����&B�  ����_��`�S[@6�[�"�ư44_��7oA$2��7��iL��ǓX���|�u*�yQ��Йk\��e�?�_���6�����B/v�-uz���3��Mi8�«��S/��X ���?ٜ��1E�/��=�8h�ބ@g���' ���1C�7:Nq `+ �����[G��e��I���� �@=���,آ�L����gD�s�Z��5#̐�uE�s�G6��̿��kh����I����i�Z8��������G2��'! ��6v=�����v��E�e�'�d�u�?��尬����Tq&�����ދ�ha�����g�������;���.���X��#`�D깼��̬o%��ex�( �Ȁ���I�<w��_��<rѵ>r8-cQ��B�|���1���ƾ�>CL�vv@ɸ_0�` H�
Кƾ�*�wX��f�Q���6�`@��2���P���d��z���H��=�w��g��6��u+�*���I�J� "B|��.6�u��c�����c,%4Ҧm��a���*rb}bb�:�շ�f��w����;��`~��
��,G�6/�K�.�9lVe`��;�1������ �
:`��q��,��c]  ��L�=m@j��b�h��u�a)��JA�ob �
���  ޕO@۴�6|���4Os�'��YC���"� �Ӷ���&�Ŷ�`�"� ��Q�cl�\��8(�Bh����r��e�.��Ў����ڌ΢�m��(��N��;\�<�5| � F=֓]�j3�!�G�ڿq�Ews�|��M6�v��z9�?�w@+�p�+�캞�1ӹ����U4|���~Z�hG�g�r�v�S('�N�X膁����N�0���d�	�|z5�<�$��  �_��&��c����Z���,d�N#�c ��6 @Q�  �fM��hDD��k\� ֋���,��ŶV��&�%n�Q������r���Os�ʡ���� Ԅ�X��p!Y�V f6��,/I�繹�.'o�t�S�q}���~��2��<�||�U����?Q3}qc���/�W�^�M��#�{M#�Z�(z�}���k�Q�w��lk=9����A;�D�`Z���e��p�>=G @� �9 Z � ��c� ��-ߣ蒧�to�IB��a��] m�:[�Z��B�B T� �u>U��b��b�P�G/vD�G:�<�** �ÅX�=��Hu}��*�۝q� <�[M���)�06����x�����`U��^�QY�pO��F�%�%_�/S>�O�;�{� @
̣D]4X� �	0�d�s�i@�/�	P�_�`߁��Py�< Ѝ�J�n?�� �D�  ��� U	A����
. ����QA�: j1Ǝ��G S����T�xi!Y�H:�y���v�l���FC��%�6�&���|x�Nӱ����uO.�����蟟�^&��'��\��
g�ΐd���߻.+��5���� [ �D����@����h����!-�/_��)����f"�z<*@�"h�Y��������NJ�XXĎh鯉�素�*���O���:m�<�B������|����H.t�wNH �LE��$Ǿ��q�����������k�E4(:D��"���2�����Yk�<J՝w���3�#,v� � -�D�� ނ���H^�a� �� �x�������� j�O7 � �@�����$1T�G�P�l��O��Z�`
�u
�)��uEB:�N���v�7�mu[&����o�37���g�b	����;�?o�o���o�q����k%�h�{~��c{4�ݽm�=��ތ�h WC��{���(
����n"��00��&T��c�y�-  P���� ���G��>D���~N	�-����%*�jA��<� �� `Z�7Y`W����6����t�p��G�[�+r���	��:�� @��i�R�3�#��eI�P4R��a�'����~o�U���xڎ�!���>�N��@���  ;� `��� P�<	�����?p �nt��˾Ɉ~��6m ����Z���	��	ִ�S�@z��i�Pl=R� Fh����A0�,�d�Ź���d#���5�`�V
߼�u ��P��]����Z���4�ߙ�Q~���Ҡ@�?�U�$��_�~��5�gڮ�G��fWP�@� 2q >@
L�h?�ZO �� bH %_���(?�Bp8���]�\l_ ,���D���l	���9���e�A+  T�K.  ��Tt��e��83��+��yQr3��o��8��R���C�q�2��d?:ʼ��q��\�QF�o��]>I��+��epG�@���p�@1�5 !i�BEP@3 ��0�/�>c��y4��3��d${
�,L��4�~_�o��'� �� rn|�	����K���܂�t[�=�� �u��
qa� Y$ci��������_���d�&�k��؄���h�p=����p8l?�� ��t
 �=��OI��A���qɹ�f��7LM�)�dnz�BC�V�X�[#ƙZ�i���ŶX��݉���݄*�>X?�~��]_�_��f����X`�fQ��ڑ�� 
 pߵx��~��x��6�Cb��f6M�9�H>��u!��?�
 "��|q��<�S�k�L"�z���u"�i�g?u�0%��h�0y��`f0�?�p"���}�s�Ε)�p��r�����x���_YQ�9�4[�L��Rd��\���#�X����]��KL+SB  ��u������h!\�7��zB�I�	��g������um�k3��wy�v��/�ϻ��ܵ�_�"�����G�,n72�'��%�߆�GB�]��F6�;��L�w���� eI�m	�0z�h?������Ϊ�{(-���x� �.�� ξ�Ծ߀&�NdvCd����B3GQ�/'f�,;��^���f�4~]Ξo��m~�w�
�I�4�$��;��{� ��.��}�szT� ��6.�}Q�̓6㢆�k��]�G�%/NE���b�?|Pw%%% >8� ��#'��Kg��IJ����u�2w�����}�E�]h��.�p�j��|��|~�:�@# ���/1@!Ǆ0�"�_K)�W��Ld����k����#���(�D���㥒Y;�&ͪ�Q���_ d	E�x����-��x�%�_�@�;[{eg|���iJ)��e2@��t7������	�1�   ��L ��w�w#�r���|�8zZ2`_�e��g8|�T/鹶�.�9�o��0{�@OILRe����/���݅�  d��b�ݒ�e����A�K��:�f�5=K��=������R�-� �%k8��p���o�� �ƿh�����$ r�$`�wp��|D���(q;ǁ��}�z����o���P�U���	*�!��҄+렼�}��6e fv��t���].L���	's�\O��8I_&��V�F ���-��/�����9?�]�����ЕUWF��� \6�;3����`�AT������E% {2�?����F��w�|�5 9@�g���aҀB��>���0�#;�+`�}�c�.��cg�&�H��MS���~���Vx �$~���ozG���׹ӘS `��B\o|� ��� ϰ�/H0�����Z�s����\�h-M�?�)|3��4��ng��7.r��@&;;��ܷ�g�X�Ң��L�u�~�c��ժ�߰���^7@3���m?�x'� �^�}b_O�[�y�o3M.�a҂ ���G������E�`���  �� D�(!ځPA�9��P��*f������q0hB�:m��;ˉ��ڢ���Q9r8A�9��̝w�[~G�yS�W���˦(��2
ϻ�� r;�*�����~����y�-�#�� |'�@n$9 ��u���'@�>�e��Hı���P�2�)`��M�R��@���@��!{��wP3eᴞtJ�_2@��'�-��`.�	� 8��}�]����裁�J������wS/u��Ii�v���˘�mr=2^�727(9�����πU�9v�D��TL3�fB ��>- ��#�IB 9��H$[�yJ�9 ����2`�D��8�*��_sU]�zg����&� H�_5��1�g�~$:'PX}a���N��Z�2anP��:�@��E�'�`H� ģ���,u)t�k�z����%�)�� #B`���_	(���ၔ� �m�9d�'a"��ihr ��^cB�Qc�S�R@���/�{=��̂�(��ܥ�8�,�E���	����έQ���s��a�E ��锶Q�>��l��@m���'X����\g�nf*P�F\|W9 :�J�u���@B )�e��6�8=�˃l`N�e\��ݦ�b���47y`�]���5�2�4���M�)��2i�i1p3��N��2�ҭ   K��(m���A6��7�me�� �Mi��`RY��z��0)�:�E��4��n�7��j�;Eh���/�L�+��?�� �!M ��k�� J| ��[[��2>L��/�-s�Xǒs��mRgkІ��c3��b���xt`�0/Y�3�SJ�a�B}��a ��+ @���V� |y@�+�H��'E�(n2眠��A��}%��|$s�=�����w1Pb�����.��WȤr  �����;/7_�����[@?��$�}�^x��#^��@&�~�{��2W��͜��s^������a+��� ]  � n�i���|�eΟ���y��V��4����Pu�Z�۫<5�F��<���b}���D�b�-��#��6�V��]���_����f�6�u9i�({��ng�������_��$MZ�E2��M�<�+�@эo��2:%�
_;�A��sm�����U'� �o@����P �J�_~�κ��ٯ5�P�>�d �<��JD_�(� 4s) !s�27�dԁ�B_�O)�w���Qy4r�u��fm貸+m�|�
S�l%�����ey3[�6�Ї������`y��m�B�=i�.7i�^�������ߗۙF�A̓d_ߒ����C\��뭗k�/���� �I�_._Ư�Q���� ; d5E��pp���p�p��{%)N���d�#l�`n ��JĐ�l��W #�T����<o H �.t���xU0���� B��R�T�?�n����9���80`РPx��ƻ�@5���&/����3���i�uު��̃9���R���L����rɎ7��B糏���޼|Y=nl�a���L&��Ę�]v�1 ;�
�~��&��^}��7�m�HOG��!rs��8.�
�$��G��
&N2��u׷�Y�3��;;Ŷ�(�g�����۷W5M��2�ri^��񎛈 $�մ�S�N���� H�A 6]�@:�f��[�C6os�[�/��F��/�02�����cl;s���wE6��z�7Cqֳ~����|�y��ԡ��Ǔ��lY-�Wl�qξu�D��yB�,SL���Ys|�����t��K^�ٯ~j���V���Er˓�uV�YD+�!��X�}�H> O��dw�4�g�7���H!�
�ɶ�t�2U;�T�,خׅe�Ԑ ���kw0n��� ���\n����_?4�H���{�3�j��*+���b�hC/��7H� �T�+��������
zej�\�e�V�"��j�/Ʀ���,{\������wì�6������v�U�k/�LI���z|��������ɕMf�]5y�P�k�Ј��v��,$�;z�8�'��\���ӷEx���@:��������6��0ټ�޽: �A��M�͝iũ�6y�,��� �!!z}
zOp��5Y $��89ڗ΅Ͷ�1������z���9��cۿ��[M��l��]K�?��W;���?���i�6�{Ĩog���EA�o�.��dv+L�W��o_�s�0�F�駨x��"4R�k�m�������ض���l� ��o�;�  ��lɐ��i�����A��-�ML�	�����˳,�fk�
^=���E ����%@ӑ�s_�>#���ުɉ���K3����V��dq��|�]��W�/�H�:��T�"�,z������yG���fl�����J�x�8�:��n� __�^E���f���\@% x}S�k� �m ��ё���!�pT�4�H� w��I�	x|��ڼ���'�� ��׻���x��|u��f��K��n��؀�[�.ta��?�� �� N
l��1��@���&��E�Ndp�ʓzp���������ɐ�%,ŤxB>��˄V�H]�2ۼ0��f\Fp�e�;^p��0n����`/u��@4	Kxs@C _���k���v�q�Ʒ�@���p' �$ ` л�'j���!����v"ۦ� �h49(V��P��b��I�uw�̀���70>[�]�f\mZ����}�g�Dx�-B!�ӣ���s�X�95`�0��F$���l+�9���4f7z��8� ���.+��S�֒�v����d������B�u����(+?����ih����1�A��A
2�ٯ՜��/璯74��wwv�d�����G@�,�`��X�� �š	��"i|��h�~��y�'&�{B��]覚���������S���Pt��ĶO���$0�(00B �{��1f�2P\�8�[ۥ3_�ٿM^�y�6�������j%ڱ�B ��ВAѰ�܅7~�����u�]�C��w�'��?��v�}�-�8]O�'��C.Z�fF@hJR>����͋Ьw�d����;�;��G6��E�I*ؗ	*=ȫ�e,r��@��]�7ohƥϥ;���L��O���Cv������F�iBc�l&?���( �L��:L��Y�Y��0Gj�yCWE�y���r�]�ֿ��-Y�7@�ޞU@MW���,:�����4=}q>���F����������:�����un�]i���ۓ4��SM��t^d��SOo��>�$Y �����[�A&M����\�e 
� @�ͼpY�ͼ�5"HL�q���W� ��֓�����S��R� ��9��/d�A�.���=g���׈��8��}g�|c3%���ܴ�t6�g�1Ƣ��څ�;���ꓸ�%K~��߿-x�!��u{o�|z%�2���Yx8�˦�A��H��7�� �P^!�٫�|��8%6�Q� ��U�����B �}��
�+�/ ��g�Knc5zS:s�pX��"��MQ�5�r� 0`����|�������j$���{��d_ ����$����4 #�����S�g78����.�W�������?�����P>Wc|D��=�������������}��z�K��'6P�&����7YK���n�W�~�蝇�d����������A��SncQuf��6̓u�S�S��G�; S8�?ꓹ#\������+�q$; 䎿g�r}f&Ȟ�K�\��B�2梭-���6
�l�t�r�n����@ɘ�	QG��u�G��4D��2�H3ͮ��
F���X������8���#���u;��;-Gk��7�����</�RwC�5�"d^����Py�!�:@�ݱ0̝ĸ�d+���)P2�#�er6��q��>2a&k��������)������ހ�	�	�6�� Y����4H�y�n9C<���q��)�A��t�U
�~"La	(���7>���{�Il�A�M�V�S�=-쎋�7�mk�u_�^o��G~IOެ�ȏ�1�}ί5� �m�JhrI�Ek�S�kt�c���vl(��������<iަy��AjI�E�i�c�r�5�!R l�� �#�4)�n��ҹ��g�T"��m57|{�⭈�ǘ�H�f7.�����J3�S��-/ɂm&��;����������_�t�Ɨ���^�*�[�V�2�̭������pA�� ! ���o t�E����#d�6�hCg�;�Ac_�4�|�`�2���qyS�Iw�o��������.�N=�M�����1��a�L�;�[�-s�j~�s�tlϜm�皌�@P���+�J]EA�� �������B#%�ץ��TU�������<��w����������o��O�5(���${��o�.7�&`xf����<7��횼R�̬F	���r���t��������o٧��?��{�)?oږ���~�|�����������K����G8�t�
��l�O��q��(�ϵ�rs헻��$���Clnx��:;ϖ1�A�D8޿!- }����d�[/t/�K�)���������-��o�t�̛� ����s�~�-ycn��Ӿ��B�F' 9��\�;�����,��N��˱x����4���C?������_�G���_x�@ޭ^ s0�If��w�}��s~έ��"i���"���)9��~d3�r8z4@�&���`x������Sޘ���|�N�6�Gs��-�2e@�~��q�}Q�@g�zCv\F�4���ֿ��_�N��f�Y�![-��{@��qɨ�e/L��_X�������'�ܗ��K���7�V_h C��p�پ�^�:Nn���]@�C��V��;�P�NS��O�[�2�����ٻ�l�M��'a㛌���o"�o����@�B�0���auGB�)A���P�\�'��;�  � �y�-�
(cb֤٘@�	�~ƹ  ��U��F{N�~��9j�΅EG^����{�n�B ��|R��9������N��Wo�@�H"� 	@�u�K���P]$����䒽2�mnGwif��d}T �9�|rp�M�[���f�����_�\���TF�EӟCB�k�Igǝ�4���v�1	7y��B2�|G�����l��祻�N�  �/��ɛ�r�/��-���" ����>ޓF����-IQ �li3�	_�;{rw�Đ��^�@�I7���]�^On ��������`��V��̹j��'�/�:ezH�	G-�xZa�� p(i��/�ҷ�[�.�>�d�����c�۞Αl�y��
�A �g�5��~;i3,�4���ּ�����@���GZq+�~��o|���c�^�3!/�腕@w0���T �$��<۹��j�q8{����%@�~��I�y���Bvpt`�X da��(��;A�w�pWg�9��{nr� r	 �Є��BHC���u��\*[o�<'�2XY`:z�-dǛ��,�. D���n&d��wv���o�����3�ŷ�7�,�c���ּu~Λ��J� �HH�J��PQu���F$��O�N�W����f����|1��]���V]�K���v��b�1�#-;{w7�)�����7�������١K8���R�&2�䘘L��5+����E8u�����E� �^1�z�����e~��I5�(�+ �B �S<lXF�_to�o\ � t|��'s /1`v¸ᶙR
"!4���������Ɨvan|k�H>��lgcJPV���B   �m5-�7��J�� C,�̕��(lBT � ��'@4E�<L�夻��.����p[7"�M��:i�s��<����<�z~���e���D:	����¶J����)�m�|Ms��`�����������y�����*;"��i_D���D���9�Sg&5W0#?q"�9 
0�$G0���^� b�b�����֓	�;�n��g�6�զ�D�������C� �5{���y�w��n<ggכ�nr%�A��7�.`s�,�i��@2����%�N�@�`a0�-�u��
@ܶx�7o���K��`K[Cu^�ce���$g�3W6s��A}8���#�7����M�����x2 ��5����)���G��0=�	�!�=. \ٰA v�2����pKc_`�$�غ\��|MM�l��ͷ~�t�A�D(���}{3en�u�<WG@~���33�$�pi���"��Z �-�`�(��H�~s��"}��3�4�"
��i�z;� �����H�et$4��w"��7���9���_X�ƕ��w3_�q�v��az֧un�  �����)�64�2q��sO|a�Cs��l�`�ru2�W}�ǥbg�E��fގnȍ���l쳥 Y�a0S�2o������K��%�	/�-I����[ m��/������  @�
 �4��gw��]L�u#C 2���t��(B��^
h��a�u?��5}��2��iN^c?&
Iu�Ykz��䋇�K���h@u7�q�org99��굀�|�zB�b�џ�h`=�e~� ��d����<ue�|�~�F �o �t���  f � �q�m��,s��6&�XNq�,�渱���k��S_}S�ͮ�@�k��y��!3�c櫾OCT���[����62� @�x�fi�*t��O=�u��)$�%k��@f��"}�t�7}�ɉzv��M+��E�wyf��	��E�� �P��,�@k<��eA�͌- / �)��� ��dI���`g;j1��z��
u�1Z.L/&e���L�%]�n ���ݟQ�~%,Y�8 Ȍ�Q
D����tJ����C����܀m��"�y�4��Mros( ����^���tE H�>ng��y��u4�͑|�}��f;uƛ�VE�~��lJ�8�cj�-��" ��xd���7���&v�}�Ԙ;?����k�q	���>H>0�Gk�=]���[��$����""(�����^�h��H����ͼ�79��&�|E�O/ �/�js?�ZY�PP47���I�*�o���*�����
i �r+�o���o�ӷ/��Qo�D r3�̙���_�N�����1�Q�$���)i@!��g<h2Bf$��ɭZ}��$�d4Y��6�d���[����o�}������5����@/95N��g�K>�P ��|�x!�.��� @�P���xn�cc��z �ѓ�O�y��� �GsH�lw�˵�K}GsHwyȽ+���y��
q(|�zS��zw��|w�` ��d�ق� xY����*��2��o{'}[��ۯ�ư!���c�lg��i�'YFg ���.��=���	����t���d�1���n���SZߗd~�x���p��%�| �
o�4s���I�I�X�@2�Qf �&�f����)᧯��*�l�����z �,��M�g?�"w��u�G�� ��P� ��<+�W|����¶�Bm��A$��7�Z�����oN�� �̧V����)P ��]#����r����,������ "��������2�K�@8π6�� �l�����9~���J�C y(	�i�wp�ʢ����N�h��@7.�
�tn���63�H�n����Nw�G�I��_�����?�N���x�s�M��,��[E3^/��+7 ���ݺX�wuݧ��M�2�r��k\�ZH��� � �ϠI6Yh2en�Ӥ�`:��-� ��f趤�W�� �/�c��4mz�N��.c 0�*�Q,��/�7P�,�{ ���t� �Kk��^ ��mIvO��L<�A&|����I����Դ�碭�d�����rw�`@6j��� p{�2%�����WFv
�h��:afm�7�K��ϴ16&Eq8�j�	sܼ?sF�� (�������\�v����䁮���j����c���`%�� ����ݕ$�
�0 sd2A��
\�I,=�V�4ݹ��c#(�+�b�o��Rw �
r@�G:7��E��� $�AP�&� eB�;�Gr4���� ��d���M��U�Y�Vg�F����_�s��s�AH)&��B6�����;�Ժ��=�o�/y̀�G \�-$�O}ۗ�n� ���A\/�w�'|�T�������E �Glߟ#�yK�mA�%9�c�r��\�D���Ɍ����\��xpyd˭V/(�4�2��A��|{i�7�D 2��/nI�`.�>���iM�\�=�c�j�3銗�iM{���-1�e�7�o���a��������^/�P ;�,iȫ�-o���������^3Y药��f:���K֛Ҵ��W"�d��w�3�}@�͜�y�޲=����ߏ�j�LK!t��o 65�o螾}����������0�h� Ì��0��ѣ� ��g_I��`�C����Ļ'�F ��}�Ix�����l�E���V �J��� ��~�f������?�[�:Ͻ���=nU�p�W @z���;�H�9������,͸����o=\�P�:�	���}C�g27�eZiO{F @D�B�:�pZ"e�0���q�O�^���
�����\�]ɷ�}�ϝ�lO�&Y�wi��U������H�h ������l������ۻ}�1sF��Jяk�m-x"��0�>��(�����&��Wm�g�&@T�)�O�m��u����&@,rD3Mg�`_n����C�G ���M�/�$���[=���9S� �O�aG'���ٸ2_�j�~�QH�+@�+��~�9�m�RFp�.�OJ>��^G  �^��L� p7���Q��z{���~;uz擴Kf Y�ڈ} =_�AH覑�]�}�������D��\���  2 0<���䂌ly�^�=@�W���_�3�H���3c�S�!؇��G(�t�g ��v��G��]7RA_4naq�n�3�8�t�Wm!4���\dv�d�p�&j_F��I5�IA�w�������<\�=2g?:����w �@*"~S2ٳ�sm曜�E�1�ߐ�k��_�_M���f�W�P��L&P�A='y�� B4
�ca30�O���u�>�{�9*�+��8칰͜��,�Ö  �|0�g����~��zY^a|���;�6�q�s��0n����D�0�p��:��R��O=��X�Fo�@�&�%7u��~ B�j@	�\�\�tS�B!���0 ��%��r��Ni��i�7H�&ͼ]�E iv.ͼ���:d����+ � �>ɀl��ZҬ�,� 
��h��`Q�gX8�?��,��\��ߖH�Sq~p ü�-Y��e��v�����!%�1���7D��  �y���ycx;n{�3	>Ypf�d}ބtZ�l�o�YN.�O�%[�y'=��&�.t�&���͛S��@�ra
��	E���Gv�^	�n43�2H���dس]{c�d��m�}�����0P�9�ֹ�$` ��?+uͬx�r�[����C��H�CȄ���a�y�=\N���	»Ί�d���X��T��������H�K*��K������ �k� ��Mw6�/S��^
/b!���bD��+�L�- ��p6�o/x�4P��̞�f�xIv���?�9(
&"4lFO�V����on��^H�%�r Ι�y~O�������K�x�4���H��M'�,#K
�N*Ws���v���텍�f�4.���� Wu0l0 �����`כɤ��i!Ig�<��fϞԥ���v����ﬄ7������D�曼p��Hw'F��֛��A?��)Z�9��W.3�L� �W,ӏb"�O����.�� <�q=�+l 2DB6dT暸���뭄Iq"aP��;��@ `R@�Rm��=�S:�:�w��_$��Δf^�4!&x���ol���0�l�2�că���Ё��Hu��y�k�nK��H��LӬ����}/7[�~��!��5��u���df��_��}_�Ѝ� p�"%�!{rs���;�yL��8��u�87 ���ο���~��6���`�  ����^�s��c��#�ڹ�[-\r$ȍ��	E�E@s$oL���Ȅ42�"	a����|�\����W��M}���\'|<�����
*o���$1J�r��� > �ts������7���d�w �!������f;�m"���~�Yo�:2�����������i�i��`|M�w<|,�JW-m��F��2z� 
d@X���e��O0��J�+���E2����h��z#3�|ғ�Q�P�>�|�����.���u4}���On�����]�ܚ�'v%���/���+K(����1Q�|z��\�ۼT�{pt#�Q�r���f�6���$�c.;��~���k�%���$Y����s6��ZN�<�� Lcd0���1�uy��3��ٯ����V+?��yEz��f*w�e�v�vJʞ@����2��$S��V���dC��_ $j�)=���lB�|;���;@@jk����M�g���}n��J���5>�?6��U��$�|��z!+ݙ����'�`SMd����7{��RB��3x�2�o�I�<�=��A `�~�>�.3O�T�"l;{�}ِ�$[G����奔k��6$
n����r�*�i��8�����rBy�>� o =�-j� ��i	�C�}U敢 �/	��kjNx��o��ҥ���rKl��3�ϻ�����?��'^���Ϝ�+`�I�(Ȥ�^�O�|:;n���\���`h�MA��M��J���,��)@��)� >( 
�}�%��57�|��#��}�@6�� �Ǖ,��57�N��������;<=a3���u�2�i墌q�Lrs�
8��	�����jP�slʿ&�P���=UC�����  v�} 5�oP�]�ٹ�ȏ��E>]��}���'ee~y_1� 'Ar��9<��+��]�y��w�����@��k�Q^��"D�2�=[p�d�ݍ��]{r�롖�/}����V�QO�W�����[���!�	���N��~u���}�h�i)D�`K;\EH���0��B�j_���4�o!�|�Ł@o����Ҕ,
J3�|��M�)w?_�є����)��3w�kW� ���:�);=~r4�	E�|k��4u�w�w�d����?��� �	
���l!�>ϲ�B)t�.x �|���f[������{��~�Yވ��-H���m�����$8]'_��ù=f�s����M�D���C5d��7�"3Y��4����w�4z����XVN�O` `M�R����)�H`R[0�N\s��/���r�?�}]��u� ��L}���ܤ�����={-�!&{��}m$\�]�І����HȎ���0l�GY��������u�����ތ�/ 94��=��c	Y�J& ;���a���5I�P��Zr��e�����0"��*59���>��9����H��d| ���ڂ� �}�<��}��3�	!/�U���=e�qs� |��b˽��~�_�~�`/�ϟ� �W��A8ܡ+���HC��Ir�wysmr��4˛b��Ϳ�=v���&��x���^N��칽����_���7�A���(`�p5�j�n�� �aR}�ƅf��kA��g�z����>����C�\ݱP	�K��Z�����TN@ @ �O[tc(*K��Փ�N+p *$���D&a<��F ��}�����%�3A�����~����]vOq�Ɨ�ҝY��	�*^
�N�p���jG�V�:Ŧo����]�:�%o�x�1���8? ���׿���4%��;��@n�#�����L�+�4W)���%��:� �^��]� �hF=Y��ϳ�A�=�n@�j�,��)�AP������5��� ݔ��0�8w����`.a ��E��hO���n���n�|	� ��]ǔ��1 1�;��s��1����o^.�n������l���0/ �y%s?�]|�������3#�1��d��0:��9<����b� ^��]�� ٳy�γ�-#f<�m���(���TnU��)4��BąC � FE?0�\ُ�nB]Μ�n�| I���L����n�����;�����P3�4��F��n��\Ż� �O�O~���_����-�w#�u?��ѹw/��U�z!������7�3%��?��g�<�љ��N��� |��{rQ�.R���c�Ր�R%!@�1�'�@b3q+�'���>�t׎�aa9 �ƶ����W�����9����n+����7;��M�[��V�x4��]w�K����o<��A/�ۃV��ޠe�.���kA�0���z7���l �fn|��ߥ�IS�+��@v�#�7K�\gF�Y4 ��x��#�"
��8t��Q6�DE2*p�bb_�Rʈ�	��o����߿�.;e���
;n�"�h������kz�����d�e�~��Gd  . Mh|'6����fR�w���[���J?�^������\Y�l�<�F�l��@�4���ll$���pf��������3[/��xF&- ��'B�889���L�f���,����o���W>nӐ	�(,���W��&<g
��涥���}��;��5}���n��3� Dݝ��6�N�\v�a ��^P �Mv��
	�,wI��l��w6 �&���( �> �=�+�yD>���<�}.І-�E�9�."U���μ�|C�,䄼" ��'�q.�T�Ng� ���-�0���\)��tQ�����E��,��o|�_�����F����ЭP��㹘�h�=7r��[�������LG��f���Y�<اM�͞B���D~�^2��Ӽ��3���T�0��1�q�K�\}����뱩��z��M�?� �i<-����Yh
HGgd&�rlT�@PP"*(((Q�!���ܩG��Y��6JDN�/����ow����0��@\ ��v) �)�Z=��L��N���K@��ֽ@uG7���� �	�@�՛8��.tz��3�x������sC��ͧR>rv�	`��^(!�M�&�y;/{�q8@��ϔ!7@v3�<�}b���z�c�]��Oʋ�|m�I7{P����,��x�"	Q=pjVin�C;�MOy�>��?}߄n���s�ts�k�q�9��g:�u��ʃT��j2jg�F7��#����tkE���*��~G2��η���O�[݇�sC�2.�>j��2''R �ػ�A]�ʮ�n�����r�|���'� |>L3����c���c��![�\ٳ��S�:���-��G�f�! �;�>$�MC2|+�>$
<�#�G��+�����e�{,U���d�6��@V���)ݚw��~��M'S��NƸ���m������G�nEmcr���b��\w��e����v���ы��0 �Jv��޵�"gs+ ����"E�A�y�����r.]�N��!y��"�@ �OD�oTQ��Έ�F.��B���b�\�"��ʡ�JO%�V6l�(��n3��,q�`uY/�da����'�eޡZ&�j���&Ý�}��p
l����eg���v֞�����~��Q�	F�\���[�ҳ���d��� jDl ��z�ri�g��M]ɇ|�*��  7io��&�R\�s�ͺ����( �'TTT��2�A��;Jtѡ��Ȝ�xs�wF��I&� �
��i�� �m� �քc�
xL=�M�-5�mjH�Nfp,�F����ڍ��?��(̯3�X]�^jvk�y�c��,@�  O�\X�좽�.c�E��DNV�'ua���JF��s��E^��U�ERx%��	��M���T�h:ѫ\���o�o�4�@�� P� �@�M��_)�^)ښ��D�w�$�D2ɺV-tg�C $ Qf�;�C.jצt��٧��܅�mC�b�`�Le�)���>U�z�T6� {���o�}���"�%&0�q�	��>��n.g61��t>�h> ���?�7��GfL�egp�{v��ߧ�΄F�#���X(/@!� ���#/H��B��]d�vz��r���`�ʁ�મ���A'H @�%�ްd��%!Ҭ��h^�����,�Q�w��en����1��t�x:�^�O�8O�DCd�6U��%���Ӝ)�&D"�e�,�
����w�~�qSR������I_!;?���L6>��+�G��8t����Y
M�-۰Pl��Κ������5��I����޾�.���  �*"$�5��:%��)Ȣ	  �I�"YT˾�swz	�؂@(l�����%�?	��s��$-f Sw �\�P��n�9���6J�L��.	$�o��YYa<�r9MJ6Ͽ�fv�\ ����\����c��}�^�� �/T�k�z����n�DR�k�0�A$�fff&l*Gh~f!���m(2�-r�8�#Q#�>�'��m�+���l�+��Ɲʛ���M�y��@-@�&D&$���8�@� 鄁���e03�ef夵�g��Sm{s0���d!��^@���@�	!,!�D��0(Q[9���p��� ���N7���ܛ� l� dS����HYw�~T�g�NP;�Td� la'�+��W�%��JM����}��A��ɂ}��"#in��=�]O�'�dތd|![I�o_�h�D�l �P�> �M7O�$Y2&Aظv3E7�uA&BD	���j�/�p���~d�Q��!�+@8`3E<"�������Lr#E�(
�S�d��Pf3l���o�Ol��.��b��h�w ?s<�l�,4�����9h���G�+=����^�o�%u�o��N
@$�Y8��Q�@�б��Ay`F�A��3�`,t:�[Yyj����ۤю8AK �,�I6�^��@ `�	�[B�k�?&!Z����q���N�M$@N�,  @� �!Й�k�ӭ>�ѭC�� Z���Y<;{�����r�]�o ��9����܂��O-���z�\3Ӎ���LN8�a�b���Ev��L�J �Z��B�y���� JW(^;+%\g�~�dgg6O�n�I �(���x �ɾ�c��n����j�i�|�!�|�3���vs7��Z@�j^��n��uN�8Qj�d������MC��S�
O��t2���h�L2$8���a�4�o zAR�t�3��,�>�:�ÙF[�SH��
ݏ=�������ݩL'l���l�k�����	@@���^t��U&���f2���H��`�R�d�S�;�H�S�ޒ7�.6s���~�&�as���2�M���&`��9j� ����J�}�=x��DdfA�f?;�������5� �^��]����!��2О��9M���ݔ�g�(�A���g2᠞R�M��V��2��s�:νu	��f��//���Nb8O|��\n^�BN�9���a����d�DJ�����뒞�4.�E;ǲ��u=o.o��U�����ԕ=�%���+�`!7��]��qq���x���`*��)7Sf;�� �
�Ȃ���	�(-��D��s+'�>�3LS��m�>]���[_�͊C�Gtn����7����&B	���7A�x��z� �lD |(�bY�Uz�o�;OVe�y>���71���! �s� �$�4�1?Z���NWƼr3������Er�e��L����[���%+k�9srг����%:揃zK'@ $[`ˌ �s'}JOZ�:��>���+Q�������| ��`Xa�Y��*B� �S,:��0��L���+�27:���fN��܀���A^s���yL��pv�=���p�� X��6��`����)�(aсLĮ�BvvC�~� `�.;`<1�Eg��~�) x#^;_!�G򡦺(����y��Za˯X|g�y�.way��S�I �� �S����t�̲ʅ�E�A���(t1��M�Q����٫�tF/��d����e8 ;�?`��D��2gzrO�S~5������>���;�"%অB�H��9��� �f#���A3�:�t2�jT2�q�4��l)�h���jt� @����T ��6@ �66a��b��ա�¢C�	: ̑���r�K���@ӤJ�W�	��)! �\&�id�?��c.�~���,��4^&��� �d!(�L��h�-�-��މ%JC�r 1ɂ�����s�^$�N=�#�\���e�"C�� �?| @�f&��k��=��e~��ؒ��2���,�_p 2���l��r��N����n���F�$0��
�t�;;!@�c���Z�M�\73+��"���񩌟�t�_0n�0�$B�� +D�=�2[��'���'�e��4P�h7w���t���Q�d9�e��6RA< � @& �P�� �9G�7GQm跓Ե��l;7��z�s�Bj/;�JfpY��[����?���(
4 h$h$��+�d=%����|/r���;{�ܚ�$�g::�9;v�DH���i@
���5I��p#e�9�� �]p�/o�\��f�.(e�Еd��1�Z�����D�A�@'ӹ�6$�9:?m�>��T��� �	!½FP ��7l�.��=z�R2ܣu���}�� ^����㢴��)$̻0����R����
��$y��򻚴�̜���iyf7��C�_|	@ 4=���0I�s�u:ǹ�/s�_��G
�mY�}�78�����wɇ��{�VKnK�Anq̶#��e�z̥p��\�x? tYI�	�f�f��J�s+�Z������Ѥ@7��G{�u���)�$G�<f��i�(4^�M��1�1�^�q���^���"�@ q޹���\ܵg6�ukH:�O5b������6b s��_��ǳߴ��yDQŚ��gpe�옭l_�]���[*M3 d^fwt��K���8�Ʈ����I����_�Zv9���e���+�ey�� �J��M���b�β�l�(�s�f<��4���\o_ɀ# ���KC�HdOڗ|���ݦ��S��2w�LZC�lu������wt�C��dA=��)�	�{��G+n�A��"���A4�՘a�ֈ+I@4�3�]ѱݡ��`p�ս��̠�M�����M�ݷ�킸�-l�r,s�~�s����'���Q�����q	[����T�g;g�3�`�rz���I4� 0�-�L�vw7�������@���)�K��rj*�B���a^mO�e����A���Au>�` j $��%�&�&3\��ɘKMH;I�<�z|����A��H�	�Ap��s���S�������0~A ;���%���h��n<#�X���`i��D��;���6(.-���LE�Nq���<d]1]� PV��)�L/��+{C� �#��܃��Qީ�!��P ��7+��gtӽ>�ͼ?���]���'�?_Fҗ=;_�.�h��0ᆁ$_.�\/aa���~������ ��vH��If�i��W8f޺=���\�ʀ�  �EC6�0:�&9rў�N�2��3"?� ���c < �BBX��h6�M0w�-������_b7��i�ɍ��L\1"�T^�iw�uS{�ՙ��	�C@���^��B�Q��Qo�a�`[�-�Ɲ���l��7/����_H���v�']���fʸ�r9[v�,7�d>\D�o�|k��+^Ʒ�$�� �iM���Җ����kd����c�6sw�ʣ�-�I2��5 1d�$x�*G�TjnԒ�&��G��q��{��;: �A �) �	"��]Ѳ5g�s��%�ы��� �in�H�Fc76�۩�3 ={\����� غp��h�3g�̷3���m� �^[9��U
ݛނe�i��i��aa���F�cw}��vۭ������w���.ӕ����]n6�v�M=����i(��2��gi�R_
n�{J��5N뒶[f��ng��=�U*�Ojz՛7�� �uZ@c6Dp���\�ؑ��$Q]�Oü�e���{��7@|"�a��s�lV9��-�����+��2�֝�R��P%�,-H9b�t�����Ƿ��zt�����z�<��C��\�=���A�m�G��[�-,�W&-����җ�o�_�����tG��W8[77��2:�L��,߀�|�9�z��ԛ4A%�Kp0z)�̹=mG;�����̜ɴ�\��xs�h���+���V/�Ѱ1̑�K����f�3^�<�$�����g&?��x��� ��UMu+uK���So`��@E��8 y��ځ����B� �@��3�	��q9�Ib{��瀚�Bȑ;w��7��Ϙ����� 8?�w����B ��k�hw��9�- �N�6M=�|�
��*�r��i���	n�v��b���+�+�;�9�.렘�$���Ǯ�ߠ�k��R�����,7f�+�`��tL�Q��/�{�%A �@�����iJq�B#8��9Ӊ��u����8 p�� [Tj�j��Y��n��� X�Ʊ� Z���������S4�D&�.M��2��2�[ܪ^���52��ֻ�a�̬m�:�e��S�֞�n�r��* p � d ta�j��o�;;�Gz��cw�tv����4�1r�ihrӷH:�M�!�w�4.�F�(�6����y�3����<�y�����2Q������,�� x@izFL�pN�d2n�lF�&�n�7z���m���_�N��������#��E��Yma� d=lO2=�\����Λ�_�!FWi@��ݍZ�3�s���@zG6�����,�F�(.ޠ�@���b�t���et߽�$�'N:�3��5ae�Dv|� d�́�~G �f�k�U�&$�������Kwm�p]K;�d��<��i� ͸a���\�����~LA��z��L��$�����l BAF����� �^�����$�~c���;���9��D��u�)'�C���l�@�{�A��`�)� /�Wj���I����z���ۿ���_���JY"��94B�m�nP�֞q��^Ї|�`��t,���Hdhio�+>4��5^p�Ɍ�9�;̮�>���f�w��}���0�o��,?|�G�I�}A|߼e>r`���bI3/�c�uGS%g[/w��H��2����׹����$��%"�pxJ��b MR�����K�3����u��*����/����NO�����y/颦��,mVn�H����:Wڑ���[ ��2����8  X4O� �ֺ�r��:��Uo�� �}{D�܇Q�4tO���5�� ��?a^�� ]��eS����
]�&�S{.�w�9�z3Ew���0W`|�, �A�)^���(fǗ��L �?�:Ogs���|A��fC�ݟ����W~׹�Rv@�=����2��2w�ն�9�M�5�qh�7Q  , @C�ȗ�ީ*¶�d�W ��A�Fs�� H>��+��胕/������?��� ���v�)��^�pV���Moԑk�C]r'=��;#�ov�B���If�h ����6��z;��]^s_n�����-)��	�T��eJ����Q��T�{3�K�u�t���$x�̈Hw'���3N��57�њ��:\���`�S�#�����1�M��G�l �zK~9�o`����Zv���ހ�n[}���W�.�*�I�U�� ���1���	ڸh���2�|�uz�gT�?՛&K�EiY�;M��3R��N3�f&�
��L��w�nu�m7�۫l��e�����Y�u���[D�h=�g�nuZ?f��	ҌT��9�t�jhvv��K� ����s'����۶aI;ͺK�,|� �% �t��}=���C���>E����W�G�qH���a�B!��\u�y�~n�\	4��l17������F^�R g�xa.}У[7�f�����)9�e����d ���ص��]o/�]�^���˒��.�����d5aq��>��,�{|/At��e�
@�!������.�e�K�=�mo��r��Sd  �]wAH�4д[=w�7�9�Ό��7u7���_��	*���_� H�A���+�O��:�F��5 �'@�@�G�L�p����L������̀N��.����cu�sb{���M�c��v����n�I`�q��u�����z����nȆܴ�KBh��d�k�Ft�Y�n����̩��3��w�~��uH�O���Ĕ6��Y��g��|�Q7sq�dq���k&*���f0��:�fn��.�'���T�
nس���A��
�A&��O�ў���L�sTu�v;ũ�������������-�^�����r�6C8ӄ�� ��Ag\�t0b�M��d�p� <�,����`���[Y�/�~��)d<�&�X�7M��c������m��J���r6V 8▛m:�r��\�+�\�@����| 29�+��32_g�jiou�$���>��v�;H�9&s�T �� ����n_���u��������5--&;�?��e���߼пzK�.�}����3��C�7����I>H�áE���9z���,���3�%� �����H�$v�̲�d�7P�S���K�����l
�f�@��H�NUN}Oz�����O�t��s����g9|�,d%e��ۿ�[{2�X�ʿe����t��t��L���SY��7w�L����l3�����S��e߼� z [��s������`a�9��`�e���r��A\hy��Le�l�V7#��t6�h��^���B�Bg�>Ɍ�����]��K	�dR�u�ʄ�*[kI�ɪ7�>��v��)G:�3mG����/�d'n����K�8\�Po'�\!��<�t�	 ��f� I�d����K�fVVkm3W�lCR(7OP`�P�v&[n�K�E}9)Z�h��k�)(s��=9} 'ފ��|��M��gC�8�y��� �  p|!�j3��m�W����t��"�CV4�4�@&��xQ"t=qrL����Gf��d�ǆY Ў�f���`8�Ժ=���йl�Aw��`D}�H�[����n`X-im��[8%���E��w��P��"����y�e� H�vnG�SAz������ZC2G!�oCQ�H@H��J#ȐHg= *- @�I|�����3G��}���	�"O���tK�e~O:r�����Ɓ��$�FZ6[w��l7لڑ|�Ju!�k�2�����>�,����XL�|�;�Fn*R��Je�0� ��� ����2�P����Z�`�D�l݀7�^��:%y�I�E
:��0 ���.�B�wd�-
@�ހ��$ =����������COӟ@͒
��k�d��]r�1���V��/G��(;8h�Q�Q  �w��G[D-څ�݀!#0��QgUc[�;/��D}>�p�g@j��@ib�hD��Si������+�߅�~k� ��d�k�k�e��� @�H@��RS��LF��T��9��*�}7= �,1* � ��Wi+i۽���49H%M�k���e��:�9;&��:k���VHD��Z�8O `�^m����;H��sB���:m]v��n�6���[p��Z! �g�����h:�HG�޻��W��f�8�3@�<'XS%E� ]��%�[��h�Ub���qBB�2�tƿ��Nz�
�߽̓�/S���g���Z�zv�m��=A组	Szv��"�W�������q{�MjD `�4���F���l��_�i�s��k�k�&PPJ�Mg��'�8l�u��}�	x]��	D~F����ã�\1�S��;J>�e��FWȎ��88ߴw��ߵM6�mpK�a�w��n���罦{�c����&��[\��½����)��ml��L��L�!y�F�������X���=n�nA�n��P@����ܖ	v�iA��f  �k���ZNL��s,A{6�2��/��+�{~��0f�=�9lj2��i)N����
�{�m8z��PHz�?�ڟ�����V��<�pmT�����8N�HCȅ�����x� ( �oG�}�ZT �	�s�[�@�&R�:3��]ӕmn���
�2��1oO�IN��e�Jh 
bF t�nf_M�0F����{ w��;n��+��'��9�4��5]���%�<��;����7�wk���T ~�+�gd�����ۃ�Jt,�c"@  N f������]��&�*�C�Ĩ�(Nl�^�u:��,�LMѼ���9=𒹶�o�<��H�h4��ش���)sV����QBH�q��$B�Y�O���&	�9?~X��Q��f�.���un�`��V���?�N�����y/z��3l�Զ�u�>XB �M���Q	���>ww��p﫰.��.�D�J\7�s��;)��v�A?����k?��r������Z������z��_s���jBr *��%��}t!�|�wE��@q�~axM�:��>�ψ�JֻŊ���Zz~��Mz��;pG]�=z���Z4G�8���_	��d)��'�� �#'��n��D��gD��ʨ� ��|�m59�bh���HU��vgfc���7 ���ڗ�_,��IEh�͙�)��f�n��7�MN�K���6b����=/�P��_b�-���rO8�-�6��x3�G&�@�����'��C�#	�A5��3�W�<�?�u)�ܕ�i@v3ْ>��F���	ٓ�e[�+E�e��{�>��ˮ��tr�RI�P���H3�u�HaW�ᓉ}L��sg*���͚[�PW����O�W _�k��ٚ���6�������P�4���ߣ^��#;���/e�����F" �]��̹�0q[���0�,��Y�d�{I�/����^�rŴr�: e9	�I��n�+'V���CixȽ�|����K438��7��h�D"���ÿ́���7w���4�G�P�ί�F���(���  S5͑͞�鉞@|E�T~��п�?�<���Ϧ>�k@M��I�I@��~��:��g�"�Ի�4fS��ft$�҂�v�vG�ئ@�f��CL�8�	I�)hH��l� 4w[;j��70؉��3wS5r(M��>��/;k��.<_�TC_������1�@e�;6Ogk��=�u��c��s�;� D@$�<����F́�(�"�=4�䛝���n���O!�To@��l���l�Eΰa�V
hM+���?�`�h�lg��tA�dg�ν�~݂���������Ժ(^{ DZ	��r�!(� ��А㌻4[sy��u�ҭ;���Γ����t�d�$g�ק�v;�4<4-2x�&bhM��A4���;�횺��" �yݖ�8 � 8�:-�;�< ���Jְ�����+5#Xm��A�ەvt�V��yF�Xܥ�lt��^O��ϟ���1�Ѕ���k��uT(٥}
�������kvi�q����ߍ8	��7��\�|�x�선�L�B��n��M$�4���4� @�" ��{=�11��ڵ]�eX �H����y�n�(�� �( * S�Åd���T6�G���0��7:��t3�;߰C���d��/h��w�R���@=�S�E��~�������
��TG�k�sǃW�w��f>�&w��B�ȨE'�����P)	[���-M�(`2SMt�cb��w�>`5�`K�,Y�{��dJ�6��lۤcUЏIv7}#Y}?�=권8g���������(�+}�_t1���]J)��b�� �{A ��X }���'�@z(���٦X�F�Y��($ d��ȿ���t�ܽ��fyf���fmR�_���{�{�_"�  ���^P9s�ͽ�G�����/	�	��`$E�N���@,�t5 ^�� 8���Fana����5r3-)-Xv�蛝��Īo�UZ�mf�L��&�ełM�j�z��rn&�%l��y�1�zU����	�'����3��=}�|3��z�$ ȯux}Ps�B1GK�eo��7r7���~�M,V�D01��]�Q�w�q���_�h��#�Wz������ @�+�kzvK����6l7s���o`$�B�f����@���q�շ��K��%`�n�+�J����#;�ڛ��t�5�B����J� �0ٮ���� ��m�~0Ea����.��:@r�+�i��B�|�ť5`��h+���M,^�7�V#o�5YP�Nnb����~eư�,ZE�\��n�[~޳�t�5H ��ԛ�03&��h���Eؠ(���s���}�o�f�a��%�ٶOq�M_�~�}�m}��4Vvr� @��\�� o��n���rU&q��L� �8W{����.��&P�d2�U�7���А�����~� �&_7� 2��<F�9.�Q d������v����w�|�|o�wz.9��� ���ݿ22��6�ּ� nf�څ�.̱�y�IM����C���n^.�7{S o��v
�&΄�;P}b���=�QQ���?���t�7�s���df�`3��kN�{����:��sZl�V�~�7����bn|��D3�eä��*���>�.s_&{&8�Q��y�]�&$�Vp H��m&�=&��Wv+��J��6�s�r�Oƅ,O�)Sg 8@� ��=> (=#̯��{��5L�c�L\�L��9����?�����0h2�9`G|}���\&޽^��|&{3%R��y�` >���vvL3o��X���������.y�BԵ�_`Z�l�h�P¾�Wxh��v����2G�}a�4j�S�`T_~�~^�w@� ������m���&������v��D��Һ��4�r������9����;ACp�� 'EG6 ��{`��Mc�*��=>�h�o�}��o�/ësc�2j����NM����32� h>��/��е��)�<�17Ӟf�+���n@��3E�$P^%�v���(D�$�`@9F�  �l�cfۣ�9�}�t0Z�` ៿�m��A�z�B��>쇫�s����,�󀙅��̢�;�w`��u�yb�
��+�|}膢�3Zۤ�d����Zf���|#�E�>�"E�� ���t����+w��d�|_�g�u�W}��B=�����	�j{���1�{J�=Ҥ� �I�0rī���W�ha۰�X � x�@�<e���!d;�����=l�d���+wNO����y�r�H`ЊTH�ڇvo����[����U�W�h���O�������@\�h��c�̟t��~;�z���:�5��va�m<r q�F~߾�7�
1�;߅�)w���{cА������ �k�- `}L�����z�L�����{f�m��K_�h��2��әΙj�8B��&<�U�l�4;5@� ��b�K>(H����w#�4�O�d��z����� ���u�8����!ӑNԌ8�?��dT�=�7v�Y<=��y_�f��g���@�C @ �(4�OFw���j����`Ac�����dL�9�x7���u������ǋ�������Ӽd�w�;B𐱠G�G'%���z��IY��}�v�y����yW�g�}��3����O�i�����K|�Y�3�&���q�r}=��(@��gV��> d�j������;
 �L � p8�0/���wf�1�it��d^#E�	�,؂ d/��xV/,��\ݱ�̃�
hĹ������V ��Kyd�v6�ށŚ�d⺦�����;LN�I������oN���6�y �����G��@Q�4� o||��� �Qs��^�$�ʛk�E��h�K�W����� �뾚��XO��T���{w���,c������g��&�|u�Gc����l�1_e�σd�N�-�0 ȏy��l�_�D��t���h 
i �VD�Ni�	!Lo���%vca�v!��=t���y��|ɱ�ʿi��+�N���9��p�4��c͜��;�Ւ�P�l�a��%��;\�,x�&Ifo멬m �w�� ��L �@���΄�Q�4����z����z}Y[�d���f�ӌ���cd^�1���9DG���͕�B�t��@��
��R��e6�l�>_dܥ,����e���V�s�@���� 8x��� &�A��I!.�J�A�;��*�_G\d��-sGn�n�K��`dlM��	��Ι�gޗ1��7�Pn:߸�w���
�=_gm�#��ﲫR���H��Zy2���R w����`^1�MkŤ;C��u�Ҽ�7O�o�����h;� &������;��,?�E ��[�ȹs����'����^o���L�:B� Мn�����A` ��1�� ��S$(�7 �(��D���y��^��BѴ/8ȭo0 �{4�MwW| �PP 4���ԣ�i�+�L�t��}w�v B'3 �~	( 첰݂���y�rZ_r�GF��5��o
/��l�-_�-o6� E�����?��j��^�8ͣR��N�$LB`2@�6���P.
��z��/�@��i�e��2����n4\U$�Op�x~��˴��,s�NXg΃�>����B4�&B�|��y����'�4ʭ^W!|�� � m�(i�)]9�:��GzM� ����w�� �]�g=L�.;�� o��'�ig��e���ed @+��/��<¤/}�Mnr)" ��e�:3��䆆���I38�����p%� H�M�����J�۲��)^3	P4�P���ny������B}.���Ǩv���i]ojКL�4��� bp�;>6�2k�&��I���D���MO�&כ뗭�K5�A�# �>��mF�A4c�5���=�E�9t� 3�)B
�sp4(�Q���e��Yxs����+�w��-���џ}悥�,��z���r[��e�f6�x�E� `+*�4��I�p�=�p��}��q!����<�r���Q��=_��fvrSl\8]��:�4�7���U�4����S�,���r�;�ɀ�xC#��F��iv@i�SD`��0E ;y���.�� BK��@BT~>�}� � ��17X�e���N��kj�Q��#!��x����������B�Q@Qlҡ{𪍓	 h�ǫ��&2o�
xS7^h�gm��IH>��~� �H��7?ҡ�M��hF2��@�A r=��r��b=/�8��]M���L#�� g{fSM���7�}����On@`�L�t��o�3�4�����d�M�|۩S7re?���B��O.cc�|���w��|U���si�O%�6���3�t@���7�S!�H )@ơ�fH� o��-{������إ? �9 � {a���HQ$��Ynr���ޘ�l�;L �%��b滚��yf[+Ogd:��n��n����d�7_O��uk�ɿ�9͝'�G8�p����|�d}��zߥ�w�7���O �� |@;����>��-ι�qf���@C�<��f�>׻�~��j�fa��&a��3	z3.g�"Pr2!4P,��?�b�У5dJ*��W�)ݻ "��P��W�y��e'�d�v6/�G�J�x	�T�����|�i0=a��5�&"����;"�ڗ|o�tf�acR
��@�e�y��t��k�l����5s�[:�Ƨؙ�ݳ���͖W(�u��M�1_�}���,��` f3>�ck�ݬ,�<�p�ؐ{��7�y龼ݿ��x�@�LH#���M��SN��+τ�� �O�Qc�'��s�e�-���d��ސ�k��n3<�+Y��ph#\^�9��B���v�n(�FP��zw8��|������^nfz H��L 粼(�A�?⨊�׌�sP�ܮ5;�x����zWg�|��y���N}�<_C˖����o_���0g��̀;�^���㓍����]���M.���r��sc,c��$��2���f�g��x�F�:@�����'��gv^./_� �e��[D|gl���L3�_���9�U 	�,������ވ��� ;��y9��Ƞ��Ht�����K��0F_�w�L6:]@�@�x���1�� %n$k[��k���j�Q�ހ�����o�ߜ�q���Y��ewn�c��.M4�"���6t�s2��Ae� �Ӽ��+�	��'&S�|�o�d&��_��4�Ne@r��L�|�}r�u��������#�B���������\�b�l~W �41��;Dd(�FF�Z^A�2s����P`�@���dN7��n�5��t�Ӽu�P�lL  �z�ý��7o��$Y�]Ba� x��(4��Y���>�Y�3�?#�$iC^\tqkG(#G�	�zt�E��o�=2 �@/�o� !�O�ї���h�2�E�^�6}�ݽs9�x�s��mU`~�:;}�����E�n��f
�8���u�Wd����xw}� �� V^i�hkXY�\�k-2��}�}����
��r�|�O��@&� @�o~
��P��:�e����	�ɹ�<����FzG*��`����V��j�?�Y����v{�M7�Hew��#����bc���X��0��̍*|��B3y�Țm�FAA�Z�ٝ�Բi�nM��i����7,��D]!h��~g֛��9_wFzH}�G�@ ��S9W{(8�&͡|�\f��Rs�Vd5ݷ߄2fx�G���ܠ�5�n�͜N�Kv��i�v��>g��fycw~�¼ɵ��g0��A�$@7h}���	!�}O|�IC�"���F����|� 9���{y�}���[n�1��
|߳UhA���;�|��7�ܩ�T웼���&0����7�;ciz#:	����P\M# � �cs'��=��7a@ @�3?d�m澴����*�B;m5���� ����͞oOzKK�pD�  4�j �p`����ܪ��s�L`�[�heF5�BQo���I2S��t</�k�{�.Oe��NO��=�^�y�@hy`���F���N(��-��V�tv���������;�*�"㛀n���}]��z;r�9G�;���(y��l1Fvz@���T�&��+�d��$Y[R�D��[�Eh<JH&�@ɽ���� �GI�`���s���O����I;�[I�j/C4�Faө��|�����s���I *A���yT� ಟ�'�Z�$���z��M��,_{2�o�����,.��3���|����=�3�~�pw2�!��GE��+�� ���t��/w{>|J�r�חOlbhJ:ߥ�?�=͝s�[S�qI�;�d��
���3��߽�����Hh ��>x Y��d�Rs#�2�d��w/��|�&�D��ӷ ��7��t`N�a�L/��G�g�w�����X{��=���4��L �؝��֖sw�f2��&v�		�ʅ��`8�^q`Y�}�����a���5�F����R��m���p�)NW���`zf6�N�z��x��)wh �Ε�	��	���7!��/M����;@|����>	d^�4�8�F��7K�9^�3���[�k���;�|��MF&dW�Vg��������4M�_!��� ��5�F�����_�X����3��K��q8ㆍ�k�9Y@ �(a���\���_�ϼ�9���th��g���jK��P�w��+��@t���!!!pѡ��P[:�ܶ|��~!��̀,kcS�3�y�ٻ��٤�1c�;cëL��T�P�k4��i����J=���)B�dP ��8�p�N�C�2��L6������@��|{�4-YM��!���|�|@ �;�1���� D���V�q����}8rR��L��i��2-������/7�%7��1n��M�r�H��<�o�\�3�Y�s杦O۱�NeI�j�4W  �16jK�Hg;��(m'�X�H������qܙȻd��	0�Y�5S�gK6S��ݪe��D���
.L�in���۠^CS����!�� �"�@� �  ��w4�`���L���aX�����hp���7u�zrrO�uawp��{���iU�ǺS�w;G�?�����Z�!(0�������YWj9&�]��kx����z�u�6��K"��mȊ&����:��������39!�q2Ƞͧ�� �Mk�-HgN���О�r\�= ��B����`����S^�a�z���w���5o�%����.�$���~;��;F��nΝ��교f�@���c����)�ٗ
�%��O�|����\�+_�S_��ȡ����wUӠ����H�v_D����%�t��m3�B�U�We*���p�;��7�����W��L37*ȱ=��FBS+ (Jʴ]�u��N���s������$��+� �,b7Z��ٔNk�i���(��s.�t(�7����C��[{O̹g�|��lu�����'��mNt�Yb�&7����4��@Bv��
z� J �w�D;S:�������[>sY������-�~����Vd�zR��Z��5�D�e��0wP�ﾃ&D��d���O7&�w�}�;N��{�N���:�#'`�	 ���ܾ�ۚT��ƥr� 4"9C�U@fl�:5���?�e��+�O��ݩh-�)M��B�I��=�\����@�B�E�Lyɶ�a�r�����(� (`�.���2͹ɇ����⾦���1~�o�1g�2C�	�4����Ѐ�LO��w�/4L�T�ѱ"����ιþ��.N�o��k$4Lk=�}a���(�h&�eف8� ;�;�����:zfn�7�$@�}i�e_���-m��u�hk�:�����3� 7����-,���\/dr%�s�(��(ŕ���e@2���;~� �L����ۮ9��ԎMOq��o3��(���c��N_!;�%ߣ��|(�}��c&�w�:7�_�󼞙K��=_�- xԧ�:�;`�@i�E{3�����H����p�w�&^�J@�]t��vi�
]�n_������4(���/;8�d( �> �1׸=mjҹ^�9�����4�i(��z6����ujs5o���&��N�����2n-�$��}w7^ �oɾp�ҕ!�:���萒f�^�� ������k��������ι�$s3u�����o_`A������P zξ�\i&-�����gh���
8h���_W  '�F咛�d�A ���> s\Ft.�{�{n�d���z�z�R��L�c����saW8�'V]\R4Sc΅hY�7�O��
7삩�ȩ�H�^|��8N��{%3�fB/�@�57n�/sLm3��Ҡ��y�6`d%7Ih^��ھM�ݮ�b������fdn��ܗ��/�|�M�*8�d�w� ���ω:g�-�U%��`|9����R(}���A�ו�+"�'*�.}�%2�e��x�|������\r��L���C*�>�;�]�����N)�h�hϐSA�K����qȕ���)�)I:����2x���9�E�7//��d�~6��Ћ˯�_2�I�s�M��AB�G����;sc¦&��$�4�an�ٗ|���|���OО��s�i&��/�wpI٠oߒ||e 7P@��`?JX) ��
�  ��w搩�ݞ���=�����B�Hm$iP%3q5�f�ߜg*u �0�\ $�7I<����|x2��tvıK	�;P6��S�wV.�.�?��X0�z�w��N7��a���(z~^nm!^���nxͣ�_�z��w世��������$C�n��~3�w���3��mޓ	��8'��d%��"�� �`����	j+M��- ���HQ }�&	@&�Kg�'��]ci����Sޘ��K�닞�����sT���l����7R���K"�h ��'�_�,#�\�������S\o|��:J�4u��Pmp�/�����(rXb�}� �]���� �����7Y_�]�˳���7���&�K�o� �
LexS��T�,!�ѹe���<G���0�À�;���=�`��$4�w��_O| �c2�´�c���o�0�-���A�dƓ��d O�K:�U������|j�d��������)w���������O{A Aj@nN0Rl�U���I�p���vLS$qew� �& ;?�ܑ�:(8� �pp��(�h- ���r3��Σn��d����}i;N�g�ВK�W�Sٸ(�}� � p��p�JJ|y%���� 3u<?�Pc��2u�G�ou�EU~���*�m�l�&0�&�Yn}�2w~=s4��q�d���E{Y�����Of^ｵS�k��񐪕��{j�O;��DcjW5�[�܍u/��[K�/G�4��.�$>�jpZ���Yo�� 6ft�i���7뽵3��)N�W�lv�יt�aeƸ�Ǵ n�:�� ���3OQ�ܪ�ܜ�����xL�}�]0;0�� �嘥�����,��A� �'�G�����,'p:�[�C�X�E�`��Ⱥ٦w�1=M���ҥħ3��t�%��@ �N��/@#��jB=�﫶�����nQ� b�P*P[�[���@v|4{��Ɍm� &�� �y_d�}滸�s��%�����|{���5�_[�����y�]$s��3x�Ƌ F�5]�),hܑ�z����Te�,%R2��T��.z��$�n�uN>V�Ю^[�m-Z��҂�ش�>����IA�� ���:&�.�P.l�k���\������]�����K��D� �W�@�F �  �y,�@�fh�� +�\��o�VMa!ZH0c��߼N8��6�Yk���٭6 ��� v��^N̚�ܩ]��=�V�4�Jvg�7}  ����#�����L~�d��$������7�bA��%�^�N.9zY��yj���ݦ�v��v����}�ɬ]�F�v{ PԘM�ХKzwZ����M��;�𦖸�m���m�|���غ��JQ@��!z���*�����^�}#�۾�;�[�-}�� �9Z ���б!w�^䮤)��m��w�<�1�%�[9 �+�5���q��uv������Ŭ���ד���H)��\��� �2�3s�hfl�6;P*M6gN�2�fk&װ�`��+&�U���8��{(W��\�ˠ����J}ߟՌ �	�s�4fƈz� � -�� ��@��I�@Q�f��N{�w`���&#B��Kw�o_�w��n|���`�F 	�+�4�r�MVg��Ɏ�뷝z
�0x��Q��?�;&��g��Gt����,�w�_���Wt�u�髞 �d���3�ń6�^�l� @(�7��I�A43 ��HQZ#���jsX�����a��$���i@�;���zߵ���7�LJE�����*1��,���y��k���U qq� �UoD&���[��,�>'&J72�d�frMθ�&��ƀ�?�R�x��������d�"`��r?۽�����W��P�P����L�� X D),����vʙ��;�$ICt���� �&�"Tϝֆ#�SD��� t"��}�o��v���A�3 �y���~wc�ݛ!�f�hE�4 ��ov��F"���]x6�آ��BS�T���|õ�[T=Y ���H9C7�w��X��w�WBQ��jve���軝��ݟ��i�S��(҃h����S�k�������6ݺ�̱J����t�.�v�U.r� <���OHVv�ح�җ�9DN�}G���@9t�ͦA_�؀����,,� ��Wr��͖n���mF� ��@��\e�-x%�_�Ar.���0������ tj �P�>�s'
@��t~��%dg2�ySC�;l[��_^����y��I�YM�t��S=��ݒ���v���N�ei�twm�oT��^;�p�P��r4�z9��ѵ(5J�T����rjr����.H��T5�����B�� ��f�y2�j^X���C3�Cǧ�;���d@�m��l��tb'ȃ�UoB ���}��=�./��ev����XU��da�vO�"B������S�ʩқC(��0�@�	�#���/�z�o��W�?Cw��>��djf���hkTm���V�����w�r�n�33ӳ����������:y$H�H:�Н��h�����?.^�m�4�v��.<���l� �Hc�2~a:T�*��5�t�U�濛/���mt��8�LѦhv&���bg��㌿�<��!i�F��d��8u����� d�n��.f��t|��K yt��J��4�[.��K��[�}��Д;z+�U5*��AA,����+ކx�Ȗ4%�ٴ�q��3������2 @�z���zB[HP�v�s����i:�Ԡ6S&�ꔑ���>��X�����9�9�GB������A�M�o�>^Ɨ=��y�쌧���n��/���}uIv
Mq�8�d��u[�}��aA��	���o^���}�O�Ϣ� |I�EUB �G 0�]D���S�Ko�w�~�M�Ί�@��m��Tr ��`j���;�y�45�5S�f�d��4`��Tx�p0:�+����/�4��]����#^��� ��������=�ϼ�KJ��@2����˶÷���O7��?`����x['�e�<߶s�E���/��_{�dS�D����U� qM-�擨?��-�;  �0d�U�4�^��Os�U^�PSDĊ}��h_�g�;� Kւ �i��1]���i�e��K�'��}�lH3h����B�Ri����(���uf^q~Ó����� �f� (�M��.�|� ��@�����r���)dz.s����=�Y�N�ՙ
`H����/l)��4u���ݑ�z#�>���6�/�C�Ϳ  )  ��c�_`�q������}9�|���� �d�+�%��Ő�I �MbHԌ��Y�Ţ�v��,�w�mq�6k� Ds��� �Ty @���?F�����v��I'�S�Xg�>� � ��b�,@�  (��F� dchc�_����n3��R@@�k<�����7�>��5T�,8�I�s�ͳ��2'˜��sc�"�4s�@<�}�����g�ēD;�mS�N=�7����P��If��� ��<�s�4���GJ
ف��j�J���~�-�*@!J���f�,R�mJ
ke �$��ً7��/b�x��Q���9�D ��E��B`1�A�_��{��~����K^�8,�! � (|��[^�� A ��u�{.2m���;���w�s@&���co��_#�/(����B�J6��Mm�k`���27�[Rv:����y�b���p�>߄3+�m:������oO�t��[���E� �tE�����jn�.s�9ө�ř��K���ߕ_���Yl� ����'Z�r���\��v�QQ,�T:� 
>X(���������¿���=<�Q�~s�����}W����M�F6� U���'��؝  4�@��ر)$�9fn6'�4  N�d7���_(�m���]c�l������'��}�5�0��:3z��h{��\v�ޝ�U��7�,,��, t��[��f�r���s�:%u�����y��t�s�5̮��p��^��}w���[�4��m�:܀DlʬfY��M�*f7�����<
���K�X `�������==��b�����5����u�T������C�G>�'&���� �S
(Ͼ�Y�� X���Q��ʖs��f:-�+"2��t> �C/ʸ��@v�W��l$�ݍв��^��{Kz�unUsE���z/d�i�z��x�I��s>/���"�7��y���@ ��+(`���@QOv�Q�6����s'=OW-G��N�����%��5�A�M�d��Ys-6�=Ԩ�@҈R�o�7xSg�L��>f4(`�.k�+�iխ1���߻y�/���7���� ������a{����	j�q׍�2( E��4/��&�$f� �J~����h�d;{�3�(@����-�J�7�D���N�dY�ܢ�u/)�؆�%��������l�K�Y��I�b��Q|��N�2^d���f��>��v��η^��H	眶�T4B�\��t� 0d�αuCz�6^l4�(@Ow�d ����� * �a F�P2���5������x��ԡfr�jWQɲ�ok������M_㚟��5 ���#PV@b`w=8�f�@���e*4�]��_/��h ���~s��.f�_ � P��w�f�dP�p�9��ur�e��Z �TXA����$4j��r��(�3��]�}�=ڛ���2���z�n�gF=ݻߺ_����w�Q�p�%�2r\��hV��4*q���u�I7��Ҕl�I�,�AG�y6�yd�8Dc׈�xm3�cp�%����gk}�bh��������z����������W��'>��YQ�8p��(�Q�P��^~�^����)�yC�����f�4��������='lY@�Ñ�q��2NC��������ׄI�32ϻÌ=���L�	��ֿo7鿒��!M�6z�O� ! ̈��'	���)~������e��M�� �W0�D	�����(KD:S~f2�kn�&)(<  ����O�|'�"�A�8��-�n�,���:��Y���]|k����P���A ����-@�o��}r���'۷�7nh �G��-\�8�2E��Q �(=�io��MC6�<�|���l��vs�IH>�wu�W$��^'�+h��q!
�!D@Y �s���s�J�N ���0.�[��ף�JS3��Gґ@����w�}�<w��b�6�Tǽ��B�����D��4�����q��_���D�@���������!�n��{��e�̘_|qEf�b�U������7CI���y�E� t�<e�A�G[�|�|�\��yo���o����I��NE)�
줶x P�hY���_d _0@4�󪴖T?a6��ᦰ	
��"��iZB2�F��c��-�<7���}����i"7�O8	��M��+=�x�����l�kٲ��`U���g��)f��:�� G�W�M>����$���2  �ML4�V;���e4$�k�}�c:��X/�1C�4���څ��!Y�;�l�(ݶ��9 P��ylm�)O����M�=�=��o|��XU2��m�H��%�� 2����Egp 
2�	Bc�����(@�41�q�|��~���MR �@����@�����w�e���-k�`����z2�:���d��j-�:tO���o���^/�:�팥��t�/�%�Kv^sɾ),@X�e'��2L]�6J]�TI��KąOf�0,�tè�,l�/҈UR�ؒ<���� j�;l��x#�-�rC �-J�Y�{�oY��u{;/u�.�Fg��1k'�l4�H�+@��!�
���N���v����n
��4��"�@��9o�;�	cn��܀�} ���7-���==�kڃ�0��B׮���:�������2�s:�����J� 
�c1��xZ �694w݃���'�tr��M@�s� .�`�BBh2-��.���F��J����&#2�[5ذ� �x��+ ��3���fA_�����v�_���;�l���-��	� ��@ b �ݕ�^��@�I���f��<sm<%� �*���A��l DB�p�S��j6�e��WQ|w_g@
p�W�8�f�R���X�!$��t�W���ֹ�K� �Bv�?〠wƚ�q����| �[/l9�v��l��+�v�A����@  �	�IFx
D��R�����:lhVrV7�p���3�|<!�lZ`C&3S3vy����d���	�v�!�!G�E�p�L���d P�;�+�@�I���o?�o�sm8㐏׀p�6 37鋫��y�:��48@�=|�����	���6�� I�e����҅�if:枦�n���Ӻ��Q�g �_�Հ���ü���x���=.��虻�4���Gޢ.-�f�l��M3���D �� "1`��h��6 j��7�N�%;�HE�;�؆�o  "�A�5����� ������r�٤�G#��_&yɣ�N��]��;@'B�B���>��߼4��#��ۀo�\���/}�͹o��� �[�%dp L�Ǘ7ԇ�&�����|�/ݤ��&}k��}��|ߥ��!�1�n.�r�y���ws�;�ڂ�@Ⅳ�C+�Q"w1�������ݥ�
���@H�~�*?( �Ft�22[�%=��̀^c�nl���� *�@Xg� LJ�4�� H@�O���7;������=���Z+��� � �yE�J��H�A����v�r.M�rEr��tr0 ��Bk�@Pp�B�,�3s%���z���հe�y���aA� �hf SO�ХA�W�U�ʼ���N��B��qSAѷ�H��$b�� ɂ̂T� �Bg_��q�����}�A�}��� �~Q��}����N���A�&r�s���f�L^������.��=?� iﲂG{ &�,��.����4���g]ށxm�5�N��k*(���"@Q��` P�!@ �@�p���s�M=1�������w�\cs~G�pA��p`7w���rX?�y%��aJ^`^2_�ػ�=�&7���:�� � �,c���4#�k��H�ٰ�@��I��j�`��]8<��#|P�~wg�;H���lJ��A�D2�����MKbhU��n����5ߥ��u�F��g�;�� �����J_�u~���?����^�pG�7ed�K>_���Zd��ywĉrp�!b5Z�U�О�w�m%����}s:�s�z#�Ądo��e� 3��*�>���o�j[��Y�^��c^���������� �<*�9"F���^������Q ����
�b���;��h�[Df�2�u��������;��e>��dz��LP H�t�9�'/l/[�)A Y�FvD'�)7S���{J�ߜ�����$\�4>3�����w&��-�׈��x�|��z�9�q�I�0eZzY�\�]�]K�Ȝ}�# d22ǭss�s0	�d��Ga 2�=������p�y54�p�KTV@@����
3�Ә�H�@�rk��8rK�_/*@16�U�i�/�c/���
E��;����  `��Q�ba����A�T 툣�-��\�EIRo{����Fu�a"�F�'x�"����g�A��� �B\Q��]k�ҧyLg�= �����i]�8�l�v��7I�0_�
( p��|EnM���-��m��i�t�d9��a�7ݿn>s�~7 !��5�7�bc ���&�H�����H����۠`_&47�W����� ���fIPiX3E�z[H��^K��8 .���o1 `�AI��׶ȯ�U�&�u�k��5=�����������jP���94t��UIѦ%T@�� =�87��g="��ݝl��ëO�nI?�13����f�k���
:�

2�1���_s�yI{2#v��_�z�e�ٯ����^#3������	�f�B�@�;d}�j���wo!zw�E]{���e_����u�$� �z 0#�<���oy������a�!��*J�l�֝�("1 �V1u�������l��&�"�bڄc]�C����_o��e�s�����es�� �  ��}�Q��� C�����!D��T ��I��S���s^E�j���~�������^;�L�'�����l���cΗ�}^Y��f� ��)]��5��/�3���N��Y ��B�</��f����|�y�d߃���/�A3�6!@���Pd�S�t�껃���':��]��SM��/K��y�w��7m��>�;&1q�7Y�~��UK�%d� Ƭ�1�z�@�,@����:��w�j�Xs�/;��f��@�1�*v!y���b�3����9b涜;p�6� �G����5J�U�E�A�N����у"���� P�gR��� q�BÆ��.�Ӑ����v��fR��'���yi@��Z�[ �fNӡKn�s�1��t ɤ	�'E�y���y�W��]��,�	�}(�w�N��r@@$,� ��a���~7���>��#rd�,0w�Qj��w��OO�띒HT��@�ɠ@>o���/�B����(,�I�`	�ӑw�>�7�5s���f��l�����q3�y+v���l2����_�⋅1qd�c�� �2�0���@>���@�!LL��S?;b��G@�V@}���~ �A;��	�2�\�0��ߛ�N������1i2#2Zg]Y��R��,=`o�=7s�I��@�� L�l//��7}_}�E2����[��ɇɮ��y�#s���l�F�O9x��[ʜ��|��j�-tӍ��H:< E�#.|��)�M�·I>��A�Ѐ��] �w����}�şf�\Y&�$ A�/�ۥ!������v�y�\a�9�x�:�M3�[|�vay��1Gj�AQ7��_��ۮ���aĔ|�xpH+1 ��E���DԹ��S�� �"  �P�z�)"�ĵġ�=�q�H��'v��bLɚF��m_��p�	��يs�\��f�F���p | 0A�ő��������ݷ|��e�^#@�A��@��������������w�2���p�H3��u��g���K��t��Z!13:�
��}��5f�*��M��������v��	����"����3?��j��]�<n#6ʼ}�oݘ���J�d��n�,i	��ɯl�es����y���%�6MhB('�0#��F��>��@&0�W���tv�ė[\�#\r'b�+��хh��$����N�" � D�|!$��dR����z���K3iK��S� �dal���� ��4R43� � 
����4���������_�������g�� ��B�J�m3':��Rfv����ܓ�T�t�+sysz�	@��7 ��O�΁��$JaN�5����0r�<|@2:�����7w|=������5_?4���6�+$l�@v�hg��_TlD Ϸ�MJ�6��h!��#�c�J��07{���l�5�����.u��7�2Y�uQNchߠA�(�/����\o���FB�@XXL��ٰ��  @�#Du(�Q+  H4P2��n�.� V/%�Zq�Qdba�6� n�y_���� 4��͏���#ik@9��>w�� ��� d���f��b�}M�8���;���<�}��eaGĖ�>����+N0L���}5��w'�	:�ٹr��7������@�w��^�v*���8�y�G�a���\�� �/�Ϋ#ޜ�&Y�rKs���*|F���p07����^�.H�uh2g�=[�4Y/ɾ����E��$/�X�[Xv��PH��%��׎}!H� �|�e��Y�����D2��Mnf3o*�&���N2��P�EF����c� 
�P�`"5b�ovWr�;<��B̺$��J+�0`  ���➂Wa�%��g���Ǽ7n�H$�P�(� ��a��Ȏ  ٛy�@�w7a��X*�APr8 (����F����O��S�@��� �\v�@����27F���r��/�&͸�/;�̻]f3��"�M�wEoR>[4!L�U�i���[�t��Τ��z�_>7���q;$+���ϕ5WNwu3�|  ��Ҁ<�} ;�=p�uI�%@�
[\�-�H��
� D�nd'ԛ��c�\�̹����������m��[#��2�#�[��M�S�;�?��h�U��@�ey�����$$Ld�bh��<Ѿ��`�N�	�ԫ `h0$|wb�Տ;����I�O�P|�_�; ��~�]�Ahȡ�+����ƹ���������k�D��nu7��c������0=�P�;�F�tg���7/�8��&R路?�B��i�J�s_�c�yX5���4�Q�Mv� �!����	i���C�� <��$�&� ��#��WI�tQ�N�'Q@�T<Ov �n� �/�5M.��m�2���8oz4ι!���撿o�/2t�_�R��$Z��3�T���*B!�	q�M(�1�f��fh�D�ڛH�~\D�M0�( �  �1��W!;|�����>u��n�@b���@���� ����H�G�C� ��Qh��"צ�z�	t�% ���[Ǘ�;m�5��l �h
��,7�s����2� �S�dAѐ���~c�4)9�z\ ����9���`*�Ϝ�|^���]e6��9,�L�H�n^��� Po�  	d� ��q�Bҳ�	`.���O�A �%�;�D�rь�}_��&?��w�ͩc�r�ι=���;A!�&��>h
��1 �3�#M�N�{�&b�`�j��E��5W^xm������,�$��{?6>����LO�+�ʍ�z��-z������f�|9�/̻�]���&���W}S3]r���t�sd&��@'�y ĝx�� �\����6uƅ&ԟU�s�8�}�.s3����U�>9�5+� �����5�,pf�|;�o4���z#�
	�M��>8�'Y� ��d��(��;��l�&�]7�|�h0-�/� �F �>��7��&� �n}w���\�y9߸Ԗ�@s#�`��� �� �F5R��V�I����I_���X"��s;h���  �*0�/ɒbfz~�y�;u�N��" ��t?������)[ H���x �'��>�&$�`�X:(���;��|�嚿���Tީ���4��L'5��0pD��Ｕ���l�o�]��A��iN��t̑2�4{��~(8O{UX8�:>�wsp �	���U�י��ɼ�o���	6~�y�^�����
d�,Тp@ �,�]68*Ѝ\��e1�6�ެ�@�oJ����R�ڸlz��2�4m�z��f&ɧ '6������O>�r��c�Uy��h�RBH�ܢ�I�~�SE<%s� a������ª��U�f��_ql�2(�� �! ��(R���$p٭�ޠ�On�ops4��C_�$�� �d�ף�C�
w>��.���&�78q�;�+����-��7P߁ b���w\bҤ�/7/��n� ��gy�6�Q�{��-7f���`0yx��y����� @1�PC�b�[�����/~K�l\�w7��s�2@_���y������w
E�9����._�Ǘ�]�~����!`�\'=2��wsg�d�/�_��םK��7��):g	���~��}��_��B`+���{v��9����4G�#h `bBQ�e[���f��������^��o�ū7����F8&c�����n������)�I��3�m�=F�[�?�|OA�|ũ[�E��czo��s��C"�s��|�Sx}K�dX�G��4\%���Ɛ���}���}S�����F����3o���y4uK7� � ��-��R�B&!Y�:�7$!��D�:��R��in�LxS/��1r��N}�I#�ž;��!�8��Q��!�h��7�����k�y��@���A
 ��z[ �_>�+������H.@�w`>�)o���9Y�W�l|�2����L&R��<������>�?��~�k;_��7g�o�K^#��x>�v��} =��(�WZ� -��l�GP�>���4�Q��QjMZ�N��T���p�S�l�DfH*};�����ϛ|�� �L����C�B6��<����������]�nn��[2���2fv�M�8EiCO�7���M��
���Q�m��H�M���vI�K��y`�'R�3�"�5M���f>�u˗;�Na�����A_i���q�|B]��>C_���׭��o�s " 2����/�]![�KM���3�[�/O��c��/��ώ��k5P��e'��t�u�OD������0@_����r'�q��Z(yQ	�-�a{�O��I?Í�!�
�q�B~�� $����D���f����2�\�@� ��6݆�Z�R!��M���"ppR��Y)H3�a˼/�-94��jEg�Z��d��4��ׯS���l�B?�|=�KF��@�w�R�,��m�d�0֜�}��d��fl�@����0�kv_өՕ�{Ipcng���>1@�����YC	L���}y���/���n��}�K]K2��ޕ i�X2 3��(�`�gӇ�=SժtY��d��Jf>N?���~�-
��ā��u�( �1��H@h�7J7������e �0`� �[ړ.�����\'}�6�	1P��&�B��N�:�K�mҨ����xf\C��)Ƒ>W^���[n�@���qPF�D±/���0y�{Z�o;G����NB ������&���N�7�6 p~B����������y��g�.�&ΫY2�p�]���)���%\��7I4����[N��y>���Z�-�jF�~�^��Z6��_n���q@& �O0�5��$!�����P�S���ȵ��n�zp^A��8�c��C��@��ݭ�?�l2i	!4 �ЕEE�3��K7R�9��.���t  ��_;�W�BB^����ٝ�\���3�c�7 )�/�ُ7%#��-/O��\�ͯ;6!D��pZ�\r��5_5�w�6�V��`�ݤJ$�8�I�4�p?����ǃ����M���D[5��|��TF��Oj�r?H�����Yb��k}�Tj�R4��fb=�~�	�\��9���%ټ��z�F�%m��@�S��E����4����F1�Ҧɒj{�	 mgϧ�zc�hD�~_�}�sm���MA,�w�� �;�g��:��M�z�K� 35��1T!ܒA��G��"��G����e	0П^b\q*�lcm}\�S�~h7�eY�����Q�&;%,�x9�T˘����#�.2��E��F�����Uc�>� U�b�8/��ݟ�$��#�W��6�]�;% ��� �i�YM@	7=?nQ�	��(dH�L�sdF $+|G'� t>�U#Ҭy}�����0��W������B�� ͂}�sg3~���졳���Je����Ey�o�[����w��|�/z�=g�tG�<��@�8,w�η�c���6VuF
@���j��A�m��l�޵��߶���خ��3J���I⊠d3h�.�?IN(�~\>���{�-�mÛ۳i hd�-��Y��M� "D)��
 b #p:.�u
�� ��\]�r���\��������d���{Ɏ���gߜ�~U �� "M�|�8v���w��pE�䞻t�����&�~%�!�� ���<� ��#�ur^�������Q_`fp ;Aف��fG�w��c�r��]8t�n�ے���v�|z��wZ�!q�� � �({ �z���@��`��
 �\� LKݶp�ú��{y��n�����g�}�s�
�o$_�h`U�tF���0(����9$)n^���n���|�~ď,	b����G�� �S��y� m9�gde��	��Rv&�qAYۡK5��v�d��()�1��d�S��4>� �	,�����x�/� �wt��	P@p [ ܛ]���t߉݇K��73�\f5[N~?�O�X���vd�1@�f�$��ݯW��ޠ�:��>�}�s"|�ņ���.`�#��3[TP�����^CY�e�C���	mRD@�{W����/e6#k���q�$ٵ⋻M�jo9Yg1C��]�	��.,�q����yT!�xP��d8b�u/e��,;�y z����4�̠=;y���o5dC� f?B�� d��%W� ��4;A$.�� pY���%hFq�: Wj�@=
�=H;b@@B�Y��N8�ﻒ�bJ��k�m�yB�Gg�ѫ���-y:�q�d'��m��W�	��d﷦1�7��/6@N���74�	�7�Դ;[h�D8O�#y�ƙ��ί�  �m�2�ބ y;j��r+�2Ώ��PPr��!��<��n(!)%:Ŋ����Eb\R��f-꜓F�|<,�3�c4Fg_Gp��磵�u����8 �oۙ�����w?Ar:oNr1p�7w_`l�w~w�4�-����ٽ��� �4�|� q`��:��{�.S/8��n��k3o�/�חj~}nf���}agfzb_�︜���L��e�8�<���<C��D�PTe�G�1@�B�!���w[�$��Y�e��+�ڶaBC��i�Xĥd��hÆ�%`7�� � ��� ��O��- �A�ί�2��>�;r�M�ǣ��(�;2��ÿ،!|��;��L1���<�x���F��ԅ�F�]��Ƙ��[0�sT�v~����@P��K��!1TS�O���~e�������~v�@��SJ��k�g=X�-�1Hd�����pKKkP� q4 f]�<�a�!�ys� {7� (x�m����;�!��' \& �/� ������5�;�3N_쮘1<����㛅v����@o^q��̂���x��11��x�l���VT�� ��3�P4D�p����� a������v,T�k��`-�V*@�ȓIZp����z~|>7�H& 3q2��m&/���  mv��Їp��xث?���?;>����?�ľ�; �6����D���"/ˤ�؊(��O3����:�
ͿΡZ|�_5�GS���-BZ�f�S�핽��$L�I6��������.�j!HqX%wF��Pp�����fi~h�Hܵ��ܨ7�%5�є|����֘�W��V;4kH�;��Օ>��EES
���[����e��?������?���8s?���J����J+�N��jl�̕9;���߽s�>�F�m�����W���{�G��j�
�_�Q1 �H���Ȁ�
q�B l=�@�� � �P�L�pcg�+�8���@�/ā�@|�^/�T��� �6oZ+d�$){T5D`@z �ť;5B���{t) &^�FP;݁8@����ސ=�tVe���|E17c,���3=	
7�F�+u:_`�_�e���c���V:۳e ��y�t��K:�����y���IO�����&7�����v��4!"���+�ڈ ��+"��&�~&I��v�\��}"#��Z�P��-�
�\\�i�4o�!�Y5��A�-s�����x��/����0��d�����:�?���l����Om&~���o/�ZoԔ��־�-%D����VCQBY� �^�@@��  @���*�PCPmoP&����	 n �K�l� :���:t�۠�x@�%l �  �U.܋�J0,� �	��Hq{e�y�";!�Ir��-�s�'R7Pw���&;�K�+ �Pq����BF�s�ґ�u�.�H3L�?4���8�x�g�7כ���v���df��G#��d=�?�c���y8^F_�����@V ��6r&G�J1������ ��[ ���h�Q�w�K�%��hu�v�������]�|矝������29hk2�';���9�n�D[Z����8ڮ��5��$�ĝ�勮$�������Ǫ)d�a�so� lه��Y@<R=�*�;�@�-� � � ���݌$���%�d � �P ��L�D��p  ���O{"��
��GZǑ���,q9A��
&$�h}�^���5� �F1�MD[ӗ&���&�j���&��rl�t6ؚe�T�ys϶�9=�o�ȩ(Tˎn�vNz�ӤQl�����>��m(
��D��0��w��TIGbȹs�1��f;H(
� aE	!�T���5㬟q; ;'X���~s�%��S:"z�N�6ֹ)��'�8���l��{#���]����ު�\��gK�P �&�� ز�\\}��j�d�����SA�E�[ۛ)�^ �h��EN.\d��5 ���W����Xy���*`0D @�`�}��T��_<�h��C�ao�,Q-m#j�^���MB�ї&:�m�a.�j�K����י=ZT� !��qZ�M�3K�Ν9Mk.=�:Mj8���*�'�����n�}���B� �0�� �w���T @�y{݊� 9`+�
sM�Nm������۽t���~���j���D�C�F7��j�XO��j Ĺ3���H��,�!@��`���vӧ�z'���+HK�-��3�s�  ��7E3��ATc�b�tq�Ψ�n �
�P�M;��Q!7#�z�n�%�L�q ,0� p��yz�����?��-`�`��`*�� * ���� �������4���p���x�ڴ6@���Tlg�7�r%�:��I��r�.��� �C��~�xE ��D	��};�V��'��7�����c�v���IE�)������f�Fʄ>�x�Y���M�/ 8H@�I�y�9�7�K3�QJ�c���m�O���k5�����hĩ� @�0��Հ���/ B@D� GS�ƶ��z��@k�a�=V�0 9(�d������	:�G,i^+���rHtU��b�G*�fxg��Q˳�����kע/32x�$P� �����?? `K� �<�x !m}!��/���_��{�枓?�焫:�h�MRs�^�{Q�MjA$��͗܋t'4�en^2���4���/E!e�6*���Yz�S�s"�����Y��4�HS��S����˸�������. �p
����������t_?�!��y���v�ܮ�pS����}Lq�nǮ� ��Lp�h���g���.n�@v˭�Vd�m��!�j��́��B� P�Iϖ%�l���:;�,�TI/��B J *�`�x�@�����N�(P����
ڣh�l7m�}��-� ��8��2�q�L�L2�$�[#���2�k4{�@w� @
��т Q�9#.`�sғ&�h���f���v�jr���c)6�����;�l�,-{[��،ρ��Ū3P���zs�P@ sc�7@a��}�~�s�W��T�����A �+ �a;t��Gޘs�	E��S $+�0w�z���F����8	x$7W.\�]���|d� x�\�}Yo}���S�2g�N�uN�t"gL� B�;��>B� ���m�_=o;k7���p⤛�(�lF`F��W��RH#*�i ��)j.���l�f��J���[o��6�ʥYFѪS)o�p{i
�ع9-�) �<"���g;+ �QC|Yg 1k\��I�����m}B��E�L���>₸�8 ~�D���b \9x�@�=R�F?��p�#{D)cbP���;�m��{��p�m��s#���8E����и2��q`��TD��(̜�� �>��~�on���$;�=��Hm�s�}�wI���b��ŁC����]����
/�ܾt��)���@ �̂�Oh��D�� ��	��A
h�A8H��	P)���_���27��R����a�  |����;M�ZϿz8;���<����	C�� �}�ta�D�]h�1{T��>��kSxgK^KԼ-u@oZ(�*g���4���:2�Ű�Yrs��UsOL� "� ��A<�X�lN��&r  o��a3�.h_0�
h��J�}�v �^h��lЬ(Dy� �g�J" ��Nk7�G�g��D���$�
�Xٸ � ]\s��=Z�9ڤ#�4Xs�����7?�qYhFL�$H#@ApS�A� ��*w����;��<5a�į��=bs��af��=����;���g��qD0�y��M�Ɲ4�}�sm�n���������,T_O2�i���	R�Ա�2���F�@�B�r��RS����N��=��.j\�`ɮO��4�����x�����`  6�%�� ���� �u�t���ċ+�v݈�|��+Z�p�-/`1��gɑ���۟Y�W�T>u���XP��`O��>�RS�����q�$ 4.:�A�!�FX��P��h
��;r��m�)
3�ȑ"��*?� ��0�tN�͹�M�si����~$�aXY7� �) ����{���A�m��%چN[R � ��S��=� wgh�9��$������B �A��r�^�S����C��f�A�ǫ d��B�OR������ݼ6ա�OC �q������+�c2��rb!Lv�dR,,mMz����� ��U�%0�ñ�yw_~?�^�S�.@<;@^��؂=hA`�h�&T ���J���(tSa���m�)A�j�ʖZ0U���~���1�k���\���� ����<*2�AC��m�n�޽�뎓�z���Mo}n�]������
*����E�ʫ}L[�]Y1��fy^����
���� 
m��n����k�P��
L�>5������� �P `�ѷ`�ȁ�ȉ��/9�\e�B���#�F'w�I�ᯧyK޵�8E��e�  s���#]�/{�9���ܣ���C+����� ��q�K����-9���[;>�վ#������I�N怢( 4�L�8M�@{�1/$� x��hu�h�������������y�=a�	!�d�U�y�H�@& ��9m�	�SK����BT��X� �h��X"�"v�Gr��K(�pG-h ���[ϲ�@"ȝQ�v�M��laxe�w�Y����ߖs8}���;���%͙��tdF���J_�p�4��f�8��F׀vy��>����qҥ.�׺*?u�R�Jq�F��s/�nwOpu����ΰV�^# ?���\���s�dd�& P�~5��e�����2��>��7Y��e�&�#��ٛ�:����y3EG���>�{�5�I�v�8�"}�n�2�dK�o�D3�{�An�P
!8Y'_�NcHN,��� �њ �
�"�9#�-��v ��0��ǯ���<|���:�bO�30��h���(գn,�B�����";N�g.�y)�ZC@�՘H���~������R+�� N�h�f�z!�j�"�xT ��%��C�o�Hk���7�=~��J��/s*���	��4��N:3�z3>�m�#@ߜ����7���Qw8�6:���q�'�'��{���O��IlZ���/G툿u�~�bӾ���� ^����3� (��N^�7o�0Q`��'�zRKܘ"0oʑ�;��x��}j�׈@�/��P�6s��S�׹��97ӤEv ��ؾ� �d�d��\p��7.=6�x_}�K���]>��{�9朌U����1	MX  ��I����C��h §���d�J���_��1�_�$�G���B��h�q0  P���[OVm(ͮI�1�h�l�IO�N]�G�Jm�!��lmC�M����H�"�⳧l �Zs���o��};oэs�\����ک	+��n��F;֏	�m�wο�>3>�쏛� Y�G$������8Y�q��:?=����x�������g�\؉��>I7j[�Q��Xw�/������
?������Ι�]�˂�0�hD6�|۫|�κ�@1���s��\�e�ͯ�]$��:�Ν����t������3?|"9`�4AtA���f��7��u'�:@|��ɹ����s=�)��s�	�1Q����`�T8�
��`�?�sͥG����%�e�]�뇰����+#q�Ɓ^?�.�P]x�DAZ�g��@����T�������װ�M�A�O_�L;" �n�R~�>����&�k���֣E��w�*��8�4�,�b��D���D����9?���w���]?3��F��t�;|�_��_�_9�yl�L���r>���?Y�xѺ~r~x��V2��=,�Y!Uz\L�	�{��~�"G���B�����n~w���9=���,,��q�o;�2���V.su�m]Ǔ��t��U����;�O���h�Kps���=  ���d���� d]��@f��������ɩw�ٛ��+7�&��%�}���[�y���:�s�#R @p��`�����t�v)s����3��߹�>@��  �e ���k���,��n� ������/�o�M��0@�/�y }�K�   `Aj�V�8Gӳ9[�V�]=�k����l_[����@��
 vPw0��Q!>G�>xQ��A��צ�6~A�VT6��I�>���#3����3�g�~Ϗ���(4��n��k�����vrpV�*�6�=>9|;���ɟ;�ϸ��P�B�@���^'�n�A*��yr�`�փ�>[�l@�U�I��v�Q&�h�U�w6- �5������qs?����)�g��96��x{F�so��p��g?�j4:�hj�.ȮN��>|��y��(j�v�;߷����O� � ��X�������f�}����z�HaG
_������{ "'����8������}�6C�h}7����g���"��^ȶ'�o(/Yo�$s�����z���� 2H>����� d�@��[���ߝ�HfϏɩo�;��y?e�cf
��`�2w��#��@H��������6�Ԝ	b� :��bĆ��7����k�����ӿ�ÿ�'~S�R5q������fAa��%	�`kP�FmhH@���w|����R�C��r�I�{��כyMh��X�P
t��~x<�_O?�������3L���>L�{��x���氁�v_�h0�ѥ1M�[6ܲ��3�S]� �p<�_r.S��¢��PsIi�3����ߓo�����I��=��]0a/ L Ľ�3gh��m�z��
ZA�=��k�����󑻃�&aQΰ�k �� ��Z�\}��}˷_��9�sd���?�L�8��c��n��o:�6w��[�fhMe����kX�H#�B���s35�>�Z�Is<�8��1�>S�z�;���U���ǗIn0nd0�VnA:	��*BfB�������t��C׹�t��^R 0��7�L~�`�x ��6Σ�6  �{�@@���$Gn*F�w�#�}�@�c=b�l��x��>
H�Hx�/l37YB2���r�ߍ�7��k>N�� �}�rP�w �����s����֞��tcZ����:ň&&���Me}���h"7!QX�n��D��k�����C�{1o{�־x�u

��>!������!�a�8��� ���i�!`�7ͪ��;c8�Ӭ�E�g�H�ݦ4[�wdwg,�Ngj��Y��ZAB���Nldj����+�^�W ������w��[������fR�����LK�=P ��� (��ϾUB��5��O��P����Z�o@�;�
Fl:"�@�t+����z��>ߙ����ۙvǭ�ꦑ�lk"w���;�蛶*�J� ���@a"���`݌�9��4�a���__�A 	��a��9�
h�;��-�o�4]s�%m*}�b�����h�S8q��� q
�룷�2�]�﫠7wx��O(r�����E0�;{�Ʌ�e���q'�"��f3�	}A�ɉu~��BB�0Ռ�H�`��8��������/�|i���e��lc�p`�(�T
���ߝ/�x]�H$@���^8��,�7�<��I=�"T �x��١aq�e� �0( � ��wC�$�Տ�R��q�n�	+;�z�:�kGUH�MZ+����M� !2ɹ�	o��g>y�{z<����[n��f;s��B�Lq�������n�c��#�����i�φΨ"�{�s��o�8%��p ('��7T��WQ��-���>��vs��-������(�r��|�~؛�]��Ԫ�/ �Pf��� @|�fU�H��ds�x���	���'��yGzq�o�͖�Hw0�ݢM� �i�gFz�cZT�x� �	�ɁS�\(��)2D�$i`f܌�~���1ݹ3���/��[����{H�n)�'����|��MP����W���wfh���j�����}ʎՀ3 ��@�9$/eQ�s�M��5��n[EQ �b����7{��-ے	��A�Of8\x����v�}�2��jK��bH>=N+СA�Q�U>�q�&�p��?lY-�џw��k�� T[:o�U40Ȁ�@�*��xZ2KBz�����ࣞz�s�9
�{���Z��v�������B|������Β��i�8q�$����~3�h���0��3fWO�ۯKrH�4M�#\y{pP��nK؜�S�}���٨�K{���}���~)P�ɾ֜M�u>��_i>�@�^�d��9<X��Q����nk&De�9�������;�~�{�t�-�q=��x�o KH��Ug�,.��lgR�ީ���ܰ���a�  �� A$r�~ ����(�Gn�:w�% 
̵� �;�� J ���y���{ W������� �=������{;��[�RfCQ�k��PX��N=5��LR;�[pm[����Y~��F
EA���O�V�	��A�T����
#���v/Z)%�v����!�����(�Rk�}�$ ����P {� �����'��v�O�'\���FΔ\J��A@"bч� q��p) T nm����yLh(ݎER �` ��0��G� h����\( +� �h�_߬��k�v��HS��-w����e�s�`~M��@��\�'�xt�s5Q��7!��$�W߉a�C��yt�ݕ$ : m�N���;��J�L�b��
�Рb*�3��V��C�p!��0���p�u^'3_/�>K���I�>�}������"��ı���"�ٙ�&�u��"sQs�?�}a 3P�@�@�=�Հˎ�1�� �����{R�E��ʓ�ě&��:i�@��<=u���EB(ae�Ѷny�A�%v���� �� `�Y7]ߗ<�/��]m�!t�����a���B2��:��$��:з���  �  �]P[o��;}�O����zq��ʙ��5W
��{� hE֓V���z�M��!٭���(��-�Da��X��a�a 6�������m���q��\���6�B�)ύ؋����1D���h�il₼��)��=�2��t| 9.CdT�{i�u�߫���i� )���p Bfh߹l���	r�nHZdq��ݵ��t�ܼO�{mA�o�k����:�"�?�P�:B\7�P��P��[�s�nT2(s�ε��:)�6rh?�qH�^�C�}0���#;�O���$s �6�k��۸����{�J5]`��h뢩ݶ�����J�iY���ǥM�aB�o�>�̣ZE��ށ�Q����bPKF��0�_5�E��
�E�0����� B���s�\Ud�w�НI�7�C�m���۾{N~`�w�W��r�I.@�-,`Bk��g�:�m��E.�hs�k�[� �Ac @A����� ,0+\��aQ�_�ף����${��	Eɚ�h�7}�QKo�[���)FpBF�:ܴ�w�|����V&=z� @}<�,2�22�_��7�����(��3EH�; E=M��yG���v���د �dg:(Qfˣ{^��/���1��ef�����5�;n�q�5@�`f�ܷғ�M��n��ܽ���9}���Pcg�b�fR}��\3�'�,�E�]<r��d��2�f��ŗ�Bc��ʜt$���u����'�$8�A���Xrpc(H4�N��Nt�0�}�M���F�ѩ�U `W�j�!KɆ���BR�gfA:�-
��X@��n�j_I\���h��֟���3	5�NX�}{z~�Y[.7i�Ԟ���o�V�<[��B���^'������ܺ���:�Kv Q L�"h�<&�H  �1��4$�	�ж���a���,��=���k��7��j,�$*g��!m�>;��[xN�w�� t�_Q I�����-y��tu���AIA�X�Z�Hq���N!7ڸ@.�"�{����i�~��-�@jv�WL��5���^b�@��7��� �dƏ<���IO,46��ȸ�:� d�y�K��#49Ϸ��d�z3%5�� v�0���o��j��D�U_6�#��2�0�#M�S� �IVD:��riY�&���[�2�G���]����,�at'QI �ە�l4j0� �l�p��? ��M�B ��OC �Pf��	����= Hؠa������� � pl��� � ث�}K&��@��
��A r�O$�����o��~� �M�̩�dL����1k�+�=\}�NGP�  �!��# ��+
 @e`��D�6�k����F�Y�>����������+?>�{�� � ��M&x��t�U�1�������9rNlL^`����a(��@�olL���Uޗ�}�o��/���9��@�u���]�<���gj�[���7ݮ!� �� B��Ǝ[L5{Š76�ʎ¤�4
���3����XY{��$Hq9�n��i�!�E��]�{a6��bii@���t�d�b�ؒ��p㶊2��H6'Rt���V��  0�	bg�b�l�q,�|��9:�
>à�<�d�}�L��4����   �B ��'(ؚ��ܷHT-�� |A\3  {���f .@�|;	�r�H֔uw˓?o����6�9h��\���8����x��M���ڒ	�#�~S�煮8f��]&������0�\��ޥ���������e��4}&��`�PF��1b��3��<ԺT�rw���˝��ppn�oxD�$ �@�������>��_� ��Q�6@pɯ@�Ev3_��a# ��
�F�7��>w����;;0XX��W�V�$�~u����F`V����Q��� RO_�u��e6�o��b2��o�@�`s(����*$�O�Eȉ@QȜc
>�oE��H����MWs9~c@�,�<�c�� s n^�� J^����4�
71 �J?_j_�4��a���EVB��JX�PP�6$ `��ٝ���7��s% �{ x��o������G]9�����Q��.Zx�i���U�κ�3����{wc�K���O�\o���o��Ќ<��?ݞ�s���o�-y�Z�f(�F�:8>}w�ћ�]?���� �<9
�B �
 ;�w�um�6�̙��w��4W�4
����͂c;H� G���;1.<f��+�������^C��Ho�O!�t<��8����ܝa]�L&A�Y�O�B��cns4�@:�  ^EP�$�}�]���<��7�o���Bn��m��͏�hU9
�M&���>�B�4""�	��;>D��3� ����J���m�ˬgih�����
�  ^6�'x @�{�o  �7�!�yǼ����5�xq3
�9�����O�c�}�t��i0�V�!��zzg�qK?\�����W{Q�7�d�ة
�q^���Z�=����Y. �]�[� F�_�K^�PA��y��w���5fRک>s��s?�R����?� ��{��B2�̝���ߚ�"L��ѫ�hR��z����V��b8��q�R�.�+�G$��) t� w+e<Y�T
�v�+ �J�rj�L��S���ی� �`H�;"�a��I�ޑ���������F#�ə��	=�` �M6��H'�HH�N�i`F F <��O�TG4�g�����6������&`��k�/  � Z<J��%�7�[ 
( 
@�O��P ��������[� �Rm!�� �� gǮ�&X�o��e�>`� �`�9��]k-<"���P7�s1�r{��Ã~õ�Cvɷ`�!g�X
�-�z�מ. ����L�kW�i'�tp��~�)�f�p7N=�G��5��Pԧ@:�8J�:�c��m�1��1 �d1/"�RA#.����s�'�At�YH
=C� �o�y�~��*���A�8�ش�cu��>�K����D(Q��da|��g'@C*�f�xⰑ��ꅦO49�B��:"� �jv�(�d��� y�f4>������/&�����O�� s�N�s v�;i�L���oz�Q����y �A 8�q:��V�1�o�ANk*�� ���&�ΏRK�}\l0 P  axTK  �[C  ����P��P@
�B �m����mp  �s v���7�J��G����E����sׇqv��U^�ۥ���u� ��� �������$  w�;�6.�'ݾ�r�����a�2.Lе�ޖ�TY�]ۿ��6�[��o_ zHS��L��,�0�����6���R��#�)��-Q���lߧ\��C]2��G8�1]���+��@w ��t���� �G�W�ff@%K۫	 ��f�&N
���W�4A nf��or�u��&3�Ƥ�3_F�s�P��;��f?�� J�g��j:�^~��|I���w;/s�K����ͮ� ��d^�t`'�o1q����*�   ��{eC����-���bOP^XaE[�o  ���v��z /�7�<# �
��uP@�b_P�h���cߌy`��7��/Inf����!��u�p�׭��n��/l��`۾#���z�.v�yf��Fᛃ�d���ޭ�� �����帷���&S�ʳa����R뜢��=�  @���A�w �dCC97շ���8�HEh�BMő63j���ʪ��{L�q�ʤ`tVS�L3<�`%t=�9�}q�'\���694��_�#2��f��|���ʯ�_�/�k~<q�'���P��
w`l!4!�����N� �xE��s���1�p���cv���|++kf݁��@�A�?$<8�7���}�����#g���]��~ph�a��[.<���ηxV�]/�����G�tj/itH4�?`� �5An��! ��_�  @���-  *T �nD��W����$��oG���=_\���w��黫���9�3yg13}�V��rC�\UJ8(�C�]~;y��~[lH'Zzs�
@o#�7�k�U! �ױ݈�b{~u���7�(�=�__�A���*:1��AT;�>�&��ui���oaw��T�ݷ�/9r+���

@�&LC\�T;fN��v�U����w�*����g1��2�A�fg8  �o~���u]tGej=7��m6ݟnW����<�r�������Mz � (�*!o��O+�&+;��/��L�����R ���ӌ����o���?~����o�w��� 岒3- SW���ý�=ad�5��U�M�� ���ˮZ
\ V���VBc�և�lv�-�V�����\w���u@%*��hO����<�܄� `� �4��, ���}e�~�T @0$`zU�͌A4��S������������<�[�A�������5ʅ� ���  n�nb�����N ��r�ן���/ɶ�1ag�o�5��k�]5R;W�&JU��C��V=���J.��[t�nӪ����K��@��K � �����\���	 1B@u�47�/z3�±(p7z	01� qt���5x ���,)x  �B%n���!���$�=A�e�(;�}\NOơ\������J̘�1Wp�~����SJ���( ��\h �mn���+;���������+��+��wd�b����W��W�h!۵ҩi`��дG��  @ �'��q$�3��xDs5^�y��L�.;+	�����XN�Q�����-�tAÞ8h޳����l|,���hL�+�.=�b�Xi	6XT�-����l- ���j��Uԑ�i ��jY�k �|���L�u��]{�| 
" c�tW�OY=J�[ �B�2p�\�l
���&mA���"���\q��	����~���[��ku�寿T[����$�m�L(�  � xxs0��`Q >��[t%��C��d%.��������e.n���{�+P7�s0�:{Z���δ<<�)���>k]���lw� .0�������3�� ����_9�i&Ӣ%ep��:Rç�	�68�WJ�o��z r@����
� D�cZ��?�v��P����(���^B\D �
�e�]&���f�W�7�.��3PxBs3 Z6V
�(9� ��2G���3�\�BX]�ʽ�"�b?x���6��Ӄ�<����a�E� ����4� Uņ�`��Zzm�oN}�ݻs{w9V��r�Ev�Nߕ���g��E;6ԫ&|�M�v=�h�h�B�Mzj�E��B  ����� �`_]q�2�wzL�`��	������Q��}��suI] м調�w��M%��0�z��)z���t�:ǂ�c�S;*�  ��e�I��M���"'�J�w��0�Ғ�r5w�-�~|#��;B�yLd`�:i�]�^N3���|	siQL��W4 �.;�e�0����:ϸx@�BU��i�.�寮����d�w1�m`�@ @����ʫ����L�v���o�|{�msY����9��1�@p��=��H]��s����õU@�C@  x��( ^��� Q־�4� �� �@�X(�����j����UQ�DB�$;V�J��#Iء̝�a���W��'����r�����|:u6��S�N�}T{݁�   t��"""�I��z��ڭ  �k�j���\��x�?e�"���
c�f���} ��3q���P/[���B��&۾��J��@;��P�x  %T�Dn�=��~~6N�1�����'�%���`@��S���@
 p�cu�����?�����t�� ��2�
�1kI�8��%���*���nQ��V��-�=%������Oi�8�^�}IШ��B4  7����l�����{��G�X�2�ȵ���6�;o-�����n���&�n�<p[������kH  ��8�A�Z8bL�����Z%W�k�E�;.��'+�35j^�gKWՔYTK%��hhM@���?�Ё�2��iD]���c�x��;�G)��%4mTl �$�Z�;�G��\��Zg}���צ6�] P Bxk�-)0��@���gׯ��[�(�������-����R Nfu��(kЦF����p ��ӍgDrj�A ȋ�� :p�* !�{� �w���P lnq�@�ƃZlv�vAy�3��$��[�àu���Dy+>�͵�R<�N21�	���$0߶�(T �"F  ��.$ڒ�����tQ"r��d���$���wI>r�g$dAr5w�;눞��2P�[�0�/ �K��V������"��V�`6GN �����^=�:�$.}��OV�B,v�C�e^��������<TEe<���� 
 �M���K怹�3g���N�rC��ty�Y��<ָ��y@�j��}��3��|yc��֣� �`��t�` ���'�\ ����Mq쾫YM����un=�&1���j�	3z�ۓ�˵M��X���4pVnW2���ن�]��ڂ
 j�O- _�L���rH�Ew�G,N��.
`6y,���:A���N�<Wk�/� HL`�@b�L�i��� ZR�P۾>A�C��|����@�TQ�#�a�V_��ml���X �.J����'��X��Y��Q.��lp P�?t/��A����	�U�D0|w���ۺX� ���@ ��>��˦d��o����~lmVp^�%��9�au��}�B�h�V:��=� ��`��DSA����q�9�؀na��& #��@�Qh�j3��L�ABÜlnt���!�Ȗ��?��?ϲ�U���%hO�4�[ �h�SP[��H�M��po��\Z�J����̯�M������X�f,*� 0H&81u���"�����e���U���d��
͠���\Ǟ�$^^ȑ�3��5H�%
�NV)�n��v����/�k����8�qсL9r�'�K�"   �TT�~�U�?;�ңz�
<��~�)���cc\ vMP�e_9b����`6���6�\�sڲтj	�G<�ݧ��9�	���m��c�g��ܸ7���kw0	ц9�\sR���I�|=	��A@v`�( 
��F0)�hт��N� �f:İ���V�.F"�ƍ����juA��
^^���VTT[@��B�:-�Z�G`�N�b���h�`  �P��j�#�,:�qD+�9(KA"�4 `���p�	3���Ž�<(gWZ(�f�������/�޽�Ju����]��$ �y��G|��P&U�i`664�
� ������z
�����It�����cy����ĸt��{P��� ��wlA樍�Ǽ��������/��3Ⱥ-f��	;�rH�F�\c^��D�|z���t�NBZ��Ez�`�a��,
@(�qkC��&�	���5������u�P�\�G�@PK� "��W���K���]$7�
Q��O<�r/X�%�a�9��"���+g�FC҃�Z۟P�l��H�Ĝ. �
���ֻ�`�YDV����N����r��^Yߓ_ͱ
޻�z$�P@��!j �7�!jݟ��b`LkwC�y�x��vԹ�lN�g.g�� �g�`�u- (� ��V���w��..96�� ��;��gx�k$��M_�7�d��\�q-a���v�h�6N���J۴���`�s� �!���M� �ţV H�jR&I�)�~��di�P���潰N
 ��u  �R�ixF0�Ra	�B� ��R�xAr�?��"�JP�h�8�*IPM��?+A� ����a����t���E���~�����e{7�A���� `��?��@?(Q��zN-
@����?�g���. t���v�o��w��~��q���:m� �<!0 ��?k�C�N�;=������ތdB9>�NlX܆�!��\��7{ҵ��7�#M��:��v��q~�����܆��$:5%S[�����6�H(Q]NF+h�w(��@@0 ���,�[C�(��E?n�@[T �b/����XM�����f�#@}���  �d�S=%hA�-��R�Q!�Man�?>Ҁ(B���W��܏�I��n=r���]��]��zd:_�G� �����wՃO Q� B�QAya!�'�����`N��ww����Ƿ>Yg����:�APލl1����7�Z�3���Āh��>/9��7 ���:D۶  @�%V���_�]�����|ckK&)�Ҷ�s�l^�����쮻v��ӓ-������v�-��d1��M�#��v ��B��Ml�=�2�v-*�d;qm����@�j� �<gC��Ej�ʭP`#��UxTxS��S}�k�z偛�Y��*4�۟V�)��'�������^���������2�n�k��B(|t�%=�F�)"� �����L���%  ��E�;��qE�
C�9���s�����~��W����rO
-���J
ӣppz��6hC� �����=����Ð[C�)Le��e�z�7�K��K}����}ڙџq��C8����=~���߇��y=7�u�N�t���=���� `ٶ� �e�J/ ɭu-`.��YsMw�o��2HAV��oE�
�
� U@5'P(]�K9@��DY�U�H��~%��H!4�$݆X� ����	�w *�� $ ]'�ns�[΍��W������ڣ��9�������*�vt�A�]9 �Y��" z�� ��@}�g��i��# 7�$�P�K���]|��r紐ʝ������6_<��}�dꦕ��,~���w�BY��9
�s���I}�y�gs6��q�V��,�2���eo��_�������<����m��s���z�߾~}�v6��
"�;u�;��?����M2t\F+�fh�ᄓ���p�h�j� �!��~��	-%���W@&���@�'�(�
 T��uZ�0����Z� ��_>;��B� �8��܅f*��m@�9�l�X��P�*�8�k*MйY��+b��;�!wx�8k�c�y���	�'��u�V$`�$����޽�y7�<x�t&z�U�*�d_� �7�*�)z�Y*&�5�vꉕ۱�
x l�xBg���d�n�58L����4�r4ٸ�>�N{��x��}�3e
�� 1H �@��P�d`"��4��,��>L���9�c��x<w=E�2�2m�� @�F��n ا�{�vo�L��^��;�3b!�}����� �l� @�z��� XW���u����?�3���]g�؄�o�^{����sB�� ��v����$���������S/�z���z6w��%w�d���������/��ẘ+�����b�t^@�2	М�@�A���<>mU֟��4������&�r:篁S��	Rˇa�%���s�YY �F��a�ξ�l�V����NU<s����^M\�Б���v��9�&4sk��Cc"�Q� hi����R�N�C�L�����}�7ƾ�1��ى'� �S�R�;7u�j,��� ��n�1�N		�_���u�2U���s �}�� * @��>V  PE �'�P��@�F@VN�����R+WC�#�x� 0� Ї���e�P ���,�%��m	u�)	�T��m��u�6e}U�rv����΍cy�i]�[���о.{}x�:��9�K
/�+��A�	
���������O���g;r�r�w�\kEw �8 $�u�|���3�u����U-me���g�s>h�b����m��0�iWըA��TȠ�w]�v|��3@Er���9� ]���S>�XX.q$�]��64�_�+��V�E�O�A��9��{�ƂX8 ���E��$�=��cZ��4!�D` B ( ^'P,�C+��ӯ眿�\�ȏ���V/)(�У�=@���KigW����5y]^' 0x�׮��b��b��Tln5&P���R�8��`^���6�M\�,�%�^�b@ ��.l�l_=g,���S���L ����.N9��8��x��m��@}�cC��3h@s�lf�X2+:�s�y�9G��9��{@g�v��-����s�����ݦ까^�[h�4�����'�=zJ�֚�OYA����!kN�`�Bf��A�ce��:�P���
7��G��2!:a+��J�3������b����h�(��/�W�O��Y�P�
�}u��4�"`�&xǴJ"@�Ѐ��uI";ki��h�ڍ�_}c�
��
��v�'� 
�><H�z@=���Ζ��{{��~9��F���%������	6�" � ²�j��G���y��m�������bY�� 
�����#
�Qm�cpQ&ۦ7ܽnIV���.�a�������}� n��y�#42Ԧ�J7t�`c�c���F�I-�d�ƹ�Έ������)���{�-e��t�����m��a굖�W}y�=_>x�.��(����	B;�\}��z������P"�`�%z��'�(;�;%`_~��Y�im�.�Y�p��-]����[�����J�?��E��9{n��2�X�V b��
 p�&�"�J# B�tr{������&}��9疵Gr�=�_���u�  Z���"H n�"~�w���(��v���r�C ��6 �|�H)�>P�'��f<��坑���c�S�X��E�y�y����餞c� $�.�Č1��0������L)/��@M�lMDc"SP� l) �ϲh�}�-�N"@�V#���*a�~/��@Ek\tHJ��~������װVp��	�0��.W�Ǟ�h�9�nq)� �e�n�T�� 0����k���^/�t����Or88�+�m��͇:��	nW8��]n�6�A��K9�%A�V+
K-cbYr��(�Q�!�Z��K��' 7�+(x �
��^�7��2 udb_z�|�;�I(T_6q��BE�Z��
�j:j&6��šڄ�ڦlz�%br�_�D(`G� 7'-a��k]i=��0��Z�¼_d��'B�)�ݨp��6���;p�CY�E��r��A��髚B�L����g@ ��$vEH`�!oQ�4�4Y�r��Ec7,�j&���\w�g���SS�ݐ;�/�MM��y+����X�hJJE�ָ��Ȍ@�8L�D2`%Ccۀ�N�z��g��K�vH�N�քf6�炔����R�/U�?Z���l�.��ܝ���*/V޲���-���#�ٸ����C��瘲l��22W��ݽL��x�s��=��11��}�� * �Y* �* � "`aϽ��ܵ.}�Zg�h�����+9>3�Q�P�A �(j �����8'�Kr-�j6�ѹ��lB�������:H > �f�X �@�o��u�[RfJv�<���v`��֝~�# �F�t� �O�۸a٠tt'�	J3� �lந����`@@�I�́r>~�������:�f�v�2M��h�숗X�1�$����& @��_�ն�ZɢVf��D��3�5.Jf��	�ñO0r'�H,`,��0i��ܾ�j��!�B�5�R��P��ɬ���T��:@ �gd�M��(���^�����$��p �ͪ6�y:�mFi���.a���3	�HX�Jqd`�
��L�໦�) � ��>T� jb�2ڡo�u׹��-0�
�>�;"6� �f���GE� �5C�b�Jp�����Uo�]��Ìa�<@��� 1�������ߣr��р��	D�"�����@ F_����}X���H'p�Nbd]���1{Z@&���^���w`K��ݥ�#zH���Pli,�ɽ�R���H]���C��e#Y��]�g�O"W�.wT�+���:�$�iג"����l.��Gu������K�+���T���훴��:%�+i��|�G�����@y���	�JMM�k*Γ��S�� `R@F�
T.4"��;�P���(�0h}ΆN��E.����U��8:ǲ�^�� T�@������Ҟ�l̤γ>d/L,�y)1Uca������otS�؂ � ָ�Y �K�՞*�����h���n�<�Z��21���
 � �����	��^��4�����<W������/��_&�c�E;@2����_���5> �-bgI���.X���NاB�P�imT=�G����X @�w�d�ߜ���[b2Ɖ�Y���xJ�R6��2P�u�H�u=�J>�G�������vu����R��A�! �t%c���qQ���|߼�d<�z4�Q D�^$���˼e
L�2oެ��n?z`�~�Q���� �b���(z���C\���1|�����닓Zہ��z��Ńr ��}�T�b�X&��-�^O���t�L�Q"���A�}�_�{��/�E&L� �@;[�@�A#6��շ�a�/�s�4w�(-iί�j��y�r�{1�>��U�fA���$ĉs N�>�,��K����g(�( (@����
  UZ� ��B�t붧*�g�oO��ڞKrݵ�0m�9Gqh���#�<�*ت#g�%��&+,^)�0�/x���b�ޝ���a�1A  ��b"�og���μ��  ����X�y�:��˺]a@~}�	E�}��I��* ��kym8��p���hcI��D�R���V��òKP��"(5kc�צe��-Z��l��,oĬ�� � ��������7�D5Drs^��@�������bH)H`�������־�� �[�����\` �c �Kx ���� �
�F�ȼ � �� K E�w�2�������\�����:�q���yYd< � j Z@��a4�1���a�*`��j���<�^�k*��p@\�^B&8�С��m� :(xfvg?;���`K�5t�]3l���)v|�@���~�	�:Ti �1��5��n�)U�{
��䋍�5��= Gܛ�&"�����q�ŌR�(��3
�K��i� E�������o��巒���-  B�9s3q@l����3O]'�
Ք�^6f� >7 ��[Ȃº  �g�K�q�>e\��/W/ �֗!�: �����6  X� <�iur6�6#9�}�͵�4k�j�R��-�z��� 
<���ޚ�(s����e:�~�� 7�3t��6؆0�`��~  0��]� RoI74��%CŶ�$�� ���w�_P�=|�Xg	KZ5���=�R�X��:X�M������i�T�D�[N��)^����u63��v ,+�}���}�c����ܖ-��v�Q�=�%l��6��t� !  4��2]�? ��/���]�] ���i\r`wv'D+` j��m�L<����J��R�F�{� ���3���g�wiƻ/7����6@��	z4  9��� h�EE �Ey��9��a>Q����S�֐C�XU��f���,`���3��Ƣ�	���x�{���݁�>@�^����gf�h��_Yɾ��z�8�(�)�Ķ��CPPlo�E<*�Rl{z���w����Y�S��!�jAOQ9E��v���}�����Z�}:Ʊb ��H)T���W�C�6���JE�0��7�:�8�Of�fw��d�܈k �[j���|FU+*�"�����ph�����|��N�*���Z�@��:� �)��*� ;�I�D�F��A_�|V���=k& ,D]�� 0
�� @G	�!p�f���{�@�`ק�yؼ��I$SiP�E� x��D(���( O�O�9*5Դ����������_b�$y�f�<�Ҩu��4{�v����f����@ˍ��'#�.v�΂����J[�K3J�"��HT@�b�� ���' ��$FX vgA������y^] ������Aɩ�� U�6� m�2d�|����n��8ʖ11& �@X�� ��z �J.���9!k_�_@�sb� -V.���E���+��FfB�^� no��#v 9V:(py�]a��~��ީ�q� �F�l��?��b����i#�`/��
��B��rn��@,��0��qX���a��z3
�P��bC�^|�~��ח�e��>�O��O������˿>���p8 .\��K쁬#�i"��l�	��أ�e=����;�?S�L���Lw��d��C_9��
x 0.w�}!��h�.	{��. ��`x�!v@�T`7T 
ߥ�������+ɞ]n������p�>�h0$l  ���:�v�di�dy��� `�3 }�T�#A� K�a��#X6���=���$�r��v $�x�F��������J���=>����lVL�ȹ��Μ P�`kI��@���YbQ����/�۵ >�1�����	'3� �>r������f͗ ��i�ʵ��������,z�.B�e�i���7�]^�k�(�%o�-8�YA^n��EU,Q��-�H{aJ� �q���X��z��t�����?������r$a�}��-
_@�M1�
��!�I1�c�)CZ �	�zօ�*� �� ��t� C��x�9��Пq�_��g����WŊ��;^�=a6�Y��j^����_��ؒ9��s��s�i�t�����s�����S߳�]������N�O�G&`�:G$E {oH Ue/B��{<�n��z�BU 1 O��h~�Կ����N���_��4�c���}����� ��sig  �s��=`�5B$mZ(H��)�Z!�У�6�K�覽"�0k�e��z<;��+�າ�����"������N��)Rɰ� A���- �������:A,��ѹDE������{_���z]��/H�Ok,��y�a+��4v�__��Σ��*�M�~�  �BO�rn Z������ǘwx&��:�s2�;�&H�O�o|��w����e�
�C'��W��E�B'm���Ĳ�~���_��:"�l���n��ڱ=��Ey � x,+KA�բ��K]`���NB���OR�/�z�&̑�li�̝`-W�Q^��[�A�7qZ-�
�2Q�ܱ�o,  PZn�-.`Qx�=A�[��cPL���it۫��w굾ݽ��~M���ո1	�ݚ��,�{�j�6�(~���"�'��@�FȻ���<=�~Go�������ܝwyY��]��'���lz5Տ�?<�=��G��	���  \�v,a��졆���cz���_�� �b.3z�1w�@ �ϢڢY;
�+���@�9BQѠ���l�4	���Tc
;Խ�� �`ʢ����b�Hk�Η�=�$v�F	K�����G �N��Bg��5j���߻�|���;�ַ|i��՜[v�_�`�t��oP  N��o�D �pY�� o;���m����;zu'w���8�����ζ]?Ƣ��� ��M9��D��<ن4qg��n9�~���ʬ�9.h�ką~TxzW�j�~����Ws/�$�k]�jt+ѐ�����֋G�M�Cv��E�d]"�b��L�_(�.U]G�f��:�()	��aO����bȽ�(a	T�
��`P�X��9��m{7t�׻�k�N��y}�X��>���_A����LҤ3��&�X�!��	� " Tݤ	�1Q�û:��@OZ�z��z��[Z�hA���s�s�s��0����8Y��'�$�|�2)��՜��G������O�DQ[*���צk.�E�>J[�h�jt�Gհ��pw�Ɔ��2�����
��}]��t.=h����^'R#!�b|���=%ОS �l�Z�S�8���������/�z��L`A5u�rX� ���/w�z�b�x��:Ɋ��v_�4���n�$@�8Lfw:5	b�U0iPk�� 6*���5��eꩾ2y�C%�t_O�@w�g ��!��� �E�و ��,b�r
�k�i"k���Q)�F�rٚ4��(tP�j�A,Wa�q����N!��)J��	��Z�N�#U��ϖ�%߾],Au�Pk��&��Bh.�����dy����9r���0�� o����(��Q:5ǽ�3�B����/�;���(,�ih'���ũ| (:���5W�,lZp�@�l��T_����y�31l0�zf�J�+na�ǒ֠#y`k�^Ա�{�N4�!B��cϚg�]��,;ؖC/�*&�v�����[�ֈn{��u1#LY�
�)�:�*p�j��:�  �U�K��k	��Դt}n�rD���2MT��(�U%v�` ��P1ف� �=x� �
�� h�B�����F�#�����2�8�Y�;w�s��|��C*��g1q�^r �^K�ԟ�s��#Q�TiR��l+J�L��|�O&�B�X���8C+�MD�z��԰Q��^Q��R�/��� *u$�cn�_�w�bm6U�c��!�u@�c-=�6�1Nq��������ȫ��'X{�c~aak� �� ��`F
��� ���v_ ��Ǜ�o�1��)��^���p=�y{�|�c�q�?�=�HoSq?\�� .��D�t����5�b���/@ ���,�z����+��Ys}��� ��Q � /�{.�Z �{C�l��� @K�-b���P?i���L�������R��j���->( �N=[ P �*��P=Z����o�-�$�P���]�W�H���Y���Ѻ	�=j����~�W��Ӕ4�X��_�)\��2  ��O��L s��r ��$#�~�l�����\x M7��s�f@ q�D�EϾ�v�&��8�L������q=�0�|jG- �@���� �^ݾ�]j{>��%8�k7D'�㻦�A�l�I�ܔmc@[�l�<( *R�:�`(l����A�]�G\3�b{�dK)n��S� x�� `��r��6ӛ��vVc/���2K��d��Y�6B�4�����s\��-�6�6k����aܻ �
v؋� `�&>@�@a�tM�N�!����f��� ���9�n��G��H�(�9,��1�c=̭��V��s3|B��{~'�hy�	P  �ꑊ���%��E�TC���4���_@7�%\�_L�� fAX�t�K�gL�"�PWu�V"�K�.0h��d��	 ?�X���ü�E0��/J-Ч6@��CӬ ��1��<7�.���Yh��8��/���z�7�����Fmh�� ��8 �� D����1�T��� t����[���,��Ԫz�� T@-� ,m$`�)9���2�J��.C�"�aɗ�E��)��?�)jO�����' ?bЏV��YĹ���n���dW]�]h�����-2Xl!��7ư4)�h>��cg{{
�A.7�����v3�W���'������wrQ`x��@Q���S;zؘ��"<�qG3��K�����i�-��\c7�k�⢪I���-�g���  �l83��D}
	5v�������̫�̆3щ�����*��Ė�c�����/c�@Ω{@u	�-6�F깟�>��* ][�>�?N a���M�x�&H��p��@�㇑^��i7��J��u��Y�8<�7�KOKFE�Pr&Ƽ��V�DP/�܋�]����D�u�w-4�a�cR�,qG|�
 x�1�}  @ ��g	���H���cZ%�.���P�^�% ���p�Ge6k8�4�����/�U@�{���F�g'�������s�@�~'��U�)4��������v�Qnaxڈ;E��8���3� pC�6�����dg��B�|�f���(�Onz����)0�� 0�uA��7�v���ʬ��`0`�Y�_,���(c��=����^�&���feQ��lU�A�[���\s�Eh�֬��MJ?eT ��y��_o�f���Ql�غ� �Ł^�E��rqn���]�{!�C���f�?�#���p��f���� ����KQ�evc����w ����S�q�8�@" �4�k� / �q��t�*������!\��@��ϲTл9Q2�@;ӟ� l�^htٜQ��쁰ĭ.P�>�N���&h�����0=�ud��|w��]����a�q�s X � 	 b�"@΀�@�R`����/G����+[ζ���3�ݧ5:��Ɔ�����z�-�hD &�1Ԝ�����#ߧ�eD�!����c��5���fA` �ș/l��+Ĝ�h `X+D!}���9��@?��-�إ]����hhk�a����|�S�c(f5aB`��}�-���� ��q0�ň��u���Z�Ĵ���כ� }�9pt) \�6AX�Nd�wP 
 p��>� Z��vݕp�.�l�X��s���> �� ��$�.����! S�����>I�%���  v@O v �Z�.��������+˯����������z�T-���G  T  �
� ���)�,j�N���!�Q \���
(sQ�Ѷ�����cϬc�R&�z|{�ۘ;!�������F�b0 � }��Tg�[��k���:W��]
�������gzz.{�޲ܵqPvA�ʿM޵�I�y2g��� ��G8IC�����!�=�	�8q�#�c�G+�VA0���=ν�/�� ���֥��>��va��A���v�uA2��k�Ձ��f  ����|�a4 m=.���v 
� �w�*ut�I�9�WSx����U�c��[_�]������xk��*���b��U�X�ބ  4��JY�bn2�Y�����'�ݴ�*�����S|�����/AZ�m�$6���D��ߵ�Z��oέ�@��
�9����S��l��#���ضeHv���9�_1�s�.f4���uE� `e<� �d2�Xt�K0���<�>R/ �(���d��{��Z��s~[B�  @- z���}8����(|�C1��D��`;�ɖ���N��|��Y��ϣ?.2�˻��k&�MQ��
��z  @o��-�,a�Í�o��Ġ��Wbৎ�ؐtܰ���h\�H�ھW��Һ҆$ ���\�����\y�Ci�Γ���S ����?y� 
�b2�$r[��c6A`��͟"a��(q�I�Y��k��޼�\D�)�'2 緔��(�� v  Z
��=E,c{eŞ2MA�u��#� � J<�2�=�������|�TA�������]N*�C�%DoRț�G: P>�R��
Tct���S&A@��E4@���Dd X� ��7�t���ϗ��E
�s� �4�Tr1|и��ϙ�^	;=K'Ĵ�Z��j��R4v@��5���9՝�f�u/ zu`#!@4�B_�x��K0w�z��>�d��1��^͂ �c�O��� &s*{,l�����$ Z�
P���*_[ϖY�����͏ێ(�:��/�C��8�~���b��T]����	��>ٳ���5��� S� ����*0+�6(�  �C���$W�C  �n%�������;�$���3���+�=h}���ԫ/)���l���r��쀾� @���g����~ �m�Ɲ�!-G|A�
�Jh�m)��� ���[��a%���e�S1aA\X�+7-��y��l�I��6 <�,�v>̯����+{󛛏�|�x$b�L+�Y4�d_z�B1�Q���c��v6��Zޞ�U [�:� ��Z��nQXnؼ�Cy}�ʂ݋�����g�y�����-?�/ʾ �И�� � ��&V�	�2ٔ*k��y
 v [R )����� � ��������lrhS�Ϲ���>�����IMLiY'�= v�̯37� �̀-| pп��;��^< �Z���� `� �-�؂�y�"�5�v ��  (� Ϳ8����i��lJ�� �!3o�`4D�sfΆFS�ׇY���LD��6'�ޑ����xk�AK1TK��,KTM��j0nǠo5�@�" �Krǻ��'��������3˓\Y.�N���h94�O��<�̐{3Ȁk�}����]�o��!� ���O̲_�)���͈�����ߘ��-��M��U��}}�s��{�#�4?��0M�M��P��]3���8�n����/� ���Vh6.,�%����)`˶����ʶ�Q ��0�(P�B=��a|��;�gy�j�c�ߠZ�f8���쨵l��)br_�}�g��u9_P07����ec<��I}�L�����9( I��!
 �C�c+���
4 �A���e ��(���y�
H��O��������n���JR���bvA<{OQ����4>��q�nF�_׉��G8��a���F�{A �i��}]�<=��	g�&�E��3?�����Л�Iט���{|yw��ι�֐��Y7?����{�I�^�H͵j� &���g�*�[�o���G���L2�hqW�r�a> q%�.�)&h�$�4 R �=	�
J�Z,�S;0��$  k
Lv������
_����� �g6�/���+ � ��L�L(h0 �m"FǮ��+�Be�USV:,��`���h!İ�Ub�C�qS~�v��욀mXh"??��=?���y-��+	@f�!1����  � ּ��D�X��(�o�7�?g��a�}W��:G�3ֈ�@`�/ř�*�Q�4C7�A�87�=G_�д�TB:i~n��?~�Wm%[xs�L��HГ�סj�T�鐘�f8n��f�.,3�l��rJ w|�m�,  �1B `�))�p@I�q��&���8�z��;� �SB Kl���4�/�~]x|�
� �M�����I2ߴ��`(|��Փ�~�]�d���}��TpW�,�����tSm�l�*t�"4�fF�7    ��Cuv،�;>sz������s�`�lܜ9ud�[l���]+`�У�Lk��lmW�����Eޟ�>q� `�p`E��'k�Ϧt��$�����$#��)�m�Ώ��fk�nH����mL?���g�t�����7����7iV��ӆJ���4i:�~A��A(A[;�$��㣄�1nA�1F0$p��Ju:���O�W�?�Wt�ⵣ�����# zВ�b���`A����[�!A 0 �`("ǥ��?�ɹ/��-6���mͰ����bl���N�|W��Z/lo��� ��!CJ53��g�d��/�8t���ٸ+ @��ݭg�]*3�^��=*�����忩��?���-v2e�L{���qB�@c���2����o��}�eA��R�P{ m �����7O����N�1�&� @)4n��t��)���5��ƶ������Q� *�"z�ijUZ�v�����¸�:�m9lt�O @�|&A�N�+��'�7��u�g�/����A- ���^�sH����§���:U  ��4������u�_��������u�Ů�r��Ci������m{%���g_d�;��*I�������*H#��ϟ���<�G�ڠvy;a�Ͼ�s7 �1��+f�"'b �t��y����b�� �Q����K 7-L�9m��@&@7+ ��H�tY�?~���Oϟ����~�@kb �����d���e��S�+rd����%�Cm.\�D�����#W�l�I�I�9�J��ֹ�=M�myn?�v��%�ZJ�%Rg�KoH��~X��������ԠT
7k�@]g"�-��%7<_@ny�O�l�|հ0�=���ci�x[߼9�0��M���A�Y+%�F}�@���mY�9`el�3����|��������&
R�� �e��[����A Pb[�i9���[����=|�;���5�t��\�0͛�9(F����'� ��
��@X,�-��Yi��̧�|����i}�M��j���aȈ
gי��'�,�7�t�D�b�ef�F���p5�Lߓ6������?R���u����ޖ6��7��栎�o���|�������C�[m=�R��l���
��	m��������Ҏ  �B�����#Z � �4D � ����B��a�ٻ�M��s��p6DZ�j}��$^�o�L�j���Q���m��_��W�$q �qX1`w׳)dT�ٞ���Sm��W�Ơ���]m2�'��y�S  �[z]�����ӳ�g�8&�DS� ���i���=1Bj W�X�h�f{f�����?����dݏ�h� n_����)���ȥ���MF���fF#o��KvU������������>{�Ο[�I$cf�~�3���L����x�f���������<�^��8 .�W o>) �����a�Gہ ��� � ;���� �[BH h|���E�� kb���y�^��;�0)���s�n�(:����r��54�׿<h�1�\��q�\j���%b۷���[����>?���������w�����b �	����4P^�Y���k������/$� <���@�\ Zo��1V�B`�`D�� 4�PT�S}q@X��쀷~�g�6�ٶ�����aS7i��^&�9��#�
� �> e�&ᄜ27d�0��1{:��� � OP`�'�*@��!��{���zߪ�+_W���:Ӳ��>��g��,��+ �S�ً�ڋ���:�;��r��A���~o��_ƶ�y�Wr�6��g��Z昺�^/�7�������i��O�?�y����^���o�=!�BCQ Q �7u8��� a
  �绱0�ǼZ)` h �� �8�� �pk8ԝD� {
  ���J��<���D�K����j���.n��x���# {��u�����>�[�W������/������bǲ��կ>����_P�G9�J1 #�eo��|���j�����/$Ϫ� dU��"��  �L	�L������fLϺ�;}g�=�^�r�^U�2 �ٷ�P O�N-  ��{�5c������]�I{��[|��"텟f������{Bԭ� �3 �hK ���x���_�����d�����?�>r�Z @`]pd%���gM&.:����@��q��]|y�~�~���o�ʯ��ӈ��H���ӓ���k�D�j�mȍAsV
����aTԂ�Z�2r�Ƭ��<'q���xM��Y�����C���v��K����M���t�	k�r�$�s���o������q?=����y8hi�c����H.F�	X�3&xo?��q@���ŏY��>��诪�)�P�
�zSm��*QN����r@�pw��� *�l  *���h�tmM����/��m ��6X�G�  �T��]���fq�s޻�@���{g!@�s���&�o���N�k����J;dX��$��f\�/�h��:�/7o�����������[��������?n�O�q�;�gڂ���Z�]� �">kP�oғ4�މ���5k�/���9�}�I����������?�W&�?�	�k��k�SoĻ9�����������6����~���7��)o��@�[o�=�>߮�۞�miЦ-Aa�&�d�^��m��M\k2��]�����v)�t�N��ޘ#@-��u�
���,����~׿�S����Nv{е^�d@��*���s}��ͷ~��|M�g�;��\;a�[����7� �-5i��37��HrGb��İ�G�xDPm�mB4�2B���eh?�G�İ/5�������;����}Wy��&�T�P1 �5�@�D��0�H.���5C�}��	�0��妳fP��QcC]�q��������;�B>�3�w����I�T�.� hݲ_����c�.�V���{�Y���ﯽsO�q�;�e��7QXBLt.��� �{�G�l� y��͢�i��GK?��	���o�����O�<�/�4w�AH0 z�+�y-���̹�X����˷���v8/#�8���#�t�s�aӷ�����S��Q�V���/��]'����Q_��Q��bB~�aq3.w-71�<T����I�M�A�e6�ӯ�������&��V�e�)k�-�H,N|�����r���9ϣ_	�l�w���X���Y��lރٰi���z���R���b�S�l�Xuh�߽��th�^�G#�g(Xj��F=i*B �:k @O)��GL����Lp49q�^��j ����M7�~�w�_��|�'��^������v'� ����\�Y�K/ϰe`ߡ��s��?�zd7��D7��Pn����q�LÈ�U@P�Zn�5<�m���,-�'��������jq.�����q�|��ѣ��7�ў�����8ξǸ��'����y��۹L�X��\�Vf$t����(�G�wϔ����s.B
��l���tQ�����M��\&k��5-�T!n�C�ڇ���ܟ��e��J�5��M��h<�z~"q����s��Y��K�x�*�oU>l�V��P�M�0��Ҵ]�Ҡ����C�d$;B�*�� �3[�4{�h�is[�������P!������kX;h�d� xR���Rq�9d����{X*�����n	� ps���d3��q���;����������u�Բ��ž}�g v����ҹ��I�WjP��� ��d;�L�����6�ȴ��:2�|��Y��q�{�'@�[l����n*W���n{ʹ�h��� ̈��d @@��N0 �-�;�Ͽ2~����o/97:�K���]i��y.�dt�I�vЮi����Mn��D��8+1�������'M�I�i'qtD��}�q���;*�t*�Zڽ����l���W�,���{�f����Y~��*����-.���xa㫮�;� =4 �������N�r����CoX�ԛk�k8�t�~@� �|j�V�ج=I����c����T܏oP��@����"l\��	��H��J0F   pP"�R�  �RI���S��W�@�&�\���ߛ�����;��t��;�G��?+ PryZ���B�{��4����l�&���I��{��[�ﳵ��9S <7�
�o�l�j�$Z�K�_�y^.`�4���YD����- ��7 D�vkfF ��ɠ����0[�_w�W�^/GO ��)�6lNt���p�)�	��PX���������d��h�t�U��K�NL�a���i�ͽ�k�2t��F�B⣋:'��M��1�D1mi���l����Vn��6��>�𧞱+)��.->P]�.��V �ك�GCf)8�8<s/�r�Ë��r�I�J��zT���hC
�8>.HJ�b�k��@K7�dF@�: 
�V��� �t̙" {J������G���֡a�W���2�eY���m]�O@ ��?�RG��'��ҏ~�w淗d�e�X7�wn���!�S�0pJ#r�6`�>FQ-��i}�����l�J�Mc��d��{�>���?��+  �h��@�ϣ��w����(}�� @���}�M�cZ�{8��=( �
����  q� ���  ǝ�>���+|���/s.VH���9�c����` '�������@���'�����[]�����MÀmi��I(��[�`�Mi�~�Lx�\�26$@ڠҾ��}����W���'����Ka�s��/���w�/�HjW\nK@�^-)0�-�=Dͫ���]\2��CRų�-��'�� ����B�>*�S�8e��_��u
 �ؼ���r�%� B�ZgOH��Yk �l��k�C`1�F�}��V�O0��q��~����|lt͛X*��w���j���sې��l�}悠��6����JMǟ����  -
%�P�Z��g�����2o�]$ �}3�����' d�a�㖆�� ͥ'����P���(���g�~�\����s�U3"���Pݞ�]` 2��@<d��NEFE�]������QOZ���<���kd����7uV#5��o����S�����1S@ݦ���6Ӡ���<Κ����̢�^�"��\{]��I$2�7Q���G  �NM��qd�H�^�E�,��Qk���-Vl���,��,�E�G6�Յ�n�I!?�I�ږ�4�< ���G��:��g* t@��KHF5{�Q߉�S9L>�����Z� ��� �n���l7���f懮t�{�-��S�"@� ���_���2ʎ0m�A�6��w����L�f��l~�|4L0��U�&P�P��3@� |>��_���Ce��Vlmv�^>�A�ݡ^���[ӡ�	o����{,�����@��"�4� Q�P�dԜ;:���9������~�_��	pA/=>�q��
��` �OH% �e�ܒ�K8��d���w.3w`�#��*�^@/�{���{�a��$G��5�*@B3͵!�h=���I|��r^��ߧ��Ď7�T� \���.�NP�b =�[�����"�^���Z��������a>U�:�}�[l�|$Wډ�a����P� ZͲ� �>M�"1����`�X �` 6Z�c�c��;v��(� 0I�@5�:�$4\H�����s���Jň>�>
䦍����`�M\s��G���� ����t��E;Kq˾��Z��� �(sP���{����˿�"B�����A���Y�B��B[��E;��W����͹��}p'<ә܁yJ֤�"��4Ȳ �5 ��vi2�tg�m��g�����}�u���
��4d�4v�]��#�n��*RU� <�D�Cs��i��ŧvr��%l��M~�+;<y�VVn��T��:m�����S�(q���Gx]���J�︎��}Pz����\����E��&ʦ�8iV��PP�]��*y����H�-�S�"p(�%!�jt��35�@�
�{����ݮ�[��q�ۀ5�3�5����k��~�;�{�+Ӟ@úP?��fp�j��柳��|�s5����7���֬-@}��ʶO�L=�>�s�K4]+ؑ���3 墠� h\���[�����D���a����qx7Z?���߄��H�)�%�
/e�f�. K��n�:;������gG�ݞ�F�Z#W�햕	 Z:9`At�39a�59g���/�ᢁ��J�  �@&   ��G��B?�( ����:�/�S �7tG5k��<�:5?n<�G6�`�kz�I�Ƌ���SO�Z��:em0v⳺�nfv�� �S��P��*�rs����tm�w�����QrxOe����H��{�����Q��fTP7��tx�7Iurƚ�0� @������$�U����Zf�C��%��^��v�l����X��5 �N�	�a�b��􀠳�Fն������,��z�Z�hBM-x��09��ˠ|�R����i,���}栻�(����1Kk(��3�����/��+���r��L�dX��J��]4fiw�RA;��H�HM4BWw�{�iO���nL��
\�y���y�p��8� � Ё^'  ����6��6�g.Z<P�p�U�MT�,8��{���;��׆G���W�+(\��q���� `+f�� P��j�a��6��뉼c�Ik}����f(����
�z  �ȵ�ޠ7��C.�@LA]ӳ���
u>�l��b݋KP* �6 ��Q-9 䂱�
��P�89�#�k��Z?%uX\Cw�@�j�̙����~�zâ M-�X��W��~v=�.����%d�j'��OPq������P���ľ�@
����ǟ�̢t�B��b.��߿������|R~y�P�^��dX@៶�8/ ���@�d�5��.�Mw����s�A���vh�!�����w��7g4��}=q�.)�9ր����Ex�4 \��Dq�ţ���X�@\���o�(q��l�4a�1[���?]ľ^�wjL��g@`ģ�B�>����-R�g��z��A�CԢ�#U{�f�/�� ��A��k���źbl&܇]����O/��w���Z�@�2�7���Cr�U���vi�'�?�K�޳�uw�� $v�@l m�\�]��wSdi	���`�.߿6��/��f�}����c�<�
(�E�(�;�a&r��q,�wC,������o��z�_�٠c1~�vM�j�<3�We�t�O4zu�0������� u1p�gh`"�k�1�N}��]�w_9�m���Kϰ
eߞ�ľ��xG?c  P(X;v�e��s�:��t�J�>�g�0��F�ޱw�6����oA4�̀8vaa���` �y��E�DK[ ѽ��kŨZ�P*h�ˎ��uI,!�Z�j�̘�����}���$Ɓ� �c���	w����zO�=(���T�$�G:Iz�giW�Gn���*�R[^�x��I6��-�Н�*���xj-V�(�@�bA��nqw�����M��t)Nv���PU �(��L%@�j�]�N�Yʰ��5X/���9��ǩ�e�h��ˁ�����5   �W}Rh��;@_���ПϘԆ�}`	��c��p�~+���]��"]΋��.�g ����>@=�vZ�Aq[o~�3��k���kvp �-����܈��$H1ZP�՚��k']�'���ns��Y���؟׺���S6��G�?�@Ve�]�\/�f&�x�ڃ5k����8� �0 ���� } �����?�O<�O��Ʀ<a����J���wUZsI��x���>[����F`��J?�/}��*����>��{�zR�#�O@P�������B��m�.tœ�l��1�vH%�����}�zZU�增��&찉B`1��)����*"���LZ �!����Ş�~�WI/��o�/�^��
%�,����j��0�j@���M����[_�nNPKCѠ�� [ �|�TG=�����ve�^=��I$�>��DP��ڽW����8K��u�.���K�} d>[넀w]�D�����9������/����C�8��Z@�3 `6X��L�l4��@aÜD�ݞN�H����Y��4l� 8���W�ݻ��{��  }!�� @A��L���.9 깛����]U��.wƂC��zT���tsV�Y��6�� �i}��#�@�j�"f�� ����Z���0+�l��	V�w-G�����ޯ�9NQ�챫�=�'c-*jh>��&b�3���,�M���A�@�+\z+PS���y��R�Nt����g�PP���F3��to�G~��{��/{���v����������,L>Y���t�
V�wz� 2}�ha�ݸ�* �B�JDظ*L���L�#KAK���
�kX`'v��� ��7�r+�t�^�Dş (h��>k��ڎT����i�I���e�Wi����_��۰/�L��O��^p�� -]� dF-E��P4{�� z�����3�?�;��|��z�q�Z�X`l7����(Q���f8�1�˻Y �Wf �i��B@��_�_�>|�#+Z+��q���;m���y�D��\>� ����q�z}C �b@D��
� 0����%��/���. S�_����-`N��# ��Bm�}$xN􉁢��������x7P4�PA�>s���G���e�.���w�����O��<����s������S}�p>RK�ʒd�kn�"��y���LL��B`���� �@���;Lˆ�C��P
f"ꨗܶ��}_�ɦ�=��H��@F�z��lv�<�.����[��5�!;��j�1T���G-�\\�3}�e� ���T@
ʍ�t��ۇJF�w�oa,�^����W͑��ĺe��` O�;�i(��&���T�:�l~��<-���!f����m{:.�;�28�����L���W  P�-c@ ���_M?���ܻ�����Z(���mf ��3�wH`\�msW��2⓬T��P �}A��=˂�^�RN��1��" @�p�5@oųU��i�&n��Z( �8Ҧ�L߹{����wHf=/�sֵ~����YE4�.P�9ev�X�;���z�Q�۷��
"�hk������?����C���}���ەĕ���X[BL�hf�Uoc�� TC.�i� � |W���f����I3(�RŊV�&P ���9�y s�)�i��y�ˑs�2�]�N0���	����0��J��7��ތ��I_���D>�7�	�` ��1�6�=� >���`�"��Bm��:Z"#��G��p�����4��u�X�]�>�/�i��k���9���m��_3>oȲ��ZS3�z.��RX'#��&�t����pcj��v�0MB��6w����<y�k}��Uϵ5��Z7�
 �Q��Rߢ�=��W��)�f�\/��VC��B �{�nz�m�k���pW��ͤ�r���D?h�/j����AI�V�rV���8x]m�?k�І  B���C�� �胚�? ��\��:��dd�����8r6'�e:�6+�As��;�I�_|��>�Y|L�Sk  D ��X�""bl0��݁
�-��[��W�g�쥠mi53g�Y!��'�а���  ց �V��F�e\�#D� O�G��־�j��:� >F�#4��,0v����a�fF�1��v�����2B@���r��R������7�ް�l$)�	��2Qx�u=7����r��b�ߨ9]=:A&@C�cv`�n��\�-x��c)S�|��ױH�B��=n�(Z�w�:����� �J@z�����f\�@u/þ�9��G�����~������;o퍩�'<���9�:_|N�-n=�H� @�۶� 0�@MVZD�h-�i�xD� ߂ڸ�E����
�F<����Z��+M�1�- ���g�@` ("Fa��%6ʑw�{�_�����#� �e��p�؊��1W仿л*DcPp����x�
�>�m7}���-����;a��Z�X�  `��D,PP�����c(׵ҹHC����r���`��!`#[z0�P�(R�-����g�8eH�R���ئn�7���I���Z#�6�J ��WCd� . �u�������˷����ε���g}�'��M=����O��V�gs�%B�޾ej0	05hD ��PSE���G*X�d0���@��u_����;R^�0���Y�7��N �!��@h
�
���0k����7>n����q@�t�G{�c_&Eϊ��&���&�,�B�0���/����S��>�w�\,3��빕����*�QA5�\�ل)ܦ���pa����bq�/fe��L��:�
�ϠUM�C�u�T�~��]�!�ix��`aP���:��n'�yi�~�.�6�����@�:*��*e�0/��h�AI ����8�Is�}���߿r8˻۹��ur �t����x[tO�������_��?�P�Q�����5"@[A�5�=P ��H���X 9z1(1�9�����B! M`���֚���� ��f4�����G3�r3���G1���1��g���x_��/%��'�>Ht��"^�	C����]<8�_#d����3ߡ;X�j�#���B!���1[ ̌	����]��Rm��v��SM��r�eRjP�.�����·h=���,`foQ���^h]{פ�K)��"KB�g�
e�JUh�O��}81$S���=-0bvc�b9�G�3����3�����Z�Uf��LL���)/����s���ϧq^'>#�A)���8/	�`՚g�;Y� m�:l�C��[�KO�S�~N�j��m���=� �NW_nuEP�>�>�W���	g5��
@�V��W�Z9yn��:	Z5��3^e�e	���V  �Ģ���U�C��p}z�O�U�#Y�퇲��@�
=��5(�)]�'��U�2 .�=��j"5�8@�L��I�SC�*2��<q�+�A��Z���S�9yYZsq����r)f\���e;o�R��Y�w�#J������lETu��Z l�x���>�ǯ��|Ǔ���B��������p�������~����r?�ww��@�� �P�:�x� ���Y�o��<T0|���Fa�4�'U  @@I�������)��t�M�	x���:�D�a����V�L��_�o�k���xƱG9�li � �w�7�٬�g,�Kҹb  �7e0^�s�Hwq�+VZլ��M%j�K]������^Q �:!�/��.F�k/�������{ϐ���xz��%�Z�c��P��7G�����&�����^g�K~\�z�ng�\�ei  
֔ ѳl랇����l��`0�8O�,рp��v��CNv���n"��1n䂗}�Hfm��ݫ+��_�NA���i� ��o{O�ه�ߦw�c��JN� ���gG�uڪ��>���ߝ9���N�Z�a�|D�V.��f�a9c��f�Т��`
 ��n�	n;E���ݞ��o~�w��ai9��#<���U6��6�0�8=,���_]��{�Ki���}V����ߥ��0�����A=��   ��R *��I�T�MT�����hcO�lm2*^Z( Z��c0Û���i=?�;�z�O�.��\K�	�SAl 1E�`�[Mz�Ӡ"��fGbh
F P�TŮ��Q�0��8i�����r���9h'�(;S���Q�c��{��I�k��6��jD��.��mރ[�x.�T
q)  �9��)S��RD c[� ���m�s����GC�0  x$ �����ś��XOu����:��b�/ "�B��P@["�d�Ǐ{3�L��� .���Q�~} 2l�C��<�������tСg�	�*  ����� ��	D� T �`	���{!5��G[<��w�']�Ϻ�����]�LBhm�ʨ%I��k��O�T�'\�!r��.;K�p�l��"4G��v�^>;)5�5ۆy��'h��������y����.�]7�Dw�L7<�UI�u���yw����H��?�nV{�;��i�;h3�\���mv��P`D_<� @���=	��� �s~��x��8����Վ��jҞk@[T�3���G�oTQUQ�n�" - �`(�4�e+�R���@�/�ѧ
P� 4�\"«��������4��B� ���s��`f�X*Ps@�  (4'>[�775��բ���'�О}�۠m�QG�h%�BŬ%AC�;	)���P�Gd� n���U�-%*I �z�P;
�%Q�(uuE�T��jЀ�$m�.��y�n�̺_��dW	sA�@;��7�m��o�2Ζ�os[�hF;7`��O���W�w�B[؆� ��q�����e�`����٢ٖZ` �+�h�M�w��1�y�5���·��$ժ�߉`y#\٤�<�)8�K\� ��&iQjHV��V_�������mOml�  ��
�z�����u� (�n �7�����!�4� {�ŝ��o�B�c�✯�^�����Lgo���ڨ]������ ��>\�� �Ǧ�����W�m-]2!B��k� C�#cf]Y� Uz���J�Js�^��:3LQ񒌺��Е�e�����&�r8�E.��$���Z!������q�M�// ��� P(�Ո.Z� �z�����3�����|=�hS{'g��G�a0 �@�~=f�7;>(1��- @��g�d���~�^�X��S�*h�5U�3Ƴyj�/j0��r� �7| ���OB��j�SJ�  T@}k���9���U�ͳ�W�_�����Ԡ��[JJ�����;���.{�t)U��J^���V�<�0���"��~�]�=Wu���z�Ko0V�@��WQny���@����G��lofȌ�vWu��8���CҤ�4`���+�[������_\us�4{K[�V�.,:�/�U_���� 6��` @b`h����Y���{v�HP��9����L=b�fr�3ۧ�uZ��%_&f��  *Phd��x�C_1�N�Pp�.� �� �.����q���S*�� R��u�7���W�w�;�=O0 ���N[�sP�#@Ux[� C?@�n��g�#�����;���}��9,��4KPUoW���Ϣy{�E����Z�����.�y�����^d��uu�{��N��qU� 
oČ�ژ�m`@���R$z��k ��
L8�vA+l2yB	WC�j�H�Z�=\-ia`�k�����1�@������*�*X  ��b "�@T��u��^��J����<�p�!�<�}��9�B�{��� �gka��00�*�T	Q	U[(n�����s ۧ�����@�����ƕO<̑ �:-"�z�,�����~�#$� �  �A�Q�@�� @�u<�J}տ�{��h�L��A�7�U�йk��h���K [��Q��l1�Ϻ7� -�O�:-�xj)�\BO+�z���jF9yy�g	o�m�]p�����Z���?�������<ff��ۇGnҁ�B#����s�������y�����r~��� ��l�k�)����N` ����hn1X���na�h�}&* @	��}
�0�5��~3\�[zU���Pg��(���!TM�n���7���iPHh�x� b��NLQ;��k=�mZ��.�>�yj���$^ᴲ)�* ��b��`����hj϶r�i�c����������t�;��\FB��M�������>DI|�_���I�D�}r��>���#GB��aͱ �:?�8?-�]~�����o�������߿Η3��*��"=��`�'�xS��P=CPPo�bQ (_	�@`��Q0}u_�ӫ��� 0�Tmu�lˣl��Z�v� �W��@��P�[���t}�I�4����@�͢	^�Rn� `@��o ��o��}�m�O��3ӷ�����C��������ߞ�yx�A�	��т��y��Bkw����f�����	
ʪ�ڱM�uU�'pN<K��F�/��� U
���� ��l ��h;P��\���{]�,na�6��s�S������wN�,�|�����kǆ4�C.þ{=�j����w�:r,�	��Y/\�}��Ѯ��.���������ߜ�]�@GN�@�3T@n �?��
f�k����@ =H�^�ģ*�f& �P�-�Ü�j�,��mw�]ۍ�ԀF��i����{��w̭�2����sNm�7z��l=���v.��h [��VJ%㾲�d�j�]$q�Xi$��%�` ���*XF�{C�2g]k��أ
`��y���*��ԃ�j�N�-�cӱ���x2�re��,���N����;]r�Q�8��o��~����~=ڜ�Ѻ��ٛ@�J�B����X[c�����q�� �7A�0�7����Mik��@ 0������Sp#�t㔬��ӂQ0�@�RU�����m��LL
�A��c��E���<���`;\����B[viY���n�P ���m�h��u�
�c�qz��! � ��s	�%�����$zT�Y(�a��)1��}���
�sc��?���������8���=���m���g���+����zm��Y//Zs���b!߉�m�K��a­2�R�)�5��Eã`P �'� ZH����ӡ��ꐭl�̩���ne(Jm��_��|��X�D:���� .��]>\�2Q���� @� �;	5��gm�	?��7� D �jĀ��ke�;���2���-���=�> <�|T��("ܣd�<+7N)6�ڑFQ�T*���@�a����Խ�Ϊ,1g��m�Q]�iF�ґD��N�ܤ�,�n~��ҚĠ���+�����x<��+�Wy^>�@n�x9r�(a��17Z�P0��<���P�� ��  @�Z}�E3@��@�Z * �&c�mW �D !D�5���gG��E`A t ))�����r�N띛�S�+ �jAT"�M'��Ø`v\�F�v��j��4Q�1�h T�= ����7�\HҘ(��T �3�Z?e0[���sMq��I\�O��}>���t�+���gX�G�����t���}�� ��MOR���[��l�5�_�_��A�� �P�\�a��  @@��l�r�(�|@P�p���� �@N���P�Z�Tk�bI �oҫ^@ �`W*�'  W�I���p��ueBv�]S"պUT�mw� �=-��5N�Ĵ�'�.	�&�*�p�� ���E@�@U�*������kC����((���]3���#*�~@߄���*��\����l�Fd�48�I���X��n
@�U�z���@! ĥ�+��Ţhj:�鿻_��j��0dQ�c��L�� <���Z�[ X� �硸'dZDA�
�  �BN�|�\d
���f
��A� ��P ��hP�
ww���T{4 �).2�kL䶘ͽ�^/�O���jhW�QS>W�J�G�E)�c �6Z�#X��P
�r�h��,�h�JOA�o��xP�q���ݝz�#����!�\���A0�=��   ��<o���^��:�<���	��r�$�@�� Px>*l>>��*<�c���) �$�7���PTs0��K�\�
k  H�] 2� �x��Ϲ �?��V8���+�o,��&���������g9Kl�f:MX.}(�Ǉ{�����!>nTǋ�s
�6������4��1MuMå��+	Fh�L��.��Io�������^�����  q
P�M@s�ʶ?�ĂF�6\A�t���aL�Ƭ  �6�O<,���_���1Υ/Q0�7�����\ � zmI�a�>볞�
C�sm�E�@Z���._b
��CK��\�C������F�	 ��oQGrM�K=�Ε����Pۺ�& (������B�C����o1�= ��?Q`�ݟ���h� �z���M��ձ��Ԯ�ळ��,Tk�~��1J�k�r�*Y*�:���{��F򎝰7�	��mOӰ��Xf<E��}�����2AQ�ڠyP������T� �XQ}t�oB���i�N{��:�Ug>��_��|�$1&Ì����q�D�E�
�����T���%& ���(`^�s.�giig��uKI����� |ыG��D���	 ���`��D?�����yǫK��Y�
����,�}�/K�W���L��iѸ���9��-c�b�������VK���.�
f6����'a������ �<�[��F�<f��t� ����6 y�zy �)l�c0�����Y`c`h���ϖ/�u_+���b%��xv$ ���З�G@?rU�`h�͍OپR�?�Ɇ�}�z��]ϰ���3A,�4�'H��M۰S�����@󒹂ξ��hZlQ �<̻���eM�n�ޡV�Z���jBUb���$)v�1GpϦ#P����;)�zY7��*.�����0������Z����K��젪�d
.o�(�8	h������^�����!  ��V�QfhnG*mL/��-Wk�"��B���uJ���HF8f�5�焚n�Q����z�h��=�6ݑ��{�K�8�
յ0`�� �BL���4' W'����8?�� ���!�<}G��<�.M&Þ���]�l+;��VT� Q��{��L�QUհ�vB�,��1�"��,��k���ϯ`
���_����������w��6�Q�P��5y�>�K��6FZi#h}}f� �`���:��Q�"���p��2X_�  ��xU������z�(�"z�Gqӣm���� %���/���q�~��ޥ=��V;d��6�I������\�'؅���~�&bY�#a�Z��k/�3���[{חO�2복Dn֨t� ��S���h��vuy^�'f]�d�)����FU��퇸�QɀA��ve��dz^�T���jQ�Qx�׻�����t�m�9wʱW�zԙwTG�!��P{�kWo�xk%^y�/C�nh��&_����E���O�x���g}�_ԁL������!��x*��ܞ#�W���ssY	�����.�@!>�a��������Ak3�mY�޳@v4l�g��·��=�8�un=�e���,>� K�Z:u}"QK?����U���s]^"����"g�%n��R�K�m��^'�x��z����\��9,@���; ���J�JH�}@M���)Ik����A��� B!`0
����$�K���	�@����������v����t����q��~�_~%���*���� W ���aQ�FO��߷�{�D�]�B?���}Ge�b}�Q��h^@ �$D��O�o�ۋ4�?+Ji�-�����^�����w-x-g�V��l A��uP�ҟ�1��	����WkpK�8Y�0cϬ�իJ�5��9��������6MQ������KePUT� ƲY���� WX���: �00�1,�O<p~ί�<a���_���O�À�T� %T� ��	�  �� l��{�����O/7�������Ϙ��_��_��Р�  (�R�͉1�Kc ��$���������.�n������������s�@\�P�;�S ޚd�t~
���������z�D$`�1�1�>o�w�b��;�:��T��D1 �O�3�}���?/y����ת��2��^C�h"i��$R@m�p�����m�@A�h} ���� PK�1ܞoCa�_����}�yZ>U��
"8!Q�a��q�w��`Z��f�p��`[$?\�h�����w�{׿�ʯ�:d|�pm�4��G������܄�CTo�E;�������$�u^��껵�n��9�V���3���I���o{^_��t&$�J�5���hh� 4�o3fd��9���2�������XQd��OYX�t����w�q���r���u�b�۵��3M��Y�h�XѠ� @��m⼫���
2�PwC�[�8�O�e_׺���  ��(ԡ��u���f�S��'*�N�z��j�LM�ݮ� ��ě��D�}S�� �i\tB|���З�� @�����5k�}�� ����՘��/�O��t�{���������}zw�	��Z�+;˭�x�-Nx����>�Z�g����UW��:\mt���'��|��=߫���l� àb����8xh!� ��m�Q�����p�F�/=�@���8Y��ߜ�v �r�}�C��������|��|�?eu2�6Az|�u��� A� ����jBu���t��?N���*��;�!{�W�n���qx��5�������L�Ս&l���ą+ ��2�����mPB;���Vހ���%Fg��]4���5nt����+�  ��A7�7������l��Z~o�7��M7; vАH�_�d+PUlh+a�e������ݜ�G�d�4*��-���;�F� h����J���nCz��w��If��q\���Y�wu�& `�-/������̍�����o��1;�Ү��� �G���}�t�2�A[��k�^�r`j�6Y��^]`F�I��Ϸ&���ء��� ,bL�6oɬ6`%�n$�Ī-P\๟��{�ӏ�q��:�wG���>{���@�B��� `��<�j�(�l����_��Slg5���L�����شY�6�� hD�dkנ��y�8�Jt�9w�.7~���T�ΰ9����� h ��S���9h���~i�cxV[�[�2�AG��B�y�w�fVP �s݁���92���fy�U�K� -�k�G���D�� =@BP���ɼ���mS�tL��������(���kLN���`�G�v?�ͧ?>��}O�-��'���g  ���� E�x��:�+b'cޯ����ˇy�R�*i�ZPV�\# ̹���f ��(`$���S�/��I�X����E_X-YHH ���D�[�]�������3,V��֘�B�3g�:��孏�*j����x����V��s��<��n��tSFf�� ��*w���DS�@�*>Ճ~\�kf>�	؎u� q=�Ai` @�č�t)rb��/�~r����G��L���C����8�r�PK��Dh������ƴ�qQ�5�*�@a��T"05�D �ā�7�_����ߏ�$FϡT9�ʈN������� ,p���tps=��n�S�XӞx��U3�#��r�j�N@M�����n�$�����GU"����nIZ"� {\Dv��2�Fb�^JLјj����� �[��� [���5`�G�������՟�O�>�o�t�� (#!Q�/W�u*P Pk`P.��Ǎ�!��iz�|���R�c�6jF��L�֍� R�,x��q�Anw���8���v�-L<�� �S�^�JQ ��.�ɻRVzr�
d[���$
B��tHI,y՝�6����5r߾��蔻O=�����F؅!��l��}�
)h�lID��Ge�L$o��  1�h�  @�іn+�B���Kl�C~�O�7~]?wO�����,=g(��~Y�s)���N��>t�v�r�����s���v�v�;���fs`�8�4������Mo�߯&��0n��Za��l�[�� ��G{����c�^s�6��P�cd��h�`��c �BL�G�ﾾů�Ɵ���-�-.q�j��<
f�ݙ��[��촰���/�Z�xf�A_�j��fڐ�R u��'�} TA+ X� ��O�0@������ާ�WnX��14�|�9���?'�i�N��k����A 51�O1�\��]�c��{��F��FuWl=i%�w�|�������3n���̌����_b�Fڣ�p�\k�л�tM"���U^�S.�Q�"�i�(`(|;@Fn�Ѥ1	Z `�v�����߻�>s�+��y�q�B�py�#Wndd&��Y�-�'^9�B,^
�:���iUKEZ�s��� P� ��J|↜��rR�Z�6!Ǹ���_��@@� �>��01�KG�=Y�64�Bn����x��d��SgIQ �1�H��.�B��<=��v�M,  �/�
�����cS��LN��s���K���bG�V��j��q��FKA�>�	���u�}�Z�7�{�q3V<��W���JqoAk�_U���[���i���� �p]�(�"���O�Ű�D� �(�QXߍ�� vB �  `�M��@���5Ќk�����.\� 5��F��ίwzGqT mU�3P���ؘ��8�g	�T@*U��U�B��X?}��ӓ�����~��mS&��z�]L,�G�b1��WhA`����w^^��jA|ֹ�o�V{ ĝʚ����s~�Eڇ(E��;���~5�����.� �'|����L$���`����5S��e5� Ш�Qf�Qg�V@  ��}�0P�����@ ���'�k�9ȏ����bh �C�oC�t8��kk���~�]d'ԁ�7�@�-A@bk��@�O�3�?�~R�u���r�F ��֕�"��w�V��Md�Q�~vp� �xq���JcͨqG<`��}5ُ�ۢ�,
0t��'s�ko�m���uR�W���L�k��ueP_˗"k٪J �Z�X;�G-��~N P u ��'�]*��v��Q�|����D�"G�_��yz�X�O���Ի��{'�n9v?z�������lm؟�wO��y��J���h��,@`x��N��Q�jͨ���[-�AX�O6YrU��p��
ʨV�>�}k�xp�Oj��s\Ֆ�vd��� (�4H�-f��c��>L�p���5� D��p��F;K4+��ƻ:-�x>���
P ��JC�.�x�x�[ t��B~cm
 aN`Gq������&Q��{%��(ۤ�,���-T����*�,�����u�e��_�U��쳅d`�j�Y�'0��ĪD�ϧ/�@кX~��s��N@� ���%��m��ޟ��5Ih\�����1���4�F�݇n=���"�7D� �z$J h T�Q�3ȳ� ۛn���< @�� 
��r�Ǔ�D�K^.�^" ;���U���]'썗���Ts�o����m� �-a����폴;�L2�  N�_�L��Pj+Zq"�c����r�>u�e��T'�b	�S�-@ P�� ���{�W*�|���g�w�$/ ���5\O�я%e~L'���G� ܺE�$`Y��@h�����+���_V��_#���jLUN�m��3�l�����-�ϧ hH  �p�L�<q����r�����˓>��ZC5��!�ƌDAҤ��	�����#[{$�G(M��u����h��0�8��G-���0 �HU�����}���K�Q'��l0K�KU8�0 �y �B�"��ݍ2E�7�����]��+�����D;s�q/�ŐSR�Ǩ��,޿V<���S���;|~�]�a|w~�O���dFh� ��
�L�5�̘?Ο��66���×)$������^#̱�V��y����Un�Eo��;���|�`�=� ��@���Z��tK� ��� �
 T%���}�x�~�ӭ��/lm�h��� �� ��5�`?ɢDX=-���T �:�z�	Ng&����u�~Z��4��{]�~` �H�R���A ?�+�/nW�Zb:�f�^ԋ	 ���p\�ƈ����'Y�O|�O�?_�c��6T���u��}�=�q�s-�' �P�H�̜yKo�>�?��|�x.���:d�e���U�Q;��7�����5�-x <h��x�iA h�,��{��L 0�Fd��=�mx?�w}�z(�?B;7��S�o��ǥy��}�|MV}�>!@,d
��v0�4B�n�p0�h�=�N�c(��hZZX�<tM}|A{�N�R�VyzQ*�0��e�>� �Z[գ�'�\�X�Z��Z״�*� l�����]���Bp�]^�Ԋ���Q�x������P�  ҅� �]|H�5���f~�����w�F�
  [QQ@x9��`];��($�M.2���>h]naƬ�˘�  1��T��n�mk�jC �ĺ�`�P�Jl@ >x��U绣T���A~��	��? n�G����BiML>i��!N}Z�ӣ"H����[�:��t�hS���Ձȵ+_Р\
5_0�@ �   �LmE�TX��]�b` ���睍
�(̩G\-�i1���}V
v6uwiJ&Ţ W����fS�oT��?�``N��B� �@/���� k �+[���2N(��R��� |��7����d�؄�f��z,��̙����L�B��
�Xl� 8{q#� XDjK�T�=��m�/��?@�ͨ[�=k�F���U?u�I�e@��욛O٫�1�Ψ=s)�HI�>a�>�U��jv=�����}�����x�K� tB��9��*]q?��^�}���I�  �����I��ν��5B�Z�plTE+��$o7L�M��[�P���7C���۩$6-�q�]�  � +�y��O&�.	  
2���.40^I@H��~3�5��DbG��U
��
���ش�֑+'=Z�Ћ]g�ڶ�9�49���
���Vu=�����0���"�)����� = �&�wK��}*��O�E���'���d�Z��㉿@k&A������=�pp>.gS�b>�{�������.�&��1S��-�V�8 �+Z�- ��R  � .ƒ1�we�A-�1�=� �[���eC�����p���hb��@���&ɺkm���w�YD{N�ƕ(�- �r 켆��:�t@4  �����Ð�f���{�A���xPE���hOE=��tzV��ۼ� ^��
��9�@�6�Y����^��]�Œ ��D �vC\�x��ך�<W�5t�I�9��猪��^숏�rK�N�߻|7W��C�<Ѝ2n �C�̍��:�`����~ʞ}j����sW�u�o�O��S���?�Q��[�W��N���A��!��LĠ <zT-��6�E���RU��|�. �MP;f�g�x����:�
�D����ESn�Fk`��F4|�7�����y�Y�Nx���A]� ��������d�# �T��O��C�ƦWMlqo�ī��FM�̜������D�����>���v��	B,A5�G���j�P�L��=N�e����MyAD�-Τ3�S$x��Ԇ�m����\n/��1�4�͕��.�2�޾s���j^Ԣ�f��b�-@�����\�}Ƴ]����'��R��Nw�gW��Vw ���.���}�*�QhW]��'
� �Dk	` $��d-r��&��'w��e���? ��<d�xc7������LJ}x�J���+Z��b�&K�"�ֹ���Ʉ��~� ��i1 �"s�Ѹ�^`����x/?�5\������]�,o�q'�- F��[ҥS�s��u=Αr^\8���Wr������C���Uر���  �`���yVl��+��u�S�e�~ϕH�(��&�6��׺�uW����O.���_�o������OuW��x��Ȭs���|���N���~�,F��:������v�\�UM���Q2��#w_�˒��F��!P P�� �  N�=���e9>$� 
�_����|Ee�f�s� ��@@1(�`��� L�/ǲX ���.0�Ʈ���Y�+`� ssܬ�3��H �,� ��`��+7ə���v3�	n��XǼ�f]�n�E��[{��'�-��:�Y#I��6��l��E����v�8d{���O����k^2��h��P�jH�b�>��zߜ���gf`��ƨ��۔��9���6z��(t��r{aK��S���w�\�3���ϵގ�[R Du���������h;W	�P��f��2#`� Ѫ�Ė$���>������8�����A B �:��6�t
6�/��i�F�l������t隀m�T`++T�u��/���x�J�p�no�{��r-k��?fLVn6��� ��t�\a�W�
fY�aq0 �s�������~�{�-�qM\�Nn�B ���� +Fs�|o��� }��15&x����j0p� 2���.}�މ�	,Ye�=�_���HwuH����U�v�F��/D�'����"i۩B�l�]�����/�������}7�J�#t��L �Lj^޷���T]+�*�>��QN��7;�˚y@�zP�G(����.0w�����?~r�_�-���S �fj��2z���3m,��r��k�C3;�
PU+�!�^( 4 ������Zw���$)�R���15;���Z��b�`Ȫ`  �]��t�2pWf�r�4@�"@�	Q�yHi3T��M3 &��3~>>W?�Մ�  _5��;��<��N�_=%�H�U6�M����+݈�"D��t��(=��0ר.����C�^nY�}[%��s������ӁS������?}��Pћ3�JF��[�@�i�@�L2���wN��s}��m��M�-C�8�kr��5���=@؇ ��mv�[?����c[g��@�Zs��0$	 	��a�,rQ�aՖ��=\�R&�۟� 4�(0������n�=/��g���]������"��}��[�;�m#��Q�鿷! 0j��$��DG/���h@h��H�W�\����7?��w��U=�e�PE��
V �/KǠs��:���kߢ��զp[�9
J��w�^j��@KS�QO=�b�S�؍�����_Pb������pŸ3*+_�0�r�ެ�?�T��������o���t3�b3�-6���@!�y��u��{xm^�'}���ލ�p�Z�_\�]�Rõ���Rz ��qҘ�n�3����K�*B�  ����{0cջe���m��� ����J�c.����w\�>��f-���~R��$�$0�PԁbmU� ��,��ul   �������osD��L����+*h��>�}���'��hL��,�����}�ü�/%c
�� ���CЋ��e������.��&�_~mtІ�j<�tû�.�M�qy�!����ߧ���A0�����z�q�7��j�P�΃�JL���=����?�%��\}�Z!L����@7�x��}�G��q<���^�^w|�l[|�W�=�>�O ���p��Sz����,�9�h�2���S�c��|  �: p5�Mp�5cۍ]�N�@�M'\{�VT� 
��-  l*�A����4U��WX�a�}���l�Q龜�oy׺�ϊv�P4�����4 �@
�1	 ����v���t�f``S��G�G��4 3��ϔ[��2��)���L����]�����:&�zh�P! ꫠE�@��mm�mf�ۓG`�@e�A�v��b����?to��sm��p]�{|�ա�H͍���r�vD��e�Pb��引��NsH��þ���B�v��Vz� �	� �~b��γ���9����ݼؔ�~���b5��N�|��}�L+DU���`�=Z/���t���ǎ�Y�j�V�J �(��O�퍖 ��d�x`A�ѩ-�
A �T 
�7�j�������̦�@@z�)�e��	�6_�k���y�(J['��%�QA� 0 A���^��e���	��$;[�t{��%-���w�;��o��Qۺ������;t\G��(?��l�ߏ+#�P�d
�S ��A �D_��9 hǐ$��{R�[�p�k%~�#��*��~������x�3��t�J��Yn�?m�R=�ԛsx2�_�/�9d�JFh�.��%	��]��x�)}�͔���y'L��G����栴˱�8�x��8��4 �*�a`,� �N�A<(����� ̹��W��M%�k��}"��0 1V��G���.���O2���(�x�  ��  ۛщA 4q��_�w��1�\
$6��;^�=����|Stα� -��V;�p	 A��_��D<0���O�3���lϐ�?��z~{v��o~���]������3�O�g������A#V�-���z�\[SI ���3����
2�pSײ]m�����A�h���zA���v���f�������:�c�5�Ig��=I:Fh$;nuǃ�G�ϧf��"�u�M3�P���jn7���Xh/�.-�� �	�����H�Wl�`;R��e_q �h>A�mi-	m����� ��C�} Sة�ӌs��6J)�ټ�	�E'��f߸ɲ�.&�U���'��G �F)`���BNŶUâ��w�Z =�%l��.truлP��ۛ*?�F雇�j)��H��ry"��
7S��E [@T�e�Y�>�:zZ�iQ� ��>x����K���[�W�����L����߷�t>���~��6=��d~���ܣw9�o"����OΟ��ĎWh:�0QU:7�dHC � �͟ą�`Ci���ĸ�ڥwWoML���qb�f7���J��-xUceP� rܯa]Zk��x����o��~�=�<�U��r����;�q
￼o�?��z�9��oKa�ѾLF��kZ
@_-��@�籯���D�s���=O����}���<s��d��D�G�+}Û�[���{-��M�����1��� gx�u����~^�����j����P  �L��������r�ޙ.)��{u�/,� �ju���"�`;}Ns��qU��w~�����{�o[�C@CҲ�4�i?��v�����9~��f,ko��/��S��`9Iw����J�x5(�@_S��~}��5=(��� �� i�r-Č�ߺ���p�_��í�x����g�v����Ek��!C� �h/�k1C���8����~����d�\�?��w����j����c?�r�J܀Z���2'����V�:�5��x�2��. � ���x�AQ��
Do ��v���Ȭ�wf��~N������w�WM�iPk�� *�Q`dk<�Ͳ�0G @��?��G��:m��~ڶ;����7�a��n[U3]bve�X��5g��|���#/h��o�؟?>xʧ^��3� ���h �����h4�ƶ#�v�����k��tN.g��븡!��^��kFe�_r�Y+� `�<gI3
�h�� S�].m��h��)�
@	��'��C�R��%6&%�.��<�^b�8T����MT�

^1[@U �熯�^�d`h�`�����囙od�͚�I3�Y�q��Iv�Z ��w�ײ�R��"�I���������~ju�=���\�S��)�����d�
A������Yq,��; �C�J2�ns{v��o���������W����L`0 �vi��G6�,�G�*��v�f�-�u=R���τ�����E6HU-�uȠ�M��Ɵ��G�eC� @��� *Ϟ��  [%١/�u,�~{w�n9��=�ɷ�s���Gp�j\Ԇm��H�PJ��x�
F��H��NL]��N��x��sj(���5�)\�I�r����ߖ	��)[�c 0�B�憗��r1���� d��7�D�g� J�P @b�U@��m��ٺ�qu�5P�F���m��E5 @�%��ot�����Y尿��� ��:�7� 8C�� AC�k�&���S��AP��s=jF�iX�Pq=��)���� `�
�`���
�a�v�#���Z���翞o��G�����<�yʮН	�h璞��]*@K|��j��m�ֽ�е�en��{{|��;���n|c����~6(�j@�bz��X��V���g�F��` ��=P��f���X�m�_�m+c[���0�����އ���e���_gٗ��AX� _�_n`�E����*�뉂}�
���������,�pB�6��3{�AMk�i  �/  4P�_����ĤӞy��IΛ�
� A X_T$��&�Ss�.7�k��	`a��/:|n^NBo�x���^p��g)��Ev]����j�����I6��V��M=h�G���|޲a��PH��~  �T  ������F|Ƿ߾����}ubI�gL��� �*HT�Y� Ǜ�kP<����$���� �y`
Z ���2K �g�Ej�(��)���F��i>Y������iz2���n��������鱂We�j;�j��� ��`,�*T�#`�]OpP��������͞^L�f����T���Lr��.�����!qv���� ����LG�{V��I!��J�|"��@D5`�S����� `��s� ��@m�{�G�-y�+$؇��`� ��Qj���͖��>��P���-_?��6�b�]i��E��ie��kj�W���(�OӃ2�榷@(�hO��������_�?��u��)H:][Ұ�O�` J��6Ɔ�1��:��~��v��&�(�>7\q�G@��HQ����������~C��^�]$��1,����������ϗT�yH��� �" �$��  a��V- `㑨 @! B��#��*f���0�-�\��������EcT&q�d ��z�q��~��%e�H��~�Z�p�	.|���b*ϛ�R��Vi����~�6R�hw��i8���}L�k^TM)�4 ��
��Ā	
 � 0�jA��tw��U�94�v�O�0l� 
@���y9�=�5�[_ׯ�5C��q���/�-� 1 �.����ZL&]��V���c$ �Z*�6*��A0?ػ���'
����x	���Fz��S���1J�=�G{
4������!  ��-��D��� ��¿���>�Z ���	`pR7�����ji�k�Qێ@}&�d�̋���p�}�]4������o:��;��= ����
� ȧ�p� �ѨUh�x�:uN%,�ns 
���P��~��­CB�ܢۿI3`w� h��$:� �(��!�ͳ��i@�}[�{S�a �9ݫV[��iA�O)��N-=T�y���wt����v鍊&�K_��a���� �����Y��-�3��C�m�"�A�� Tl_LK!���lu����2��X�[~Vk���_��l�u� �5�1�[�^U,Ѣ	�z [Y��`@�� ̓�������EҘ L�F �D���~�� zh1h�d�F�;n��C���T ��r�_�3��T�bΏEƼ.�޲��@�5@g[
h3�O!h����x!���l�ܐ�e �T?)�#6���M���M�
��TO @� P:{,Be��s7S�ڽv�9��.9�l�= 1q�i\!D�}\NVIkXA��Ɏβ��ѯ���o��;��L�[����]������ � ��� ���$�t���w\S� M `���Jة��*G�q��W���
S��F�����`����n��C�_g��C=7��[C�������Hj�K` �Chk  ���ݡ� k�� ^����Sl�"���-�������	���Lc�=�-#���w��h����w�[:�q5  ��nنv�r�S���1��R�
�پ���~�>�e��P !�	�^)�ge]{w44�P�̿6��$�=;8�E ���{�B �k�� �UZs�U:�.�,�@,��A �
D"�+ x<��b��δ��'��L:���s|�E���t�v���lr�Gy�������4'�R�L�#�3� �ٸ 
� P(�@= B��p��22�X� A ����Nv�%ecս�9���.$����� n��O�ǱO~���(�֌�g��iK� T7_�Ǘ�}�k���À��)�H�2�|1���븊�X�p0���CW�F��~U�޾犯��/���?����;�%�d]�M�-(,�B0�Z�%㠾B���K5>dq�s�N����>ׯ,�9��4;8 ������L���u��(�2��X�W�P���p�Sċ7\�����TmoC	��MT� ��ƍ샃5�a�B3C��l��F�"Kr]�a��_��',[/�`)�2������B=BTftH����mi	5{lw�P�����@��F�,�1I�Lv�#	���l��G �`�O��9����V��+t��)D��<�* �M{�9@�����O!�[�����w���0'����G�������6#�Jz8b�X[����̰�`��@u hRԛ�Ӯ{]7��1�~��g>9|�<z�{j^�z�vbÆ�0  Z�M>���O���ߎF��%\���ysim�n���	v� �%�����	�p{幱������yO=�'?@��"`	 ��m�hrJ��L3E�4.0��u�6̦g�w��ki�J4�����z>j�}��"16.���2bԚ  ࣇNi� �!`@�T�l�;w�[ڂ6�z��
���nғ)�'?�,�t>#��B��� �H(  �  "R"��]p1
/ ��V)�3�,.���*6�6��q�(���p��e��[ǣ.6���cvm���$g=�io$�Hb �#1ĒJ�������g�3>_33�xe\�4��z;�Z 0�$�\��断6�O{��r�	�x�N�6;h��`��ȹ����C��g[���'ЫA9V;�(�B�� �}    $ 
 �d�F �]}((������>L�r�ִ���f�ʢ�!L�a�+���5�k�/�K�}���>`�Mm��E���	h5��h,u���&vg^���*� u�q����j�� nb�b����z�K�e�>5K9�Y��S@� ��������.
��?�S�ъ���� I2�z��c	S's2��ntu��SI��J�О1o�x)`%�z$������|������v�N:���� �����S������)�+� �����BҎڔZ�xeH�q�~�:K8��A`��{�> ������
�F�k�i~P
@�Z�'  [����}ބz
��Q67n\ >��$چ������3X���z`��A����:џ/(�  [��YPU�,{G����Ѥ'gx������aY��Ķ=��2���9���-�.$=�$f�NH��ߠ a�-�������d��P��=�7�T7�1��]��,����������X�YwRt$Ics��S�V6�
�G�ݱ���ju����{�MC�c%�{�Yn��������l<1��M�4�3��`S�C���I�]y7N��X���I�/
~�� $v�	>AP؉ܝ}�dѕX�� ��O�S �Oգu��|  �(% ���w���0�|�2��¹��)�V�x,-8�p��]���"�M��YL4�E�9(�>���� `)@E�Bt���R�e�E.�R6��Qk((��2�����w��z����|�-���L�䰊�^�e� x� C��  ���p���w���4�X��RcK*�sF��j �<�%�R��W�?��7K��c�i�#$�U�]�G&��W���}+$�gOп�{�Ku� .E&��Ѓj�Oց�1���n�񼭤: 
�%����~�4��0*($&����	p}�ȴ�����:�4MW���`ÞL�SF;[��A��l?�(/�	��_�k����/��< ��7n ��4 ��#ſ���#�Vi�9�xA������4(|� p���d���=谸�
%�d�N���h��(NLgwi����
*�VP "h� �$��D xVe���4Eu-�0��P���iԅ^�� A�5v�ֿ6���E%��BU v2�agx2�Zwx��ޘ-��W�r雟��-�h��VT�H}�a J_lR  �'EG�j8~;�3[;�W���Ѵ��e��2�9�}�ݛ��]Z-'=��i<�ۅd��v��
|.��#��o��ͷ>�`�x�Y�f�ݼ+f���we�o(P E	��>�:����(��7�C�=�T?q~���y�18 ��dI;=�Ꝃ�� �0dP���&�M�M	@�OPp;-����]<���{z�E���w������ōz�ַ�������0����(���;����ߔ�� �� ��V�-�p�z��ZG@�h��}��kl�-����q���3m�O-�g�S P_í�<�@��T��e����f*+���� �L�{+B� ӭ���2t��0�%�E��k����;==�d������v� i[�9Py��Ջgܧ�ӿ��s��<Э�Z
jXt�޷�������?�e�>i�s���r�>�G?(7u �sZ ��r�x��E�QA����G�/���4���]<�i�XO�����w���Ei-_|���s���y-��]���$�zw��Ȃ|o��7�S,C�:����ng�|�{�sc~[/M�o�|����o� �. t��@�vw0�z3�r�۲ �f��+KF��g��&��U{0�T�m:M7LGl/_�����#Qn~��m��������A>�n�@�� ��H�d���:�?�텰��z�͈ ���;���|K��������ӌS���_����ID wL\���w��]>�����H�=|M_��{\��,��r���t��x�p����8�  u��|?{����vQ�1ݴ��E  9@闄�ֽ�>2@ <���YF�ڠ� �gB��Ȟg�\8;��\
?@{@���^=o����v�idu���`�M��_����_�%Wdw �����[��[B��l@��Р�Dgy��|K���������7� _؋� �m��mPc�����Ae�5N�� T��1����G��̝��D�jsz���3a��+V��5���?��2ʖ��t���z�:l��(�x�E��~S�����L����WBs��2Q��~? @}��7{o_;����:�x��g	L@�l��ַcs��~K��3m_Y��_}������z��8�3ý\���G�c��m[U���fZ���!����'�W�O�N�]�h��eq���v�N�Ě��f��7ޢDC��?���xw={>"5��P��?�O|��\�(F]~���U�C��u�����wJ (�o%ڇ�>m����Z�@�Γ�������.������|��^�X\)q�����)��$@������R�J	�nw*�p��Y]w����^�_��tro�e��7����C9�<�9?�����o|�]�q�U�A9�d�_��p� 6�������AOA�;ܛ��~5DL����̫ў-�^�S��f �K���x�(lɜ����8������s��)� � ܝ!�����O�������8�O�@0��9�|��B�ҩ*(U
( h��W��
�= (@!0+ B�B�S1�� oZqq���!
 l�����:O8�.:X �3�)�g���M?7��rv����
ܼ��� � �7�M� `�-}Q�"j�gu�]�`ٖ||_$�gb*h�	���g�1l�ɥ9�_�m�]O�$LP���4�G�(�W�7'MbэI:(�Co;�	;�7�8\�k�l�RV5$JZ����q�  ���i���(�p��+����~oϹԩ�hv\����Bj���ԴJK�
�Z�������i���X/��L~�]l�|���/�_9������B�cg 4gG��>����7��q^0.��k���0H�-D��h�Ս:�E� �
  �� PZ�Ƹo%��YhyfB�A�zBE�c�=��I�]G�&S`�{�#���γx�|tQ��2�x�roC��H�>�� >
P[�.@�'�.��AD�Db3'1�*����n�����34�z�]���<]��ö�?�J��"���n*)Sh��`]�pcSMho6�FQ|���;�[z#Y��lr�]8p#H�z�zf�����sR�u|ԇ|��y���᦯�7ו$���m(��6����M��c4';�sb�o�5L���|tlOm��F�j��rͅӎO��#�/���/�_��|6�n@`7BqB (/��X�kR��Eq%��i��< �  ��/���*�������B�������
 �,��7`'����G���h  |s�¯��o5JQݧ�;ݒ�X�MDv�Ȫ \��MA�o<[�	����y`4E��H���b�s�T���!���5�J0w�sִr�^5�TJ@���b�`
A�fD0�b�vS(����͵��05���@7�����������QD�z��_ǳ�������~����f�n��K&�%���=��B����i��
c)}s�%�Q;M�����p�F�E8w�o�p���u^'w���+8̗˼4�Ph9�a����� k��:(  �76��w����k$D*� �/�G l� � ��-T�v  ,�k��n~Q ����}�L[�p���L��$~�D��{OkB�٣L)�� \[��(]*Ԏ�K�߳�y��"��m�m����p���E�k���x<��z���:��f(�-R]\/�B=0�Q�iUrm�(�6�ة��E���]��}n؃i��NƂ.�7�]�%;L3��St�����6�;'��e=_�b�ݾF�T� ��wcF�� �%���Wp�)�}é3Z��`��@����xz���}w"�}�i��r�u���#���v�����r&�r�864 ��L������7�~���W����o���A��0[�[�j� � N�E����~5���w�dZ���+d�y�7?�h� -7��>�-A�<Z�ġuڋDKe׽��_�Q���m�\������	��}8��4[?�&�Es�m:NE��,��*��&N:t9�[����0�V�L����v�e��-�;4�ț�����)'���|��MB��xpw ��ru=z��x��-߷p;�%�F��mߎ:3ƈ.�e����^�J�{D�Q3�g�������D��� |ֿ��(��f}�2����|  �Q��YK�M�x��K䤝�)��ԧ��?�,�~���;~����: =Z^:��k@@�V*����x[+h � �}�.c��p�Evm�m��"����@�}���Z��b�F���E77�2�2�ۢ�e��2Y��Y^~���ݏ�z��l�;��j��u9�y���ߦ��~��߾��)s{���d��C<�G]�
Ea���E�ZC�Vt6��$���Y�p����\?vf�hݬ(WE�B�u�h��þ�-���mⲄ�����~����yo������lpQx�C�H�ۚ�ݸ��o�WD� 2" �V�<�ܙHD��Р ���a���K����h �jc�:j�@ XR	�� �<��+x�ŎR`�eW&q�v�)�2�9���;�߻�}�����ƺ�A�=��k5��P�Ц`���J�(V��,���F`x�f��4'9A׾O��Z?�F�g�}n��F65�������+���W������>F;j���Q]A���-~����q�M|��<����Ph<J�eQO�eO��:oQw՝|��k�P)d؆�����u��,|o��� @O[ c��n�Մ�����p%reэnt3�$��@� @�3�c* (@�]Dz�^�	c�oZBU  ;h�� BЬ�0� ;P���(  @PP�6E' d��r��a���������
���� <" �K>����V��b�	;Th|����Tm��Y�шk.�@��s����- ��g��]!�ҳ5�V�\L������]L�.�#9�"� X4��|�������N��7���0g� (�(�G�����q/��^�]�{�f�a����5��b��W��	SO�(�C�R�-�Q�f����c��g��+�OU�0b���P�ruՍ6T�:[[�_��@�*H� ���R$.-�K9��/����)W��;  *�  ���>�7<�����f|,��d��Sߌ�
��i��)�� ��* LM�@u2F]�`�Wt�r��to%$n����|ا��} �;Yl�FAB��`�����j�?W����9�H�
�x�� E��a�l3|md\�4�I�Q��Y�jr�K�Os�Im�ӌ�;�����F�ui����#���r?U. ҆�A�^E���N].M-�� ���6-����7*�ڞO)=��2�J��h @��{h/�+�p[��O�x�1�
�����<_���Ǐ��Ǽ	�� h�>��G�_P���T��l�Ӆ	
�ƍn�jo��2�@��[�:  ��H�°�(t��i��Z�7y�I�a���f�I����.  �+KD��+�in�1�*�+o���g��R��O��H����r8�I=x	�[ 3t�R2z�4hЊ�P�Qj�`,t�SY��;g��O�C,�B 2S�x�>�d-�K�  ��G n�CU~m�k��"B�!��~5�?��P 6H�� ��@���� ��ygV�̸Yn�w�?��ɏ����``�%� @;  _b���d�4��1ق�k��,2gV�к��L��� ��dm	��z����Rj���|uHS.���� ��G�:1(�ҡ.����a���4��ڜ�j�JE�j1D��d[�$a
�Nz=����y⿳J�6.T�ꅣi}pP�~�(���}|D/rQ3����1�P��Q��z���R�m�[�M���7 ��	�:�&����N���Ϡ���= �=O� `���ݴ����?  �,�c\�H3�3���>�����.ߗ��b�p -�R b�5x�
iWulq�
[���]_��`��:F@@}���(0������ =\llĆMD�|���'3u}��e<�P�'�~J��}$Z<��()RT�Ȩ}}��C��M� ��}���+۩�"�ՙV"�M��0b����W��o-J�� @�~pи���70�a [���P���#���4�vY����Ȟ=��3- @�,�8��gK�  �V�Uoq޴�x!�+�&�Z�:� ԛ�X	@E<���moi�� Ot�D* �BA� P��A -���t��]�#F���[��������=y~nw�� �a`��͗t�Ց�8hܙ�#��񓳅u�˙[�{q����]����x`�
 .��~��z ���ͦ��P��.{��O�z�����V[�PC�4P6�U��-�ǩ+�E�� �S���c�<.�O�s+X��ӽ�"VN^Hq� �{ &�!fxXK �H燣��,�=�M@�g�lচޚ\W�:���ꀷ�.��J�l���'x��` *�D���N�����Aw�*�T�Ң�� `c��+���Zu����;��)�E7�!U���csj�֫���H��XU����,}� +��P{���������8N�WWB� �G�.?s��w������On��%����A��@K������}:|����0�n�;��d�9�]����'����m�_�g>�*�R���0�B\��%�Z�§^�}��	f��]�B����#���㧳�l�������A|���N�����z�cԙߡ�tc��������\�GT{�Kh�����8����7�9��~ō�שe�D�l���y������[� ���YO���ߦ;���/C��6T�~[Jʭ7P�: ܶ^з�/f LG�f��� m����P�m0���?>o��}
�!�.� �#(��75�
�N\;�����<|��v� Ѭ�TKT�K#6EL��������5
b\S ��֊`	ɬ`��� 
�+S�����hB�(��Q�0��@Zs6��Q)9Tz  ��J\w��{1�|nz���� ��d��� `��������;�L�i͊��j�q������fq�N�瘏_:f���ސ8�ڥ������MG���r=`�5�%��=FAAH���t���zDl � � �D���H]4]���P%�x�ar�g1���o�Rzz����X�f�{msط�5N�toٜ���c}�{S����"�yA�����  - h� �����x���  ��ۨ;�ڧ��} >�
}�j�����#�U(CG����k�v  X�`��#:V:�nm� =? �:��_����"�����E�6Ef� ci����i �,�2�O�@\�X;�7���q&���;�@P�b���` \l�|�d_�����6
�;[�O��	-��yZ(=�}-�r��a� c�Q@��!�փ0 Z<jA��zW���R���v�acE7ȶ;5�������B�� � (�],�M���$VC6��T�4���jA����GUh�|�������x�t�?������� �L@�j" �/�w��-T)�G���9mP�!��!"t��S$�0�![���:������弸辥1�����{��Ԗ����c-�e�lt���;��MW.��? ��yTb�B�LA ( \�*|��}�I��$��LFL��G[���2:�=
X����?��w�7!Q�0`B��M�J޲ii���㹭ą�>	��2�Y� [ ��^�KL�J���E�^�\�����ω��g�c2A�=[@U���� ���� �����د��������ovw(�C,�Ps{g i  �Uxyݛ� sVhi�Z<e�'��&v@�R���A�)�9ϩ ��� �ň�Z@�D�X���"l�D��\��� ��h��]�<m���.(-���q�"j��<�`��NM�Դ�a��P �Z�� Z �����y
��� C�����^6�d�i|�9�M�̈́���@!bGvt�}�PM�4K�bf�������=p�dX�N���8��?�qb�ٗd�e+����+�l�l�*���������訖@	`�3L�dj ��^\�1�  �Ā @4 ��Y���6^��ؕw�;u��٩.!l{�L/>h��`o'��)  �9[�6XqBq�s�N(�������\����_?[�(� r* j�ҀUQ�Z��1@��= *Wn��񹧝??w��r?S@�t���ܨx 
��(��a{B��0RV�: �	��j�4���yt�2��.��v31�����̤����/[��3O�a[-������fh��:����B��m�h֡$�VD�0�f��M���p���EPz���/WC�d�:��e��lh$�<0���p�B� P��i� 8+�� @��F1:R ���fi�w��r��H���O�-a���Q��=u��) ��-P:��&���wS3	�7�r(��Q=�@w�p=T@�jQ�B��5���0�J�������<9=�??�����M�Ѹ ��e���(P	x�z��aN0����|�m,0h6͡J����Ȫ=��ҍ�7���%@�W���C.X��B:hQJr��iz��4�`�V+t٠�"R���@�:�!�0UzECBA4g���ٞ� ��������@ZԲa���l����ԫ�F
��! �H�hc�؁i:Xt*4� �Z�&0EK'����&��`{�厹[m�	���<Gfk��=�L�O�  "t�w����h�%O��s��t�<�@<���lqm� �T-�z�`�4,i�DJ�yY?=>ݞ����7��O��٩Z �%��iD:���
��݀C��3�A픏�?�?�
�x�Ffϣە������u�P�s�t��eu�t�Ѿ}v*�]���t'��v��u"��8�u�ywbp�6I �x�J���s'�	0.p�-�שLU�{̥{�\a���  
��};DI   � :Wb�D  A�\���2CK�` n��$8�B�h��� Q���@fҬGeg@��9&y�Hc��8��3��a���g�+^�rJ,��M\.�����5�rA��sD�2P@�'�>�zb�Er
�u �1��|@�BC�  ���Z��p���O����Z��G:� �T7Sa�G��c�K�� |��s�ސ���X�zPu�k�aΡ�\2OA��)�B9賯ZDq!�X����
��Ｓ��I����N|)C�K����~���YƆ��-�ܡ^�o��:���RNW`�����op)��t�|�{_Q�"�Nf��{�Ŷw����B9ŋx�aj�&7�=�.��߲�լ��m�gKz��U��6��	�-t���bɣ�^}$Gx2[��9Lp`�����6�+��vʂܯ;��ݠ, �#��O��� �²H7a�&F��QUp�}2��;O�3]S��f7U��[�V9i��E2MӺx1�C�2P���ηw��w��y�T(�:�	�'�2�!��E*��f�8�����]�/�h ������`�V򍸠h}�#]�ן���9�u'7�C}�E����- ��P8�G�����;��"�p�����dgaNR��7'6'�O���<��7�x3 �9�w� l�	�i��4�� $S�9��)�n���=v�ێ:;�(�c���Gs�&�p'����~�̋YbL�����|�77�#Spn���um���`w�T����E�YY%MӷҮ�+	x& ��NnЀ�'��^�3C3: V  �h�!��)F�E,� HTXh}д[��v"a�*yӧF�R��0�B%c������3[�������Zހ"P,�Z`���2�=�/��<��͇�� ��]ئ��%���.�) (���G6�����G3�i�v�� .>d@��O̞���;%��|��6��_���R�J3i�.,\�Uɗ���bDB$���0�8C�� �xF#+��W��  ��m)�� ��[z�6����ԁs� x�Z�X�d�0ᱞ�o���~��q��np�Nو��hE��O�s'b�-��j���y|�Z o�J�j�u�z�Hݲ�H@ ��q*Cfc�c��۞�μ􃍚�hE�U:�Fч��Äd��אI(���D����Nd�<	hJ���=Mq�v�!<
����*LxL���n�;�yi��f���M�%aNŌ̪����<��k2/(  ��`�.d�3T#�ݸ2�.<���d�;��iݎ(�TR�" ��R�c��|����ht�6%��\Z�3A��*K.�.�:�%;8����s��+��9�N�x���D ��uzU3Ph|弝A 8-��b�C$D����'q厼�i�	�KE ��@!걨�Mw����O.���deT���@p+�/���7��r�V=03�o�B! @Q�뵛W��S{�� @�p�0��ϟ�~3qo�y�Ӻ�;ܟ�BS�hmP�f`��½-pf�UmKAjA�CU �����D�ð����O@PG�R�>>m��=U���e\�[�{��O?��M�#'����R� 03�����0�]�k�e�컟$�2F�}�]���ziLr�������[��ٮ���ruZ$l0M"��h�[(�R�O�* �\��eY�<v"=Z�	h]��[Bm.���4�����LM�ʭ�q��]���-
�P"s��,O���P���"�$6�����u�  �"t�!0kb���icD�*\��, pU�T&�4�f0 -0 ��*�� 
`nF��
����� v��3�=�2z�L�@�6�����	���m	~���>��0�%�� 4d�˸�f�n��Ǹh�G($�~����uB6��d��leS@��-	��������/_����������7�����!AJ����$�\��7������W�̓��N[��f㤆S�6����%6�d|bgk���
 �[� Sɕс��<(�B�5�C0tbl5�<���A����w�;���ɢ|���_�����}Ln��	Q ����8����a����n���u��lV��i;&9l,��gY�� P� m�A@�ؤ���]^�W�k�Y�2���8	 a�XT�*�ɱV�0T�����u_�UZ-`�2�\�o�]�]�����he�p�����f3;}=���9N����i�ѿ�T�.$�D� ��Q#VDN����V��}�b�
��-%ȕ=������`k�𻾩��ѝ �l=R�x��q�J𦝞=\kѼ��R<�v��]�2�6�kܻ���OC��-$�ɶ��z-���
� d�{6��k�I! n@�������`l4C@�FQ��9�0l{44�^�t�^.��r���W=��w�o�?��s���� l7L�,���/pw�H;Nt�ګ ��a=dH�d)�t���ź�η��A�EhP3)�����l�^V  j\���ef�q��f�;`���n# �l�H��c  d�����]���.�ET|� ZA��������K~N�?����~~���]G��K7�sxs��1EJ@1��@Ar�Aj��&'�   ��슗3 ض�����|1���v���v\ě������1 \��w�g����5�~�5�'ꐋh�)HvTl&	���^��H@�;�^R[;�FL�Bv���g@)�
�Z`��ʹ50F۾�/�,�u<�d[�# ��hc�]�鯋���s��9k���qݰ�]��]��y������>_�+G$�������v1��L�����޼����f��2-��H�@6C� �ds墟�����Fs��4~ �F/��N=��r�A��=�ٽ?䰳��q.� �J�����25�f�,w:��$	�~@�?��������|ߔ�ڢ�wJ�s_����A=�~˪�V�6@g��fz�Mϻ�iQC�TZ#���a){N0P�U�Jv�z�� P22 -- ��*o�F��F{-��y�w�ٮ��� hPކDTx;�2�*��Y��}�dCoL���a�q4�����9��)w$��HfA\ ��5Pfs30�G�!h�T�d���)�R����b��-��� ��E#�we�(���klK���o�T���s�d��������{�[I��"����y#���w�>�2�i X�<�� l=S��׋������9謁�����'���L! �tl�n�.�0�� ����|V ���̃Xa9�qrHz�6S��峐@P
@� �u�1K����;G�&`M��sf�}�<����[���D����o�s�?�W���.;pE�r!tۏ�� �ƃ�7����篿�w-Ui �6��z��|�wƭ2���=���;�|��<i�
H�M?�ɹ�nʿ����+`@R��h���ǟ�}�u����o���߉9�N~l�j�Л ��!<�vĸ� ؼ��w�?S�%�c����	nnd)�X��(60H���r߫Pscs�������q�8����?���ʭ���p���Ň��ks�r����|���q��{��}ܖ�?�dZɏq��ΎX�	���B, �`0 �qN �Tk��������f��j�ޤA+����e������z��32  P�9�>�Qp	   ����g9������s��n����u��7�~u�[�?������}���e�" �� ���[Շ.M������!�VU��\�C���w�B�n��J 4���Sw��o��}�6}~�~��)��t���aSԵ3EW*�s5;fs�}��?kn�sӷIiM��g�n����ߙ�������۟������� �� h l*Է���	 ��0@;wqW	ҩ���"����!�w�QQ'�{@�8��[�i���n�%_��ݥ7��*���u0_!��]|G�q��AS��Р�ɜ��^�\�t�]�Ĭ�F�95.zA�KߡLTnɍ\]�)�7Z�/0@h �# ��E��̞�(��g�@�U_~��.3D^ܫ����EZ�ٖ�K��5<�����P2|�
T�*�� sj!� �`�o��@O�|ۨ�@T��::U��$r�~�R�i[�@x���r6u�7U��eI�I�I�3Vj�o�l��y^�ç̄$im�$���3{B���5�o�����������O�녰F��G��C�( ����9�Kp��.�  ��iT-�LY���0a�����T�\s��u����}���$4�lv�D�� �.�����
�IB@��Y+�M�]�M�!��0CȪm�@D���5���i�'@6��M���^����n���l���N}� ��KՇ�U�����#`��FْQ"3խ;�w���S������񸉓�2��a�y��X�o �Eէ�؛���D�P)��43��N��lV�#��x�E�ݭW��&%�-{i]�T���E�/�+�3k2�v�N5��٨�S"E��h|~�ۗk��J��y%-2u4DTf	 >��x�9���5/l{�#4��`����A`��O|��Cb��Y�ߪ��f*I�|T����#.��HKt���%T���1H�C�BA�ܝVϏ�e��%cT B�~�"�(�Q��
�閦�֥�X�u���e�[����r��7�_ `N�lm1�G  ��֣-��:��>�T�j�ț��7��=�\���~��ce��x�m;��ěu|��% ��w�|۠�h��( �=d�ݪ��_�������n`EjѺ�E5$W6I4H|x�L�� I(��x~��xݘd�|���_��\�Q	x��D� ��f ٟ�ş	� �QKC�S���*�ZQ��@�;� ��B㞜Cŉ�w��\>��4�C/�O=�bQ���	ɰ��t|44 �,��jyl�R��:�k�0�Nj/�$����;D�-��g)h0,���N����v�P����6���[��G��[����d0��[ ����+T}�)�j �jh.�v�{���&��fn��	��r���m���B1 @�B�[i �3��m����E� ��8������9э0����>��ii`0�3�DX�" { �ń��$AP$h  @��ݖ��Z�FDݫ�.}׿�pvx��C�S�X�<� /�od�y87 `�:���E=��ۑ%���BCB������DF���+�r<�[A��H�H�jt=h�T�<�ҭ-8��u�l�TG�I�� ��-p)�g��t�U�����E�D�� ��VZ�F�!*����<_ە�*��m�����ڳ3(@���h�R��q�����  �t���/4�J)HҟI6^vG�I��K�ȭ�('~Yڮ��Wma � � 8��[|`�47��,� 
 Z=<S6��ޙ�Z|c�h=��\B�	�m0B�/	Ak��R �@"���hx��l�@l�H�TR��HO6�Y4���FŨ `�;\F�����!	h0D�o�Zm	�Hxc��ųfU�ɢ�I��-OyR.Z�j2�RqⷱC�� p���Q�b6�ṏM�vZYMFvl𒢍������E'�b���%n��Ӓ��@_�oݛH'6I��������k���W�Q��� N��gk��*#Ѣk|GAy�#�O�[�#@�����{�r�����d�3)+Im��Gs�m[�ZQ A ��	*  @� ��(�2�Z��m�&*_����nrN��0B�f�A* 	�/)�@R+rPZ�$��cH����Z !��$����[j����3eZ*V���H��㱜m"0�Ծ<FUhK�tU�%��K{���s�Ww�F�o���9*:vYöi��Ҙ�{Ll�{Lo߹�=He�t�)�lK��dz�Tpd�v7�q���S9-}W|؁K3C�K-
� ��$ �G�����E'��Ε���30 6:`��
D�D�����å�{+�+P�l���dy�^�fO��ui�Bw�!J���6_��W�V6�ߕ�bٛtE�V�� (�_�+SY�-�ݫgS������= � �J�7r�򷼯��?H 0�7��ӫ�oD��8� ���	�2���Kp ��d������~2�ճ|܆��sT"�÷����0����d��eD�k���$C  �%����EO`��f��� 'fH,m��u3��Y鯽��,v�sq�8!t�{h� �?s�;��g��SsHU\����e-�
K��@���)
`[`�wKsB@B ` �b��Cׯn�o�s@�5nn����/L��F�v���>}�ۏ���-,�o��젞�:Wp&�]-k2���
�9 v��Nѥ���}�0��V9΋�����S�)$U�T@�:(�����wQ# x@J�&����2����F�������)�ݓ�N���K� -�$�@[p I-c��~gW<�wY���\i��Lt����K�6a��`�Z��ضl葊PJ�L! ���α���F��i�2�7Ǻ�%��Q������P�h�=��5o��V���i�-���.�c�[RእE�:4���/�|P6������P��6\}}��/���땃%�oAb̽ʄ�
�c��z��#��c^����R�B�g����=b^�FhE�������*�"���&d���e�A����3���.(����Xw�
P�tڡ=��M} A8@�gv�@a���h]

`�	B�F{O��[ O�'z"_�^K�����M����Ju%����J�)>֔S,�:z�Zz x|:J�z�F�{Iנ�y;�6�]|{�mT\�Ɓ��ǀq%~}.����P��;2p����l�����s� �-�'�+Oܪ�l&��O�-n�y��FO3<[/����#�f�P���1�h2�h��H�����ߍo�'\w]����jk�{@f"޹*q01H��z��1¤MbLir].������A(�����'�P��(~����4��b� <�WC�Zs���p��ǿ��K������ڍ4�'������M���t73y�1��F;� nQOj&��#�^��Sv��'��\=Uk�����٥6������%d$o�*i�� Ŗj3'�ĲL��Q�ά�|ObV�����0G�� b ��$Fs�_��i����%��g �r�� `����RV��fM^| @@  �p~�8�[>'���:�ks.g�Z��� �ؠ� �)�{�FW���e�j3`��d�J2O�����b7�6�����mU,#��f^���ز�Z�õ�96��rqݔO�G�Z,�Ye���C!jT�:����7���~D�7=  �h��N�L.r\����
`_��	�O�}ծNL�6׺�/�[m-6�ؕTʵ��v����8i��PتX����6 ���YL;B��hk�{T��͵{4l؜q�Ñ�۟�6iZH7b ��K4bF��T���f�6Q�$@�`�i�3(x(�<���5Ã/�i��>��=���]���s^^�>t���cٛC ��u�H�.�����5��H!��$sj�ūd�֦����%t���K$!��=���Ň4�۫vh�p�2U=Q ���F,0t�j.(  6�`��I���&ջ��ƙ� � �UB.b  @&;���d B��<����\��:�]i�۝[�հ0Z�� ��N�gwH�b�7�=�T���=���AT<B�:X��t���a��y({������f��ױ�t����ُb �܀h �M����ؘ�l|w�M��l�
���@�'QLچ��o��:<n���c7��uǯ���]����Xtp� :�_��$Cę��;��:�]�&��`�(��+]g��� `T^�-��U`��>Ѽ���9F�l�1�;�E�&\���ဋi,U���f� ��^a�-{��г�h�QO�`z �i��E�8�� � �P\�@_�
 �r��X����K@���e��=��\�fxY�w�?;h6�X�L.�=����`� � x*9�ex>ٞg�?֫~�x���������l���.͞ B.١4��$�b���CTghG�`	И��`������㘽߈��P��Q`�1��x����/q{]���� ��/p�a�|�ll��_|כ���Ne����x��F%@��@ 44234j���ml=�'��D40�쥍`Kz�-d��d���aBw���{
j���y�M�`8�:��f�c���A�I����=���n�}�
v]Ǝ8 �0�k�A=��
	3 ����l�6=�C���|�F�}z�jp�4��(�@m� @Z h�!��u��k��I=�_P2F(�)�(�t	+����̚�m@ �4  aK�ሴTeA���1- ����>G_��&[�xa���l��t�* �Au��c������5N�=LZ�tN��� }����ϛ�ޣh�2�*aT�y:�r�`P[�V�\c�ϧ������Qz�U+W+��T��� 0�
�� F����ѐ�(S	�m�@���bnW��x����k���ף*��B_�gc:�Z�ْo�3p ]��Ԇ3 ����w���c��j�A��=����t����H�\�B=����7���zު�0��KPc   �>���G) `��B'�]��_��������S(Um�?��T���n�A����E;������i�v�ބ��q,�i)��_;�m�r9��]߱������zB$�B� �
֩Q�X`�����e�E  [�v���p����8iݜִt��6.0`a�~�i���`���Y��݈۷�N�d٩4h� `Pf�z�7#& �j�r3�K��J"�Sob�[�l!�fۈ�x  x�
hE� }Pb�m�����	8z�f��[�)a�pa6j�{�~ �q��;���7w$⾻&�	�54t\W��R$@+*0X�u�E��_7�N�`l{�(��ݵ�5��޿��G�Oˇ(nZ,1!b��V�bU�%�֣�����JT��9@���+kN��Ya��<:�>�h�h�N6�����, 0 � @ �?��[�m-�� �Qk�<" bm��Q���0~[4�M 5��r�wd쵌'�jE�@�( �oh�l�2.�2Ss��Ճ ��<��!:�U ��x1��R�;�,�:����jѣT�w�?+X��$�������`�fi�B"�m�6��^T���؂���(�nO>,����/�4���uG��'�@�]*�@�O���.�����]3�@�@�	n �o�`�
 
�08�)X��+� ��(��Ebٛu�8�θ������ۂ���V L�;lFV���O�r	����*� '����H17����P=d�Hθ��;�nm�\.�6�ڪ ��6,4�t��C�ڪ�@�!zZ.�vk��2�E�B���?��6�G�Zi�rB�D���R�Z_)Q�N  n��? �hE"�tǥ5��͈��f�WK@�n@+� D����.�{��W����P �@�z.XDiuYu��� /H,�9��Zҕ�� z��-�iA�zNA���ۥ�ZJr]��V�u��Z��Z����v*��/�I�����<냜u�Z�ܸ�]��b����`�P�d�8�f��� L|R)��'J� q{���\�L���r�[,2�]�%�-#�Q���Ƃ��AA��P0�3<A�b	`(���y�ڸ�������9Z�Yg� h�d|��e������8;@b
ĝ޹�D1P�uN,�w�}���@�RGӹ�ϔ����T�R T�����oэ�Ga�n��J�B� A�8��n6��C?_�̉�Œ bkH���Ӂ��7 ��e\a�h66��e���[��*;��gqe�� ��G��m�q׸�-N��
����Z�
���Q���X��a$�� @`y�͂���h���4:��v���`Cσ����ِ�Pc���d�쬛@� &X
�������) J�*�i�|:�m�����߬��i00�J�^O � �(�{��
�H/�ބ�8|�:-Ji`�(�X`s.x�����;  �����)�*v���/6}����L���6��8�D��U8��Ċx�t� ( �6 O�(���'"���xO��x7�U�� ��F	���� u���qĜ�ｶ�U�j1@�Ի�P(B�Vˬ�Ƶ׀`5��-f��Nv��"i�w��)� C�Zl���� �r�S��'F ��SC�I�T�q7�e��F  �et��dY�7���S�Pg���x�o|'v�?
\3�5  ��AP�������]�M7mԘ������:���a0������{�
w����YԂ �+�,��|ǻ��=n���x�	����R���T���X�� �l_���$\�G�J/\�'1� x,VG[��ߪx��6ݤ��0ȴ�jB���b�"�ŶA���*� ���kR�N@et"L�m��=U��X�g&l�����%��z  ��̰&q�<�~�v7 �%B�-�J��$���رRۆ`�����$�0Pc�Л�����/g�z��Lz��S�Q:�1V0���T�����۶Wh��sL��]D�[j�Bco�\�8���\X�k\�wk1��7�
�"B)<���lp�
Db=rzӰ[�qcj�R�	V��"4ٙ��q�@ (P�2��\�A5�ٮȃ~�� |��X�^ �hŦ� ��;`�mnf��r,1�iv�/r��.}ǁ"�W���N�{���ȩ����E�
QkI���K $�X�}�	�t���Q��D?�������n��^?s��M�ȳ��4k����d1w�R����阉��mEBY�@[�7�R�!�J��a��X������v��Ů��;��W[�6�o��`�N7:��D�����А@�(�z���
�� �j_)�zYю��f?8�)� l��y��&ּ��,�7�v���K���u�o��_���'wsʬ�]9�D�?������9�� =���޿��:w��	; ���*��P����0�z��Z# � �o �DU�R �)A�r���SжO=	u��-]�wk ϻmrůs����W/:F�`��V  ^j��9Eg@1�dqӡ�������xq�� nF��^�2x}��Jݹ=�  ���Z��,Y������G�I�;s�j/�l��MlL�w�� ��"%w�MfӨ>r��������d�$4� 2D �!�xI���S���rO����* �����  3q�	T��/#JS�N��Ex�&Ԝ� �v�1��ʬ�H�_�<"`)�F�C��� �	�$޿Ml*`!�蹌�j� 	Z��g���<��'���Ͽm)�
pp8*��sl�z�M�QK��Q진Y`h����  }�vG� ��g�^��e7�Ew��3�s���"n;�z,�"
s��޾��麙m��B z��N=;J-�`� �A T�X s@C�NZQ%sc��ɪ�]<Bcl7���;~�����T<(��"�
1�( @>�߀��$�CTC,�-*�8��
����:1�:�7��P ���=����\b�����{�NW����(�!S �C(�7Gl���3ѹ������(�{,��ɭ�ȳ�1�69/f�D֟PN��j�����!mh�1��'��� ��\�[!h�C) b�" �<�������%K���}��SE�����a��x�mb9]�����v�B]��U�� ���3 p�-��]	��@7W�KkKl@�s4D=����75�bV�D��-��<�!��؅(�#p�ƅ. DL�V�����N�w��׫���p�S���!�#�8�B� FkC�2�nƳ��m������4O�((���V����Z�� }�U1���Ђ��, -6 �\U�g� Ra���"�6�o�}?~����S�ċ{�ݶ�t��6 ��=��=�=!֙7��e���Ȯd��.i�!4 00^vڼ,��.�`wj�z�H���k-4���h -�'�D��s� ��k�,
�=����$����Z��e��&��b�֎�Qp��sJ��pb�Sp/� {
us�a ��D[4�Ҽu5 �JmFj  ���/���dF������$�8x�1��D4w�h !-�7� �8@ `�h~�l[S�~}�������O�<=Y�����E�q�!%��z$F�'c�\���3�ٜ�=y'�����Z���}��>���ǿl���ߛ_���5��� �xx�� �7wB� �-��'�����q���a~98P(�5 �P�!�4v�  
 ��,���҂��
 �paA  ���a̓/�E�^�ɔi ���5,`.)�fh56���bN}�U0*(@o��'�|y�'�R�����3v�P{�W�g��D��*.(Oz������-����k����l@*�e쵕��uW��)�R�1 �����&6����w�~��� 5���H{�ȋ��@AE� �yq��^A���q 0��ƕ6w_) /�+��  ��L����oz4�	by��J*�؍m����N��U���x��� �V h05�D��	7�h�^��
�h���!�co*�+�VR���!prdm�v``�;X &��8��������@.|���|f���O|�ܩ��	���Y� ��l���Ң�F"����� � !7����?����<�MX@ v� �< ������+ǧ˿���+�P�� !�H�E�������-����Ɔ�k�zO9`��ݵ?(�>  @�n�@TH�*GT�^Zs}&�uj��F�/Y���  @��K6!r�A���Z�̄���CT�����%@ 05���/gS�z�73b���4`#�`�ryAA\ k�0�h��sbG^.Nv1wwwd\�R��L���瀛�"�>�� �2��hk��m�����ǚ�ė��]��N�1�n�)Ƌt��4m���}N� ��R�����@����� (�S���� 
hT�~���j��_k����r�k�����zX�q�oq�I䖎�
�N����C��z�����@�n �K�nЈF `���Yn�����L}��7����깵�NN&�x��B,�(���U�aM�$	�����>L#c<�� �9B�!橿���~�0�M �Hv~D#�v�Ȃ@ h�E�nZ�p�"�(1���]yѷ�g�1 �+~B\0r ��(6��]O��-{��핫>��p�Pv�:o�n�  ��@�ZD���#�±L��j��"3�x�~��{  A0F@����EKk'�!����ŷ�nW�E����/`;a{9�}_� ���À� ׅ8W���X���늀>�)h<�b��G��j�A���	 �G�_���$��r�o˫!#���k/�Ϩ���ik�V6�����J�
i
�jI @���>z-��Tח��l��&���F�7�m�)��R�#�h��Á�|=�|}ص( @a L��JXT'lct�t�ҩ���g��Y�g���r�h�(}:���A�	�Hhl��$qϝ�[�c�V��h�>���� e�u7�IÔZ_l_�y?�~~��߇w7��iT��Bq肰� �@ o���哸�4}��}��  ��ƅ�L��yZ� S �y�E9�q���2����������~9���j��YY ��(( F���rS���F����Ny5���Њe��z?�#��5��K{�t�`���1̱����)�@0�u�T�m7 �o�b����.�Փ�P�J�Z�_�`�Ukx�C �R-J���|�'> -�T#TŶtS'�V���?w��.�K���X}u��g�磇��}�`tǪ��<��z�ꍈY�h�)��46R�
 9��6W���N�{e��u(<����=�s�?�ve�����^V�Dw�	���G�7~������A � l
#r;~"�d}J��MFw �y������'����?Y���J�3]'9��D�P�-sY�vY,� ǵ�P����_y���C?�Q��Z�2� (� Ц-ƙ�m�������_�?~sZ�	�E�pt� lD��� ��p[�����v*%���x�^\Z\@�����ؗ),@T��������ӹ���7[ӹ�#7�?�׾�����G��(< ��!� @��B��x�1]]�[.pqŒ3ȥ�螾$f� -�i�E�F6�n�oyo���j�T�痁lb��   
�`�� ������-7\����#�}*�� �)%<��Ѣ  O�����g����$]�[�u����*.�d6�9/����,�b�+��&��<�-  "bT�D�R�\��ңSFf�A�T  %ğ>l����i��\�4n�}pB�o���mkt�܌��@���y`��z��{����(4.?���w���nO�ED�����O@;�;w��?��'�O�~:~�'t���V��I�`آY�"@���$a@,g���y��iڃ���� `}@�oh��\��/���o���������� H�I���p�\�q�f�� 4�3��lO2������qѢs�q%�k).0GK"�f
�{� .0��4I�<ɝ�����&�����`�Z��U���Ǩ A��`�v|v����+�[�����g��&�C�ME'�bQXC�F̣�X��Nz���)�^k��݊iC��X{��w��5.:|L K��;4$�+  P@�L@�d�HP��w�P �� �	
�`��`�
 ���Up����#�%o��������NǞ]�m�������+ �Ø�"\��!Q�}T��P��o'i3Bд!↑�K  ��������L��^�O���G�ۍ�dܗ�9�i\F���v쵓��\��?���ox���h�g�#~�7��}��{��&"���a�Ngtk"�ӷ����3O��'�O���ә.K5m(��f�l�[Ҁ�g�)-��I���_����E�1H���#����0�.��&N�p��_����2��/�	`��DV�K8Q�sq�`$c�|~��ζ_;���٣���rsq�3 ݮK����qdAX��a���z�<��'�o>Y��N%�B�/��}���8t����P"�T<Ts�uj�`��s�����P氖9�]�ʖTqE�B X���~��g�Z �R�,���g q��P���I�&C�7צ_�,����ݹ���0�W\�/�^~�O� (p�g�gb7!@@�Cx�: ��Km\ ��sPh��u��;��Of���m�w����mq�_JQ�����o�4@ �(��%�����vs���ro�wl���t�j_2�Bs"�r�q�݈��n�����\lɥ<X�7�5+Mb����	�~o��+�X01!
"hVV��Ҋ9���~�<j�<u��߼����v�7C�3E��DP�j��ͤ	�P�q)<����1g۳y�A�9<;���1�@!�Y�����ۇ8a�a�����qr�7N�L�*�ά�)�X��xuюsN�Ʃ	�H�"|��O��Ӻ������s��<��"�� Ľv	��7DRs@ r  b'M=��8����?;��pS��.� ������ mDD-,@�Z ��0�<�+�2��%t�f�j؟����*��n���n�
  ��	��|I/��������'�eef2����!죏ܵ;D��-43�!��B@AC��	� ����h���X�(�h�(8k���DR��W$����#s�&ƀI���Zgu�Ǐ��7�M�w|{��5\l���Op���%�2y���l�tD��w��6�����9}��}�=B��dG��^z�9i��'�^8������N�~��$�o�7�S�X�2�1�n@��n&q�*�=������8s�v�rI��O=����nT�	��h��Q�k�����_\)F��9F!�vD�L���`��P�:������怰@ ��?���� $
 @�'����8���;G�����ֺ�Nc&����9&c�8IoɌ�ZO���=_�`׭?��g8�/�ޟEׯ��9T���N�"�nC���W�#�(7��>����|o���z�{��n@�}qa�ںl�;��s�a�JX:1 2T��$���P���Vo���ɲiSs\@e�cޅ��vsw<rg�.�I\�b���-hH��*�	4���õ?�!��rL��L��a�Op�e<q��fK ��@��� ��� ��# � 2#� C�ItJ������.T�[g.Z��ˀ��1"��z���'K��`h�Qژ<�������,럄��Qڸ���jE���v%ml{�ʨ�ȤLצ�=�eѸ�����6���4�X@j�m�u�"bmu����������=����׽tȱ���&��  ��ı@4o� q ^�/��1 ۝�7 ��� �%$.pTK6�"��rnP����aۆ��a�� 4 �G O��Ah� 
 `��jaq��W�֤���,:<�i��vp�7�vNg��aYg�11?3~�O�����}y��}�x����Ʀ���B X� 2�ܞ֦P-{��[��UZ� I�����?�I�˕�iQ�B����ɍ^fW�9�):IAa0��?D�0  �<�ՆPk`cy����m���A ^�fx%�)���)´J�D��Lk�X�����Q��2��w����lA�>�7�>a�Q�4[ �]Q�4m n�73�y���]:|��0���۶U��`0��&VS�qo��?|���p��o�r��q����:�~s�-d���~�!�P�s��)�d�OmI��m��3޸s�2W�����e�0Y��~�� ��a�����`�Ԇ]��/��o�\�୘%���%�I&�u������G���  �,�V �>\��0$ �5�4����v�A�K��>f�"Wsa�jz:�`ǎ$  Z����P <v� ���]OZ��Z"�JO�1iߔL���
F���i��~6'�ռ�����,�ϛ�Y1@�@�n�t��U߄A�U�J�%��։�{�4���D߲l�k}c�L_���og��aE/5�Yf�)Q�0�eaFxO|�!���žod�P�P�'����.�{/�co�� �9�/6�C �� �>�*� m����_B��}��o��6���'qv�1�2��v����潋�,]�lĲ����- A�'�S���8ޮ���t�o��$��_H�L�C=�Gl #�  u��}��ˏ�����.�m��<=9}}�/v୾������j��[��$J�[�G0(eT�>� Б����z�/?�'|�Y��� s����uk���f27��>� �����@�)�K��ا�@P`�f �Wﱺ��.(p��q�p�mX ��?�$0�����[ ^���'A�~��a��;}�a9a�A����(^<�Q <��ͤ ׀ V:�BL'�)/h���D#(�@�D�{���{��O��?o����M����AP9���= h�,��6�zJ��!�H2��5�$=|_g�I��@.StV��N��.��q��)��}
��� (0$� W\P�7]��U��>m�?����m�^����/�$�G*��X���!�8�\Չ		Z����9�L��S�I��o�`n��
�¾��� ���%H��A�� ��!�	͢�kM����|���5���t<>�z����~�h[#�����q���'�?<\�5n��_9|���w���G;�%��}v�̥�K�S��L�z��fُZ���K�wÁ�{��^�9�f�O��4*��@z�cLϬr#/H��x9�
Sį��G|�f.�k\�u  � 2yUjȰ�d�F @`e�Y�h��k�p7��k����x��M�Iv��-��pt���B�z�l�@��  �:- @֧EC7 qdE@���d��mq��m2P�,���}����kY�1F��w�[�Pۋ����j/�,��k���s���`OT;�V$i�
�a� �@��{��,|[r�n��r9L��p�{M	�H��w=�00xt����n^�
@;�� T�-	�aS㱏\�{�\�)"rmc�~Q��T�Hɤ�@��+���%�DE�`NMxО����Zy��8��
�3 ��$�Zn��6�u�ݜ�sf�L��;j�Bm��Eg<F�d"����e�8�/N�|h��#N`��7��:��O�o��xOY:��}q�����{�1y���;�&+Qizti�Ԟ�r85�F��GH,�iF�Ћ�o���!wѺ&����� �5�Ͽ�8�u��-��콀���T���q6��{�$s������ �&p���+>���"h��E :�Q� H ���'���o����,��Ud �8J?'�� '����� ;H�H����)���� aA�[2��+,0`w�C@4 �e����Ѭ�1�}��3;p0t�K����- �&��?���-��5]"0	@ 5��*.��ϰ�������M��{'P�c!(`��o�JA@������  �{jw��སP� &� Di֢	��_�.���|��e�C�����S��	����;���Z͚Km1�Z,��b4.nAV� ����٦u�mo�o��?=��3�ϧ�1S���_�� �`ѴS��%Ɍ`+OF.j�o1�0��E_�=>^�k�yS��O֛���Ҵ6�Nǟ��V���'q�[��l����ֿH�7h�MBX�|d[+�Ǫ�q��U�O$�#5��1p��J83�f�S��aO�k~�5g�riJ�5'�'
������ �����xEb�& ��z���1�>
 2%RLD�E��Eh�dj'ǎ�Z �P|�[�;> �-D�������K�DE2�l�р�!�A{�&;��&�1(Hҹ�O4[}�����&A'�0���鿆��'
 �B�( 4������h��Ƌ��\��Zá�o_����鷫�0��܌��bC[�3���
Z�r�>��}��+�&h���7����-`O����Ǩ�^�\���	�y�t4X��^<�;J��� @�^� d
��������n*Y�����g���|޺�c��Ԑ=�EۚX�x�&8P#�FԂ��I@M�
�]�2�d�Z��	�Hb/nxK��g��"cy����Q/&M�0�*���@ h�Jx
��Ѻ�Y���U?�P�}�E�m���lrJ��}�?���ΦZOv���!�C<��,��&�a���u�ۀAag9֟D����EV1[ ���k�y �ć��f���p`N�`�����M����m��g~�/��c�px�5�l':T�]���� ^�xb�	 hn\��g���" ��2d`�  ������փ�Ȟ�O��u���}��~O�&[�DN�Z�Z_����>?y�=~ ��C�� F��I#P'DpE a긓��Mt�ػ�1��nU����px�=�.v}ܩ-.� U P���Ȍ`�`\􊁘�wKR�n{��{k��m�z�Nt����(� mt�Xg���@�LC�JfUl����£rtT�n�"��Nv�'�?@^���m�_���vN����m�d�
�wim �e�;- ��nzb>�hXQ  ( <��\{�����߽z��X  �>�1B��C�>���ĺ�fb�Wv�'�	M�dVZo��l������:�9?@ݒ���h�m��&�J %"�9>.�%�3��n����l����,Jb�^;�o��ۿ�톏'Sg�S_���_��s�e�}��6P0�gT���o�3�}!�n2��� ��zC�'t'�%⥚�#��.� ���o�n�.�m������2��ö!���μ�e(�A���C��ϟ.?˟:a�կ����0�� _Pw�������A��R�����,s�??�>�/��3���\}  s���.�����>�:�3_,�uny��ӓ�x��>\?����q���L=���4���d>5���LV`A�(0�+��C�f��X�m�d����_�立@�A��H�FD) 1b��,�ܬ� �������-�y{/ć�]c�Rױj~��uX��BW��#��A�K���;�(kwb�Ca�O����|�`�_c�x��������6�t9N_7_߸̽Vb����/K�Ν�#S�-@�:����P�'� �#��բ �CXCP ���-���Ƹ�X�_0��P�1���mt��Li���TAo�ŏĂ1����CH�$P�	bJ�T�J?�h0��c�4�(9�3����� (5���Ⴝ�h�'�ӱ��Y������f���q�m��� � `��8YX��8����L��U�L�c�۪�������̧�w��>�jl[��-7�r�����N����>6�y�b)e�6��]*辸7S�m�5���O0�;VD��"�0X ]����y�+݉-]X�.��
�;��~̈́`A� ��Ǜ:$hU= ���L�S��0��-�A����|���Q��|�϶��v�ZfZ�HZ12vX�^��z � �ږzRz�F�:��jC��h/`��K���GiŴ������
��#�F���D0)�;��d/w]���@l)-�؊فǂ�v٥�"ΉI����n��mwN��  P�UKE��6�9$����:��IN �  Pg����_�/�+�P}K�ǋxv���!��s�����O������+<��������n�_�&�n�r�\E�����N}�	�MX�\�}�_���i̔N:�ј!d��}e%�   4"����G�x<̛!ҋ��Xv|�>��̴ o	��E�9�}��]����������?���|�&�|Y>�Yr �02A:��&F{3z��e������h��0-��՞����x�=N�6��{�D܇s"�Dj?r���A@��I�b�Q:��.^4&�H\� P׶M� �`�����O��V{b��]��)l�ERg��t�Mw���Yt�>�_�_��������6�> �E���6,�߹����G B\↋�z���wOOs'��q��E2��x^�d���$f.�K�%q��1�I
 �ዽ�̨m z^,�&dc�C��b��YM$�5��� �@��! hh ��M_}����O~<��S?o��w�����{E@ :F�m5�B�   7 تX*�J�dN�p�E�t�G	��
 ��`�xW��.�>�|���H	p�C�E�2h���s�.��q	���ݱ3Ju�u�%H #�"��D"�u
" @��f�o�)�:�-|�)�a�z�-$) ��T���f2<t�t�ۗoӿ����.z�2�/Q�V����}�������������a���ނ���oZ��s ҙ��LJ�緓oK��W���$�r�E�k�no�Q4���v��y�g&Z�tC|G#��0wH�ԝJ�-��g� ����xk}��] (\~r،�P7�y��'~�_j���X  ���	������@���� ���s�ݞ�?��{~~����5&�o~��ݫ�%�8<�Z�&h��G�Z�P�O�`�l�ݒ��׼^^��~�?������W��r�I���s�pt��#���v)Uih]�AUMy/�.�Z�Ҏ��# �K-��̩��&fЮ�F%�?��f�ybD��G� �K�V�����6r�ժ��_~s����|�s������خ- �(L��{v�@C@p!�2�Z<FB���Q9_��t�J��w�?�>���˼[�h:�Ϸ� ���o4d�<<-7z�M����!�d���5��a�I<�v�A$�5'̋u `x5�
n�
 7,����t�|��>yz��Ͽ������Ͻ���+���u�m � # ��V�, ���[�Ց)���B@(c��q���׏ۿ�?��۟��>�e��s�3>���� �א����\�����]H��~;{ @3 ���r
�J�D5�s��0B����"����n�Mox�1#+�6���f|�/��z���q0;'}������?���/��& đ�5G� �u���s�I��V�W�E����%�\t�T��{��.v�q�ޜ0q����EG������MϷ��?�s'"��A�$����7U 0�����A����H�vGf�%��[�+< �碅LK-��ˢm��5��>��t\�ǝM�39�=�w�2A�� �Fp+�Wm�ޡ�}���8]�k���VO����m�~����^��L���Tq���p�����ꬳ=�~�bi��Σ�  &��?���\b3���kl����1��#�u�e<}:�ƒ}��A�$[�G�N~�`�[���
 ���#�����M����Zka�J�!;�N�����K�P֏ř�Xp�L'�=ЂB�D��x��Aڞ� @F�y S��.l��K�ōڬr`i��T)7ٲ�u4n���pb 4���a�1� �Z���$�`+�^?�               [remap]

importer="texture"
type="StreamTexture"
path="res://.import/background.jpg-58f6528e73f93f0ca6a67982ab436354.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/background.jpg"
dest_files=[ "res://.import/background.jpg-58f6528e73f93f0ca6a67982ab436354.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
         GDST                4   WEBPRIFF(   WEBPVP8L   /���Lڦ֫��f!���N [remap]

importer="texture"
type="StreamTexture"
path="res://.import/checks1.png-41d892b29a54d08e4d86082a36d8956d.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/checks1.png"
dest_files=[ "res://.import/checks1.png-41d892b29a54d08e4d86082a36d8956d.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
  GDST                Z   WEBPRIFFN   WEBPVP8LB   /�09#7�"�G��"�v��p�8�H�"
��$B������Jd,H"Jْ����0�i]�f          [remap]

importer="texture"
type="StreamTexture"
path="res://.import/checks2.png-3af718c4df2eda9566f49340406a755b.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/checks2.png"
dest_files=[ "res://.import/checks2.png-3af718c4df2eda9566f49340406a755b.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
  GDST   @             �
  WEBPRIFF�
  WEBPVP8L�
  /����6�mU���q��j�IB������p۶���.���PR �K��nc�V����"w���膈\#w�?Z ������#�|z| ]T�; �i
`��M� �'@� f J�e�a���o~�F��I��e�e��Rm���#�����Ov
�%����`��$����4�� ��= )� ��? -��#���<�ܕ�tT@{x�P�-fKs�@�;�����^>�,m���h�zc@�nmo�8�Lz�����Y����6��YgMI���X� JJѿ��Cp�F�$'=�^vU�wz���V؊�`��:��B�G�b�ה�ϕ<9�����m��JT,m�g��j�u�W<z'"M�jI]u��Ե������M�*��UT�{%dk@>,��q�_U0 .��.���:�Z�T�	��Wo���B�pI���DN�?J�-��0��{g�?�+�޾�}�p��bT���h$=���''�<9�lȃ�$��f4O�6�ka��D�>�����~�@9(��0�d�����:�@ )�I2g�fh�aҦ[c��6!��,<���Q҄��c�.�Wz_I�8R��4n���E_�&!���{�UQ��{���"D���$v'>��*�eB������uU�@��TjQ�{ �3��A��j�����!�#�?�[�ؼ��J��ˊ�sTB�;/>o��:�D��M�-��TBmc9��X��Y�
 �6饫���%0�Y���l��7���ᤲ��ǵ��6GDS�D�8���@�{�r2�B�U��ʥ�t�bhM��@>+.�NPy�%������r�N2����Z9p�)�J�dx�SF�V+v�흲�uB��λ.b�j�+�8�Ik�s*�AQd�<��5d���ņ�M{E�&'o� �P�{]��[�t��8�vE�KU�F-�8tF1tL��o��MŮ+8fQxsݓ�]�$#0��,�3��  �l&��5J6>o�"D���d�.�	"'>�� �Dq��	���Ib0��$O>��-;��s��$����Yj�Ԏ!F�-�)�H�I��}����1����K� e��)��h5�?m��X�w+�"�(���H� mn�kk4�F��Q<�
��/9�|��F�֥��sB-Q4V��aQ�L��,�������(�>�,,|[A���8QX6[�h8m:�>��=Q��� �*Ħ�]w08N��bPk���̀l�]D�K�O�0�_w��驈���w`��f�-���V�����9����)@#�b8��8wZ+�LAd�?�i����g"tE�;폶)%�mS��	���������T4�U�����lc�1]��G�www7}�c�B��>!������/��d�~��A^�}5�3KaF�JLbwQ��������R�/H5��~K>}��hW��p��@�Ȇ(8Q�w��r���|_�_�lf���	���;����[M�i��o���,�4EH9P���M!�9��O���~�&�v(�\ BDDB8dT��% ��\�P�JD*�x�M�����BD���)�\���Кڀ(�v(�@@Di�"PS�	Վ�t c��-rpᎄ	�ӺZ��c6(���$1ڠ��n�A3w����3��_l�����d!��>����Ҧm�66f3��a��$�a��c��9J�ܢ�Ai ��̟�P��e6��3�п�itVWd��L���O�x�4����D�Q(��~|��(�]�H�u(7J��,u�H���\f����g�WT��.��R8 G��I�)�ݵK���v����Bv���B���5R�1Q&e�����4�[G��3�X�0�v���M�ǫE�>G��]�ֽ��,�	�����J?�@�&�4��6�\#$C��S �AhQ	"rͼc���@���閍v�@�h� C��2�,Z��a`��$9��kO�k~X��7j]�υ^�ֻy	߄�*{����h�a����n�J�l�8N���X�e�G�"4�����jb`��39B�E�ecؘfk���L_����k:�˖v�
~�<4�j�\g[�kں����_}07ΰ�:[�l�2�g�s�j��<M0��f?�����Y�l5�V�f��2��u�5ؿ�F��eh�)�~5�o���H�}��m����G9��jE7(�WeEօ�������We�Z��p�����V��,�8��	�+��CY9w>iu��jY1�$+���^�*k��ce�M_�����jb))�����嫗��4�$����/K�z)Kz��v`��/���+�R���f��S�e/[��(�Z���S�������>͜>�ǡ^��$���'N�8��8�X�z,<S�>}J��`R�r���7Ac���	Q'�EY��(w�>d����O��������W��d)_�'�|u�l�:H�
�F�ͧ4UT��D��,�M�<x �����'OT�8��ʍ��?�����ڡCk��9z��	٬Tʗ��^���w�z��~r�H�u�u��{��/Ћg�$^�Bnqݹs�nb퉉�+W�^�R/r���z!\��ޕ�%�X���]Ru��U����E��网[ŭ[��ͥ��%u+�ر�c�z ����c,� 1��֎�=�;vL<�����2<e=K�7`l_k���cZ���a4������1   [remap]

importer="texture"
type="StreamTexture"
path="res://.import/ground.png-a50b8922e8f0846677c2afa8b873914a.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Envrioment/ground.png"
dest_files=[ "res://.import/ground.png-a50b8922e8f0846677c2afa8b873914a.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
            DSIG    ��   GSUB�|� ��  vOS/2+�(�  �   `TTFA�� �8  `cmap��j�  P  �cvt �-p  5p  fpgm6��6  '  vgasp    ��   glyf�9Na  O ��head��s     6hhea	|  T   $hmtx�A�  �  Xloca�N  6|  �maxp��  x    name�

_ F�  !�post�~<9 hP  Gfprep����  4�   �     ��w�_<�      �    �â��F��K�            m�  ��F��K                  % �       � � �  bv     ��   3�   �3�  � f  	� � ��        SRC  @  ����m�  ���  `�     � h    �  �  � %� %� %� %� %� %� %�  � �� �� �� �� �� �� �� � �� � �� �� �� �� �� �� �� �� �� �� f� f� f� f� f� �� � �� �� �� �� �� �� �� �� �� m� �� �� �� �� �� ����� V� �� �� �� �� �� �� u� u� u� u� u� � u� u� � � u� H� �� �� r� �� �� �� �� �� �� �� �� �� /� /� /� /� �� �� �� �� �� 	� �� �� �� �� �� 9�  �  �  �  �  � � %� %� %� %� %� n� n� n� n� �� �� �� �� �� �� �� �� �� �� )� �� �� �� �� �� �� {� �� ]� {� |� |� |� |� |� |� |� |� �� |� |� �� �� �� �� �� �� �� F������ ��� ����� �� �� �� �� �� �� �� L� m� �� �� �� �� �� �� �� �� �� �� ��  � �� �� u� �� /� /� �� � �� �� ��.�.�.� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� '� �� �� �� �� �� d�  �  �  �  �  � L� h� h� h� h� h� �� �� �� �� ��� �� %� �� �� �� �� �� !� �� �� �� � �� �� �� �� �� �� � V� �� u� �� �� �� /� |� |� B� � �� d� r� ]� �� .� �� 4� A�  � ,� �� �� �� �� �� m���� P����  � u� _� �� � �� �� =� �� /� %� %� � �� �� � �� �� �� %� %� �� u� u� � �� � �� �� u� u� u� �� |� |� |� � �� R� �� r�  � �� }� ��3�3�=� i� |� |� |� ;� �� �� �� �� �� �� 2� =� �� �� �� �� �� �� r� r� h� L� �� �� }� i� �� �� �� <� h� � j� �� �� �� �� �� �� A� v� K� 2� �� �� �� ;� �� �� �� �� �� \� \� `� ���� ;� �� �� �� �� �� |� �� �� ;� �� �� �� �� �� �� �� �� h� h� h� ��$� h� �� ��  � �� ��  � )� %� u� �� w� �� U� 6� �� `� x� �� I� F� �� �� ]� 6� �� G� _� 6� V� V� @� 6� `� �� `� -� `� b� �� !� i� �� @� �� F� $� u� G� g� �� I� �� �� g� �� �� j� ]� ���� h� �� �� �� �� �� �� �� �� � �� �� �� b� �� �� �� �� h� �� ��5� h� O� �� � p� �� �� o� 7� �� �� �� -� �� �� �� �� �� 7� �� �� 7� �� -� 7� -� �� 7� �� 7� �� V� �� �� �� �� �� �� �� �� �� �� r� 7� j� �� e� ���� �� �� �� �� f� �� �� �� �� � f� � � � � � � � � � �X�B�F� �� ����?������� � P��� ���� ��� �� "� ��R���� f� ^�  ��?��� ��  ������Z� "� �� �� �� X� ���� �� ������ ��C����Z���Z�(������� �� ��g�n�D�D� �� �� �� ������� ��5�7�,�,��� ��  �5� �� ��d�d�d�  � ��� �� �� ���������� ����� ����� ��)�(����� �� ��#���z� ��y� �� ����d�  �  �  �  �  �  �  �  �  �  �  �  �  �  � %�  � �� {� �� �� �� %�  �  � �� 
� �� �� 
� _� m�  � 
�  � *� *� /� � .� j� 5� '�  � �� /� h� %� ~� X� �� T� P� P� X� X��� �� J� X� X� ����� X� X� )� �� |�� �� X� V� �� X� �� X� �� �� X� X� ~� �� !� X�  � X� X� �� X� X� �� ;� X� X� X� X� �� �� ��  ������� J� u� �� �� �� �� �� �� X�+� ;� ;�� ?� 5� ���� �� X� J� W� X� X� X� X� X� X� X� X� X� X� X� X� W� X� X� X� X� X� W� J� J� X� X� X� X� X� X� X� E� X� X� X� X� V� V� V� V� W� X� X� X� X� V� V� V� V� V� V� V� V� V� X� V� V� V� V� V� V� X� X� X� X� X� �� �� X� X� X� X� ^� ^� P� P� P� P� P� P� P� P� P� P� P� X� X� X� X� X� X� X� � �� �� i�	� X������� Z� Z� X� X� V� X� V� V� V� V� X� X� X� X� V� V� V� V� P���Z���Z���������������� ��� �� �� � u� u� X� X� P� �� X� X� �� %�� ��  � ��� �� B� �� B�� *� B� B� B� B� B� B� B� B� B� Y� Y� B� B�� B�� B� B� B�� B��� B� B� B� B� B� B� B� r� �� �� �� �� �� @� Q� Q� 2� F� F� Y� Y� B� B��� B� B��G� B� B� B� *� B� *� B� *� B�� �� B� ��� �� B� �� B�� B� B� B� B� B� B� B� B�� B�� �� B� �� � �� �� �� �� �� B� �� B� B� � B� � �� T� t� T� t� .� J� T� .� 6� T�1� �� ��1� �� T� �� T�1� `� {� {� 6� 6�P� 6� e� e� 6� a� ~� U� 3� *� �� X� u� T� t� u� +� O� 6� � &� &� 2���������� T�  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �  �i�F�  �i�  �  �  �  �  �i�  �  �  �  �  � � ���� � � � �8�8� � � � � � � � � � �?������������� � �7�8�8�7� � � � � � � � ,� u� � �D� � �D�����������������������������������������x��������������x�x�x�������x�������������������x���x������� � � � � � � � � � � � �� �� � � � � � � � � � a� a� �� �� � � � � � � � � � � � � � � � �� �� �� �� �� �� �� �� � � � � � � � ������ <� <���� <� <��������������������������������������������������������������������������������������������������������������������������������������������������������� <� <�������������������������h�������h��������������� � 8� j�  �  � ��  �+� H� �� �� �  �
  �0  �F  ��  �N���/�)���)�?���X�=���V���� %�?����y�7�7� ��/���� b�������  �  � %� �� �� �� n� �� &� �� �� %� W� �� �� u� �� �� x� /� "� v� � u� J����������!��N��+��A� �� "� F� �� B� �� �� �� �� ��6� �� D� t� �� �� P� �� �� w� �� 3� L� Y� �� F�6�6� �� 3� 3� 3� �� F� F� �� ��=�X�B�F��?�I�=�;�0� � � � 
� � � � �=��?�I�=�;�0� O� �� ������� �    �� � % � � f � � � m � � �  	  h % | � � � � � / � � 6   � �               �  :   :    / 9 ~��������	#�������������#:C_cs��������VY_��?������ 
 ' 1 7 : ? I K _ p y ~ � � � �!!"!&!Q!_!�!�!�!�!�!�!�!�!�""" "#"-"="H"_"i"�"�"�"�"�"�"�"�"�"�"�####!#�%%%<%O%l%%�%�%�&j'V'u'�'�'�'�'�'�'�'�'�'�'�'�)�)�)�)�* */*k++...%..������        0 : ��������� 	#������������� $;Dbr��������1YZa�?������    / 2 9 < D K _ p t z � � � �!!"!&!P!S!�!�!�!�!�!�!�!�!�!�"""#"'"4"A"I"`"m"�"�"�"�"�"�"�"�"�"�#### #�% %%%=%P%m%�%�%�&j'V'h'�'�'�'�'�'�'�'�'�'�'�'�)�)�)�)�* */*j++..."..������ ��  �    8  q              x\  32    ��  ���  ��  �&                          �� 7�R�w�)���/          �    �m�\    ��U��      �*  ���V���    �B  �C�4�D    �?  �   �      ��  ��  ��  ������  �����2���  �  �  �  ��  ��  ߷�Y�ܣܠ��ܨ  ܧ�D������ڿ�q���������ٕ�[    �M�G  �9$�$��     6  R�  �  �������      �    �    �      �    �  �  NPRhn�������              �����  �             "*2  H        D\  t      x�  �  �  *  6  F  V      T            P  P  R  �  �                �                            ��    �           LTO�sUuvCH�PWGV���Qr�        % ' 0 1 3 8 9 ? K M N R W [ f g l m roDpzX� v � � � � � � � � � � � � � � � � � � � � � � � � �mpn��N����qw�u ����v�y	AB�t�@ � :7;S   
  	       , ( ) *  > C @ A I B� G _ \ ] ^ n L � { w y  z ~ � � � � � � � � � � � � � � � � �� � � � � � � � �  |� x  }  �	
  �  �  �  �  � � �  �  �  � ! � $ � # � & � / � - � � � . � + � 2 �  4 � 6 � 5 � 7 � : � < � ; �" = � F � � � E � J � O � Q � P � S � U � T � Y � X � e � b �#$ d � a � c � i � o � p s � u � t � � D � ` � " � H � V � Z ����������~�������������������� � �% � !"# � � � � � � � $PQRSVWZ[\]_klnmoptuszrXY�Tyx{|}vw~`^jq&�'� �U(�)�*�+�,�-���.�/�0�1�2�3�45�6�7�8��9�:���;�<�=�>�?�@�A�B�C�D�E�F�G�H�I�J�K�L�M�N�O��* k � h � j � q �������ZY��������{|F[IJK\�M]^_`aRbcwxkl���������������89������<=>?6��������������������
	 !"#$%��)&'(��01�2������345�����  !"#
$�%�&E'(�������*+,-./01234567�89��QR��STUVlmnop�y�����������"#$�%&'�()*�+,-�./01234�56789:;�<=>?@AB�CDEFGHI������������������������������rjklmnopqzyxwvut{���s����������������������	��
� �����������������������������������������������XYZ]\[`_^FADBGCEHI�����stqr� , � UXEY  K� 
QK�SZX�4�(Y`f �UX�%a�  cc#b!!� Y� C#D�  C`B-�,� `f-�, d ��P�&Z�(CEcE�EX!�%YR[X!#!�X �PPX!�@Y �8PX!�8YY �CEcEad�(PX!�CEcE �0PX!�0Y ��PX f ��a �
PX` � PX!�
` �6PX!�6``YYY�%�
Cc� RX� K�
PX!�
CK�PX!�Ka� c�
Cc� bYYdaY�+YY#� PXeYY-�, E �%ad �CPX�#B�#B!!Y�`-�,#!#! d�bB �#B�EX�CEc�C�`Ec�*! �C � ��+�0%�&QX`PaRYX#Y!Y �@SX�+!�@Y#� PXeY-�,�C+�  C`B-�,�#B# � #Ba�bf�c�`�*-�,  E �Cc� b � PX�@`Yf�c`D�`-�,� CEB*!�  C`B-�	,� C#D�  C`B-�
,  E �+#� C�%` E�#a d � PX!� �0PX� �@YY#� PXeY�%#aDD�`-�,  E �+#� C�%` E�#a d�$PX� �@Y#� PXeY�%#aDD�`-�, � #B�
EX!#!Y*!-�,�E�daD-�,�`  �CJ� PX �#BY�CJ� RX �#BY-�, �bf�c � c�#a�C` �` �#B#-�,KTX�dDY$�e#x-�,KQXKSX�dDY!Y$�e#x-�,� CUX�C�aB�+Y� C�%B�%B�%B�# �%PX� C`�%B�� �#a�*!#�a �#a�*!� C`�%B�%a�*!Y�CG�CG`�b � PX�@`Yf�c �Cc� b � PX�@`Yf�c`�  #D�C� >�C`B-�, � ETX�#B E�#B�#�`B `�a�  BB�`�+��+�"Y-�,� +-�,�+-�,�+-�,�+-�,�+-�,�+-�,�+-�,�+-�,�+-�,�	+-�),# �bf�c�`KTX# .�]!!Y-�*,# �bf�c�`KTX# .�q!!Y-�+,# �bf�c�&`KTX# .�r!!Y-�, �+� ETX�#B E�#B�#�`B `�a�  BB�`�+��+�"Y-�,� +-� ,�+-�!,�+-�",�+-�#,�+-�$,�+-�%,�+-�&,�+-�',�+-�(,�	+-�,, <�`-�-, `�` C#�`C�%a�`�,*!-�.,�-+�-*-�/,  G  �Cc� b � PX�@`Yf�c`#a8# �UX G  �Cc� b � PX�@`Yf�c`#a8!Y-�0, � ETX�EB��/*�EX0Y"Y-�1, �+� ETX�EB��/*�EX0Y"Y-�2, 5�`-�3, �EB�Ec� b � PX�@`Yf�c�+�Cc� b � PX�@`Yf�c�+� �     D>#8�2*!�-�4, < G �Cc� b � PX�@`Yf�c`� Ca8-�5,.<-�6, < G �Cc� b � PX�@`Yf�c`� Ca�Cc8-�7,� % . G� #B�%I��G#G#a Xb!Y�#B�6*-�8,� �#B�%�%G#G#a�
 B�	C+e�.#  <�8-�9,� �#B�%�% .G#G#a �#B�
 B�	C+ �`PX �@QX�  �&YBB# �C �#G#G#a#F`�C�b � PX�@`Yf�c` �+ ��a �C`d#�CadPX�Ca�C`Y�%�b � PX�@`Yf�ca#  �&#Fa8#�CF�%�CG#G#a` �C�b � PX�@`Yf�c`# �+#�C`�+�%a�%�b � PX�@`Yf�c�&a �%`d#�%`dPX!#!Y#  �&#Fa8Y-�:,� �#B   �& .G#G#a#<8-�;,� �#B �#B   F#G�+#a8-�<,� �#B�%�%G#G#a� TX. <#!�%�%G#G#a �%�%G#G#a�%�%I�%a�  cc# Xb!Yc� b � PX�@`Yf�c`#.#  <�8#!Y-�=,� �#B �C .G#G#a `� `f�b � PX�@`Yf�c#  <�8-�>,# .F�%F�CXPRYX <Y.�.+-�?,# .F�%F�CXRPYX <Y.�.+-�@,# .F�%F�CXPRYX <Y# .F�%F�CXRPYX <Y.�.+-�A,�8+# .F�%F�CXPRYX <Y.�.+-�B,�9+�  <�#B�8# .F�%F�CXPRYX <Y.�.+�C.�.+-�C,� �%�&   F#Ga�
#B.G#G#a�	C+# < .#8�.+-�D,�%B� �%�% .G#G#a �#B�
 B�	C+ �`PX �@QX�  �&YBB# G�C�b � PX�@`Yf�c` �+ ��a �C`d#�CadPX�Ca�C`Y�%�b � PX�@`Yf�ca�%Fa8# <#8!  F#G�+#a8!Y�.+-�E,� 8+.�.+-�F,� 9+!#  <�#B#8�.+�C.�.+-�G,�  G� #B� .�4*-�H,�  G� #B� .�4*-�I,� �5*-�J,�7*-�K,� E# . F�#a8�.+-�L,�#B�K+-�M,�  D+-�N,� D+-�O,� D+-�P,�D+-�Q,�  E+-�R,� E+-�S,� E+-�T,�E+-�U,�   A+-�V,�  A+-�W,�  A+-�X,� A+-�Y,�  A+-�Z,� A+-�[,� A+-�\,�A+-�],�  C+-�^,� C+-�_,� C+-�`,�C+-�a,�  F+-�b,� F+-�c,� F+-�d,�F+-�e,�   B+-�f,�  B+-�g,�  B+-�h,� B+-�i,�  B+-�j,� B+-�k,� B+-�l,�B+-�m,� :+.�.+-�n,� :+�>+-�o,� :+�?+-�p,� � :+�@+-�q,�:+�>+-�r,�:+�?+-�s,� �:+�@+-�t,� ;+.�.+-�u,� ;+�>+-�v,� ;+�?+-�w,� ;+�@+-�x,�;+�>+-�y,�;+�?+-�z,�;+�@+-�{,� <+.�.+-�|,� <+�>+-�},� <+�?+-�~,� <+�@+-�,�<+�>+-��,�<+�?+-��,�<+�@+-��,� =+.�.+-��,� =+�>+-��,� =+�?+-��,� =+�@+-��,�=+�>+-��,�=+�?+-��,�=+�@+-��,�	EX!#!YB+�e�$Px�EX0Y-   K� �RX��Y��  cp� B� s_J;) *� B@{fRB0	*� B@�p\J9&*� B� ���@   	*� B� � @ @ @ @ �  	*� D�$�QX�@�X�dD�(�QX� �X� DY�'�QX�� @�cTX� DYYYYY@~hTD2*������ D�^�d DD                                                   � � � �^�  `  �Vm����{���Hm� � � � ��  `  �Vm����{���Vm� � � � �  ��Ym�  �Ym� � � � ����`���Vm����!{���Vm� � � � ��  `  �Vm����{���Hm� } } � Y Y ��`m��`m�       �   �   �   �  |  8  �  0    �  �  d  ,  �  	  
H  |  �     �  �  8  �  @  ,    �  �  h  �  �    �    |  @  |  �  T  �  H  $  �  �   T   �  !�  "�  #\  #�  $$  $\  $�  %$  %t  %�  &8  &�  '  '�  (<  (�  *  *�  +�  ,�  -�  .�  /�  0�  1,  2T  3x  5  5�  6<  6�  7�  88  9  :@  :�  ;�  <�  >D  ?�  @�  @�  A$  A�  B�  C8  D,  EX  F\  Gt  HT  Il  J$  K  LH  M�  M�  Nl  O8  P<  Qp  R`  R�  S  S�  Tx  Ud  V  Vh  W4  X  X�  Y�  \  ^�  `�  c  e  g$  h�  k0  n  o�  pd  p�  q�  r�  s�  t�  ux  v�  wp  x�  y4  z  z�  {�  }   }�  ~�  |  �L  ��  ��  �$  ��  �,  �   ��  ��  �   ��  �  �t  ��  ��  �<  ��  �d  �(  �  �  ��  �h  ��  �8  ��  �8  ��  �   ��  �|  �   ��  �`  �   ��  ��  �X  �  ��  ��  �p  �T  ��  ��  ��  ��  ��  ��  ��  ��  ��  �X  �  ��  �<  ��  ��  �0  ��  �  �|  �@  ��  �   ��  �0  �  ��  �h  �@  �H  �  �  ��  ��  ��  ��  �   �d  ��  �D  ��  Ì  �  �l  ��  Ő  �8  �  Ǽ  �  Ȅ  �  �h  ��  ��  ˸  �  ̠  �D  �|  �  ΄  �  �x  �T  �p  ��  Ҭ  ��  ��  Ԭ  �  ��  �,  ֐  ��  �p  װ  �  ؼ  ��  �p  ڠ  �L  ۬  �$  �x  ��  �(  ݠ  �   ތ  �  ߌ  �8  �   ��  �l  �  �d  �p  ��  �  �  �  �4  ��  �4  �  �D  �h  ��  �8  �(  �|  ��  �<  �  �D  �  ��  �X  ��  �l  �  ��  ��  ��  ��  �  ��  �@  ��  ��  �  ��  $ � \ x d � �  � � 	 
�  �   T � T � � � d  h   � � T � $ t � 0 � � � \ L � H �  ` � 8 � , � ( � \    � !X " "� #p #� % %� &D &� 'L '� (` )� )� *P +H +� +� ,T ,� -, -\ .l / /| 0  2L 4� 6  6� 7� 8� 9� :� ; ;� <� =h >� ?� @� Ap B B� C4 D D� E� E� F@ F� G( H@ H� Ix JH J� Kp L L� M4 N Nl N� P P� Q@ Qx R@ S� T( T� U� V0 W W� X� Y Y� Z\ [ [� \� ]h ]� ^d _d _� `� a8 b b� c| d� ex f, gX g� h� i� i� j� k� lX l� m  n n� oX o� p� q� r� sd s� tP u$ u� vp w, xD y y� z {$ {� }P }� ~� � �D �$ �  �� �P �$ �� �8 � � �� �P � �� �$ �0 �� �� �x �l � �� �� � � � �  �� �� �� �� �( �� �� �l �  �� �X �H �� �� �� �� �� �� �@ � �T �� �h �d �� �� �� �� �� �� �� �h �X �T �| �H �� �� �< �� �� � �� �� �P À �� �( Ġ �( �l �� �` �� �� �t Ɉ �� ʼ �$ �T ͔ �� �  �0 �l ϼ �� �  �l �8 �t �� �( �| �� �l �� ִ �T �$ ب ٜ ڜ �� �8 �� ܬ �� �< �| ݼ �� �, ތ �� �< ߈ �� �| �� �$ �h � �� �< �| �� �� �  �� �t �  �� � �t � �� � �D �x � �� � �H �| � �� �4 � �� � �T � �� �$ �T � �� �  �` � � �d �� �� �@ � � �� � � �� � �  �t �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� � � �l �t �h �| �� �� �� � �� �� �L  0 ( < � x � � � , � 
� x \ 0 � � �  � � �   t  < | 0 �  � � , �  T � �  <  �  |  �  � !@ !� !� " "d #p #� $� $� %� '� '� )� * *t *� +< +� ,l ,� -h -� .D .� /| 0 0� 2� 3 38 3� 3� 4( 4t 5, 5� 7  7� 8� 9  9P 9� : :� ;� <� <� > ?` @  @� A� B B� C� D� E� F, F� Gl H8 I  J K  L@ M� N� O< P< P� QX R� SD S� T� U< U� V� W W� X� Yl Z  \ ] ]� ^� _, _� ` `� a< a� b4 b� c$ c� d\ e e� f� g gT g� hx h� h� il i� j� kT k� l@ l� m� n� o$ o� pl q qx q� r4 r� r� s t  u( v8 w� x� z  { {� | |� }$ }h }� }� ~  ~T ~�  � � �� �� � �� � �p �4 �� �d �� �H �� �0 �� �X �� �� �X �� �` � �� �� �� � �P �� �� �� �p �� �4 �� �  �p �� � �l �� � �@ �� �P �� � �` �$ �� �� �| �� � �� � �� �� �� �� �� �� �H �� � �� �� �P �� �$ �� �  �x �� �h �� �d �� �� �$ �� �h �x �� �� �@ �� �$ �� �� �h �� �8 �� � �� �� �d �  �� �T �( �� �D �� � �h �� �$ �� �$ �� �T �$ �� �� �� �� �@ �� �� � �P �� �� �D �� �D �� �L �� �< �� �$ �� �  � �| � �t � Ť �( �� Ǡ �L �� �D �� �X �� �P �� �D ̰ �  ͨ � Μ �L �� Д �\ �  ҄ ӄ �, Ԉ �� �\ Ք � �H ֜ �� �$ � �T ؤ �( ٰ �� �< �x ڴ �� �4 �| �� �$ �l ܰ �� �< ݜ �� �@ �� ߨ �h �( � � �h �L � �T �� �x �  � �p �( �D �� �, �< �H � �� �l � � �L � �� �$ �d � �  � �� �H �� � �� �� �P �� �$ �� �� �  �� � �� �4 �� �  �� �P � l X � � p  � L � 8 | 	@ 	� 
� | H $ H | � � d �  � P � 0 � �  h � �  < � �  � � � P � � $ � � d � 0 � H � h    <  � !p "( "� # #� $l $� %� & &� '� (8 (� )` * *� +� +� -  -� .8 .� /( /� 0H 0� 1$ 2 2� 3D 3� 4X 4� 7  8 8� ;� =  > @x @� A  At A� BX B� CP C� D� E@ E� F4 Fd F� F� G G8 Gp G� G� H Hp H� I$ Ip I� I� J  J4 Jd J� J� J� J� KH K| K� K� L( LP L| L� M M\ M� N N8 N� N� O\ O� Ph P� Q8 Q� R� R� S0 S� S� T8 T� U Ux U� Vd V� WL W� X� YL Y� Z� [P [� \� ]@ ]� ^� _8 _� `� `� ap a� b0 b� c c| d d� e0 e� fH f� gd h4 i i� jt k, k� l� m� nt oT p p� q� rd s  sh s� s� tD t� u u� v vt v� wX w� w� x  xh x� y y< y� y� zh z� {@ {p {� }P | � �` �  �@ �� �� �� �L �� �� �� �, �d � �� �� �T �� �H �� � �\ �� �� �( �� �` � �l �� �< �� �( �� �� �< �` �� �h �� �D �� �� �� � �L �| �  �� �  �� � �� �4 �� � �t �� �` �� �� �� �� � �h �l �P �� �x �D � �� �< �� �� �T �0 �d �< �� �h �� �� �p � �� �� �� �h �� �l �0 �� �t �� �� �0 �� �\ � �� �$ �� �| �d �p �@ �x �� �T �D �� Ŭ ƌ �\ �� �P �� �d �� �� �0 �� ̔ �| ΐ �� �� �� �  Ә �� ՘ �$ � �� �8 �  �� �< ڌ �x �� � ܘ ܘ �� �( �� �� ߰ � �� � � � � �d �@ �0 � � � �� �� � � �@ � � �� �� �@ �� �� �� ��  h��h�   jK�
PX@ e   U  ]   MK�PX@    a ]hL@ e   U  ]   MYY@    +!!!h� ������s��     %  �<    �@
 JK�
PX@    �� f hKiLK�PX@#  ~ f   nK hKiL@    �� f hKiLYY@	+3#'#3#!#
�ӌ�������n��l���<����]�+��{'��   %  �:    " K@H!J
	  g f hKiL    " " 
+"554332#3"554332#3#!#]����{���n��l���o������+��{'��     %  �9    7@4J   � � f hKiL+3#3#!#f�Ś[���n��l���9��\�+��{'��  %  �    5@2J    e f hKiL+!!3#!#=V������n��l������+��{'��    %�u��   y@  JIK�!PX@  f hKiK  _ mL@ f   c hKiLY@  	+267#"54673!#3#d/,2!�/=n��l����^0(�������1gF��{��+AU"X7��    %  �m  ( + ?@<*J f  _   nKhKiL)))+)+#!(('	+&'&546632#!#27654'&&#"�: !J|L:e%#, <��n��l�C@,,,9?+,X��w!<;JO|I+%#d=H;9&����{�,,?@,+,A?X�d��    %  � ' / 2 M@J1
J   g h
 
f hK	iL00  0202/.-,+*)( ' &)#"'$+467632326553#"'&&''&&'&#"3#!#3V%49(}33U"%9	"R���n��l���30P ;4(d;<!	,^�+��{'��        ��   =@:  	e
	 	e ]   hK ]iL+!!!!!!!##����3��e����e�}k�ժ�F�����'��    �  q�   * >@;J e  ]   hK] iL! )' *!* +!2!!27654'&##27654'&##���}|" bC�SS�����F��@A@A���MKOP���cc�Fk&&3
gg��ghm98yu12�>�9>>��ED��    ���1�  7@4 J _ pK  _  q L 
 +"&'&4$32&'&#"!2767��P���a�OIVWV�bb�VWTIOOPdg�m�[�&,�=  ������  =�)   ���1<  ' �@#$JK�PX@!   n � _ pK _qLK�
PX@    � � _ pK _qLK�PX@#   ~   nK _ pK _qL@    � � _ pK _qLYYY@ ''+3# '&476!2&'&#"32767��嚱�⟞OP�]POOIVWV�bbb/�fWWTIOOP<������m� g�*�=  �����ΘHP  =�)     ���1<  * �@ &'JK�
PX@!  � � _ pK _qLK�PX@$   ~  nK _ pK _qL@!  � � _ pK _qLYY@#!**+373# '&476!2&'&#"32767�����ӽ��⟞OP�]POOIVWV�bbb/�fWWTIOOP<��������m� g�*�=  �����ΘHP  =�)   ��u1� < x@8 9 "!JK�!PX@   _ pK _ qK _ mL@  c  _ pK _ qLY@ 53,+%#
 <<+"32767#"'&'53254'&&'$'&476!2&'&��bbb/�fWWTIOO/+<X>,+.*ER|����OP�]POOIVWL�����ΘHP  =�)	4&3U.� \ +'��m� g�*�=       ���1<    �@JK�
PX@   g _ pK _qLK�PX@!  _ nK _ pK _qL@   g _ pK _qLYY@    
+"554332#   !2&&# !27j�����> ��I�]�z����o���t�no�R�<A����}�R  �  R� 	  &@#  ]   hK] iL

% +!  !!% 76'&&##�/VD������+ ded3�}`����������~}JK|@=�w      N�  ! 6@3  e ] hK] iL !!&!	+#53!  #!%2676654&'&&##!!�}}/VD�S����/��142325��`��ŕ{�������]Y�B=Aܪ��@C<�+���    �  R<    �� JK�
PX@!  � � ] hK] iLK�PX@$   ~  nK ] hK] iL@!  � � ] hK] iLYY@$!+373#!   !!%26654&&##錥��ӽ��/VD������+��VWȪ`<����]���������l����k�w     N�   6@3  e ] hK] iL$!	+#53!   !!%26654&&##!!�}}/UE������/��VWȪ`��ŕ{���������l����k�+���   �  N�  )@&  e  ]   hK ] iL+!!!!!!�v�T��r��wժ�F���     �  N@   jK�PX@*   ~  e   nK ] hK ] iL@'   � �  e ] hK ] iLY@+3#!!!!!!�����v�T��r��w@��c��F���     �  N<   �� JK�
PX@(  � �  e ] hK ] iLK�PX@+   ~  e  nK ] hK ] iL@(  � �  e ] hK ] iLYY@	+373#!!!!!![����ӽ��v�T��r��w<����]��F���  �  N<   �� JK�
PX@(   ��  e ] hK ] iLK�PX@+  ~  e   nK ] hK ] iL@(   ��  e ] hK ] iLYY@	+3#'#!!!!!!�ӌ����v�T��r��w<����]��F���   �  N:   # K@H
  g  e ] hK 	] 		i	L #"!  
+"554332#3"554332#!!!!!!o����@v�T��r��wo�������F���    �  N<   �K�
PX@&   g  e ] hK ] iLK�PX@(  e  _ nK ] hK ] iL@&   g  e ] hK ] iLYY@  
	+"554332#!!!!!!1��v�T��r��wo�����F���   �  N@   jK�PX@*   ~  e   nK ] hK ] iL@'   � �  e ] hK ] iLY@+3#!!!!!!��Ś�Wv�T��r��w@��c��F���     �  N   3@0    e  e ] hK ] iL+!!!!!!!!OV���v�T��r��w����F���     ��uN�  z@
  JK�!PX@)  e ] hK ]	iK   _ mL@&  e    c ] hK ]	iLY@    $$
+!327#"&5467!!!!!!�0(n>>*@%pv/=��v�T��r�AU"X�	UY1fFժ�F���    �  X� 	 #@   e  ]   hK iL+!!!!#�o�\e���ժ�4��K     f��P� ) F@C!& J  e _ pK  _  q L %$#"	 ))+"&'& !2&&'&&#"327667#5!���M�@bVXN+U&,\-�cc00_�B3.��Rdfhd�lr�5�)8���˞�K����}L%'   f��P' 	 2 �@	*/JK�PX@.n 
  h 	 	e _ pK _qL@-� 
  h 	 	e _ pK _qLY@
 .-,+)'
22 		+ '33273"&'&476632&&'&&#"327#5!���w��w���M�OPLޏŚ+U&,\-�cc002�c�P��Rdf5�oo���hd�l� gakk�)8���˞�KNH@���}L%'     f��P<  # �@ "JK�PX@*  n �  e _ pK _	qLK�
PX@)  � �  e _ pK _	qLK�PX@,   ~  e  nK _ pK _	qL@)  � �  e _ pK _	qLYYY@! ##
+373#  4$32&&#"327#5!�����ӽX���Đ�c�QQ�`����}Q���<�������n�\�56�NH��������@���}�   f��P�    Q@N
 J  e  a _ pK  _  q L   	+  4$32&&#"327#5!3#����Đ�c�QQ�`����}Q�����ﻒ�n�\�56�NH��������@���}����     f��P<  ( �@"'JK�
PX@'   g  e _ pK _	qLK�PX@)  e  _ nK _ pK _	qL@'   g  e _ pK _	qLYY@ &%$#!(( 

+"554332#  4$32&&#"327#5!j�?���Đ�c�QQ�`����}Q���o���t�n�\�56�NH��������@���}�  �  H�  !@  e  hKiL+3!3#!#��)��������d�+��9    ��   ;@8
  e ehK	iL+#5353!533##!#5!����*ʇ��������Q���������9q��    �  �  #@ ] hK  ] iL+7!!5!!!!�9��=��9�ê�����    �  @   ^K�PX@$   ~   nK] hK] iL@!   � �] hK] iLY@+3#!!5!!!!�����9��=��9��@���r�����    �  <   �� JK�
PX@"   ��] hK] iLK�PX@%  ~   nK] hK] iL@"   ��] hK] iLYY@	+3#'#!!5!!!!	�ӌ���m9��=��9��<�����x�����    �  :   # E@B
  g] hK	] 		i	L #"!  
+"554332#3"554332#!!5!!!!]����V9��=��9��o�����;�����     �  <   �K�
PX@    g] hK] iLK�PX@"  _ nK] hK] iL@    g] hK] iLYY@  
	+"554332#!!5!!!!��9��=��9��o���;�����    �  @   ^K�PX@$   ~   nK] hK] iL@!   � �] hK] iLY@+3#!!5!!!!t�Ś�r9��=��9��@���r�����    �     -@*    e] hK] iL+!!!!5!!!!OV���9��=��9����6�����  ��u�  n@
JK�!PX@#	] hK  ]iK _ mL@   c	] hK  ]iLY@    $$
+!!327#"&5467!5!!5!�9��0(n?=*@%pv.>�s9��=+��AU"X�	UY1fF����   �  < ' 3 �K�
PX@*   g h	] hK
] iLK�PX@, h  _  nK	] hK
] iL@*   g h	] hK
] iLYY@  3210/.-,+*)( ' &)#"'$+467632326553#"'&&''&&'&#"!!5!!!!3V%49(}33U"%9	"�9��=��9��a0P ;4(d;<!	,�I�����   m����  2@/ J ] hK  _  q L 
 +"'&'5326765!5!�jY_g[adfCg8��G\�.�Q()$'J�D����e   �  ��   @	 J  hKiL+33##��w���V������h��������   �����   )@&	 J  a  hKiL+33##3#��w���V�����ﻒ��h�����������    �  s�  @   hK ^ iL+3!!����d��ժ  �  s@  	 LK�PX@   ~   nK hK ^ iL@   � � hK ^ iLY�+3#3!!������d@��c�ժ  �  s�  	 !@  ]  hK ^ iL+3!!3#����d��q���ժ���   ���s�  	 "@  a   hK ^ iL+3!!3#����d�ﻒ��ժ���  ��  s�  &@#	  J   hK ^ iL+'73%!!בP��;N�w��d;jn�����o����  V  y�  (@%
 J   ~  hKiL+!!###V�����������+'����   �  F� 	 @ J  hKiL+!3!#� ��� ����3��+��3     �  F@   P�JK�PX@   ~   nKhKiL@   � �hKiLY@	+3#!3!#ۺ��u ��� ��@��c�3��+��3    �  F<   y@ 	JK�
PX@  � �hKiLK�PX@   ~  nKhKiL@  � �hKiLYY@
+373#!3!#[����ӽ�] ��� ��<����]�3��+��3   ���F� 	  '@$ J  a  hKiL+!3!#3#� ��� ���ﻒ��3��+��3���  ��V=�  X�JK�PX@ _hK iK   ] mL@ hK _ pK iK   ] mLY@	$"% +32654&#"#363 ##�ZYt|��ʸn�t�����|�����W��������     �  F< ' 1 ��/*JK�
PX@    g 
hhK	iLK�PX@" 
h  _  nKhK	iL@    g 
hhK	iLYY@  10.-,+)( ' &)#"'$+467632326553#"'&&''&&'&#"!3!#3V%49(}33U"%9	"�� ��� ��a0P ;4(d;<!	,��3��+��3  u��\�  ! -@* _ pK _  q L !!	 +"'&7632'276'&#"h�{{|}�{�@{{@�{�DCCD��DDDD������\d��y�z�d\���LL����������    u��\@   % hK�PX@$   ~   nK _ pK_qL@!   � � _ pK_qLY@%%+3#"'&7632'276'&#"���p�{{|}�{�@{{@�{�DCCD��DDDD@����������\d��y�z�d\���LL����������  u��\<   ( ɵ JK�PX@#   n� _ pK_qLK�
PX@"   �� _ pK_qLK�PX@%  ~   nK _ pK_qL@"   �� _ pK_qLYYY@" ((	+3#'#"'&7632'276'&#"�ӌ����{{|}�{�@{{@�{�DCCD��DDDD<������������\d��y�z�d\���LL����������    u��\:   ) 9 I@F	  g _ pK_
qL+* 31*9+9!)) 
+"554332#3"554332#"'&7632'276'&#"]������{{|}�{�@{{@�{�DCCD��DDDDo�����t������\d��y�z�d\���LL����������    u��\@   % hK�PX@$   ~   nK _ pK_qL@!   � � _ pK_qLY@%%+3#"'&7632'276'&#"~�Ś�{{|}�{�@{{@�{�DCCD��DDDD@����������\d��y�z�d\���LL����������  ���  + =@: J    hjK _ pK _ qL  +)#!  #$$%+#"'!"323254'6'&#"32�	UY#&=������x-?X��CCC��CDDC��*@%pv�����}����n?=���LL����������  u��\C    " iK�PX@# ]  nK _ pK	_qL@!  e _ pK	_qLY@	""	
+3#3#"32%276'&#"����0��������DCCD��DDDDC������}������y�����LL����������   u��\    7@4    e _ pK_qL	+!!"32%276'&#"=V��*��������DCCD��DDDD��o}������y�����LL����������   ��� % 7 H A@> ED$J H%G  _   pK_ qL988H9H,* ++37&'&&54766327#"&'&'&&'&#"2676654&'&&'�	
=?@�|<c,U:�d�
{<��9f0Z=��+8YTi " Rk  #��BA�F�?�T� ac](Q�J�)l=:�V�{�^b(Q��*>*LHL��,6 $#��JDB߶4Y"!6�#N--    ���@   $ / |@.-$JGK�PX@#   ~   nK _ pK_ qL@    � � _ pK_ qLY@&%%/&/%)&+3#7&5!27#"'&&#"276654&'����� %��s�d�**���z��p[Ug %
�C #

��C@�����H���J�Q����z�����NXLFR����@���Cݾd�-�#�     u��\< ' 9 I �K�
PX@*   g 
h 		_ pK_qLK�PX@, 
h  _  nK 		_ pK_qL@*   g 
h 		_ pK_qLYY@;:)(  CA:I;I1/(9)9 ' &)#"'$+467632326553#"'&&''&&'&#""'&7632'276'&#"3V%49(}33U"%9	"��{{|}�{�@{{@�{�DCCD��DDDDa0P ;4(d;<!	,��������\d��y�z�d\���LL����������  H  ��  " ?@<  e] hK	 ]  i L "!
 
+!"&'&47663!!!!!%#"3d��;|@;<ʛR��H��q��=�E"$##E�WP���QRT��F��㪪�s9޸��:s   �  \�   *@' e  ]   hK iL' +!2###267654'&##����C>�����Kl$NNL���q;�j�qq���("J��JI��  �  ��   .@+  e e   hK iL'!+33 !##27654&'&&##���}|?=}������PN&($vS����ii�p�3i��BB�?e!#��     r����  & 2@/ J  � _ pK _   q L &&%@+"#7632#276'&#"���|}�{�@{D!hGj����DCCD��DDDD����\d��y�ܵX�$��卉LL����������    �  ��  ' 2@/
J e  ]   hKiL&$''& +!2#&&'&&###27654'&&##�����((O�Q4A,�ٲ'ES/����GGK$mK��op�Ow/^7iX�hySf��AA��E $��   �  �@   ! q�JK�PX@'   ~ e   nK ] hKiL@$   � � e ] hKiLY@ !!$!	+3#!2#.### 4&##w��������6QP7�ٲ4X_@������@��c�ɠ�7vm�hymm$������  �  �<   $ �@
 JK�
PX@%  � �	 e ] hKiLK�PX@(   ~	 e  nK ] hKiL@%  � �	 e ] hKiLYY@#!$$$!
+373#!2#.### 4&##����ӽ������6QP7�ٲ4X_@������<����]�ɠ�7vm�hymm$������    �����   ! =@:J e  a  ]   hKiL! $ 	+!2#.### 4&##3#�����6QP7�ٲ4X_@������ﻒ��ɠ�7vm�hymm$���������  ���J� 8 7@4!" J _ pK  _  q L (&	 88+"&'5327654'&&''&&'&5476632&&'&#"Hk�kqieh�VU: aKle�2^�@�rW^.e50[-]]��9�j�baF=�.,�H#"DD�k:!*D3^��w9>
�+�u3E6"/kg�r�4p  ���J@  ) s@JK�PX@#   ~   nK _ pK _qL@    � � _ pK _qLY@	))+3#"&'532654&''&&546632&#"���Rn�l�˙�s�lҺzݕ�ҹ���p�jԾ��@����--׍��et#0����mN�w�{Yl 0֯��   ���J<  H �@ -.JK�
PX@!  � � _ pK _qLK�PX@$   ~  nK _ pK _qL@!  � � _ pK _qLYY@42)'HH+373#"'&&'53276654&'&&''&&'&&546632&&'&#"G����ӽ.w^5m3qi6f2�V(-gFle�2.0zݕW^.e52\*]]Ks&R :�ja�5aF=B�<������$�H#D _E9R +D3/|T��k
� +#Cv)J7!K9g�r�497   ��uJ� Z r@GH'& JK�!PX@ _ pK _ qK  _   m L@    c _ pK _ qLY@NLCA-+" +#"'&'53254'&&'#"'&&'53276654&'&&''&&'&&546632&&'&#"�aF=^�"
<X>,+.*ER|w^5m3qi6f2�V(-gFle�2.0zݕW^.e52\*]]Ks&R :�ja��g�r�4O13U.� \ +%$�H#D _E9R +D3/|T��k
� +#Cv)J7!K  ���J� % ) B@? J  a _ pK  _  q L )('& %%+"&'532654&''&&546632&#"3#Jn�l�˙�s�lҺzݕ�ҹ���p�jԾ����ﻒ--׍��et#0����mN�w�{Yl 0֯����     /  ��  @  ] hK iL+!5!!#�+s�-�+����  /  ��  )@&  e] hK iL+!5!!5!!!!#��	�+s�-	���A�@�������  /  �<   � JK�
PX@  � �] hK iLK�PX@   ~  nK] hK iL@  � �] hK iLYY@
+373#!5!!#=����ӽ�+s�-�<����������    /�u��  [@	 J IK�!PX@] hK iK  _   m L@    c] hK iLY@	$%+!##"'53254&'#!5!!�94�UYO%�'1B�+s�-?f7��ZSD+��   ���=� + $@!hK  _  q L   +++"'&&'&&'&&533276767653hhU'S 0� =<VW<>�G!Q'%^-L92�{��m..; 9*/k��h��-a@,    ���=@  / ZK�PX@   ~   nKhK _qL@   � �hK _qLY@$#//+3#"'&&'&&'&&533276767653��嚍hU'S 0� =<VW<>�G!Q'%^@����-L92�{��m..; 9*/k��h��-a@,   ���=<  2 �� JK�
PX@   ��hK _qLK�PX@   ~   nKhK _qL@   ��hK _qLYY@'&22+3#'#"'&&'&&'&&533276767653
�ӌ���1hU'S 0� =<VW<>�G!Q'%^<������-L92�{��m..; 9*/k��h��-a@,  ���=:   C @@=	  ghK _
qL 87/-%$CC 
+"554332#3"554332#"'&&'&&'&&533276767653]�����hU'S 0� =<VW<>�G!Q'%^o�����t-L92�{��m..; 9*/k��h��-a@,    ���=<  / K�
PX@   � �hK _qLK�PX@   ~   nKhK _qL@   � �hK _qLYY@$#//+3#"'&&'&&'&&533276767653y�ŚhU'S 0� =<VW<>�G!Q'%^<����-L92�{��m..; 9*/k��h��-a@,  	��� 6 ;@80	 J    hjKhK _ qL   6 6"'*%+#"&'#"&'&&'&&5332676676533254'�	UY2 �OYdm�<$0�1;<VU��%X*@%pv��~�3iu>6!R0/�{��m.+[>9$/k��n?=     ���=<   - �K�
PX@  ehK _qLK�PX@ ]  nKhK _qL@  ehK _qLYY@	%$-	-	+3#3#"&'&&'&&533267667653����-m�<$0�1;<VU�� �OY<������>6!R0/�{��m.+[>9$/k��h~�3iu    ���=  ) .@+    ehK _qL! ))+!!"&'&&'&&533267667653=V��-m�<$0�1;<VU�� �OY��o>6!R0/�{��m.+[>9$/k��h~�3iu    ��e=� 6 <@9 J IhK  _   qK _ mL   6 6'$$+327#"&5467&&'&&'&&53326766765= �OAK,$n?=*@%pv*:V�2$0�1;<VU���h~�3iu=P X�	UY/dA;-!R0/�{��m.+[>9$/k�     ���=m   A yK�PX@$ _ nK  ]	hK _
qL@( _ nKhK  _	hK _
qLY@ 980.'&AA	 +"&&546632'2654&#""&'&&'&&533267667653sM}II}MM}HH}N?YY?@WW8m�<$0�1;<VU�� �OYHJ|ML|JJ|LM|J{Y??XW@AW� >6!R0/�{��m.+[>9$/k��h~�3iu     ���=<  A �K�
PX@%   g 
h	hK _qLK�PX@' 
h  _  nK	hK _qL@%   g 
h	hK _qLYY@  980.'&AA  $""$"+4632326553#"&''&#""&'&&'&&533267667653e^(=&9+(}`] ?.9+"(�m�<$0�1;<VU�� �OYafu2*by!2-��>6!R0/�{��m.+[>9$/k��h~�3iu  9  ��  @ J  hK iL+33#9�^_��K����+�+       ��  E�
JK�PX@  hK kKiL@   ~  hKiLY�+333##ŏ�Ӭ��߿�ʿ��D"����+w��     �@   ��	JK�PX@   ~   nKhK kKiLK�PX@   � �hK kKiL@   � � ~hKiLYY@
+3#333##����%ŏ�Ӭ��߿�ʿ@��c�D"����+w��      �<   �@ 	JK�
PX@   ��hK kKiLK�PX@   ~   nKhK kKiLK�PX@   ��hK kKiL@    �� ~hKiLYYY@+3#'#333##
�ӌ�����ŏ�Ӭ��߿�ʿ<����]�D"����+w��       �<   $ ÷"JK�
PX@
	  ghK kKiLK�PX@ 
	  _nKhK kKiLK�PX@
	  ghK kKiL@! ~
	  ghKiLYYY@ $#!  
+"554332#3"554332#333##^�����ŏ�Ӭ��߿�ʿr������D"����+w��       �<   ��	JK�
PX@   � �hK kKiLK�PX@   ~   nKhK kKiLK�PX@   � �hK kKiL@   � � ~hKiLYYY@
+3#333##y�Ś��ŏ�Ӭ��߿�ʿ<��_�D"����+w��    ��  @	 J  hKiL+33##�P�HN��A�����u����3�B����}     %  ��  @  J  hK iL+33#�#�lk��!��7�m����b     %  �<   l�
JK�
PX@   � �hK iLK�PX@   ~   nKhK iL@   � �hK iLYY�+3#33#���'�#�lk��!�<���j7�m����b    %  �<   v@ 
JK�
PX@   ��hK iLK�PX@  ~   nKhK iL@   ��hK iLYY@	+3#'#33#
�ӌ�����#�lk��!�<�����l7�m����b  %  �<     ��JK�
PX@  ghK iLK�PX@  _nKhK iL@  ghK iLYY@   
	+"554332#3"554332#33#]������#�lk��!�q�����-7�m����b    %  �<   l�
JK�
PX@   � �hK iLK�PX@   ~   nKhK iL@   � �hK iLYY�+3#33#y�ŚZ�#�lk��!�<���j7�m����b    n  c� 	 )@&  J   ] hK ] iL+7!5!!!n�����"������o�    n  c<   �@
	JK�
PX@   � � ] hK ] iLK�PX@"   ~   nK ] hK ] iL@   � � ] hK ] iLYY@	+3#!5!!!����������"�<���f����o�    n  c<   �@ JK�
PX@   � � ] hK ] iLK�PX@#   ~  nK ] hK ] iL@   � � ] hK ] iLYY@
+373#!5!!!	����ӽ�������"�<�����h����o�    n  c<   �@
JK�
PX@   g ] hK ] iLK�PX@   _ nK ] hK ] iL@   g ] hK ] iLYY@  
+"554332#!5!!!#��������"�o���+����o�    ���a{ # 0 {@!JK�PX@   e _ sK _  q L@$  e _ sK iK _  q LY@%$ +)$0%0 ##	+"&54663354&#"56632#&&''26655#"��ӌ����f�U\�bd��&�;�Gr�B�N�a�����B�p82�",7}iJ��^�X'Y*eb�p�h)#b^ji  ���a�  ; J.@
JK�PX@.   � �  f _ sK iK
_	qLK�
PX@*   � �  f _ sK
_	qLK�PX@.   � �  f _ sK iK
_	qLK�PX@*   � �  f _ sK
_	qL@.   � �  f _ sK iK
_	qLYYYY@=<CA<J=J20;;+3#"'&&54763354'&#"5667632#&'&&''27655#"�����#�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=S�����a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8    ���a/ 
 B Q�@
JK�PX@3   h  
	
ejK _ sK iK		_qLK�
PX@/   h  
	
ejK _ sK		_qLK�PX@3   h  
	
ejK _ sK iK		_qLK�PX@/   h  
	
ejK _ sK		_qLK�%PX@3   h  
	
ejK _ sK iK		_qL@3�   h  
	
e _ sK iK		_qLYYYYY@%DC JHCQDQ97%#BB	 

+ 33273"'&&54763354'&#"5667632#&'&&''27655#"k��w[[�w�s�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=SHN�����a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8     ���a�  > M8@ JK�PX@/   ��  		e _ sK iK_
qLK�
PX@+   ��  		e _ sK_
qLK�PX@/   ��  		e _ sK iK_
qLK�PX@+   ��  		e _ sK_
qL@/   ��  		e _ sK iK_
qLYYYY@@?FD?M@M53!>>+3#'#"'&&54763354'&#"5667632#&'&&''27655#""������կd06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=S�������a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8   ���a   O ^P@
,+JK�PX@2  
	
e  _jK _ sK iK		_qLK�
PX@.  
	
e  _jK _ sK		_qLK�PX@2  
	
e  _jK _ sK iK		_qLK�PX@.  
	
e  _jK _ sK		_qL@2  
	
e  _jK _ sK iK		_qLYYYY@)QP WUP^Q^FD20(&" OO 
+"554332#3"554332#"'&&54763354'&#"5667632#&'&&''27655#"`������d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=SF������a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8  ���a�  ; J.@
JK�PX@.   � �  e _ sK iK
_	qLK�
PX@*   � �  e _ sK
_	qLK�PX@.   � �  e _ sK iK
_	qLK�PX@*   � �  e _ sK
_	qL@.   � �  e _ sK iK
_	qLYYYY@=<CA<J=J20;;+3#"'&&54763354'&#"5667632#&'&&''27655#"��^�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=S�����a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8    ���a�  ; J.@
JK�PX@.  e  ]   hK _ sK iK
_	qLK�
PX@*  e  ]   hK _ sK
_	qLK�PX@.  e  ]   hK _ sK iK
_	qLK�PX@*  e  ]   hK _ sK
_	qL@.  e  ]   hK _ sK iK
_	qLYYYY@=<CA<J=J20;;+!!"'&&54763354'&#"5667632#&'&&''27655#"@V����d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=Sؔ��a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8     ��x�{ H W �@*)  JK�PX@(  e _ sK _ qK  _ mL@%  e   c _ sK _ qLY@ TRKI0.&$  HH	+27#"&5467&'&&'#"'&&54763354'&#"5667632##"327656>>*@%pv.<	[,]{�d06~|��DB�_`bY*f4Y^�d.SC/'[�SR=S:�WX���	UY2cF:-2N0a.}X�ba�><4� *=(@G��:X&*J7@T!X@88rd8jk�    ���a   T cd@
10JK�PX@6  g  g  
	
e _ sK iK		_qLK�
PX@2  g  g  
	
e _ sK		_qLK�PX@6  g  g  
	
e _ sK iK		_qLK�PX@2  g  g  
	
e _ sK		_qL@6  g  g  
	
e _ sK iK		_qLYYYY@)VU \ZUcVcKI75-+'%TT	 +"'&547632'2654&#""'&&54763354'&#"5667632#&'&&''27655#"krPPPOsuOOOPt@XXA?+,X+�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=S�PPssPOOOttOP{X@?X+,@@X��a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8   ���aU $ \ k�@
9	8JK�PX@9   g  e_ hK 	_ 		sK 

iK_qLK�
PX@5   g  e_ hK 	_ 		sK_
qLK�PX@9   g  e_ hK 	_ 		sK 

iK_qLK�PX@5   g  e_ hK 	_ 		sK_
qLK�%PX@9   g  e_ hK 	_ 		sK 

iK_qL@7   g 	h  e 	_ 		sK 

iK_qLYYYYY@$^]&%  db]k^kSQ?=53/-%\&\ $ $(#'#+67632327673#"'&''&&'&#""'&&54763354'&#"5667632#&'&&''27655#""33Z&" %9&}33Z&" %9&c�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=S;�KJ 7

%&P�KJ 7	%%Q��a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8  )���{ A M \ d@a>67 J	g_sK
 _  q LONBB VTN\O\BMBMJH;931&%!	 AA+"'&&546763354&#"5667632632!32767#"'&'54&'&&#"276655#"f�Q+'/5e�ub^<?C&H!?@[=>%E��GH�R8JC?3<zOkJK 'BCC>/WL��^%1�<<--V-}MU�/YXx�
� @vw��Zbs"&!3�+)))NO)(�4Nl $��+��C tfH-/m[01  ���X  ' k�JK�PX@ jK _ sK _  q L@! jK _ sK iK _  q LY@ ''	 +"'#36632'2>54.#"��`��.�ex�c+,c��Xk77kXWk99k����WSg��hiѬh�R��DD��RR��DE��R  ���{  7@4 J _ sK  _  q L 	 +"&54632&&#"3267���{|�]�NG�[��GH��X�B��
��	�++�?<t�xw�t:?�V    ����  * C@@$%J   � � _ sK _qL**+3#" 467632&'&#"3267667/��������MF��[GIRLFLZ�]]+2_�2S#-A"P&#S�����9��J�-�Cpq�`�<q-�"
     ����  - I@F '(J  � � _ sK _qL" --+373#" 467632&'&#"3267667d������n���MF��[GIRLFLZ�]]+2_�2S#-A"P&#S�������9��J�-�Cpq�`�<q-�"
    ��u{ ? x@; < %$JK�!PX@   _ sK _ qK _ mL@  c  _ sK _ qLY@ 86/.(&!
 ??+"3267667#"'&'53254'&&'&'&467632&'&ή]]+2_�2S#-A"P&)'<X>+,.*ER|憒MF��[GIRLFL�pq�`�<q-�"	.-3U.� \ +'����J�-�C     ���  # J@G!"J  _ jK _ sK _qL  ## 
+"554332#   !2&&#"327K�����%Q�NI�]������D����88)-�A:����y�V     {��  % k�JK�PX@ jK _ sK _  q L@! jK _ sK iK _  q LY@ %%	 +".5323#''2>54.#"*z�c,��b�.��c�Wk99kWXk77kh��k8SWC�썪�R��ED��RR��DD��S     ���H % 8 h@JK�(PX@ jK _ kK _  q L@  h jK _  q LY@'& 31&8'8	 %%+"'&323&&&'&&''7'3%'27654&'&&'&#"i�}��,%�����!!��[.-}@�q�IJ;1-)&��JI��	(;+\bPȑ^bPӿ`�l���LH�jm�s�F���kj    ]��     y�JK�PX@#  ]  jK _ sK	_qL@'  ]  jK _ sK iK	_qLY@	
+3#"323#'' ! Z�q��������[��]��������F;7�C�썪����P�P  {���  / ��	JK�PX@'e jK 		_ sK _
  q L@+e jK 		_ sK iK _
  q LY@ (&//	 +"&'&32!5!533##''27654'&&#"/j�6t��fLM,��1����:)MJ�EEE dG�CDD#fTJ�9+,S5y��y���(?,�nm��n3:mn��n94   |��Y{   C@@ J e _ sK  _  q L  +  4632!32674&&#"�����u����㸴h�[_Õ8{ef�M
7�����Z��B/�'/�]�XY�\  |��Y�  # - O@LJ   � �	 e _ sK _qL$$$-$-*(##
+3#  4676632!327667&&'&#"���������LCI�q����`.�[\]1f65l)0`�)!H��UU�����9��KQO���Z�e04+�"	
�V{&TXX�    |��Y�   # U@R J  � �
 f _ sK _	qL##!+373#  4632!327&&#"M������b���ۂ���������j�������������:�	����Z��q�++�����     |��Y�  & 0 U@R  !J   ��
 e _ sK _	qL'''0'0-+&&+3#'#  4676632!327667&&'&#".������m����LCI�q����`.�[\]1f65l)0`�)!H��UU�������9��KQO���Z�e04+�"	
�V{&TXX�  |��Y   7 A a@^12J	 	e
  _jK _ sK _qL88 8A8A><-+&%" 77 
+"554332#3"554332#  4676632!327667&&'&#"l��������LCI�q����`.�[\]1f65l)0`�)!H��UUF������9��KQO���Z�e04+�"	
�V{&TXX�   |��Y  ! ( V@SJ
 e  _ jK _ sK _	qL"" "("(&$!! 
+"554332#  4632!327&&#".����ۂ���������j������D����:�	����Z��q�++�����  |��Y�  # - O@LJ   � �	 f _ sK _qL$$$-$-*(##
+3#  4676632!327667&&'&#"&��:����LCI�q����`.�[\]1f65l)0`�)!H��UU�����9��KQO���Z�e04+�"	
�V{&TXX�    |��Y�     O@LJ	 e  ]   hK _ sK _qL  

+!!  4632!327&&#"aV��D���ۂ���������j������ؔ��:�	����Z��q�++�����  �  NE 	  �K�PX@, 
  h  enK ] hK 	] 		i	L@,� 
  h  e ] hK 	] 		i	LY@ 
 		+ '33273!!!!!!���w��w�v�T��r��wS�oo�~��F���   |��Y1  . 8 �@
)*JK�#PX@. 
  h	 	ejK _ sK _qL@.� 
  h	 	e _ sK _qLY@#// /8/853%#.. + 3327673  4676632!327667&&'&#"���w0.YW.0wOPo����LCI�q����`.�[\]1f6gc0`�)!H��UUL%%%%L�HH��9��KQO���Z�e04+�*
�V{&TXX�    |�uY{ ( / �@  JK�!PX@)  e	_ sK   _ qK _ mL@&  e  c	_ sK   _ qLY@*)  -,)/*/ ( (%&$)#
+327327#"&5467#  4632"%&&<����.X+/(n>>*@%pv%2$)���ۂ����.��^���q�AT"X�	UY,];:�	����Zۭ���  �    )@& ] jK  ]kK iL!#+!5!54633#"!!#���+����bN���яN���Qgc��/     ��H.{ ! /	@ JK�PX@& kK _ sK_ iK  _  u LK�
PX@" _sK_ iK  _  u LK�PX@& kK _ sK_ iK  _  u LK�PX@" _sK_ iK  _  u L@& kK _ sK_ iK  _  u LYYYY@#" +)"/#/ !!	+"&'5326655#".54>32732654.#"WQ�OL�Xlx1-�hw�e..f�xe�1��デ7jV����H�$6V�c�`Zf��ff̩fT\������I��C�P����     ��H.1  7 E�@1!	
JK�PX@5   hjK kK 

_ sK		_ iK _uLK�
PX@1   hjK 

_sK		_ iK _uLK�PX@5   hjK kK 

_ sK		_ iK _uLK�PX@1   hjK 

_sK		_ iK _uLK�#PX@5   hjK kK 

_ sK		_ iK _uL@5�   h kK 

_ sK		_ iK _uLYYYYY@%98 A?8E9E32.,&$77 + 3327673"&'&'53276655#"'&7632732654'&&#"���w0.YW.0wOP�'N*OW1[&LK�E!#,LLl�uuuv�iLJ0�wvӂ�C#e>���L%%%%L�HH�6�"R({]�^..����+*[������I���j92����  ��H.�  ! ,G@ 	
	JK�PX@1  � � kK 		_ sK_ iK `
uLK�
PX@-  � � 		_sK_ iK `
uLK�PX@1  � � kK 		_ sK_ iK `
uLK�PX@-  � � 		_sK_ iK `
uL@1  � � kK 		_ sK_ iK `
uLYYYY@#"(&",#,!!+373#"'532655#"&5463273265!"E��������d�I��Vׅ�jiĆ�Z��>�������������77�/+������������� I�������   ��H.j   )3@JK�PX@.    e kK _ sK
_ iK `	uLK�
PX@*    e _sK
_ iK `	uLK�PX@.    e kK _ sK
_ iK `	uLK�PX@*    e _sK
_ iK `	uL@.    e kK _ sK
_ iK `	uLYYYY@ %#) )	+3#"'532655#"&5463273265!"��^�W��d�I��Vׅ�jiĆ�Z��>�������j���77�/+������������� I�������   ��H.  & 1H@"JK�PX@1	  _ jK kK _ sK_ iK `
uLK�
PX@-	  _ jK _sK_ iK `
uLK�PX@1	  _ jK kK _ sK_ iK `
uLK�PX@-	  _ jK _sK_ iK `
uL@1	  _ jK kK _ sK_ iK `
uLYYYY@!(' -+'1(1$#!&& 
+"554332#"'532655#"&5463273265!";�s��d�I��Vׅ�jiĆ�Z��>�������D���7�/+������������� I�������    �    '@$J   jK _ sKiL#"+3632#4&#"#øe抓8�jphu0���À�w�J���g�Y��   F    5@2
J  e jK _ sKiL#"	+#5353!!63 #4&#"#�}}�a��b�T�iq�����zz�����;�J������� ��D   ;@8  _ jK ] kK ]iL  
+"554332#"&5#5!33������\X�+������B��.z��    ��D`  (@% ] kK  ]  i L 	 +"&'&5#5!33[P0[��..X�28j�B��.~=?�   ��Do   4@1   � � ] kK ]iL
+3#"&'&5#5!33����ZP0[��..X�o���28j�B��.~=?�  ��Dp   <@9 J   �� ] kK ]iL+3#'#"&'&5#5!33������OP0[��..X�p����� 28j�B��.~=?�   ��D   ( F@C	  _jK ] kK ]
iL '%! (( 
+"554332#3"554332#"&'&5#5!33H���P0[��..X�F������28j�B��.~=?�   ���Do   4@1   � � ] kK ]iL
+3#"&'&5#5!33���<P0[��..X�o���28j�B��.~=?�   ��D�   ]K�(PX@   ]   hK ] kK ]iL@    e ] kK ]iLY@
+!!"&'&5#5!33V��OP0[��..X�����28j�B��.~=?�   �  E 	  uK�PX@& 
  hnK] hK	] 		i	L@&� 
  h] hK	] 		i	LY@ 
 		+ '33273!!5!!!!g��w��w�?9��=��9��S�oo��W����� ��D1    sK�#PX@%   hjK ] kK ]	iL@%�   h ] kK ]	iLY@    
+ 3327673"&'&5#5!33]��w0.YW.0wOOmP0[��..X�L%%%%L�HH��28j�B��.~=?�   ��H  , �@JK�PX@+  _ jK ] kK ] iK	_ mL@(	 c  _ jK ] kK ] iLY@ ('&$ ,, 

+"554332#27#"&5467&'&5#5!33#!!�!!4>>*@%pv)4�O[��..Xל("+�����	UY/]@\j�B��.~=?�9L X ��D  + H@E 
h  _  jK ] kK 		]iL  *($#"!++  #"$"+4632327673#"''&#""&'&5#5!33e^GD9 $}e^GD9($�P0[��..X�냗=7%&P��=7'%%Q�28j�B��.~=?�     ��VD   6@3  _ jK ] kK ] mL  
+"554332#325!5!##�����������+����������   �  �  $@!	J   jK kKiL+33##����G���b���{��Z�FB��?   ����   -@*	J  a   jK kKiL+33##3#����G���b���ﻒ�{��Z�FB��?���    ���  (@% ] jK  ]  i L 
 +"&5!5!335�����\X������zz��    ���
X   bK�0PX@#   ~   nK ] jK ]iL@    � � ] jK ]iLY@
	+3#"&5!5!33A�������ߴ�X���������z��     ����   8@5 ]jK ]jK  ]  i L 	 +"&5!5!333#!����ߴ�K�q������z����     ���
   3@0  a ] jK  ]  i L 	 +"&5!5!333#!����ߴ���ﻒ�����z�����  L��
  5@2	J ] jK  ]  i L 
 +"&'&5'!5!%33!P0[��P{���;P�u..X�28j�$�o,����n���_~=?�    m  o{ ( O� JK�PX@ _  kKiL@   kK_sKiLY@%%""+3632632#4&'&#"#4&'&#"#m�D��8D��67�JL�JJ�``{��fi���w�~�!7<#�{��y�!8;"�x�     �  {  D�JK�PX@  _  kKiL@   kK _ sKiLY�#"+363 #4&#"#æe�W�in���`���;�J�������     �  �   [�JK�PX@   � � _kKiL@    � � kK _ sKiLY@
#"+3#363 #4&#"#�����Ԧb�T�iq����������;�J�������  �  �   c@
 	JK�PX@  � � _kKiL@!  � � kK _ sKiLY@#"+373#363 #4&#"#���������b�T�iq������������;�J�������   ���{   U�JK�PX@  a  _  kKiL@  a   kK _ sKiLY@
#"+363 #4&#"#3#æb�T�iq���cﻒ`���;�J����������  ��V{  X�JK�PX@ _kK iK   ] mL@ kK _ sK iK   ] mLY@	$"$ +3254&#"#363 ##���iq����b�T������ʗ�����`���;�6��    �    $ : �'	JK�PX@' h  _  jK 		_kK
iL@+ h  _  jK kK 		_ sK
iLY@  :9530/*(&% $ $(#'#+67632327673#"'&''&&'&#"3632#4&#"#33Z&" %9&}33Z&" %9&ئe�Z~)T�jr�DF��KJ 7

%&P�KJ 7	%%Q���:6q��J���[[���   ���H{   -@* _ sK _  q L  +"32'2654&#"j�������鉓�����/0�������Ӝ��������  ���H�   $ 9@6   � � _ sK_qL$$+3#"'&&57632'27654'&#"�������|?<{{��z{{y�HHHH��HHHH����ҖN݌�������ܔ��nm��nmmn��mn    ���H�   ' A@> J   �� _ sK_qL!''	+3#'#"'&&57632'27654'&#"������?�|?<{{��z{{y�HHHH��HHHH������ҖN݌�������ܔ��nm��nmmn��mn    ���H   ( 8 K@H	  _jK _ sK_
qL*) 20)8*8" (( 
+"554332#3"554332#"'&&57632'27654'&#"]������|?<{{��z{{y�HHHH��HHHHF�������N݌�������ܔ��nm��nmmn��mn  ���H�   $ 9@6   � � _ sK_qL$$+3#"'&&57632'27654'&#"���|?<{{��z{{y�HHHH��HHHH����ҖN݌�������ܔ��nm��nmmn��mn     ���{  $ gK�1PX@     h _sK_ qL@$    hkK _ sK_ qLY@  " $$  "$%5	+#"&'#"3 3254' ! �	UY������w)"X������q*@%pv`v����+ /�n?=����P�P     ���H�     ;@8  e _ sK	_qL		
+3#3#"32' ! ������0���������������x����+ /�������Ӝ���P�P   ���H�    9@6  ]   hK _ sK_qL	+!!"32' ! =V��+������������ה��+ /�������Ӝ���P�P   u��\' 	  + zK�PX@'n   h _ pK
_	qL@&�   h _ pK
_	qLY@
 %#++
 		+ '33273"'&7632'276'&#"h��w��w���{{|}�{�@{{@�{�DCCD��DDDD5�oo���������\d��y�z�d\���LL����������    ���H1    0 yK�#PX@&   hjK _ sK
_	qL@&�   h _ sK
_	qLY@"! *(!0"0   + 3327673"'&&57632'27654'&#"h��w0.YW.0wOP��|?<{{��z{{y�HHHH��HHHHL%%%%L�HH�іN݌�������ܔ��nm��nmmn��mn   /���� ! / ? @@= :9/ J H!G  _   sK_ qL100?1?)/)+7&&'&576327#"&'&'&'&#"27654'&&'/�
{{�1]&%G�]�*{{�7W&P8��!34A�J$'�HH�1)6�*P/_s��*�M�C__z�ܔ�<��0k4�g77;F�nm�878$��    /����   ! * L@I)(!JG   � � _ sK_ qL#""*#*%(&+3#7&5327#"'&&#"2654&'������T�P���u�]�V���q��$e=�����1H�����Ȕ�-o�MÇ�����w��2,��9sH���<n:��^   ���H  $ 5 E M@J 
h  _  jK 		_ sK_qL76&%  ?=6E7E/-%5&5 $ $(#'#+67632327673#"'&''&&'&#""'&&57632'27654'&#"33Z&" %9&}33Z&" %9&��|?<{{��z{{y�HHHH��HHHH�KJ 7

%&P�KJ 7	%%Q�ݖN݌�������ܔ��nm��nmmn��mn  ���{ , A M Y@V (! J	 	e_sK _
  q LBB.- BMBMIG75-A.A'%	 ,,+"&'&467632632!326767#"''276654&&#"4654&#"qc�)V,)U�[>@/K��HH�21r%J!A/A<P�`8>Wh(#QD7DG�PVW&'HB�7��C� @vw��ZT�JH4�!�&/!�T*����H+()����*.&+��DE�+  ��VT{   a�JK�PX@  _  kK_ qK mL@    kK _ sK_ qK mLY@$"+3632#"'# !"��`������[�������`���������Ī��)������  ��VT   9@6J   jK _ sK_ qK mL%"+3632#"&'&'# !"��`���tt�9T%M,����EEEE��������훜-Q��)��mn��mn     ��Rw   a� JK�PX@ _sK _   qK mL@  kK _ sK _   qK mLY@&!+%#".53273#2654&#"f^�x�d,���^���󁌋������g��g?����)��������    .  G{  G@ JK�PX@  _  kK iL@   kK _ sK iLY�##+36632&#"#.�/���fl����`�wF�X����  .  G�   ^@JK�PX@   � � _kK iL@   � � kK _ sK iLY@	##+3#36632&#"#6�����-���is���������t�F�X���� .  G�   e@ 	JK�PX@  � � _kK iL@   � � kK _ sK iLY@
##+373#36632&#"#Q��������-���is�����������t�F�X����   ���G{   X@ JK�PX@  a  _  kK iL@  a   kK _ sK iLY@	##+36632&#"#3#.�-���is����ﻒ`�t�F�X�������     ���{ " 7@4 J _ sK  _  q L  ""+"'532654&''&&54632&#"M��Ҥu�u�M���ˬ����*vsJ�F�jbRGW ���B�\�6?+7���   ����  * C@@J   � � _ sK _qL	**+3#"&'532654&/&&54632&&#"����VW�jͪz�p�E���έ�Q�Z�.sXJ������##�jdPDY �{��B�..�K$#5���    ����  D J@G ,5-J  � � _ sK _qL20(&DD+373#"'&&'53276654&/&&'&5476632&'&#")������/\X'i5@Z+.V.yD# vEKu(Im9�bZQ&S*OPQVy=>1kcJ�CF=9=��������� #2F$FW2(I��V.)�/()T&5'"LL�V-0.   ��u{ V s@FOG'& JK�!PX@ _ sK _ qK  _   m L@    c _ sK _ qLY@LJB@.," +#"'&'53254'&&'#"'&&'53276654&/&&'&5476632&'&#"�F=9Pt!<X>,+.*ER|\X'i5@Z+.V.yD# vEKu(Im9�bZQ&S*OPQVy=>1kcJ�L�V-?33U.� \ +%� #2F$FW2(I��V.)�/()T&5'"   ���{ & * B@? J  a _ sK  _  q L *)(' &&+"&'532654&/&&54632&&#"3#KW�jͪz�p�E���έ�Q�Z�.sXJ���ﻒ##�jdPDY �{��B�..�K$#5������   ���} F tK�PX@3  J@3 JYK�PX@ _ jK  _  q L@ _ jK iK  _  q LY@ 0.*)%#	 FF+"'&&'53276654'&&''&&'&&546767&'&#"#47632�IAJ%HGB<l?#"M1C/D()O�<>py99�ij��hi�UT.:Oc74<q�0D-=0#:'@ "E-<l+U#k99AB���q�ggno�?=c1(%%2Q,SpJ~/X     ����  3@0	H]kK  ]  i L 
 +"&5!5!7!!33'Ϋ��+���^^u���d�%P�����{c�    ����  E@BH	e]kK 		 ]
  i L 
	 +"&55#535!5!7!!3#33'Ϫ����+���^��^u�����/F�����|b�    ����   ?@< J    e]kK ]iL
		+3#"'&5!5!7!!334�q�8�VU��+���^/.v������SR�d�%P�����{21�   ���� % p@J"!HK�PX@"]kK   ] iK _ mL@  c]kK   ] iLY@   % %$$$	+33##"'53254&'&'&5!5!7!f/.v��0,�VXO%�#*�@U��+�����{21�8]3��ZJ>?R�d�%P���     ���^  P�JK�PX@kK  `  q L@kK iK  `  q LY@  + 332653#'���ۀ���d���J�۹�y����  ���l   f�JK�PX@   � �kK `qL@!   � �kK iK `qLY@
	+3#"'&53327653#'�����;�TT�6O<�EE��1TVl����qp���J�F"%\[�y���a22   ���l   n@
 JK�PX@   ��kK `qL@"   ��kK iK `qLY@	+3#'#"'&53327653#'��������TT�6O<�EE��1TVl������qp���J�F"%\[�y���a22    ���   0 |�-JK�PX@!
	  _jKkK `qL@%
	  _jKkK iK `qLY@! ,+*)%#00 
+"554332#3"554332#"'&53327653#']������TT�6O<�EE��1TVF������qp���J�F"%\[�y���a22     ���l   f�JK�PX@   � �kK `qL@!   � �kK iK `qLY@
	+3#"'&53327653#'��F�TT�6O<�EE��1TVl����qp���J�F"%\[�y���a22   '���q ! �@  JK�PX@    hkK `iLK�PX@     hkK iK ` qL@$    hkKkK iK ` qLYY@   ! !"#"%	+#"'#'# 3326533254'�	UY=@�c����kp���4$Xq*@%pv%�ߨ����J����y�n?=  ���l    h�JK�PX@  ekK `	qL@!  ekK iK `	qLY@		
+3#3# 332653#'����������kp����cl��x�������J����y����  ����   ��JK�PX@  ]   hKkK `qLK�%PX@!  ]   hKkK iK `qL@    ekK iK `qLYY@+!! 332653#'=V������kp����c�������J����y����   ��u�^ # �K�PX@  JI@  JIYK�PX@kK `iK  _ mLK�!PX@!kK iK ` qK  _ mL@   ckK iK ` qLYY@  ##+27#"&5467#5# 33265334>>*@%pv/=Ec����kp���0(���	UY1fF�����J����y��AU"X   ����   - ��,JK�PX@%  g
	  gkK `qL@)  g
	  gkK iK `qLY@! +*)(%# --	 +"&&546632'2654&#" 332653#'xM}II}MN|HH|O?YY?@WW!���kp����c�J|ML|JJ|LM|J{Y??XW@AW�����J����y����    ���  , ��+JK�PX@( h  _  pK	kK `
qLK�PX@( h  _  jK	kK `
qL@, h  _  jK	kK 

iK `qLYY@  *)('$",,  #"$"+4632327673#"''&#" 332653#'e^GD9 $}e^GD9(${���kp����c郗=7%&P��=7'%%Q�����J����y����    d  m`  @ J  kK iL+33#d�EF��r�`�T���       �`  (@%
J   ~  kKiL+333##�à��ö������`�wB�����f��     �o   7@4	J   ~ ~kK   ]iL+3#333##4������à��ö������o����wB�����f��     �o   :@7 	J   �� ~kKiL+3#'#333##�������׶à��ö������o������wB�����f��       ��   $ K@H"J ~
	  _pKkKiL $#!  
+"554332#3"554332#333##]������à��ö������(������wB�����f��      �o   7@4	J   ~ ~kK   ]iL+3#333##�����à��ö������o����wB�����f��   L  �`  @	 J  kKiL+33##�o�)'��o�������H�k�������?     h�V�`  "@ JkK   ^ mL, +3276733##�mQ,1F�O�LG���#	'EZ����.3�N��l�ZC$( m�*�     h�V�n   .@+J   � �kK ^ mL-!+3#326766733##�������m->8'�O�LG���,+	2A4#V)�n����plN��l�pp8��'63   h�V�o    4@1 J   ��kK ^ mL+!+3#'#326766733##+������}m->7(�O�LG���4:,�d�o������plN��l�HH.<:��(KQ  h�V��   5 D@A"J	  _pKkK ^ mL 53$#!  

+"554332#3"554332#326766733##]����Em->8'�O�LG���	(4
6'E\�(������plN��l�JI"15lC&;'   h�V�o   .@+J   � �kK ^ mL-!+3#326766733##�����m->8'�O�LG���!	,2
+�^�o����plN��l�PT(&)t~>KQ   �  b 	 &@#  J   ] kK ] iL+7!5!!!����-�}����%���ܖ   �  q   2@/	J   � � ] kK ] iL+3#!5!!!J���������-�}���q����%���ܖ     �  q   8@5 J  � � ] kK ] iL+373#!5!!!)�����������-�}���q������%���ܖ    ���n  %@"  � ] jK   ] k L!$+!5!547633#"#5��SUW���6A'�яN�UW�)g�/  �  �   =@:J  _ pK ] kK ] iL  
+"554332#!5!!!�����-�}���*����%���ܖ    ��� # 2 6 Z@W J   ~  g
	  g  a _ L%$ 6543+)$2%2	 ##+"'&54763354'&&#"5676632#''27655#"!!#}MK]^��<#X-=<@BDD"?&�XW�2@?:hBA�=>,���d�DDs�GF[- VT��@pA!!wHGs"#M$1'�{     ����  & * <@9  g  g U ] M *)(' &&
 +"&'&&5476632'276654'&&#"!!h^�-/6e/�[Z�/dd/�[f:9O6g9:::���\�>13�b�q4<<5p��p4<uN$lI�N%)MO��ML�{    %  ��  
 +@(	 J f   2K3L

+3#!#����n��l�����+��{'��   �  q�   0@-  e  ]   2K] 3L&!+!!3!!%2654&##���E�{e�����F������զ�>�5�A�Ц{�����   �  q�    =@:J e  ]   2K] 3L( +!2!!2654&##2654&##�����������F�����ﰖ����ƹ��(Τ�imozte�>�9{�����  �  s�  @  ]   2K 3L+!!#���/�ժ��  �  s<  	 oK�
PX@   � � ] 2K 3LK�PX@   ~   7K ] 2K 3L@   � � ] 2K 3LYY�+3#!!#������/�<��_���     �  s  ?K�PX@   n  ]   2K 3L@  �  ]   2K 3LY�+!3!#����/��2�$��     !����   1@. Q ] 2K  ] 3L	+732>5!3#!#!3!M#Ty��ŪK�B/�k���l����B������Z�Գp     �  N�  )@&  e  ]   2K ] 3L+!!!!!!�v�T��r��wժ�F���     �  N<   �K�
PX@'   � �  e ] 2K ] 3LK�PX@*   ~  e   7K ] 2K ] 3L@'   � �  e ] 2K ] 3LYY@+3#!!!!!!y�Ś�iv�T��r��w<��_��F���     �  N<   # �K�
PX@)
  g  e ] 2K 	] 		3	LK�PX@+  e
  _7K ] 2K 	] 		3	L@)
  g  e ] 2K 	] 		3	LYY@ #"!  
+"554332#3"554332#!!!!!!�����v�T��r��wq�������F���      ��  '@$	 J  2K3L+333##'#?�������0��Y�Y��{Z��S��S�������0к�v     ���7� ' J@G" J  e _ 9K  _  : L  ''+"'532654&##532654&#"56632)��g�`����������L�ly�N��w������J�63�����ytoy&*�  c�x�E'Ƙ��     �  F� 	 @ J  2K3L+3!#!��� ��� ��3��+��3     �  F; 	  ��JK�PX@n   h2K3LK�PX@   h7K2K3LK�PX@n   h2K3L@�   h2K3LYYY@ 
 			+ '332733!#!h��w��w� �� ��� I�oo�t�3��+��3    �  F;   p�JK�PX@   � �2K3LK�PX@   ~   7K2K3L@   � �2K3LYY@	+3#3!#!y�Ś�/�� ��� ;��^�3��+��3    �  ��   @	 J  2K3L+33##��w���V������h��������   �  �;   s@		JK�PX@   � �2K3LK�PX@   ~   7K2K3L@   � �2K3LYY@	+3#33##������w���V����;��^�h��������       P�  !@ ] 2K   _3L+72667>5!#!#^o5.��h59f��=��=��f��++�M����Cw  V  y�  (@%
 J   ~  2K3L+!!###V�����������+'����   �  H�  !@  e  2K3L+3!3#!#��)��������d�+��9  u��\� 
  -@* _ 9K _  : L  

+"32%276'&#"g��������DCCD��DDDD}������y�����LL����������     �  H�  @  ]   2K3L+!#!#��������++��  �  u�   *@' e  ]   2K 3L
		
" +! !##2654&##��������������A�B���������  ���1�  7@4 J _ 9K  _  : L 
 +"&'&4$32&'&#"!2767��P���a�OIVWV�bb�VWTIOOPdg�m�[�&,�=  ������  =�)   /  ��  @  ] 2K 3L+!5!!#�+s�-�+����  |  ��  "@
 J2K   ^ 3L& +7326766733##�mRY#�X�74��dA!.�g��^L5��>��N�3FV     |  �; 	  ��JK�PX@!n   h2K ^ 3LK�PX@    h7K2K ^ 3LK�PX@!n   h2K ^ 3L@ �   h2K ^ 3LYYY@ 
 			+ '33273326766733##|��w��w�-mRY#�X�74��dA!.�g�I�oo��c^L5��>��N�3FV  B  ��   ' *@'' J  g 2K 3L+%&&546753#3>54&&'��QPĭ˴�KOĮ�oddo�nddn����
�zz�������n����ll����n       ��  @	 J  2K3L+33##�P�HN��A�����u����3�B����}     �  D�  )@&  J    g2K 3L$"+#".53326673#yh�ZS�q@�4mV=][9���4P���pg*,x�+   d����  #@  R2K ^   3 L+!!3!33#��e�)ˆ����+���     r  `�  @  2K^ 3L+33333!r�������+��+�+     ]����  '@$ R2K ^   3 L+!!333333#'�6��ຆ����+��+���    ���H�  FK�PX@   o2K  ^  3 L@  �2K  ^  3 LY@	+!!3!3!#�v�)��v����+�+��     .  O�   +@( e  ]   2K3L"&+.54$3!#!#!"!�H�S��������V�����^�z���+w������   �  u�   *@'  e   2K^ 3L
		
"!+33 !!%2654&##������L����������B�A�������   4  �� 
  0@-  g   ] 2K] 3L"!+!5!3 !!%2654&##9��ϊ����T�����+����B�A�������  A  n�    .@+  g  2K^3L&!+332#!3#%2654&##A�[��vẁ��b����f�xx[���eƓ��e��+�������        ��  & 4@1   g ] 2K  _3L%#&&&!	+52667>5!32####%2654&##^j1 `�yy�`Ϭ'Vb�@Z}y^�=��=��f���eƓ��e+�f���fiw�������    ,  ��   �K� PX@g  2K	^3LK�(PX@" W e  2K	^3L@#  g  e  2K	^3LYY@%!
+3!332##!#%2654&##,�����y�`��u�Z}w`���d���Ԣ�b��9�������    ���J� % 7@4 J _ 9K  _  : L  %%+"&'532654&''&&546632&#"Jn�l�˙�s�lҺzݕ�ҹ���p�jԾ��--׍��et#0����mN�w�{Yl 0֯��  ���'�  F@C	 J  e _ 9K  _  : L 
 +   !2&#"!!3267�����?������Ps��V��X�J��np�R�}xꫪ��?>�R  ���O�  F@C J  e _ 9K  _  : L 
 +"'532667!5!.#"563   �K�U��V��sR�|����?��R�?>�훪��m}�R�g�����j   �  �  #@ ] 2K  ] 3L+7!!5!!!!�9��=��9�ê�����    �  <   # �K�
PX@#
  g] 2K	] 		3	LK�PX@%
  _7K] 2K	] 		3	L@#
  g] 2K	] 		3	LYY@ #"!  
+"554332#3"554332#!!5!!!!]����V9��=��9��q�����9�����     m����  2@/ J ] 2K  _  : L  +"&'532665!5!�d�o\�p\n0��G�)1�QQ@��D����� ��  o� ) -@*J  g  ] 2K3L#X+#5!!667667676632#4&#"#��`�C%>��U	U�lv2\,!$�-����%
Tp��Κ�(�T�o    P����  $ �K�PX@!  e _2K	 _  : LK�PX@%  e _2K 3K	 _  : L@)  e 2K _ 9K 3K	 _  : LYY@ $$
	 
+"##333 '276654&'&&#"ȼ
o��o
�����j/J9k/00/eR�f��oCi���y����F䫫�GEH��������  ���*o� 8 H@E"J  g] 2K 3K  _  8 L .)! 	 88	+"&#'326654&#"##5!!667667676632�4NZk0lv2\,!$��j�C%>��U	U]��*�@�����(�T�o-����%
Tp��F��d       u�   8@5  e  g 2K	^ 3L"!
+!5!53!!3 !!%2654&##%���q�������T�����Q�����B�A�������     u��\� 
   >@; e _ 9K _  : L  

	+"32#"267!g���������~ �}
��|}������y��Y�����K�����     _  }�  '@$  e ] 2K 3L+#53!!!!#ႂ��/#���>��������    ��fK�  /@,  e ] 2K 3K   _ 6L&!$ +3265#!#!!!2##M>�o������/7�oo��L��"=�9ժ�Fwv������    ����  1@.
J  a2K  3 L+!##'#3333#�Y�Y��0��������:����0к�v{Z��S��S���/�  ��u7� 7 �@,+5
 JK�!PX@'  e _ 9K _ :K  _   6 L@$  e    c _ 9K _ :LY@%$!$$$'+#"'53254&'&'532654&##532654&#"566327��-+�VXO%�&��g�`����������L�ly�N��w�������6\2��ZF7E�63�����ytoy&*�  c�x�E'�     �����  )@&J  a2K  3 L+!##333#�����w����r������h����7�     =����  *@'  e  a2K  3 L+!#!#3!33#������)�����9���d���    ��u1� $ x@! " 	JK�!PX@   _ 9K _ :K _ 6L@  c  _ 9K _ :LY@   $$+ !27#"'53254&'$  !2&&��z���x�-*�UYO%�&����> ��I�L����}�@6[2��ZF7�ao�R�<A   /����  $@!  a] 2K   3 L+!#!5!!3#���+s�-��+����     %  ��  @  J  2K 3L+33#�#�lk��!��7�m����b     %  ��  +@(
J  e2K 3L+!5!533!!#���#�lk��!
�����P7�m���P��\   ����  ,@)J  I  a2K   3 L+!##333#����u���P�HN��Ayf���}���3�B���  �  [� " %@"J  g   2K3L#6+367766772#4&#"#��#20&y60Uz)	U�lv2\,!$���U&-'p��ښ�(�T�c  �  �  #@ ] 2K  ] 3L+7!!5!!!!�9��=��9�ê�����      �; 	  �@JK�PX@n 
  h2K	3LK�PX@ 
  h7K2K	3LK�PX@n 
  h2K	3L@� 
  h2K	3LYYY@  		+ '33273333##'#h��w��w���������0��Y�Y��I�oo��2Z��S��S�������0к�v   ��f��  5@2	J  e2K 3K   _ 6L%!$ +3265###3332##'>�o��w��w�������L��"=����h����������  ��fH�  +@(  e2K 3K   _ 6L# +3265!#3!3##J>�o����)���L��_�9���d�����    ���=� $ .@+J   g    a2K 3L#6+%3"'&'&&533267676653##��7/%y70�X(,�js,f--'��ժ$$T
6�y��I��%�\z�)��     %  �; 	   ֵJK�PX@%n 	  h
 f 2K3LK�PX@$ 	  h
 f7K 2K3LK�PX@%n 	  h
 f 2K3L@$� 	  h
 f 2K3LYYY@ 
 		+ '332733#!#h��w��w�c���n��l���I�oo�t�+��{'��   %  �<    " ��!JK�
PX@!
	  g f 2K3LK�PX@# f
	  _7K 2K3L@!
	  g f 2K3LYY@!    " " 
+"554332#3"554332#3#!#]����{���n��l���q������+��{'��    �  N; 	  �K�PX@-n 
  h  e ] 2K 	] 		3	LK�PX@, 
  h  e7K ] 2K 	] 		3	LK�PX@-n 
  h  e ] 2K 	] 		3	L@,� 
  h  e ] 2K 	] 		3	LYYY@ 
 		+ '33273!!!!!!z��w��w�(v�T��r��wI�oo�t��F���   u��\�   C@@J  e _ 9K _  : L 
 +"5!54#"5663 '267!g����L�GN�S ����}
�Ō~�S�B;�*(���x�y��������    u��\<   - 4 �@
%$JK�
PX@+
  g  		e _ 9K_:LK�PX@-  		e
  _7K _ 9K_:L@+
  g  		e _ 9K_:LYY@'/. 21.4/4)'" -- 
+"554332#3"554332#"5!54#"5663 '267!]���������L�GN�S ����}
�Ōq�����r~�S�B;�*(���x�y��������    �<   + �@)(%$!JK�
PX@
  g2K	3LK�PX@
  _7K2K	3L@
  g2K	3LYY@ +*'&#"  
+"554332#3"554332#333##'#]������������0��Y�Y��q�����
Z��S��S�������0к�v  ���7<   ? �@1	0:JK�
PX@*
 	 g  e 	_ 		9K _:LK�PX@,  e
  _7K 	_ 		9K _:L@*
 	 g  e 	_ 		9K _:LYY@# 53.,(&%#?? 
+"554332#3"554332#"'532654&##532654&#"56632L�������g�`����������L�ly�N��w������q�����rJ�63�����ytoy&*�  c�x�E'Ƙ��     ����  H@EJ ~  e ] 2K  _  : L  + $5332654&##5!5!2g�����ƾ�Ǻ��r����i�O+%���ݐ����������Ghg9wH��  �  F<   i�JK�
PX@    e2K3LK�PX@  ]   7K2K3L@    e2K3LYY@	+!!3!#!=V����� ��� <���3��+��3    �  F<   ! ��JK�
PX@	  g2K3LK�PX@	  _7K2K3L@	  g2K3LYY@ !  

+"554332#3"554332#3!#!]������ ��� q������3��+��3     u��\<   " 2 �K�
PX@#	  g _ 9K_
:LK�PX@%	  _7K _ 9K_
:L@#	  g _ 9K_
:LYY@#$# ,*#2$2"" 
+"554332#3"554332#"32%276'&#"]�������������DCCD��DDDDq�����r}������y�����LL����������     u��\� 
   >@; e _ 9K _  : L  

	+"32&&#"2!g�������x�hw6�����}������y�����t֑�-����   u��\<   " * 1 �K�
PX@,
  g 		e _ 9K_:LK�PX@. 		e
  _7K _ 9K_:L@,
  g 		e _ 9K_:LYY@+,+## /.+1,1#*#*'%"" 
+"554332#3"554332#"32&&#"2!]������������x�hw6�����q�����r}������y�����t֑�-����     ���Y<   3 �@,	+JK�
PX@*
 	 g  e 	_ 		9K _:LK�PX@,  e
  _7K 	_ 		9K _:L@*
 	 g  e 	_ 		9K _:LYY@# /-*(%$#"33 
+"554332#3"554332#"'532667!5!.#"563   P�������K�U��V��sR�|����?��q�����rR�?>�훪��m}�R�g�����j   |  �<   u�JK�
PX@    e2K ^ 3LK�PX@  ]   7K2K ^ 3L@    e2K ^ 3LYY@	&!+!!326766733##QV���mRY#�X�74��dA!.�g�<��^L5��>��N�3FV  |  �<   , ��"JK�
PX@	  g2K ^ 3LK�PX@	  _7K2K ^ 3L@	  g2K ^ 3LYY@ ,*$#!  

+"554332#3"554332#326766733##q����EmRY#�X�74��dA!.�g�q�����;^L5��>��N�3FV   |  �<    }�JK�
PX@  e2K ^ 3LK�PX@ ]  7K2K ^ 3L@  e2K ^ 3LYY@&!+3#3#326766733##1�����!mRY#�X�74��dA!.�g�<�����x^L5��>��N�3FV    :<   / �@
+JK�
PX@ 
	  g  g2K 3LK�PX@"  g
	  _7K2K 3L@ 
	  g  g2K 3LYY@ /.-,(&"! 
+"554332#3"554332##".53326673#S���h�ZS�q@�4mV=][9��q�����!4P���pg*,x�+    ���s� 	 "@  a ] 2K   3 L+!#!!3#����/��ժ��    R  <   $ ( 1 �K�
PX@'  g  
	
g2K		^3LK�PX@)  
	
g  _7K2K		^3L@'  g  
	
g2K		^3LYY@%*) 0.)1*1('&%$" 
+"554332#3"554332#332#!3#%2654&##n������[��vẁ��b����f�xx[q�������eƓ��e��+�������     ���7� ' J@G%& J  e _ 9K  _  : L #! ''+"$5467$546632&&#"33#"3267���뛔��w֎N�yl�L����������`�g��͘�'E�x�d  �*&yoty�����36�J     r����  & 2@/ J  � _ 9K _   : L &&%@+"#7632#276'&#"���|}�{�@{D!hGj����DCCD��DDDD����\d��y�ܵX�$��卉LL����������       ��  E�
JK�PX@  2K 4K3L@   ~  2K3LY�+333##ŏ�Ӭ��߿�ʿ��D"����+w��  ���a{ 7 F �@
JK�PX@$  e _ ;K 3K _  : LK�
PX@   e _ ;K _  : LK�PX@$  e _ ;K 3K _  : LK�PX@   e _ ;K _  : L@$  e _ ;K 3K _  : LYYYY@98 ?=8F9F.,
 77	+"'&&54763354'&#"5667632#&'&&''27655#"�d06~|��DB�_`bY*f4Y^�d.S�	[,]U�WX�SR=Sa.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8    }��H7 - 5 �@%JHK�
PX@ � _ ;K _  : LK�PX@ 9K _ ;K _  : L@ � _ ;K _  : LYY@/. 31.5/5)' --+"46544''&&547>76676676632' ! i��D�hV�y$F+�,T,[u
?�a��������&	�8Y_��1)�0�G<A:�������Ӝ���R�N  �  `   ! =@:J e  ]   4K] 3L !!+ +!2#!2654&##2654&##��f�d`b�l���c�UTTV��_eWi�`>}`Y��l���UCCV����oVK]��    3  #`  @  ]   4K 3L+!!#3��ȸ`��6    3  =m  	 %@"   � � ] 4K 3L+3#!!#w��������ȸm�����6 =  .�  ?K�PX@   n  ]   4K 3L@  �  ]   4K 3LY�+!3!#=8��ȸ`:��X    i��h`   1@. Q ] 4K  ] 3L 	+732>5!3#!#!3iC�y��-����	
�X���(��6�L���4�����
   |��Y{   C@@ J e _ ;K  _  : L  +  4632!327&&#"����ۂ���������j������:�	����Z��q�++�����  |��Y�     O@LJ   � �	 f _ ;K _:L  

+3#  4632!327&&#"���f���ۂ���������j�����������:�	����Z��q�++�����   |��Y   - 4 �@
*+JK�#PX@-	 	e
  _9K _ ;K _:L@+
  g	 	e _ ;K _:LY@'.. .4.420)'$# -- 
+"554332#3"554332#  4632!327&&#"��������ۂ���������j������C������:�	����Z��q�++�����     ;  �`  '@$	 J  4K3L+333##'#>���������h�h�����P��P��l�4���_���     ���({ % J@G  J  e _ ;K  _  : L 
 %%+"'532654&##532654&#"5632�śʯ���������G�iҝ���x����8�Ei[Zl�VDEU�0��`��w��    �  ` 	 @ J  4K3L+33##ø縸��`��)��)��   �   
  f�JK�PX@n   h4K3L@�   h4K3LY@ 	 

	+ 3327333##h��w[[�w�8�縸���HN�����)��)��    �  o   *@'J   � �4K3L+3#33##W���'�縸��o�����)��)��   �  �`   @	 J  4K3L+33##����G���b��`�/��Z�FB��?   �  �o   ,@)	J   � �4K3L+3#33##$���������G���b��o����/��Z�FB��?   2  .`  !@ ] 4K   _3L' +73267665!#!##2#ZX��_	*3){b7�z�4�X�����k��I:;  =  �`  (@%
 J   ~  4K3L+33###=�ww������`�M�������     �  `  !@  e  4K3L+3!3#!#��縸��`�9�����  ���H{   -@* _ ;K _  : L  +"32' ! h������������+ /�������Ӝ���P�P   �  `  @  ]   4K3L+!#!#�W���`����6  ��VT{   a�JK�PX@  _  4K_ :K 6L@    4K _ ;K_ :K 6LY@$"+3632#"'# ! ��_������[������`���������Ȫ��)���P�P     ���{ ' 7@4!" J _ ;K  _  : L 
 ''+ '&467632&'&#"3267667�����MF��[GIRLFLZ�]]+2_�2S#-A"P&#S����J�-�Cpq�`�<q-�"
   �  �`  @  ] 4K 3L+!5!!#��&�ɸʖ��6  r�V�`  "@
 J4K   ^ 6L+ +326766733##�m->7(�O�LG���4:,�d���plN��l�HH.<:��(KQ   r�V� 
 $ n�JK�PX@!n   h4K ^ 6L@ �   h4K ^ 6LY@ $"	 

	+ 33273326766733##r��w[[�w�-m->7(�O�LG���4:,�d��HN�����plN��l�HH.<:��(KQ   h�Vj   '  @'  J   � 6L+.546673#3>54&&'��XW�����WX���Pd..dP�Pd..dP|����}��g}����|�s�I����MM����I  L  �`  @	 J  4K3L+33##�o�)'��o�������H�k�������?     �  �b  )@&  J    g4K 3L$#+#"&5332673#EP�U�ŸCn@Et>�����o��VR$���     ����`  #@  R4K ^   3 L+!!3!33#���渌�`�6��6�L     }  U`  @  4K^ 3L+33333!}����(`�6��6���     i���`  '@$ R4K ^   3 L+!!333333#;�.��𨐖`�6��6��6�L    ���`  FK�PX@   o4K  ^  3 L@  �4K  ^  3 LY@	+!!3!3!#�������`�6�����     �  �`   +@( e  ]   4K3L"(+.54663!####"3�KI2f�d������x�%O66O$�
(HpRs�C����9]m&PA@P&  �  V` 
  *@'  e   4K^ 3L$!+3!2#!% 54!#� �����H����`�;���������    <  �`   0@-  e   ] 4K] 3L$!+#5!!2#!%2654&##4�� �����H�|��z�ʖ�;�����WZ[Z��    h  i` 
   .@+  g  4K^3L$!+332#!3#%2654&##h�[������I����|��zS`�;����`���X[\[��     �`  & 4@1   g ] 4K  _3L! $# &!&'&! 	+73267665!32#####%254###ZX5j�nk�m��.3"on'-���z�4�X��;I�qo�I���N��F-<�����  j  �`   2@/g  4K	^3L&!
+3!332##!#%254##j�l�j�nk�m�������`�9��;I�qo�I�������    ���{ & 7@4 J _ ;K  _  : L  &&+"&'532654&/&&54632&&#"KW�jͪz�p�E���έ�Q�Z�.sXJ�##�jdPDY �{��B�..�K$#5���    ���{  F@C
 J  e _ ;K  _  : L  +"&5 32&&#"%!327Ǩ��%�T�SD�_y�L��
���~Q���8(.�=>\�Y���y�.(  ���C{  F@C J  e _ ;K  _  : L 
	 +"&'53267!5!.#"56632 !U�Q~���
��L�x[�FR�T�%��(.�y֯�X�\<?�.(�������    ���   _K�PX@   _ 9K ] 4K ] 3L@   g ] 4K ] 3LY@  
+"554332#33#"&'&5#5!�  �   ..X��P0[��+���c~=?�28j�B�     ����   ( A@>	  _9K ] 4K ] 3L ('&%  

+"554332#3"554332#33#"&'&5#5!����..X��P0[��)�����e~=?�28j�B�     ��VD   _K�PX@   _ 9K ] 4K ] 6L@   g ] 4K ] 6LY@  
+"554332#325!5!##�  �  ���������+����������  A  W  5@2
J  g  ]4K ]3L#"	+#533!!63 #4&#"#������@b�T�iq���я��L��s��;��B������    v���{  ( �K�PX@   e _4K  _  : LK�PX@$  e _4K 3K  _  : L@(  e 4K _ ;K 3K  _  : LYY@ " 
	 	+"'##3363232676654'&#"<������Ԙj�gj��5S'I85MO8��`���������|u??9�e�nlz<�bb�    K�V|  8@5 J G    g]4K ] 3L"&+>54&#"##533!!632�P�P]���������@b������򪘟����я��L��s������~,    2  �   :@7 �  e  ]4K	^ 3L$!
+#533!!!2#!%2654&##*�����W �����H�|��z�͓��L��Φ����WZ[Z��   ���H{    >@; e _ ;K _  : L 	 	+"76632&&#"2667!h��{<�y���1����^t<	��
;s- �IN�����������̰�V�YY�V    �  -`  '@$  e ] 4K 3L+#53!!!!#=�������`���¸����   ��V4`  /@,  e ] 4K 3K   ] 6L'!' +326654&&#!#!!32##�IO$`Y���������X!�����+mbrf�`���"T�r����   ;���`  1@.
J  a4K  3 L+!##'#3333#4�h�h����������M����_������P��P��l���L  ��u({ 6 �@,+4
 JK�!PX@'  e _ ;K _ :K  _   6 L@$  e    c _ ;K _ :LY@$$!$$$'+#"'53254&'&&'532654&##532654&#"5632(��0.�VXO%�)W�d�ʯ���������G�iҝ���x��A��9_3��ZI:�Ei[Zl�VDEU�0��`��     ����`  )@&J  a4K  3 L+!##333#��b������Gx��B��?`�/��Z���*     ����`  *@'  e  a4K  3 L+!#!#3!33#���������`�C��X�*    ��u{ ( x@& '	 
JK�!PX@   _ ;K _ :K _ 6L@  c  _ ;K _ :LY@ $" ((+"3267#"'53254&'&  32&ӳ���X�B<t<-+�UYO%�&���%�T�S������:?�#&6\2��ZF848(.�{     ����`  $@!  a] 4K   3 L+!#!5!!3#Ÿ��&��������
�*     \�Vt`  @  J  4K 6L+%33#�T�II��T�N��l���D  \�Vt`  +@(
J  e4K 6L+#535333##���T�II��T�����5N��l��5��     `���`  ,@)J  I  b4K   3 L+!##333#��������o�)'��o-����?H�k����p�*  �    '@$J _ ;K   ]3L#"+363 #4&#"#øb�T�iq�������;�J������� �    @   ] 3L+3#Ǹ���     ;  �H 	  �@JK�PX@!n
  _ 2K4K	3LK�PX@ �
  _ 2K4K	3L@� 
  h4K	3LYY@  		+ 33273333##'#h��w��w�����������h�h��)��������P��P��l�4���_���     ��VY`  5@2J  e4K 3K   ^ 6L'!' +326654&&###3332##�JN$_Z�'������:��X!�����+mbrf&�?`�/��"T�r����     ��V$`  +@(  e4K 3K   ^ 6L# +32665!#3!3##�IO���縤����+mb�`�C�����     ���b  .@+J   h    a4K 3L#'+%36# 3326553##��<Vp���iq����ø~3$
2������������   ���h1 
 B QU@
JK�PX@4n   h  
	
e _ ;K 3K		_:LK�
PX@0n   h  
	
e _ ;K		_:LK�PX@4n   h  
	
e _ ;K 3K		_:LK�PX@0n   h  
	
e _ ;K		_:L@3�   h  
	
e _ ;K 3K		_:LYYYY@%DC JHCQDQ97%#BB	 

+ 33273"'&&54763354'&#"5667632#&'&&''27655#"h��w[[�w�}�d06~|��DB�_`bY*f4Y^�e.S�	[,]U�WX�SR=SHN�����a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8     ���h   O ^�@
,+JK�PX@2  
	
e  _9K _ ;K 3K		_:LK�
PX@.  
	
e  _9K _ ;K		_:LK�PX@2  
	
e  _9K _ ;K 3K		_:LK�PX@.  
	
e  _9K _ ;K		_:LK� PX@2  
	
e  _9K _ ;K 3K		_:L@0  g  
	
e _ ;K 3K		_:LYYYYY@)QP WUP^Q^FD20(&" OO 
+"554332#3"554332#"'&&54763354'&#"5667632#&'&&''27655#"]������d06~|��DB�_`bY*f4Y^�e.S�	[,]U�WX�SR=SF������a.}X�ba�><4� *=(@G��:X&*J79-2N0�jk�)88rd8     |��Y1 
   ' �@
JK�PX@/n 
  h	 	e _ ;K _:L@.� 
  h	 	e _ ;K _:LY@#!! !'!'%#  	 

+ 33273  4632!327&&#"w��w[[�w����ۂ���������j������HN�����:�	����Z��q�++�����    ���k{   C@@J  e _ ;K _  : L 
 +"55!54&#"56632'267!b������j�^����ꞈ����"�Z��q�++�������������   ���k   . 5 �@
$#JK� PX@-  		e
  _9K _ ;K_:L@+
  g  		e _ ;K_:LY@'0/ 32/505(&" .. 
+"554332#3"554332#"55!54&#"56632'267!q�����������j�^����ꞈ����F������"�Z��q�++�������������     ;  ��   + K@H)(%$!J
  _9K4K	3L +*'&#"  
+"554332#3"554332#333##'#]��������������h�h��)��������P��P��l�4���_���  ���(   = �@0	/8JK� PX@,  e
  _9K 	_ 		;K _:L@*
 	 g  e 	_ 		;K _:LY@# 31-+'%$"== 
+"554332#3"554332#"'532654&##532654&#"5632N������śʯ���������G�iҝ���x����F������8�Ei[Zl�VDEU�0��`��w��   ��Lh`  F@C J  e ] 4K  _  6 L  +"&'532654&##5!5!2'a�q�ݿƺ����ej�ea�VQ���L"(�c�������$_pj���     �  �   K�JK�(PX@  ]   2K4K3L@    e4K3LY@	+!!33##=V��z�縸�������)��)��    �  �   ! @@=J	  _9K4K3L !  

+"554332#3"554332#33##]����P�縸��*�������)��)��  ���H   # + yK� PX@%	  _9K _ ;K_
:L@#	  g _ ;K_
:LY@#%$ )'$+%+## 
+"554332#3"554332#"32' ! ]�����������������F������+ /�������Ӝ���P�P   ���H{    >@; e _ ;K _  : L 	 	+"76632&&#"2667!h��{<�y���1����^t<	��
;s- �IN�����������̰�V�YY�V    ���H   % , 5 �K� PX@. 		e
  _9K _ ;K_:L@,
  g 		e _ ;K_:LY@+.-&& 21-5.5&,&,*(!%% 
+"554332#3"554332#"76632&&#"2667!]�������{<�y���1����^t<	��
;sF������- �IN�����������̰�V�YY�V   ���9   5 �@,	+JK� PX@,  e
  _9K 	_ 		;K _:L@*
 	 g  e 	_ 		;K _:LY@# 0.)'$#"!55 
+"554332#3"554332#"&'53267!5!.#"56632 I�����U�Q~���
��L�x[�FR�T�%��F������(.�y֯�X�\<?�.(�������   h�V��   S�JK�(PX@  ]   2K4K ^ 6L@    e4K ^ 6LY@	+!+!!326766733##=V���m->7(�O�LG���4:,�d�����plN��l�HH.<:��(KQ   h�V��   1 D@A"J	  _9K4K ^ 6L 1/$#!  

+"554332#3"554332#326766733##]����Em->7(�O�LG���4:,�d� ������plN��l�HH.<:��(KQ     h�V�p   ! 0@-J  e4K ^ 6L+!+3#3#326766733##������� m->7(�O�LG���4:,�d�p��x����plN��l�HH.<:��(KQ  �  ��   - L@I)J  g
	  _9K4K 3L -,+*'%!  
+"554332#3"554332##"&5332673#g���8P�U�ŸAnBJp=��+��������o��US#���   $��` 	 "@  a ] 4K   3 L+!#!!3#ܸ�����`���*    h  i�   " & / Q@N  
	
g  _9K4K		^3L(' .,'/(/&%$#"  
+"554332#3"554332#332#!3#%2654&##]������[������I����|��zS)������;����`���X[\[��     ���({ & J@G#$ J  e _ ;K  _  : L "  &&+"$5467&&54632&&#"33#"327���헁x��Ҟ�i�H����������Ɵa���w��`��0�UEDV�lZ[iE�     ��Rw   a�
 JK�PX@ _;K _   :K 6L@  4K _ ;K _   :K 6LY@$!+%#"3273# ! a]������]��������8;����)���P�P        �`  (@%
J   ~  4K3L+333##�à��ö������`�wB�����f��  �  ��  '@$  e  ]  2K3L+3!!!#!#պl���������d�����9  �  �`  '@$  e  ]  4K3L+3!!!#!#�����Ҩ�f�`�9ǖ�6��     ��   =@:  	e
	 	e ]   2K ]3L+!!!!!!!##����3��e����e�}k�ժ�F�����'��    )���{ ) 2 ? d@a("# J	g_;K
 _  : L43** ;93?4?*2*2/-&$!	 ))+"&5463354#"56326632!327#"&'54&#"276655#"e����u�u��y�I }gq�>�cv�bp�m�O�MWWL��^%1�}X����X�R�D9Fg��Z$��f�TTL��4����+��C tfHXjd_   %  ��   ?� JK�(PX@   TK^ UL@ b   T LY@
+3!%����y�������+�y��  u��\� 
   gK�PX@  e _ VK _  ] L@  g e _  ] LY@  

	
+"32&&#"2!g�������x�hw6�����}������y�����t֑�-����  ��T�`  uK�1PX@ J@ JYK�1PX@  WK`]K YL@"  WK `]K _]K YLY@
"&#
+33 332767#"'#"&'#øwp �AJB}Y�]}-�`�H��P���s�-��KQ��    w��Z� % *@'#% JK  _   ' L$$+&&'#"'&&53327&&'76653-V-q��w=@�'rrI7=_�R6	�#":D<2Dw<�}��;xQ6j3\3^-@ J��]�9"     �  P�  .@+   ~  |  f   &K L$$+467632#54&&#"!!#�@=w��w<@�'srqs&���}�<vv<�}��;wPPw;�#��=  U  |�  % 0@- ~  f &K L%$%& +!"'&&56323##4&&#"35���w=B��o�=<A}}�(ssqr%gWÀBȒ�;@@ɐ����=m�J�X^�lQ�016     6  ��  ,@)   ~  e   _ &K L%#+4&&#"#54676323##'srrr&�@=w��w<@���J;wPPw;ߡ}�<vv<�}�a��=     ���P�  ;@8 ~   | K ] !K  ' L 
	 +"'&&53!!3266553T�w=@���&sqrs'�@<=�w<�}�����;xQQx;ߡ}�<=:     `  q� + aK�PX@$   ~   n _ &K^ L@%   ~   | _ &K^ LY@
$+!+3327667654&'&&#"#54632!!��3g{=o*\"*&pV��ˈ�r�G�%"S.-W$g�CK�_0�P��`�=62���yCJ���i�OH�33@�  x  Y� 	 (@% ~   K ] !K L+3!!!!x�������������    �  P�  (@% ~  _   &K ] L$$+467632#54&&#"!!�@=w�m�=<@�'srqs&�0}�<w:=<�}��;xQQx;�`�  I���� * < yK�PX@%
  ~g _ &K	  ' L@)
~g _ &K K	  ' LY@,+ 31+<,<$#"! **+"&&5463354&'&'&#"#76323#'26765#"�\�W���""=9`z�7ć���AE��1-/|H#5"�4@!5\Ý����77Yš�s�"���Jݕ4���l�9<8�"@�>SE-�>"  F��m�  $ =@:  ~ K]!K  ' L $$
	 	+"46763!33#'2665!"��C<|��}}}=�jor(��Wg$s��H�u����B��A;�X�IA96�Xl�r    �  e�  .@+J ~   K _ )K L$"+3632#54&&#"#��r�g�=<@�'rsqs&���PP;<<�}��;xQQx;�3     �  T�  @   K ^ L+3!!����d��ժ  ]��t�  aK�PX@ K ]!K  _  ' L@! K ]!K K  _  ' LY@ 
	 +"&'&&5##3!3276653&o�%'���q>`]�$%�858�x�O����1�t:fK��Ix�885     6���� - K �@
JK�PX@-~ _K_K
 `	  ' L@+~ _ &K] K
 `	  ' LY@/. >=.K/K 
	 --+"&'&&5467#33676632&&#"'26676654&'&&'&&##r��;<...��4a�B�_cS*O*l�R^�9��SU\U;?�dn�D

I?@��+%	%#$peWX郋�h���G#%	�F6:4WMO�R�CHu),.�=lD2x'F�86W  $a�$6e/9Y !%    �  =�  )@&  J    g K !K L$"+#"'&&53326653#s6�\�z=@�&sqsr'���$+w<�}��3;xQQx;X��   G��b�  @ G    L+&'&&54676$73@r>"'iyh!����o�WY�68 7�
.2?)=�fX�S;��5q68n02$%���  _��r� 3 = P@M713 J ~ ~  | _ &K  _   ' L54:84=5=&*(%+&&'#"&'&54676326654&'&&#"#54676632%267&#"�#H$X�rEw-Z/+V�g�X75%&(|K���PEE�ln�FHS_PcN�DD�A��DH06a-T]%&M�Hq(PMBk�s�7:.����KJBBHJ勤��{j�OJH�IB�     6  ��  (@%   ~   _ &K ] L%#+4&&#"#54676323!'srrr&�@=w��w<@��{J;wPPw;ߡ}�<vv<�}���     V  z�  " f@ JK�PX@ _K ^   L@ K _ &K ^   LY@ "! +!"&'&&54676736$3"'3k8f(%*OZ_]����m�����9B=b[XDVЛ�����������Ȥ�y-^3s�5E3  V����  +@( ]K  _  ' L  +"'&&5332665!#*�w=@�&rrrs'��@<=�w<�}��;xQQx;J���}�<=:     @���� : R@O2J ~ | ~   |  f &K  ' L (&#" 
 ::	+"&&533267654'&#!5!2676654#"#46632���j�!$#oUPr%GNQ���PB]�uy�qʅf�<9F8\�}9A?���Bp*)3.)M��HI�*$#Y3�q{z�b831�^<f*V"�X�DBL    6����  2@/ ~ ] K  _  ' L 	 +"'&&5#5!3266553��w=@��&sqsr'�@<=�w<�}b���;xQQx;ߡ}�<=:    `��q� 1 H@EJ ~  g _ K  _  ' L +*&$
	 11+"&5467667'&&##532'&&#"3276553q��K;9�CZ9m%-{3~H��d(�UMK��IJ�PEE�}��OLP(���g�'V0b��migj���KJB   �  =�  @  _   &KL$$+467632#4&&#"#�@=w�m�=<@�'rsqs&�}�<w:=<�}��J;xQQx;��   `��q� + 8@5   J+*G   ~   | � _ &L&)$+5326767654'&#"#54676632#�� ])Nw('MK�Pu&K�PEE�jo�HGTMz�<��eOGEi_��mi07i���KJBEKK����Kc�  -  |�  )@&	J   ~   _ &K L$+4&'&&'##54632#�iW�sr%�o����g��O�<;O	��lu�u*9�	������\  `  p� . K uK�PX@+ ~   |   n _ &K^ L@, ~   |   | _ &K^ LY@FD86.-,+ (!+33276654'&&'&&'&&'&&54676676632!!6654&'&#"��(ww."Z"=~7&*	N89�g��=>6E68�Kg�C}FO"I�B]!%-O1/~4JL�Y4^*i8(#@& <K�<>j()/fUY�n��]_�$��i�Q�<� H$KY"=A\�(   b  ��  %@"  e  _   &KL$$+4676323##4&&#"#b@=w��w<@���'srrr&�}�<vv<�}�a��=J;wPPw;��   ���=�  $@!K  _  ' L  +"'&&53326653g�w=@�&sqsr'�@<=�w<�}��;xQQx;J��}�<=:     !  ��  /@,  J    g K !K ^ L$"+#"'&&533266533!6�\�z=@�&sqsr'���R�$+w<�}��;xQQx;��ժ    i��g� B ;@8 ~ | _ &K  _  ' L '%#"
 BB+"&&533276654&'&&'&&'&&546632#4&#"w���[W��O&-=:6�HN�76B`ƙ��c�t�@] ,#&c51 5s/0L�?�x֎�UQK#hBJb#!.8--~al�nn�li�! T+:L(3 !Y?>O�z=D     �  =�  "@ ~  _   &K L$$+467632#54&&#"#�@=w�m�=<@�'rsqs&�}�<w:=<�}��;xQQx;��  @���� . F O@L&J ~ ~	 f &K  `  ' L0/ <:/F0F
 ..
+&&7332676654&#!5!&&5467663226654&'&'&&#"���o�;�lVs## ����@C=;7�p��8\�}:?@[k.+8&K]_��{U�U4*+q8|��"�LN�63<ܳ=d)S"�{Y�BDL�EpA,Y "	
&  T3/Y!")   �  ^�  @   K ] !K L+3!!#����������O   F  ��  % 0 6@3	~ X  h K L0/
+%&&'&&546766753#3>54&'&&'��50)'33�����LLĳ�Ia7��bn-bI�TQJҖ��NOUzz����������/34�wx�8e[ßy�43/   $  ��  1 G@DJ ~	| |  f &K L -+1 1(&
+7#534676632#"'&'!!#2676654&'&'&#"㿿7:<�x��a6:8�qZHU(��,��Nb37K�pz���`�<=@t�a�<9F 4����)"$h@@e%%�y�   u��\� 
  -@* _ &K _  ' L  

+"32%2676654&'&#"g�������Sk  #%E��CDD!k}������y���JDBߵ��C��������FH   G���� + 2 ; R@O	J ~  ~^ K`!K	  ' L ;:4321-, +*
+"&'.5533"&5467633"326654&&#tz�<YZ�cVŴ+0^˶��29+Q?9T*b�^RR^�nl##ln*��ok�1393��Ef"A��H?JݐX�CAk!N$FE"�%\����V  g��i` . lK�PX�,' J�,'JYK�PX@!K _  ' L@!K K _  ' LY@ *(&%$# ..	+"&'&&533267665332676653#5#"&'X>\�'H-1�K+-��D�Di#e,;6����wIJV  �{���y8"%�p���`{CJHE   ��V#{  m�JK�PX@%   ~  |  !K ^ K #L@)   ~  | )K   !K ^ K #LY@
#"+3632#54&#"!!#��bꭧ�iq����V�`�������������V   I�V�w   �K�PX@
 J@
 JYK�PX@% ~)K] K   'K #LK�PX@) ~ )K !K] K   'K #L@0 ~~ )K !K ] K   'K #LYY@&!	+%#"&'&32733## !"&[�d�9t���\��������CC��QL�<���/��V%��lm��P   ��V�{  [� JK�PX@   _!K ]K #L@  !K   _ )K ]K #LY@
""+4&#"#36323##Wiq����bꭧ����������`�����ُ�V   ���A  z�JK�PX@& ~   |  K ] !K  ' L@* ~ |  K ] !K K  ' LY@ 	 +"&53!!326553#5
�����/kp����c��l�L��ח�����0��    g�V�w   v� JK�PX@& ~  |)K   'K ^ #L@* ~  | )K !K   'K ^ #LY@&!+%#"&'&32733! !"D[�d�9t���\��������CC��QL�<�����%��lm��P  �   	 (@% ~    K ] !K L+3!!!!�z��%�#�L��Ô    ��V{  X�JK�PX@  _  !K K ^ #L@   !K _ )K K ^ #LY@	#"+3632#4&#"!!��bꭧ�iq�����`�����J������l�  j�V�{ $ 4 ~�JK�PX@)
~	e  _  !K 'K #L@-
~	e   !K _ )K 'K #LY@&%,*%4&4$%#$+3676323##"&546633&&'&#"#27667#"j�AULru�;zehp�U��Z�P�/'V����qR1#�8(!2`�o.(SL����M��g�Bm�5t����E&tV(=(@'   ]���  % =@:  ~  K]!K  ' L %% 	+"&'&&5467663!33#'2765!"'{�893277�{���a̛�GA��v� !CXOQ�yx�NM[��L��(��to����^�9s    ��V  +@(J    K _ )K K #L#"+3632#4&#"#��bꭧ�iq���������J�������    ��V�`  @   !K ^ #L+3!!�����`���     h�Vh / �K�PX@
J@
JYK�PX@!    K _)K _K #L@)    K !K _ )K K _ 'K #LY@)")"+363232676653#5#"'&&554&'&#"#h�F��6K+-��F��6K+-���{m6�d��y8"%�p���`{m6�d��z8"%�p��  ���H+  3 =@:
JH] !K _  ' L ,*33 +"&'&&54667%!#'2676654&'&&'#"g~�:<8i�j��ϔjAZ '	7<9��Np#6.�h~8"HWJK�|���!b�Ҫ0r66f��KHY�@94�oq65g*q�qS�8y   ��V  +@( J  K !K  `   'K #L#!+%#"&5332653#[cꭥ�kp��������l������{��     �    '@$J    K _ )KL#"+363 #4&#"#��b�T�iq�������;�J�������  ���  + A m@7'JK�PX@ ~  K `  ' L@ ~  K K `  ' LY@-, ,A-A&% +++"&&547&&54773327667#5'26766554&&'v�Y÷rn#3�9 &'=#8)Zx##�)T(h	Hl"  'id=_$%*<rʅ�^��PD6OU2/7&'$�5HI�[���[6�7/,zGVE��49wDE�UAt,\     ��V�{  X� JK�PX@   _!K K ] #L@ !K   _ )K K ] #LY@	""+4&#"#36323!aiq����bꭧ����������`�����/�  ���- & 8 �@$JK�PX@# _  K] !K	 _  ' L@' _  K] !K K	 _  ' LY@(' 10'8(8#"
	 &&
+"&'&&547#53>32&#" #''26766554&')`�-.-86��D�ڀ+;9k.1_'��/�@Nf  ��45'"?A89�nz4��~�q�-#&oD������Xm�<10y=���y��ykq$@   ����  d�JK�PX@ ]  K !K  `  ' L@  ]  K !K K  `  ' LY@ 
 +"&533265!##'⭥�kp��a��c����H����/��{��  ��V/` 
 @ !K   ] #L# +3253##�괸������t����    ��  d�JK�PX@ ]  K !K  _  ' L@  ]  K !K K  _  ' LY@ 
 +"&5#5!32653#'���`kp����c��ݏ������{����  ��V| 5 0@-0J _ )K  ]  # L 42 55+"'&546676676654&'&#"'66323!`S32e�YE{23:"*O�/H K+�Hɍa�?@@813x=J6g"3�V30HG��UB�CD�I3`%F(Ce\i667�XU�JL�>G4e&(<�   �  {  D�JK�PX@  _  !KL@   !K _ )KLY�#"+363 #4&#"#��b�T�iq���`���;�J�������     ��V�� 0 4@1$J#H � �  ^  # L /-! 00+"'&&54667667".5467732673!�F1<e?0l5-lb@17_{/;+!Q(#=?p�EFL'��V+>1J��ZE�3!ElK<{7`q-`/)6	q[�ki�>- !�  b�Vd` . .@+  J!K _  'K #L%%$!+%#"&'#"&'&&533267665332676653#�C�Di#eR>\�'H-1�K+-��`{CJHE,;6����wIJV  �{���y8"%�p���     ��V)| 6 P (@% _ )K  ]  # L A?53 66+"&54676676654&'&&'&&'&&546766323!>54'&&#"kLkf4%% &2
F>9�`R�F�:/0x@@ LQ@�	T�rO'f9kAL0�VZKM�:4,5A_5)/J*.L�3/727m�X�HJ�@>HP&))!�fR��hxD" 5>WA-(#O&),P   �  { " [@
JK�PX@   ~  !K ^L@   ~ )K   !K ^LY@	+"+3632!!5676654&'&&#"#��a臦LR6)��:! aE���`��yԉO�D@v:��hv:�WD�426�s    ���^  P�JK�PX@!K  `  ' L@!K K  `  ' LY@ 	 + 332653#'���kp����c���J����y����    ��V�  1@. J  K !K  `   'K ^ #L#!+%#"&53326533!Ucꭥ�kp������������H����/�ӑ  h��i{ 1 �K�PX@
/ J@
/JYK�PX@ ]!K  ^   L@"!K _ )KK  `  ' LY@ .-'%  11	+"'&&53326766536632#4&'&#"#5M�5�K+-�%bB�5�ND,�%bk6�g���y8"%�p�`B9k6�g�)���8XB R3�^`B9    ��V{  L�JK�PX@  _  !K K #L@   !K _ )K K #LY�#"+3632#4&#"#��bꭧ�iq���`�����J�������    ��H*{  %'@
 JK�PX@, ~   ~ )K !K K `  + LK�PX@( ~   ~)K K `  + LK�PX@, ~   ~ )K !K K `  + LK�PX@( ~   ~)K K `  + L@, ~   ~ )K !K K `  + LYYYY@ !%% 	+"'532655#"&5463273265!"U��d�I��Vׅ�jiĆ�Z��>��������H7�/+������������� I�������    5  `  @   !K ^ L+3!!5�&�"`�/�     h�Vi 1 �K�PX@
  J@
 JYK�PX@!  K _!K  `  'K #L@)  K !K _ )K K  `   'K #LY@%#%"+%#"'&&53326766536632#4&'&#"#%bA�5�K+-�%bB�5�ND,�`B9k6�g���y8"%�p5��B9k6�g�)���8XB R3��     O�Vr{  " ��	JK�PX@(
	p  f 		_!K 'K #LK�PX@)
		~  f 		_!K 'K #L@-
		~  f !K 		_ )K 'K #LYY@ ""&"+#533632#"'!!#2765! �xx�\���s9�g�\���ɆCC���������������LQ����c)mj���P�P  ���H{   2@/ ~  | )K  ' L  +"32' ! h������������+ /�������Ӝ���P�P  �V�  & 1 E@BJ ~!K
^  K	 _  K #L10('%+"&'&&'73"&547633 ##"32676654&&#�P}58_/{!G(Rk��rq˯�e⹸}tzw�^'&!7�� M4�-I8.���OM�G���������[0OCHQ�/B;;�av�X   p���  �K�(PX�J�JYK�PX@  K !K `  ' LK�(PX@"  K !K^ K `  ' L@   K !K ^ K  `  ' LYY@ 
 +"&53326533!5­��kp�����_c��l������{�/���  �  3z  (@% � �  `  E L  	+!"&5467332654&'$3a��2�3"����Wf���}æ���?_@=U=����t�)f�3Jװ��     �  4  $ U�JK�PX@ ] FK _  E L@  g _  E LY@ !$$ 	+!"546754&&'&&53'2654&# m����1K&GF�~����刄��������,�6:
dcY9��@�����ʿ������     o�Wa " 0 E@BJ  g _ DK _  G L$# +)#0$0 ""	+"&&546676654&#"&5463 '2654&&#"~��ou�1=bw��.���z��� ���_�QQ�`��W��ruڌ%z<Ej�*-RLj���ۦR8ج�镠�v�FF�v��  7�W� , 8 �@	  JK�	PX@- ~   p_DK
` EK	GLK�PX@. ~   ~_DK
` EK	GL@, ~   ~
  h_DK	GLYY@.-  52-8.8 , ,3#!+"	+&&#"'675&54632363 ! 54##"26554##"3�Q?y3,)S����9R2<�g����I+�P�^k�q4�QM�Gw�W^R+&i,�r���(:b�+��]��m�م,3QkZa{������    ��W3 $ ;@8 ~ | _ DK  `  G L  $$	+"&546733 5#"&&546632w��;R�HH����>�t�di�{�WʹRx@<vRu����oe(l6~�S[���g�w     ��W2 5 O@L0/J ~ ~  g _ DK  `  G L *($# 55		+"&54673326554##532654&&#"#&54632p��*A�D,����IIqq/l\g��<����ly���Wͱ@^FMW9s�opb�_:mFed'l>S}����{�1+��O��     �  K   , u@JK�,PX@  g _ LK _  E L@  g g _  E LY@  '%, ,	 		+! 75&&5! 2654&#"2654&&#"��7�k\UU]F��ZVpCEn[ǈ�O|DD}O��KJ �vL�ßW-�Y��n`zhktbo������OO����  -  �  , <@9	J_DK _  E L!  '$ ,!, 		+!"5!236632#65##"'254#���vJn(+_<���Ԅ!S���DW[YS�,78+��C����Bu�����i������     �  2  !@  _   DKEL    &$	+!&5! #654&&#"�|p��t|�bg6wb���l������g~.�_�Z������   ��Y4 ( E@B#"J ~  g _ DK  `  G L  ((	+"&546733 55##532654&#5 v��0@�20���AAsq��--w����Y��Ov<;tL���2�d[yt���k���2�w    ��W2 1 ;@8
  J   ~   | _ DKGL   1 1)*"	+&&#"'677&5!2&5467665!"��\5_"M>p}|�����a�CL�X�Wqq%&_[�G����SN1MB$0*;A*UKF����5?xt5    �  (  ) �K�PX@0 p ~ _ LK _ DK	 `  E LK�,PX@1 ~ ~ _ LK _ DK	 `  E L@/ ~ ~  g _ DK	 `  E LYY@ #!))	 
	+! 3234&&#"#5! %2654&#"h�*��i�$S�D<mD����Ly�}a{;>�<ASi1$E0>>&���T������m�^_�o     �  2�   �K�PX@( p ] FK _ DK _  E LK�,PX@) ~ ] FK _ DK _  E L@' ~  e _ DK _  E LYY@ 	 		+! !!!"36632' ! _�@N���##xk����������[����B>��������r����   7  � ' 4@1	 J ~ _  DKEL   ' '24%%	+3&55463236632#654#"#4##"�ǿ�GS+,P=�ü���K@�BM����f��/9?)��k������������׿     �  4 * k�%$JK�#PX@! ~  g FK  `  E L@! � ~  g  `  E LY@ 
 **	+!"&54733265!#532654&'$53k��e�[������?Rio���ܬ﫬Yayo��ֽY|�����O�dBE�6�G)��`� :����  ��Y32  a@	
	HK�PX@ p  g  `  G L@ ~  g  `  G LY@  	+ 3! 52654&'5%_�A�	#�Mno���ɞ����Yo��4<+�m���LXg�"�����k  7  � + q@
 JHK�*PX@#   p ~_DKEL@$   ~ ~_DKELY@   + +24#		+!&54$7372363 #655##"#6##"	�R�%����V�HH�=��؄XA�K|g��g~�=�R��=bb�I��и��*���=��ۥ��  �  3�   E�JK�,PX@ FK  _  E L@ �  _  E LY@ 	   	+!"3!2654&'&&5467j����:M1WjdWMAg2VC�������d~1 PII�<|:,S 7�y���     -�Y��   4@1J  e _  G L  	+  %3'24'#V������{�~@C����Ú�����YcaxT���������s� �,:��9�����    7�YJ 9 Z@W$#	J ~  g 	 	e_
DK  `  G L 5310.,(&"  99	+"&546733 54&#"#''#"'73267663236632���>S�N<��L.3Y
�	n%%')IS2"1!,#8T),hM���Y־Y{5HvI|���\c���� "-_�5- OimJ�����     -�W� 5 @ �@&0/	JK�PX@0 p  g	 	g
_DK  `  G L@1 ~  g	 	g
_DK  `  G LY@!76 =:6@7@*($"
 54	+ 333 554'#536554##"#"&&5546323632!254##"��R��/9PP6dS;i�XT�a��Kf'`���NP��4�ҟ^M��W���e�����{ʤ�h]�����+8c˽��,\�i�������x��   ��W� + ~�%JK�,PX@* ~ | FK _ DK  `  G L@* � ~ | _ DK  `  G LY@ ('#! ++	+"&54673267#"#&&54663233V��:L�F7�����X\*(�%!NJh�8���W޷Rm=GmDx���(
Ub@�(9�Dp�>hV��R��   7�V� 7 V@S
  J ~ |   |   |_DK	GL   7 724$&"
	+&&#"'675 5463236326554##"#4##"�b3f-A:@�а�Le&G�����x�d:�AL�>ds6h�k&�W]w&*\T'P��44h��F��������5����|�{R;cb   ��Y2� ! �K�	PX@) ~ p  hDK  `  G LK�#PX@* ~ ~  hDK  `  G L@*� ~ ~  h  `  G LYY@ 	 !!		+ 3! 55##"&5467332653t�*�
.�_�႕�q�<��y���Y�����20�ә�[O��\��uv	����     7  5 , 7 �K�PX@4 ~ e_	LK _ DK

 _  E LK�,PX@; ~ ~  e_	LK _ DK

 _  E L@9 ~ ~	g  e _ DK

 _  E LYY@#.- 42-7.7'%#" 
 ,,	+!".54663234#"#54&#"#463236632'2654&# ���|<f˖]�#���Q>8.�osU~  oe����z�����Z��c��@B!��!#hhb���^cd]���	�����������  �  4  + �@%JK�PX@#p  _   LK _ DKELK�*PX@$~  _   LK _ DKELK�,PX@"~  g  _   LKEL@ ~    g  gELYYY@++$"W"	+4632#>54&&#&"# #63265&#"�����bxo���Zx<:tW����3�/88�gb�����`�4���� `B��^]�\�����h�I�go��     V�Yz% 1 <@9,+JH  f DK  _  G L !  11	+  532654&##532654&'.'3|����ё�����Ua��SPOQB0�B@O;XSoZ���Y[haDdL��ߞ���꽶xq�^PNE
'WRCO+RHQv+F�v��     �  �   �K�PX@# p FK _ DK _  E LK�,PX@$ ~ FK _ DK _  E L@$ � ~ _ DK _  E LYY@ 	 	+! !233% ! Q�9��1��1����sN����x~�}��     �  � , < �K�PX@3 	
	
~ 	e_LK 

	_ 		DK  _  E LK�,PX@: ~ 	
	
~  	e_LK 

	_ 		DK  _  E L@8 ~ 	
	
~g  	e 

	_ 		DK  _  E LYY@ :820%#! 
 ,,	+!"463236632#4&#"#54#"366324&&#"3266M�ߖ�bq!}Wsn�.8>Q���#�[��d9w��Q�F@yNP�HAyLš�Zg_b���bhh#!����B@��b��Z
��TJ�}~�`S�   ��Y4� , : �@%JK�PX@*  g  e
 g FK  _	  G LK�PX@,  e
 g FK _ DK  _	  G LK�,PX@*  g  e
 g FK  _	  G L@* �  g  e
 g  _	  G LYYY@.- 64-:.:#"!  ,,	+"&5467326654'&' !33#276654&#"j��%,�&N{DD}P�qY��AM�^��R�����T)h?>hS�YʷF`5i$JRo89tV�dqdHM	��;i�i7HBhb����3K*i`_nZd  �  H�   �K�PX@# p FK _ DK _  E LK�,PX@$ ~ FK _ DK _  E L@$ � ~ _ DK _  E LYY@ 
 	+! 336632% ! ~�5�)*}`���7�������I;�������{|����     ��Y4� ) 0@-! 
J �  _  G L  ))	+"&5467326654&'&55%553%e��/<�(O}CE|NYh���G�P���hW��Y��WzRYBQ*a�IJ�b]�V���x�������}H�h�u��   �  " = �@3287JK�PX@* p  e FK ] DK  `  E LK�PX@+ ~  e FK ] DK  `  E LK�0PX@+ � ~  e ] DK  `  E L@) � ~  f  e  `  E LYYY@ '& ==		+! 53!26654&##532654&##532654&&'.53\�0�gy6?0��2332��-/*ogOL3�PENM4���VH��ee��Dh5?c�K,-I�F.'.1[K39	+QC�/5��:6oU��  ��YG V �@FELKSRJK�PX@3 		~  g  g 		FK _ DK  _
  G LK�PX@1 		~  h  g  g 		FK  _
  G L@. 		� �  h  g  g  _
  G LYY@ <;421/-+*(%#"  VV	+ 476654&'332654&##53254&##53254##532654&'&'3����
""�:
G�srCC���BB������AEYa��qLK<��W\YZV]��Y_�(F2[�j��(U,Mʾ:L�h;T_Kj��JS����?*.X"�.7%RI�")�RttQNa9���    ���4  ! (@% J G  � _ DL+&	+27$466327$'6654&#"ɕP���srх��[�������������~<Y�C��wv����^�E��F�.ǧ������   ��X4 " }@!  JK�PX@% p   g ] DK  _ GL@& ~   g ] DK  _ GLY@ 	 ""	+ 5#5326''#%#"&&57j��rr��� �l����rsх��� ,���J�]�/�p�� ��ZZ��o[��  ��W, ) �@!%$JK�	PX@- p  g  e _ LK  `	  G LK�,PX@. ~  g  e _ LK  `	  G L@, ~  g  g  e  `	  G LYY@ 	 ))
	+ 3! 54!#53$#"&546"!267a�6��휜@�G���霜,��p��5�W���7�
������{r�TT���wk=�7�k   r  c  " * �K�PX@3 U 
e _ LK]	DK

 _  E LK�,PX@1	e U 
e _ LK

 _  E L@/  g	e U 
e

 _  E LYY@'$# (&#*$*"!	 	+! 463!5!"&5!23#3#54! ! 55! 5�=���������rrrr���������U�����W��ؔ����������������    7�X� # 0 �@! JK�!PX@,	_DK _ EK
_ EK   _ GL@*  g	_DK
_ EK   _ GLY@%$,)$0%0$##3	+2'4#3$5!2363 #"&'#!2654##"h�	Mas���1�C=�2��FM
���A<�LIT���	����ٔx�����t���5?��|9OX�����ji   j�Yf 1 2@/-,J _ DK  _  G L (& 11	+"&&5467>54&#"'463232654'7o��c��4qb=PUL]�
��z�J��j�DC�r��@�d���Y{�r��H(4Q@E[PO8A��M~Ju�At�IH�P��{6\o���     ��YG( % �@
JHK�	PX@( ~ p  g DK  `  G LK�,PX@) ~ ~  g DK  `  G L@) � ~ ~  g  `  G LYY@ $# 	 %%	+ 332654&'7##"'#326653~�5��x�������]Ȟ�VP~FFR��Y���_`����\?j�Ґl�lY�Wt::tW�p  e�WZ$ " . 8@5J ~ _ DK  _  G L *( ""	+"&5467&&5466323265536654&#"t��vy�ɓ�~锭��SZNf�����������W��}�,,Ԡ��bc����YC�XMXGFLL�����������  ��y3 % (@% J$
	 G _ DK   E L(%	+4&'&&#"'675&&5467'654!"�*G5E`!�Ctwu�����l����cn�|p�0!;9JfW����#�����=�旣��\*�]  ��;   k�JK�PX@  g  c ] FL@#  e  g  W _  OY@ 
 	+"&5433%"72'2654#"^`i����F{E\..bA9;rC79���L�RQ�OP�GF�ROk\�xHJy   ���L�  " 8 �� DK�*PX@" _ pK_ kK _  q L@  g _ pK _  q LY@$# /-#8$8""	 	+@ $#$$$-$.$/$8`#`$`8p#p$p8�#�$�8)*0�dD"'&7632'276'&#""&'&&5467632h�yzzy��z<>><{�EEEE��E##FF� #
1'

��}~���`������`Ġ��78���K��Ǖ�	V:.�"|7�LF2|"v>�  �  F� 
 #@  J hK  ^ iL+%!'3!!:�nZ�6�Ȫ/����ժ  �  #� / -@*  J   _ pK ] iL/.-,+747667>7667654'&#"567632!!�9�YDE$5?#IJ���fecah�D<H,E6P5&AH]C��u�%<�aJK)@Z,NN|FG��18<5�`bc2_A"Z9)BG_G�     ���C� < J@G%$3 J  e _ pK  _  q L *(! <<+"&'&&'5327654'&##5327654'&#"56763260i6.n63b42a2�XYXX����MMHF�Sb`gz^YPi�B�#!D��N)%�D�	
�*KL��LL�=<qq==)� 67k�Af(Q#'c4~H�v:<    f  o� 
  .@+J  f hK iL+!533##���X�����)d���3�����  ���-� + C@@ J  g ] hK  _  q L #!
 +++"&'&&'5327654&'&&#"!!67632-o13V(^[]\�XZ2+*�[NLNE���+,&2y�?��E��2XY�W|)(0%���J?���BE     ���L� " 7 G@DJ  g _ pK _  q L$# -+#7$7
 ""+"&'&5 !2&'&&#"67632'27654'&&#"y��;?;#)M (G @F#L#�bc0UVu����CDD#f>Ff"#''#"fa[b����&
	����d65�������YY��Y.*1+,�UU�,+1  �  7�  @ J   ] hK iL+!5!#V�5����+�V��   ���N�   . > E@BJ g _ pK _  q L0/"! 86/>0>*(!.".   	+"$54767&&'&&547663227654'&#"2654&'&#"g���PO�=h$&#y;�k�yy����C>��z@@?@{y��|��'#K��JJJL�͟ed!>-/p?�j35hg���"!Ȟi�6q�??xz@@�zx~���Jj#LKL��MM   ��F� & 9 G@D J g _ pK  _  q L(' 20'9(9	 &&+"&'&'53276#"'&5467632267654'&&#"%M#BM?GJI�cbF'S{�ww;?w≶;@:EK��Ff"II"fF>f#DDB�%��3N5���v�D�a[d�����e��1+\��\+1*.Y��YX    f�B7�  @  �   h L+3#y�����m   �Z{ 
  1@.  JG  �  U  ^  N+35733!h������M$���c)t'�+n�l��    ��Z{ 
  / U�dD@J  J  �   f  g U ] M'-+� D35733!7667654&#"567632!!h������M$����><(dP479?C;><�V,*-o�����c)t'�+n�l���h�<D=4<L$}B"X2#7Em�r   ��e{ 
  0 j@g  $	#,J  �  	 f 	 	g  g W _
O(&" 00+35733!"'532654##53254&#"56632h������M$���ny�\fu�BJ�_X^yEt3������c)t'�+n�l����)y5PE�l{9>/yvc�&+�}�   ��e�   ? o@l 
  3	2;! J    g  	e 	 	g  g W _
O751/,*)'$"??$'+767654&#"56632!!"'532654##53254&#"56632@�f((dRc~Bw<��%&v����%$���ny�\fu�BJ�_X^yEt3�������b<=3=LH}�k::<u�r�l����)y5PE�l{9>/yvc�&+�}�  ��Z{ 
    _�dD@T  J  � ~ �   f
	U
	^N+� D35733!!533##h������M$���}k�tt����c)t'�+n�l����y��o�)��c     ��Z� : > I L ��dD@{&%3< KA>J   ~ 

�  g  g   gU^	NJJ JLJLIHGFEDCB@?,*! ::+� D"&'&&'53276654'&##5327654'&#"5667632!533##O#8 6#>35a= 78lBJ\210/U/89#@;3�VT,,T^21__� $���}k�tt���)
y)8&F&&l ;9 y	;;bG//64TyDC�l����y��o�)��c     ��_{ 
  $ , 7 i@f   	J  �   f  g 		gW_
O.-&%42-7.7*(%,&,$$+35733!"&547&&54632254#"2654&#"h������M$������QY����YQ�������U[\T�]�c)t'�+n�l����p�&dHcuucHd&�q������cUNNT�NU    ��_� ! % ; C N �@�# %	7+J  g  g   g  		g 
g

W

_
OED=<'& KIDNENA?<C=C20&;';	 !!+"'532654##53254&#"56632"&547&&54632254#"2654&#"+ny�\fu�BJ�_X^yEt3������>$������QY����YQ�������U[\T�]))y5PE�l{9>/yvc�&+�}��l����p�&dHcuucHd&�q������cUNNT�NU    ��_{   3 ; F �@� 	/#J  e  g   g  		g 
g

W

_
O=<54 CA<F=F974;5;*(33
 +"'532654&#"!!632"&547&&54632254#"2654&#"1�`l|iotgc[���39����Q$������QY����YQ�������U[\T�])$r7b[Zc)�_������l����p�&dHcuucHd&�q������cUNNT�NU   ��_{  
   ( 3 h@e  
J   ~    e  g
 gW_	O*)"!0.)3*3&$!("(  +!5!#"&547&&54632254#"2654&#"��DH����$������QY����YQ�������U[\T�]_0���l����p�&dHcuucHd&�q������cUNNT�NU   X`�� 
 ?� JK�1PX@ ~K  ^ L@  �  ^ LY�+35733!j�������c)t'�+n  B`}�  Z@   JK�PX@   _ ~K ] LK�PX@   _ �K ] LK�	PX@   _ ~K ] LK�
PX@   _ �K ] LK�PX@   _ ~K ] LK�PX@   _ �K ] LK�PX@   _ ~K ] LK�PX@   _ �K ] LK�PX@   _ ~K ] LK�1PX@   _ �K ] L@    g ] LYYYYYYYYYY�'(+7667654&#"567632!!B�>=(dP389?D:><�U,*-o������<D=4<L$}B"X2#7Em�r  FU�� : s@&%3 JK�1PX@  g _ �K  _   L@  g  g  _   LY@ ,*! ::+"&'&&'53276654'&##5327654'&#"56676322#8 6#>35a= 78lBJ\210/U079#@:4�VT,,T_11__U
y)8&F&&l ;9 y	;;bG//64TyDC    ��L�  @
	 G   t+%73%����$xlx$���^�����s�g{��W{g���Ce��     ��BQ�  @  �   h L+3#�����m   �/�`  @   U  ]  M  
+"554332#�/�� ?��!  @   W  _  O 
 +"'&5476632f|VUU'l@}W&0WY�VW{~U'.U&kB{WV   � <Z   *@' c  _ k L  +"&54632"&54632lD^^DD^^DD^^DD^^^KK^^KK^�4^KK^^KK^  ��}]  9@
 J GK�PX@  _   i L@   W  _   OY�(#+67#"'&54676632��D*,<$U/.\\���n�''G!;DCy�}{>   �  �1  @  ]  i L  
+!"554332#���       �1   %@" ]  i L  
+!"554332#!"554332#������   P  1   # 0@- ]  i L #" 
	+3"554332#3"554332#3"554332#n�����������   ���
�   L�  JK�!PX@  ]   hK _qL@ c  ]   hLY@+!#"'&547632�	Cy:F.../EE/...��C����0.ON.//.NO.0    ���"�    + c@		  JK�!PX@ ]  hK_	qL@	c ]  hLY@%#++
+!#!#"'&547632!"'&547632	Cy�	Cy�PF.../EE/...�F.../EE/...��C��7��C����0.ON.//.NO.00.ON.//.NO.0  ����   1@.J a  _  hL 	 +2#"'&5476!rF.../EE/...�C��M�0.ON.//.NO.0�����C�7       ��   �K�,PX@&f	
  ehKiL@&�f	
  eiLY@+@"y yyyyyyyyyyyyyyy)* !5!!5!3333!3!####��)T��/h�h�i�i���T���h�i�i�%S�T��N���a��a�����b��b7N��    ���7  @  _  q L  +"&54632eD^^DD^^^KK^^KK^    ���� ) : 9@6  J   ~   _ pK _qL+*42*:+:(.+47677667654&'&#"567632#"'&5476632�!RZ-$AlSV-]1`^Zid�3m"$[XF�c>*+*5">***+GOCERY5,2/G7"4"�:3-a�Q@CZVC)',� *+DC***CD*+     "����   A R c L@I/ . J  ~  _pK	_
qLTSCB][ScTcLJBRCRE*E)+46776654&#"566322#%46776654&#"566322#"'&5476632!"'&5476632�(6;'SB5^=@|U��*>9-�`(6;'SB5^=@|U��*>9-��>*+*5">***+(>*+*5">***++e�RY;W,RP:A�=5��L�^VEQ=��e�RY;W,RP:A�=5��L�^VEQ=��G*+DC***CD*+*+DC***CD*+    ����  A j@
;<JK�%PX@  _ jK kK `qL@   ~  _ jK `qLY@ 75%$AA
 +"'&5476632"'&54667766765566553326767�>*+*5">***+r�noF@X-�TZ4
$Al*R-Za2`+0e�*+DC***CD*+�_a�7Y^?V4'B
{�bDFQY85+I7"D�*    R��   @ ]  hL+3#3#R�������+��  ���  @  ]   hL+3#�����    ��*,"  $ �@
J$GK�PX@   g _ iLK�PX@   g _ qLK�PX@   g _ iLK�PX@   g _ qLK�PX@   g _ iL@   g _ qLYYYYY@ 	 +"'&547632$7#"'&5476632bH0220HI0110�� 	E/.0?&Y20°�20PN2111OP02��r�)+IL*GG~���@   f�B7�  @  �   h L+3#y�����m   ^��r�B   �dD@   U   ]  M+� D!!^��x      ���]   *�dD@    e U ] M+� D!!!!��/��/�P�P   ��   @  jKoL+3#3#��ꬬ�  �   ?��q  � 0+	?��^q����   �@
�  @   W  _  O  +"&54632hD^^DD^^@^KK^^KK^  ����    1 0@-   J  _   pK _qL"!+)!1"1)+56632#6654&&'"'&5476632� +_1_�a��A`X/.��941G"[>*+*5">***+>
4"�:7��I�\V.@<)�09R8<N*
�R�D*+DC***CD*+     ��   �dD@   U   ]  M+� D!!��/P    �����  !@H  _  o L 	 + %532$7f������U�Z�Q������~j2gi~vv    ���w  &@#  e  a  ]   jL+!#3#3!�������X��E��F�  Z��  &@#   e    a ] jL+3#53#5!!Z������X������   "��$�   & 7 H �K�PX@ $! J@ $! JYK�PX@- ~   _pK _pK_
	qL@+ ~   _ pK ] hK_
	qLY@98('B@8H9H1/'7(7E)+46776654&#"566322#!#"'&5476632!"'&5476632�(6;'SB5^=@|U��*>9-�e	Cy��>*+*5">***+F>*+*5">***++e�RY;W,RP:A�=5��L�^VEQ=����C����*+DC***CD*+*+DC***CD*+     �����   & 7 H �K�PX@
  J@
  JYK�PX@- ~   _pK _pK_
	qL@+ ~   _ pK ] hK_
	qLY@98('B@8H9H1/'7(7E)+46776654&#"566322#3#"'&5476632!"'&5476632(6;'SB5^=@|U��*>9-�����S>*+*5">***+�>*+*5">***++e�RY;W,RP:A�=5��L�^VEQ=����q����*+DC***CD*+*+DC***CD*+  ��;g�  !@J�  ]   hL +!2###����w�Ս���i��������   ��p�x  ( 0 X@
0)&%JK�'PX@  _ sK _mL@ c  _ s LY@ ((
 +"'&5476632"&54677>553667667�>*+*5">***+g��B_X0.� +_1_��-94g3H*+DC***CD*+�(��J�]V-A=(��S
4"�:7\-9Q9[U  X �y   ?@<  JI
 H    g  g U ] M%$$!+632327#"&''&&#"3#X��0rD s_��E�R6Z=!Da>M�N����s 6{�7;7D:��     �����   1 9@6 J ~  _   pK _qL"!+)!1"1$,+4&'&&''&&54632&&#"#"'&5476632>).XXJ�˶a�Ri�57Z;@�_>*+*5">***+4<:-VV�S��q�CFnZ6W6Y:ZcF��G*+DC***CD*+    ����   1@.J a  _  hL 	 +2#"'&5476!rF.../EE/...�C��M�0.ON.//.NO.0�����C�7     �����  ( 0 [@
0)&%JK�%PX@  _ pK kKqL@  _ pK _qLY@ ((
 +"'&5476632"&54677>553667667�>*+*5">***+d��B_X0.� +_1_��-94g3�*+DC***CD*+���J�]V-A=(��S
4"�:7\-9Q9[V   �����  2 j@
/0JK�%PX@  _ pK kK `qL@   ~  _ pK `qLY@ .,"!22
 +"'&5476632"&54677>5566553327�>*+*5">***+e��B_X,.�APZ:3�k��_��*+DC***CD*+���J�]V-<=-
{�h�PY:Q7[n��:7  ��i�f  @   U   ] M    +&&54673�^^^^f�����~~���� ���   ��i�f 	 @   U   ] M   	 	+543ا�e����� ������    ��e + =@:!J  g  g   W  _  O *(
 +++"'&554'&##532765547633#"33��VU56�tt�55UR�@F�*+-.noZ+*�F�JI��;:�9;���II�++���GG����++�   ��X\ / 7@4	J  g   g   W   _  O/-%#"  +327655467&'&&554'&##53233#"##D�,+Zon-+,�D>�RT**(sE@@�M**TV�>v,+����F"mU��+,�II��Nc�:dN��JJ C���d  "@    e U ] M+!!!!Cp�H���d���� ���c  "@   e   U   ]  M+!!5!!��Hp��S��� ���w�  @   � U ^ N+33!ϸ��X����    Z���  @  �   U   ^  N+33!Z��XK�&    �:w  @ �  ]   jL+!##������ Z:  @  �   ] j L+#5!#J������& (���  @ �   j L    +&'&5476673S�HJJ&nM�G_ B��������s�xy�p���:�5    ����  @ �   j L    +676654'&&'3ރD"AcE��HJJI�����k�u��k�w�������� ��  @   U   ] M    +&&54673�^^^^f����~~���� ���  �� 	 @   U   ] M   	 	+543ا�e���� ������   �����  "@  g   W  _   O+ '&5476$3"3����krqlp�Z�DDA���e�k	��lpp'gkk������    �����  @ J G  �   t+276654'&&'&'52�CAF>*n2=8�mrkwfF�Scb>�j���Y;P&smr������Z<W     g��jQ 
 @   U   ] M   
 
+&5!Yyy���y�o�jz��������    n��c$ 
 @   U   ] M   
 
+!n��	�vvyfjgf��������    D�~�U  @ J   U   ]  M+3#Dt���v�i��� D�~�U  @ J   U   ]  M+3#����t���i���  ��W�.  @ J   U   ]  M+!!��J����B���     ��W�.  @ J   U   ]  M+!!��J����B���    ��B�  @ J  �   h L+!!����\��m�H����  ��B�  @ J  �   h L+!!q�^���^�m�H����    ���v  �0+7��W��W3��W����W    ���|  �0+7'7���W���\�W��>�    ���] ( =@:J  g  g   W  ]  M '%
	 ((+"&&554&##53265546633#"33!w�2Me,,fL2�w�1CEAOOAEC1��8��׈i�h�؄�7�!YTߏ}���TY!�    ����i ( 2@/	J  g   g   W   ]  M&!&!. +326655467&&554&&##53233#"##�5IMEWUGMI5���7Sp//oT7����!YV⎂���VZ!�8��ۇi�i�ن�8    5���& ' ,@)J   c _ jL %" ''+"&'&&547654&#"'66327267]9��iPU]3#'1��WT��R`��O&
��$ڞ~Q��!5*(;N1mlej��$���epu&�    7���& ( #@  J    c _ jL-%,@+3676654'54632&&#"##7
=&��bP��TW��/($1YZPh��9=�
&wnf6�ܛjelm1M<)*6��� ���|��$  ,��� 
  �
 0+.54667���IG��dH�c99c�H��(��%��!��(����~~�͊   ,��� 
  �
 0+7>54.',��IG��dH�c99c�H(���ۙ�����(����~~�͊   ����H  �0+%��e��e���e���l��e   ���AH  �0+7���e����e��8�   ��y  @   U   ]  M+!!��/y�    5��y  @   U   ]  M+!!5g��y�   ��Dy  @   U   ]  M+!!���Jy�    ��  @   U   ]  M+!!�5����   d�m�  @   U   ]  M+!!d	����  d�m�  @   U   ]  M+!!d	����  d�m�  @   U   ]  M+!!d	����    ��y  @   U   ]  M+!!��/y�      ��#  �0+5 ���-/R�������   � ��#  �0+	5�-����+L��^R�^  ����/   &@#	  J  U  ] M+%53#53#5�Ě-�ř`��������   ���    @	  J ]  jL+3#%3#�Ǚb��Ěb��~����~���  ���    @	  J ]  jL+53#53#5�Ě-�řF��������   ��-  @  J  ]   jL+3#�Ěb��~���  ��-  @  J  ]   jL+53#��b�F����    ��-  @  J  ]   jL+53#1�řF����    ����/  @  J   U   ]  M+%53#��Ś`����     ���    @	  J ]  jL+53#53#��b��b�F��������    �`$�  @  �   h L+3#Z���X���  `��   @ ]  hL+3#3#����X����X���u��   �`P�    @ ]  hL+3#3#3#.���X����X����X���u��u��  �`$�  @  �   h L+3#�̬V���   `��   @ ]  hL+3#3#̬V
̬V���u��  �`P�    @ ]  hL+3#3#3#�̬V
̬V
̬V���u��u��    )���   &@# a ]   jL+!#3!%#)�����,�d��ddZ�� (���   &@#   a] jL+3#5!!%#(�����ȪZd��dZ�� ���J  @ J  �   j L+3#��������p�p  ���J  @ J  �   j L+3#��������p�p   ���   @	 J �  j L+3#3#�����m�������p�p���p�p  ���   @	 J �  j L+3#3#�������������p�p���p�p   # 2��   # �K�PX@#   g g W _OK�PX@  g  _ DK _EL@#   g g W _OYY@ #" 
		+"554332#"554332#"554332#A�M~���3tt��rr�jrr  ����  '�dD@  J   U   ]  M+� D53#(Ӥ�=����   z�Ym  �dD@   � t+� D3#�����m��     ���%  �dD@   �t    +� D467667676676673�)%*g8i8o#�J&a3C�k"�<l,194'/%u\07'*5'    y�Xf  �dD@   � t+� D3#y��f��     �� , @�dD@5 ~  g   W  _  O " 	 ,,+� D"&'&&'3327654'&#"#467667632*P%"6�3#385V3.�}�736�Q>AE�54A$"b�I9 /O-* Ýx�BET#'&vO;X!&  ��  F�dDK�PX@   n U ^ N@   � U ^ NY�+� D3!!������z �  �R   .@+   ~   eL  
+"554332#"554332#���T������  d�m� 
 $@!
 J  H   W   _  O$!+3267#"'d|�B�D���|�<�;;  %  �' 	   {�JK�PX@%n 	  h
 f hKiL@$� 	  h
 f hKiLY@ 
 		+ '332733#!#h��w��w�c���n��l���5�oo�`�+��{'��  ���%� ' 0 <@9 0(  J   � � � _ qL+&&'&&54676673&'&&'667667#�p�B?GI>=�vg={L@D#> @!D .=C7g�OPPQ�WQM�xz�LK\��"�&�����vw��wv  {��c9 & , 3 \@3,*
 $"JK�PX@�  jK ` qL@  �� ` qLY@	3'+%&'&4677373&'327#"&'#7&'#&'>�����;8�+'4;��٨���;4"�t4A��->&�QqJ��c�O�KNi��;*���Ӑ?W����&�p����   � �LB & 6 K@H %J
	 H&G    gW_ O('0.'6(6$".+7&&54767'7676327'#"'%27654'&#"ͦ!�^�..-1[f�Z�!�^�.-/2_`�d[>>==][=?>?�6X13-0+�_�;�]�7(-31-2)�^�9��>@[[==<<^XA?   ���Z 0 9 B B@?B9&   J  Q] jK  _ iL+!&&'&'5&&'&5476753&&'&&'#67654'&'(d3^i6`4c[Z�4eji��S%)R*,\"U �klts��];;79cxe=>89o+�!-!�;/[��^]���$
�Q `b��hg	���88]W23��:;aa23     ���K   " ��	JK�PX@.e 
 
a jK 		_ sK _  q L@2e 
 
a jK 		_ sK iK _  q LY@# "! 
	 +"32!5!533##'' ! !!������[��1����]�����V��;7�5y��y��������P�P���  %��%� C b@_?@ Je	
e _ pK  _  q L ;96542'&%$! CC+& #73&4''7465#73667632&&'&#"!!!!327667����3�1u�1}^C��RMKH!J&MS�WW�1�Fi1��WW�RM*F!GKM%n
>Al��G�*�/"hh�l	  
n�hi"/�*     �V� 0 L@I Je _ jK  _  m L +*)(#!	 00	+"'&'53267#5!667632&&'&&#"!!�823.000ftu�1>1c�02/5*-3M9-/��dG3a�V
�����J\�2d		�!>��ɏ��}�<s       C�  1@.  e  e ] hK iL	+#53!!!!3##���Z�pP�����9EW��H���E��     �  l� # K@HJe	
 e _ pK  ] iL#"! %#+73#535#5354632&&#"!!!!!!�쿿����Q�ON�J�q��y��q-��B���_���*(��H������  
���� C LK�PX@56#
JK�!PX@56#
J@56#
JYYK�PX@9 
g ]hK	]kK 

` iK  _  q LK�PX@= 
g ]hK	]kK 

` iK iK  _  q LK�PX@H 
g ]hK	]kK ]kK 

` iK iK  _  q LK�!PX@>	U g 
g 
 
h ]hK iK  _  q LK�'PX@A	e 
g 
 
h ]hK _ sK iK  _  q L@E	e 
g 
 
h hK ] hK _ sK iK  _  q LYYYYY@+ED KIDLEL9742'%" 	 CC+"'5#"&5####32333#33532654&''&&54632&#"2654&##�ZjZiR&|}~d�Sg6*\��9Z6a/?F<K UKnm`LNZ�0K]Vz��FMMF~F��`�����[�Z>����%'#91X\ND$$����<�P�=I"*����������   �  X� ! 9@6J e _ pK  ] iL)$	+73#53547632&&'&#"!!!!����nm�JCM("A>D�?@s���3�я��}}�!	YX�ُ�/�    ���`    # * W@T	J  �g	
	g jK

 _  i L  *)%$ # #"!+!!!53##%6654&'#%6654&'0��xd��{����d�]xofd����z��
��y�������,��vTneQ�
��!fy�l   
���� " �@  JK�,PX@/  e    g _ pK ] kK 	] 		i	L@,  e    g  		a _ pK ] kLY@"!$#$"
+#"32&#"327!!!!!!�<�M��ܽ�tq������q�^��o����78??n�����������`�  _��Y� ) �K�PX@
('$ J@
('$ JYK�PX@  W _ pK _  q L@   g _ pK  _  q LY@ !	 ))+"$54$32&&#"3632&#"667¼�픔��T�v��\�^�U�#.Bv�Y�U��[��[���^_�������]������wV_ӏ   m�Bo 3 �K�PX@ 1  J@ 1  JYK�PX@  n 		�  _kKiLK�PX@ � 		�  _kKiL@# � 		� kK  _sKiLYY@32&""%
+4&'&&#"#36323632#4&'&&#"#5#.*,,��E�JSBj0.A@b7�.*M�]i���#���``{=$�26g���w��=#�w����        ��   " & ) g@d) Jf	
  ehKiL##('#&#&%$""! +#535#53!333#3#!##''#!5##�������Ģ��������O�9~�9~OO&{�{&��&��{�{��&������򓓓�{�     
���� ; B �@-.JK�PX@/ g 		] hK _ sK iK  _
  q L@/ g 		] hK _ sKiK  _
  q LY@=< A?<B=B1/+) ;;+"&'&&'#.###!23254&''&&54632&#"2##�!8�z 9H4��$��TP.K':|�O_)o`��;v.gr�;b){l�����
ck*����К�%�z�g�NG"$�����P�:O *����:
��        ��  # & * - 0 p@m0- J%I	
f  ehKiL''$$  /.,+'*'*)($&$& # #"!+#53'#53'3!73!733#3####7!!'!7!##YYD2�1� �2CY���ȿ�������ϷIr�p��u������u���w��uuuuuu���g��     *����   lK�#PX@' ~ |  ]  hK ^iL@$ ~ | b  ]  hLY@# 	+%6#4&#!#!"33!3*��ؕ�����ԕ}���������V����*$o����N�  *  ��  /@, J  fhKiL+#5333!!##����<�����~r�����s���w�s���1  /  ��  0@-  J  ] hK iL+'%5'%!5!!77#�M�M�+s�-�P���P�����nو�n������o؈�o���   �9�� / C Y k u n@k<@
n
X, JY G  g  

g pK	 `  q Lml[Z10 qolumucbZk[kVTLJ0C1C&$ //+"&54632667'667632#"&'&&''%2676654&'&&'6676632#"&'276654'&#"27&#"�7QE9$(_$
	\4#=cg�3,,$1#L_34

&9Q!%b6^+:?U>%.)>"////9>�& $!���eZ�'M
0"55Wx%@{m^��g��}Av0i:

&T��f_�`q�BUP��EU"70��И�1<2T�x�??63��\Dh>Q-+QN#8:^>"  .���� 1 = @@=*J  g   g _ pK   _ qL&'%#'+%2654&'#"&'&#"'66323267&54632#6654&#"���1FJx7LX6+C1�RzG,\#155㫁P�T56^Wf֨�""?14:L��~<[FD:NFCQ`�m%)92#����M��b�UV�nw�r�3�GgkoQ[�    j  ��    ' , ^@[e  e 	
	e ] hK 

i
L)(!!+*(,),!'!'&%  !+#535#53! 3#3####&##654'!27!�[[[[��^x_^r%�����M�����M�rsst	��t!s{����cc�#s�tt  5�[�x   ) K@H!) J   � �  e _ pK _ qL+&&546753&&'667#5!#E�j�^`�lN�9x"d�v��NooN��F��G���CF�`[�?#'���TN�� l����ҙl     '  ��    O@LJf
 	 e hK		i	L+#537#5!3!#3##!#'!˅�C��Х�A������3���`_!>��={�{��{�{�����A������      ���� 5 ^@[23 Je	
e _ pK  _  q L 1/+*)($#"! 55+"$547#537667!5!67654&#"56323#!!327������kH�E?7����ҫ��z��0�i':��,����l���N@{"D{	7[w�w�NmǅK={.D	{;\����--   ���O  . <@9.  J �  g   jK _ qL+.554>757&&#267#�]��Y[��Ye^�X[�ed�ZZ�[d[CT:F1S.^����Z��DH�iZ��Yj�HF���BR�g&G\�01  /  ��   %@" e  ]   hK iL+!!!5!!#/s����+s�-�ժ�ު���  h  q� $ k� JK�PX@%   	 e] hK]kK 		i	L@#e   	 e] hK 		i	LY@$##!#
+.##53267!7!.##7!!!##r4X_@�ݑ�
��7�
>w`�7�7��V#7���4PR8��ymm$��f{3_={{P{��6vp�h   %  ��  >@;Jf	 
 ehK 

i
L+!5!5'!53333!!!#�q�Z������lk������V��o�o#�o1�m���o�#o��    ~T�  @   � U ^ N+3!!���p��*��Ԫ  X1y� ' L X@U  (;J':I HLG    g  g W  g _ O')%)''++67632&32767#"&''&&'&#"67663233267667#"''&&'&&#"XOHDd$&"/,/q3DEDJHJGN8^7!00 42TBK&RF O)e�!<`3)B "D*JHGM_o!N8KGGJP=?�8/"�@7,#�93A  � �+U  &@#
	  J  ]   kL+'%%73%%#/��9f��9PsP9��f9��s(�b��c�y���c��b���    TbL " 4�dD@) g   W  `  P   " "'#&$+� D#"'&'&'&#"#676323267%H�O:4JO$)$M "�@S�I;E 72*.PGHp�A�"!enHT�υ�#C-K2,��  P j��  2 > b@>=<;:987654JK�PX@  c _ sL@  g  W _  OY@ (&22 +%"&'&&546767632'2676654&'&&'&#"'7'77'ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78����c��c��c��jVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=���c��c��c��  P j��  2 > �K�PX@&	e  		e
  c _ sL@-  g	e  		e  W _
  OY@ >=<;:9876543(&22 +%"&'&&546767632'2676654&'&&'&#"!5!3!!#ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78�
�����jVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=F�����   X �y�   " C@@  JI H  g  e  a  _   sL%$%"+6632327#"&''&&#"!!!!XT�Q$gU =a1��E�R6Z=!Da>M�N!��!��@3${�7;7D����    X �yo    6@3  e a  ] k L  
+"554332#!!"554332#���!����y�����i��   �/�`  @   U  ]  M  
+"554332#�/��  �  P�  [K�#PX@  e ] hK  ]  i L@  e  e  ]  i LY@ 	 +!"&'&54763!!"!!3!x��BC�ut���(`�(��#2�X�Ǧ���Pdb��w*j1�da���   J c��  + < d@ 87+J HGK�PX@ c  _   sL@    gW_ OY@-,,<-<(,'+77&&5476327#"&'&&'&#"2676654'&&'Ju.A���o�;ucv-A�K�tl�7v�$FON�:<7BN�9;8��(F�u:�mߝ�E,ucv8�mߝKSA.ve	;9<�NPD&�;9;�NQE)��   X`y�   "@    e U ] M+!!!!X!��!�����  X �yB    QK�!PX@  e  a  ]   kL@     e  e U ] MY@	+!!!!!!X!��!��!��B�����   �  �  )@&   e ] hK   ] iL+7!!5!!5!!���L��Lk������+    ��  ��   @J    e iL+!#!������p��q���  X �yw  �0+5XR��!��D=@��^��^  X  y?  
 @  H   ] iL+%%5!!X#��!��!����������V�     ) ��� $ 7 I M@JE) Jg
	  W
	 _  O98&% B@8I9I/-%7&7	 $$+%"&&54676632632#"'&''2767&&'&#"!267654'&#"LT�L''%kE2L!"=`�?i'%0QQRAAMAB#K7B55/2.<G/*7m"<-**FB45. 0-�b�oP�416YE�:30�Z�gi22�|5�;;~HY1BW;jB# #Cmj@@::}KV2     ���L 7 �K�PX@  p n   d _ jLK�PX@! ~ n   d _ jL@" ~ |   d _ jLYY@ .,%#
 77+"'&&547632326447632#"'&'&&'&#":T3"#:#77
Y��'G1@7*i
7.`��)94! 0(cM*-*$U��+B3@"$��h�6���d�  |���  mK�PX@ p nK  `  o LK�%PX@ ~ nK  `  o L@ � �  `  o LYY@  +"&546323236Xb@607	g�5/_�TB6>, $k/k��$�����n�   � Ll  cK�PX@ p  _   nK oLK�#PX@ ~  _   nK oL@ ~ �  _   nLYY�'$&+477632#"&'&&'&&#"#5/_�Xb@9,3	g�$�ln�TB6>&#������     �  ,� ( 4K�PX@  _   sKiL@    giLY�)'+467667632#4&'&&'&&#"#�y[Ydm�9,
��QM��Dx�4gt>7L8,�����`$#6B>9"+c�`  X �yw  �0+5X!��R/������÷     V  w?  
 @  H   ] iL+5!!V!��!��!��L�K���V�  �  ,�  @ J   �iL+3##��M��������^��T   Xsy^  >K�PX@   o   U  ]   M@  �   U  ]   MY�+!5!#���!����    �  ,�  @ J  � iL+33#��������T��^    X-y�  @   U   ]  M+!!X!��ת    � �;T  �	0+7�^��t^_t��\t����%\^u��^u����w^��     ��OPi  $ + y@+J HGK�#PX@"
	e ]  hK ] iL@   g
	e ] iLY@&%$$$!"(+7&54763373#!!3!!"'#"#?Cx��tt��6�'|��>�����(0,:|�v�c#��%9��bW��Rbb�2��#��'������bc�:Z1nD     X %y�  4@1
	H Ge  U ]  M+77#5!7!5!3!!!}��J�����}������y��Ӭ�;fժ���    X��y>    3@0 J HG  a _  kL")+7&&'&5466337!!!!#"5F-K �م~K�9���#��K�J[�W_+3�4!���ۀ�5���p��X�^�_+   ~T�  @   � U ^ N+3!!~�,�*��Ԫ     ���- 5 G G@DJ ~  g  g _  q L76 ?>6G7G,*! 
 55	+"&'&546766326676654&'&#"#"&'&5467632'27654&'&#&!H�2e779�L`@6%H!8&"2$%#Dj�k37MBE�loEF,NFtC,65k�W�AC<-D7,S*)OBe#A =0�Kӊ���fjr8���EZ>�yGZ=   !  ��  ' + ? L �� D@\)* (+J  g	  g  g_
iLA@-, HF@LAL53,?-? ''
 +@VK KKKKK'M(K)K*K+K3K4K5KFKGKHR(])]*R+� ���	�
������ �'�(�)�*�+�3�4�5�F�G�H*)*0�dD"&'&546632'276654'&#""'&546632'27654&#"_Dt*\T�Z@;:-.\*vEM768JN565B��~��E�\ZT�Z�^"-0_�M65lLMjj1*\�]�R-.9:A�\*2�5C*L6544PO5���q�R�;\\�^�S^68A?t0\�65MMljONj   X  y  @  �  ^ iL+7!3!!X����ߪZ���        ��    $ 7 K \ q m@j"$	J  g  g		g
_iL^]ML98&% ig]q^qUSL\M\B@8K9K/-%7&7  	 +"&'&5476632'27654&#""&'&547632!"'&5467632%2654'&&#"!2676654'&&#"?h&RS&i<zR$/K�QE10bDE01`�'��>h%QSRw?h%SR&i*{QR,&Sy>j&))R%i�XFa1=%D//1�%=1=$$=01X-'Sy{S&,R$iAP�M{10EDb01EF`���`�`��-&R|zSQ-%SyxU&.TSy?g&S-&)i9xU&.yaFF1/>&D21>F10G=1     X qy�  @� D@# U  e ] M+@kkk
k)*0�dD!5!3!!#�D����C�-���D��D  X  y�   +@(  e  e ] iL+!5!3!!#!!�D����C��D!����I�������     ��L9�  4K�(PX@  ]   hKmL@    emLY�+!#!#��������^��     X �y_  %@"   a ] kL 
	 +%"&&54663!!"3!6��مD��[�WX�[D��م�؁�Y�Z\�W�  X �y_  @    a ] kL&!& +!26654&&#!5!2#!XDZ�XW�\��D��ن��9W�\Z�Y��؅�ـ  � ��  * G@D 
Jg	  W	 _  O &$** 
+%"&&54632663"3"&''267&&'&#"�U�L��\�8.�[9g. 2/9P�M@�eEi+2.<HZR�a�t��s�v~�t}QS2�d�xo�}wHY1�pi�     ;���� 
 A@	JK�PX@    e iL@ �   U   ]  MY�+'%3##�)#�Ӕ/�5}b�%����  X  y    2@/  e   e ] iL 
	 +"&&54663!!"3!!!6��مD��[�WX�[D��!��D�م�ف�Y�[[�W���  X  y    '@$   e    e ] iL&!& +!26654&&#!5!2#!!!XDZ�XW�\��D��ن��!���W�[[�Y��ل�ـ��   Xsy^  >K�PX@ o   U   ]  M@ �   U   ]  MY�+!!#X!���^���     X�y  4@1  J
 HG W    g _ O%$$!+632327#"&''&&#"X��0rD s_��E�R6Z=!Da>M�N�s 6{�7;7D     �  P�  OK�#PX@   e ] hK   ] iL@  e   e   ] iLY@	(!$ +7!267667!5!&&'&#!5!2#!��^�*��MKLZ�(؈�BC�tt��(��{&g8�f�KK�Ĩ�����bb  ��L=�  M@  JK�(PX@  ]   hK ] mL@    e ] mLY�+5!!!!�%����#
����R���P_������     � ��   # ^K�PX@a  ] k L@   eU]MY@ #" 
	+"554332#"554332#!"554332#�����S���3����      ��     [ g s  y@v J  g  g
g

_	iLutih]\"! {ytuomhsisca\g]gSQGE?=31)'!["[	 +"&&546632'2654&#""&5466326676326676632#"&'&&'#"'&&''2654&#"!2654&#"!2654&#"P�LL�QP�LL�OEabFC01a�'��f�?mDbE	Fh>I
"T3Dm@@mE4R"
#M7fG	Gc9RQ:9OO�:PR99QQ�:PR99QQXM�PP�MM�PQ�M{aDDc01DFa���`�`�ɥzQ�LS		S3 	',L�QQ�M-'(,T		TycDDcaFFaaEFbaFFaaEFbaFFa    ��,  &@# U  e ] M+!5!53!!#4��j��j�_��_�  ��3  @   U   ]  M+!!��f3_  a��   >K�'PX@  a   ] L@    e U ] MY�+!!!!��f��f�_�`     ?��  &@# U  e ] M+!5!53!!#4��j��j8_��_�  8��  @   U   ]  M+!!��f�_   ��	   "@    e U ] M+!!!!��f��f	_�`     J  �� " J�  IK� PX@ _ hK  ]iL@   g  ]iLY@	&&+73&546323!5654#"!J�xq�����pz��1t�����;qR�1�� ��2����Ҹ�߅��HL�������2�   u��\� ! ;@8 ~ | _ pK  _  q L 	 !!+"'&5 !2#&'&&# !267673|��E@}�l=�#wS��8Sw#�?l��g�{�U��DJ6HQ����QH9GH��R     ���5    �K�PX@0 	  	oe jK
]hK ]  i LK� PX@/ 	 	�e jK
]hK ]  i L@/ � 	 	�e
]hK ]  i LYY@+!#53!5!!5!733!##!Z����D��2������tK��������``�+^����j��   � �N]  1@.  e   a ] kL 
 +%"&'&&546763!!"!!3!v��B# �rs���(X�Q��Q�Xإn:w<��>?�Fg0�1fF�    ��OPi  " + �@!JH GK�#PX@#
	e ] hK ]  i L@!  e
	e ]  i LY@$#*)#+$+""+!"+7#53!5!&#!5!27##&&'267667!�'{����r��(�/-9�Cy��tt��6'E:rM[�,�ӑ�ݪ���1�e������bb��f�F���y��&g8�#   � �N]  &@#   e    a ] kL(!# +!2667!5!.#!5!2#!��Z�Q��Q�Z�(؈�BC�ws��(OFf1�0gF�nm���C@     �  �  @   ] iL+!!���#��    ��L9�  6K�(PX@  hK ] mL@  � ] mLY�+3!3!��k��_����^   X  y�   +@(    ee ] iL+!!!5!3!!#X!����D����C����`�L�����    +G��   1@.  g  W _  O 	 +"&&546632'2654&#"eY�RT�Y�]0,V�YPqpPNomGR�Y[�U_0q>Z�SmOOpoQOl  ;���v $ / �@  )('& JK�PX@-  e _ nK _ jK	  _ sK iL@-  �  e _ nK _ jK	  _ s LY@ /.-,+* $$
+"&'532654&##53254&#"56632'%3##�Bp<Fn5^wmnBJ�_ScyEt6��������)#�Ӕ/�yOKELly:?/ywc�&+�x���5}b�%����  ;���e 
   �@JK�PX@&   ~  e	  f nK iL@%   ~ �  e	  f nLY@
+!533##'%3##��}k�tt��� �)#�Ӕ/��y��o�)��c��5}b�%����  ��  @   jK oL+3#���      ?�|�  ; v@01"! JK�PX@g _	  m L@g  W _	  OY@ 53.,&$;; 
+"&'7326546632&&#"!"&'7326546632&&#"�(f-C1&+6lP(f-C1$/7k_(f-C1&+7kP(f-C1$.6l�|L^"A�]Ia��B�\L^"B�]Ia��A�]   5����  7 S f@cI-J<. ; J
g	  W	 _  O98 NLGE@>8S9S20+)$"77 +"&'732654632&&#"3"&'732654632&&#"3"&'732654632&&#"� 9$$/bm 9$$.`� 9$$.`n 9$$/b� 9$$.`n 9$$/b���/]o��/��p��/]o��/��p��/]o��/��p�    � ��   # ]K�PX@ a  ]k L@  e U ]MY@ #" 
	+"554332#!"554332#"554332#������S�����3��    � ���   OK�PX@ a  ] k L@   e U ]MY@  
+"554332#"554332#���S���3��  � ��   # / lK�PX@
a	  ]k L@!	  eU]
MY@#%$ +($/%.#" 
+"554332#!"554332#"554332#!"554332#���������S�����3����   X-y�   IK�PX@  a  ] k L@   e U ] MY@  
+"554332#!!	���!��S��|�  J ���    cK�PX@  e a  ] k L@"   e  e U ]MY@  
+"554332#!!"554332#������]�S��|��Y��   W �}�    ' 3 �K�PX@"  e	a
  ]k L@)
  e  e	U	]MY@')( /,(3)2# '& 
+"554332#!"554332#!!"554332#!"554332#v�e���!���j�S����|��Y����  X �y�  $ 0 �@J$IK�PX@$  g  g 	a  ] k L@*   e  g  g U ]	MY@&% ,)%0&/"  

+"554332#632327#"&''&&#""554332#	�����0rD s_��E�R6Z=!Da>M�N��S���s 6{�7;7D����    X�y  =@: JH G  W   g  _  O  +"&'532776632&&#"6}K�K��^t Dr0��L�Q>bC6`�6<�{6 s�B9
     X �yG  ;@8	 JHG  W    g _ O$&#%+%&&'&#"5632327#"&'�X43����9^N�SVK��E�O.Y3S��{�sW��"{�7;��    X1y�   ?@<JIG    e W  g _ O$$&#+!!66323327#"''&&#"X!��N�M7nB!=a0��F�Nao!Qm(Q�J����>7}�8;3%<A    X`y�   ?@<  JI
 H    g  g U ] M%$$!+632327#"&''&&#"!!X��0rD s_��E�R6Z=!Da>M�N!��Ps 6{�7;7D��  X cz� * J@G%JH* G  g  g  U ]  M&('"+77#5!7&#"566323267#"&'!!�Y�Q�\cL@$VT�B4ZF�q�" Q�:$ms-</n*�x�ǚ��*5�H/Xd��D7�#4���  X 1y�  . W@T  %$JI H.G  g	e
a  _   sL-,+*)(%$%"+6632327#"&''&&#"7#5!7!5!73!!!XT�Q$gU =a1��E�R6Z=!Da>M�N�,�u�� {hq,���� ��g@3${�7;7D�=����R=����   X  y. . V@S 	JIH. G  g	e
  a _ sL-,+*)($6$%+%7!5!7!5!7&'&&#"566327327#"'!!!!62��ME�n�K	Nf0��N�X1eJ:V�Q��K�M "8��!E$��F7�����"{�<7 �8�{�<6�����  X 0y� 2 c@`%!&1+ J*I H2G  g  g  W    g _ O###&$%$"+%&#"56327&&#"56632327#"'327#"&''zc4-N�K��#@#67[1��L�Z2`O]�a91����EG4uX����2j3bYJ;B�u

�{�:9 7)��{�r�5}�s��   X �y�  3 7 �@!  'J&3I
 HK�*PX@*  g  g  g  		a  _   sL@0    g  g  g  g 		U 	] 		MY@76$$&%%$$!
+632327#"&''&&#"66323327#"''&&#"!!X��0rD s_��E�R6Z=!Da>M�NN�M7nB!=a0��F�Nao!Qm(Q�J!�� s 6{�7;7D�>7}�8;3%<A��    X �y�  3 N �@0  '4	B
J&3AI
 HN
GK�*PX@2  g  g  g  
g 	 
	
c  _   sL@8    g  g  g  g 	
	W  
g 		
_ 
	
OY@LJFD@>%$$&%%$$!+632327#"&''&&#"66323327#"''&&#"66323327#"''&&#"X��0rD s_��E�R6Z=!Da>M�NN�M7nB!=a0��F�Nao!Qm(Q�JN�M7nB!=a0��F�Nao!Qm(Q�J s 6{�7;7D�>7}�8;3%<A�>7}�8;3%<A     X �y�    $ P@M J IH   g  e  a _ sL $#"!  	+"&'5326776632&&#"6!!!!}K�K��3`< Ug$P�TL�Q>bC6`��!��!��n6<�{$3@�B9����  W �y' 	  A@> 
JHG   g W _ O  		+"%52%$32$'"i���[��S���'H��I������ٜ������������     X Dy�  : I@F   g  e
	e 		W 		_	O5432.,'&%$::%&+3>766323!&&'&&!"&'&&'#5!326767!#X�=@#K*P�&���3)+6S
��<�2�W2*00UV�>;M�Na,aO,@�a�$GHK.�JP`3�\�!GJ7a�Ra'2   X`y�  ! 0@-   g  e U ] M%&+3>766323!&&'&&!!!X�=@#K*P�&���3)+6S
��!���Na,aO,@�a�$GHK.�   X`y    7@4   e  e U ] M  
+"554332#!!!!	���!��!�����F��    X��y       # �@	I HK�%PX@2   � � � n
 f  e	] 		i	LK�,PX@1   � � � �
 f  e	] 		i	L@7   � � � �
 f  e		U	] 		MYY@#"+"54#33#325!5!!2##"5543	������!��p���F���j�F��    X��y     C@@   e  e  e ]	iL  

+"554332#!!!!"554332#v��!��!��C����F������     W��y     C@@   e  e  e ]	iL  

+"554332#!!!!"554332#����!��!������F������    J.��     H@E   e   e U  e ]	M  

+"554332#7!!"554332#7!!h�j�����j�����ݪ�6��ެ   J.��     H@E   e   e U  e ]	M  

+"554332#%!!"554332#%!!������o��������ݪ�6��ެ    X`y�   3@0  e  U  ]  M	+!&547!5!!!!%6654'#X>��!��8��]4�43
<<>:��@& 8&��> F40HH0    X`y    # D@A  e  a _ jK  _	k L #"! 	 
+"&&546632'2654&#"!!!!fR�KM�P}QTN�OIdeHIdd�8!��!���H}NOLSPtN~Jo`EFbbFE`���    X`yK 	   8@5  	J    g  e U ] M#!+632&'!!!!���������^!��!�������	�`��   X`yD  
  �� JK�PX@#   ��  f U ] MK�PX@  ~  f  a   j L@#   ��  f U ] MYY@
+3##!!!!�鏫���!��!��D����VH��    X`yD  
  �� JK�PX@#  � �  f U ] MK�PX@   ~  f  a  j L@#  � �  f U ] MYY@
+33#!!!!.������@!��!��D�V���H��   X`y� 	   �@	 J HK�PX@  �  f U ] MK�PX@  f  a  h L@  �  f U ] MYY@	+'!!'!!!!��TU�U����!��!��� � �� ��e��  X`y�   
  n� JK�PX@    �  e  a ]kL@&   � f  e U ] MY@
	+3!%!!!!6e��͗���!��!����io��z��   E`�  $ 6 C J N R	K�1PX@	45 J@	45JYK�1PX@A	g e
  g  e  a _jL@PW	g e  g  e  a _jK
_jLY@ADD87&% RQPONMLKDJDJHF><7C8C310/,*%6&6$#"! 
 +"&5463253#'#5354633#"3##"&54632!327%2654&#"%&&#"!!!!�M\\M'AC=A�??>E?@#mmC��bqlXT^���EIH��5;;55<X966@�&!��!���t__u"%���=%"j3E<7%$3��
ndbsh[ �%>7SJJR)*HKS�7@A7�ɪ�    X`y  # ' {�JK�'PX@+  	
	e 
 
a _  jK _  jL@(  	
	e 
 
a_jK ]   jLY@'&%$#"""##+36632632#4#"#4#"#!!!!�QT;:SAzX[YrCQYqEPY�!��!��U028?wxo��H�]Q��H�]Q��@��    X`y�  ) - 1 N@K  J   ~    g  e  a	_ kL10/.-,+*%")(#)
+46776654&#"5632#"554332#!!!!+-@5Pd_b^p%,,`*��!��!���8;+,+-7D^8aO)B++.>�CC@��  X 
y�  r@	H GK�!PX@ 	e
  a]kL@'e	e
  U
 ]  MY@+%7#5!7!5!7!5!73!!!!!7�=X�k�X���U�7���Y�� Z:�wSJv������Aw������     X  y�     1@.    e  e  e ] iL+!!!!!!!!X!��!��!��!���������   V�Tw�  
  ,@)  H    e U ] M+5!!!!V!��!��!��!����K���V�`�   V�Tw�  
  ,@)  H    e U ] M+%%5!!!!V!��!��!��!���������V�`�  V��w�   ;@8 	H Ge  U ]  M+57#5!7!5!73!!!V!��!��'�p[�5m�{*���[������K�����)�`��u,�`��    V��w�   ;@8 	H Ge  U ]  M+%%57#5!7!5!73!!!V!��!�ߣ'�p[�5m�{*���[�������������)�`��u,�`��  W  y  2@/
 J HG   W   _  O+756677&%5767$�|�n�Qa���[��z�آb�����M)I�4F����M��)I�g#������   X��y    �0+%%5%%%jw�w2r�K/��d���tK�������m0�x���������oV   X��y    �	0+%75%%5'<K��nd�.t�w���r��>�x��E���u0�������V�   X�y   ,@)
	H G ]  i L+7!5!%5%%%!!%?��C_�^?s�M��N��#N+��P�� Ӿ�����`5�Y�d�|�����J>   X�y   ,@)
	H G ]  i L+7#5375%7%5!!'�>��:��fL�N�t�s���N��EO�*����\�h�}��a5��������<�  V��w?  ! 6@3 J  H!G    g _ qL%$%)+56632327#"&''&&#"V!��!��T�Q$gU =a1��E�R6Z=!Da>M�NL�K���~@3${�7;7D    V��w?  ! 6@3 J  H!G    g _ qL%$%)+%%56632327#"&''&&#"V!��!��T�Q$gU =a1��E�R6Z=!Da>M�N��������~@3${�7;7D   V�w + . B@?*  J.-
H+G    g _ qL$"3+"56327%5%%%327#"&''&&'%X����E�^As�M��P��#Bs^��K�N9X;!&_���վ{�sփ��_5�X�c�|���6{�<6���K>   V�w , / 6@3+" J/.! H,G   _ qL%# +566775%7%5327#"&''&&''�UGIN~:"��gN�K�t�s���;I s_����4\<!4-+g�*�
@�<0j]�i�~��b5�����6{�r
���;�     V�Jw�   �
0+5%%5V!��!��!��!���K����l�������    V�Jw�   �	0+%%55V!��!��!��!J���������K���   V�pw�   ! 
�! 0+75%%57%5%7%'L�4P�|��3hn�L���P��N���m����%�2���N�Zp��O���h2�M�X��q��N�����WJ� H�  V�pw�   ! 
�!0+%5%75%7%5%%'}����A�0��Y}�~'�b��
0&��|�U��iX���^��_��������2�e\��`��������j�7��    V��w/ 
 � 0+ %5$ w���&�C���\�?-Ŗ������Wa��  X��y/ 
 �
0+7 %$5 X@��\��C��&���^aWh��9����;   V�w�   � 0+%& %5$ 7 .'&$'5w�����a	����k�%9��Hn����v.���:�=����P]���@E��0Hh �%��    V�w�   �0+ %$5  6$$7V%��k�޷	a������-w��ϣNO��:�"]P/����=�:���Ւ�%�9M34��D    V��w�  % 5@2 J
  H%G  c   _ iL%$$.+%& %5$ 7 632327#"&''&&#"w�����a	����k�%�ߖ�0rD s_��E�R6Z=!Da>M�N��:�=����P]���xs 6{�7;7D   V��w�  % 5@2 J	  H%G  c   _ iL%$$.+ %$5  632327#"&''&&#"V%��k�޷	a���𺖛0rD s_��E�R6Z=!Da>M�N�"]P/����=�9��̙s 6{�7;7D  V�[w�   �0+&'5$767&%Y���J�h�lQ�[U�²�֠U0a3SQs"P/�B2��x��X�7��w������`     V�[w�   �0+5667&'5667&'�h�lQ�[U�²*���������0a3SQsVx��X�7w����2��P/�B���  X��y>    9@6J
	H G  c ] kL  ++7!5!!5!7##26654'&'29��F���WK�F-K �؆~K�\�W_+3������5�4!���ۀ�uX�^�_+��   X�,y�  ' C@@'JH G	g  e ]  i L (
+7#5!7.54663373!!!!!#"6�:K�lم�G�5�������2U�rG[�WIn7����u���ۀ�5���p����>X�]X�P  X�,y� ! , H@E+JH! G  e
	g ]  i L#"",#,+!1+7#5!7!5!&#!5!27##!!26654&'&'5�3������D#&I�I:1�نD4V�qF�Z�X2-ʟ�������5�!1���ڀ����W�^Et-��     X�0y  " 7@4J" G  e g ]  i L&!&!	+7!5!7#"&&54663!!"3!!!!fR���|���مD��[�WX�ZD��AQ_��ff���ل�ف�Y�Z\�W�5e��    X�0y  $ 9@6J$ G  e  e ]  i L!&!A+7!5!7"#!5!26654&&#!5!2!!fR���|��DZ�YW�\��D��o�OTQ_��ff���W�\Z�Y��ۆ��vDe��    ���N  ! 5@2� e  _  q L ! 
 +"&&53326653"554332#i��b�A�nn�A�b���a�����CC�������a���     ���N  ! B@?�	e  		e  _
  q L ! 
 +"&&53326653#53533##i��b�A�nn�A�b�પe��ea�����CC�������ad��d�    X wy�  >K�PX@  a  ]   kL@    e U ] MY�+!!!!X!��w�����@�   X wy�  >K�PX@    a ] kL@   e   U   ]  MY�+!!5!!Xw��!��!����  X y�   '@$    e  e ] iL+!!!!!!X!��w��!���������  X y�   '@$   e    e ] iL+!!5!!!!Xw��!��!���h��D��     ^  r  @    eiL+!#!#^��@���Z��    ^  r  @  � ^ iL+3!3!^�������Z��  P j��  2 6 dK�PX@  e  c _ sL@#  g  e  W _  OY@ 6543(&22 +%"&'&&546767632'2676654&'&&'&#"!!ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78�����MjVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=Ҍ   P j��  2 6 Y�654JK�PX@  c _ sL@  g  W _  OY@ (&22 +%"&'&&546767632'2676654&'&&'&#"'ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78���c�jVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=��c�   P j��  2 6 dK�PX@  e  c _ sL@#  g  e  W _  OY@ 6543(&22 +%"&'&&546767632'2676654&'&&'&#"3#ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78�/��jVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=��     P j��  2 A N �K�PX@&  g
g	  c _ sL@-  g  g
g	  W	 _  OY@#CB43 JHBNCN;93A4A(&22 +%"&'&&546767632'2676654&'&&'&#"7"&546632'2654'&#"ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78�Nq�GyJsKMHyK8O''88MLjVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=��pLzHPJpLyF�L96''N88K    P j��    ( . 4 < D J@D=<6543.*('  JK�PX@  _ s L@   W  _  OY@  +%"&'&&546767632%&&'&&'%!654'3667667'ir�GNNNNMc`iv�HNNMOFí1s:	�r	:s1�������:s1s1s:�jVGN�jj�NM*(VHN�kh�OFW�19

��

91��Z�EQRDDRQE�Z�		9119		�  P j��  2 6 : xK�PX@$  e  e	  c _ sL@+  g  e  e	  W	 _  OY@ :9876543(&22 
+%"&'&&546767632'2676654&'&&'&#"!!!!ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78��{��{��jVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=8f�g    P j��  2 6 dK�PX@  e  c _ sL@#  g  e  W _  OY@ 6543(&22 +%"&'&&546767632'2676654&'&&'&#"!!ir�GNNNNMc`iv�HNNMOF�tO�86=7= AFON�9:9=78�y��mjVGN�jj�NM*(VHN�kh�OFW�=76�UL�< );9:�NT�67=Ҍ    P i��    G@D    e	e  		e
U
] M
	+!!%!!5!3!!#P3�����F��7�8�Ȍ��͌��G�9�ǌ��     P i��    5@2    e  eU] M
	+!!%!!!P3�����3��M��͌��ӌ     P i��    9@6
	J    eU] M+!!%!77P3�����!
��cc��c������͌��	c��c����c��     P i��    5@2    e  eU] M
	+!!%!3#P3���������͌����     X  y  @  e   ] iL+3!!#X�y����Ӫ��     X  y  @    e ] iL+!5!3#���y��-�-��    X  y  @   e iL+!5!!#�C!�D�Z����    X �yw   �0+5X!��V�/�������   X �yw   � 0+	X!��R�Vw�^��^��  X  y?   
 @  H   ] iL+5!!X!���y��!��L�K��W���ê    X  y?   
 @  H   ] iL+%!!X!��#���!��?����������ê    g��   =@:  g  e  W _  O 
 +"&&'!7!>32'2654&#"�PrC��iHsKP�KJ�R:OO9:POgA\*�.^@M�QP�J�O99PQ98O   ��LN  @  _   jKmL$#+46632#4&&#"#�bծ��b�A�nn�A����aa���M���CC���z    ��/N�  AK�(PX@hK  _  o L@�  _  o LY@ 
 +"&&53326653i��b�A�nn�A�b��/a����z��CC����M��a    i �g�   �0+	i� �������� ������   	��7 	 @ H	 G  t+'!7!'��TS�T����������    X`y�   J@G J IH   g   g U ] M  +"&'532776632&&#"6!!}K�K��^t Dr0��L�Q>bC6`��!���6<�{6 s�B9�� ��  � 
 @  �iL   
 
+!3 3 ���qk���|�����**�x��   ��  � 
 @   �iL   
 
+# 3# �������|���x(,����     Z��w
  + C@@  e  e 	e  ]  i L *($"!++	 
+".54>3!!"3!"&&54663!!"3!��dc����j��ن��jU�RR�V��k:PP:�d�뇆�e��ل�ـ�TR�VV�S�Q9:P�  Z��w
  + 1@.  e  e   e   ] iL&!$!(!& +7!26654&&#!5!2#!!2654&#!5!2#!Z���ن�k���dc���i�:PP:�k�V�RR�V�j��م�ـ�d�뇆�e�Q9:P�R�VV�S     X�Ay  
  ,@)  HG   U   ]  M+5!!%%5X!��!��!��#��!��"�K���V��#�������    X�Ay  
  ,@)  HG   U   ]  M+%%5!!5X!��!��!��!��#��������V����L���  V  w?  
 9@

	GK� PX@  ]   kL@   U   ]  MY�+!!5V!��!��!?����L���   X  y?  
 9@

	GK� PX@  ]   kL@   U   ]  MY�+!!%%5X!��#��!��?��#�������    V�w�   �0+>7>7& %5$ 7 V�ϤMO��9������!�����W����n�"J:N24��D���&���=�8����]P��     V�w�   � 0+&$$'5 %$5  w����ӈ9��Hn���"��n�۶U������&���E��0Hh ��/P]"����8�=���     V��w) * 0 �0+*0+&'57&%56$7767&'&&'&&'���}�Y3���>^4��MmQ�Vʥ��3t�dS�#��eh-T*��N@�7#�Z-�h4�3�U[�]��e�﹏�B�n�b�a
���$
   V��w) ' * �*)'0+567756%7$'56%'�WwZ��N��(���Y��1��������D�>���o����hi��y�����kd��d�D
	3��3 �,R�i0�gL� �  X�[y�   _@	H GK�PX@  a]kL@e  U ]  MY@	+7#!3!!!!�Y��r�Y�����B�zr�hf�?ݪ�@������@    X�[y�   _@	
	H GK�PX@  a]kL@e  U ]  MY@	+7#5!!5!3!#�Y�(���r�Y��zrN~��fݪ��?��������@    X�>y�  7@4J G  e e ]  i L	+7!5!7!!!!!!!fR���g��!��w�� R`��Xf�������f��     X�>y�  7@4J G  e e ]  i L	+7!5!7!5!!5!!!!fR���g��w��!�� R`��Xf���h��Df��     V��w? $ =@:	# J
H$G    g _ qL$-#%+&&'&#"56327%5%327#"&'�C43����<Z0��!��!�x2VK��E�O.Y3>�'{�sҧ�K���{�"{�7;��    V��w? % >@;	$ JH%G    g _ qL$.#%+&&'&#"563275%%5327#"&'�C43����<Z0��!��!�?E>VK��E�O.Y3>�'{�sԧ���������"{�7;��   V�Kw�  * @@=)# J"
 
H*G  c  _   i L'%!+%& %5$ 7 &&'&#"5632327#"&'w�����a	����k�%�GX43����9^N�SVK��E�O.Y3S��:�=����P]�����{�sW��"{�7;��  V�Kw�  * @@=)# J"	 
H*G  c  _   i L'%!+ %$5  &&'&#"5632327#"&'V%��k�޷	a����hX43����9^N�SVK��E�O.Y3S�"]P/����=�9������{�sW��"{�7;��  P�   # 7@4  U ]  M #" 
	+"554332#3"554332#3"554332#n������������  ���w  @ �  ]   jL+!##�����m Z��  @  �   ] j L+#5!#J������� ���w  @  a   j L+33!ϸ��X�m�    Z��  @    a jL+33!Z��X���    ����  :K�PX@   nK oLK�(PX@  �   n L@	   � tYY�+73
#`��S�h�pF!�������������V���� ����  :K� PX@   nK oLK�%PX@  �   n L@	   � tYY�+3#����s ���  0K�%PX@   nKoL@   �oLY@
    +&
53h��Q�/Uw�R������������I�����   ����  :K�PX@   nK oLK�(PX@  �   n L@	   � tYY�+
'3#�!Fp�h�S��`���;���|ҁ�����7�5� �����  :K� PX@   nK oLK�%PX@  �   n L@	   � tYY�+3#�����s ���  0K�%PX@   nKoL@   �oLY@
    +653
R�wU/�Q��h��Jo� W���g�g���^�   ���m  3K� PX@  ]   nK oL@ �  ]   nLY�+!!#��#�m��R  ����  :K� PX@   nK oLK�%PX@  �   n L@	   � tYY�+3#����s ���  3K�%PX@   nK ] oL@   � ] oLY�+3!!���`��N�  ���m  3K� PX@   ] nK oL@  �   ] n LY�+!5!#��#������  ����z  (K� PX@   nK oL@  �   n LY�+3#���z��   ��z  @ nK   ] oL+!3!���`�����   ���m  @ �  ]   nL!#+4663!!"#j�|��e}�_�����    ����  d� JK� PX@    g nK oLK�(PX@  �    g nL@ �  �   W  _   OYY�!%+%4.''532>53#=f�h==��e+�e$@514���~9�p�����H�8%3J�����  ���  =K�(PX@ nK  ]  o L@ �  ]  o LY@ 	 +"&&533!�z�k�}e���d�����   ����  :K�PX@   nK oLK�!PX@  �   n L@	   � tYY�+3#����h  ���m  @  �   ] n L!"+4&#!5!2#}e��|�j�g�������   ����  d�JK� PX@  g   nK oLK�(PX@ �  g   n L@   � � W _ OYY�!%+%4767&&'&333#32+9 2e�+e��==h�f=��!J>1������p�9~���    ���  3K�(PX@ nK   ] oL@  �   ] oLY�$ +!2653#!e}�k�z���ļ�l���� � ��  :K�#PX@   nK oLK�%PX@  �   n L@	   � tYY�+3#����w  g��   =@:  g  e  W _  O 	 +"&&546632!!'2654&#"9Q�KJ�RQqCk��FrO:PO::OOgM�QP�J@]*�,_A�Q98OO99P   u�#\u   	 0@- J H	G  U  ]  M+	!u���i������/hP%����f��r�   u�#\u  �0+	u���P%����    X qy�  0@-U  e]	M
+#533333####L��������-���D��D��D��D  X qy�  =@:	U
 	 e	]		M+#53333333######�rr�����ss�����-���D��D��D��D��D��D  P�/�    >@; e _ jK _  o L	 	 	+ ! % ! "554332#h������s�t+��/�����ac�������    � �;T  �	0+7�^��t^_t��\t����%\^u��^u����w^��     X�y�  $ r@JI$GK�PX@  g  c  ] k L@!   e W  g _ OY@ "  
+"554332#632327#"&''&&#"	�����0rD s_��E�R6Z=!Da>M�NS���s 6{�7;7D  X �y�  $ 0 �@J$IK�PX@$  g  g 	a  ] k L@*   e  g  g U ]	MY@&% ,)%0&/"  

+"554332#632327#"&''&&#""554332#������0rD s_��E�R6Z=!Da>M�N��S���s 6{�7;7D����     �  ,� ' $@!�  _  i L 
	 ''+!"&'&'&&5332676676653hc�:;��LV��yVZ;:;f4�xD�`c+9>F1%$`�����*hr     %  ��  
 '@$
J  hK ] kK iL+3!3#!%�ln��7�O�V���{��+��      �M 	 @  J   kK iL+'3'#�Z$R"Z��p�Z#��Z���    �  a 	 N@  J	GK�PX@   o   U  ]   M@  �   U  ]   MY�+7#5!#5�n��:��tn:�d���     x� 	 (@% JH	 G   U  ]   M+7!5!'7��N��Z#��Ҙ��Z��R��  �  a 	 E@  JHK�PX@   n   ^ iL@  �   ^ iLY�+%3753!C���tn:�dnt����d:    �M 	 @ J   kK iL+737#Z���Z��R#Z�p���Z��   �  a 	 E@  J HK�PX@   n ^ iL@   � ^ iLY�+733!�nt����d:��nt��     Bx� 	 )@&  J H	G   U   ]  M+5!!B#Z���N�Z�R#Z���Z    �  a 	 O@  J	 GK�PX@   o U ] M@   � U ] MY�+#7!#7:��ntn��:��t   B ��}  /@,	  J H
G   U   ]  M+5!'7'7!B#Z���Z#��Z��m�ZR#Z��Z��R��Z��Z     �M  #@ 
	 J   kK iL+7'3'7#Z��Z$R"Z��Z��R#Z���Z#��Z��m�Z��   *  �M 	  '@$
 J  kKiL+737#'3'#*Z���Z��R��Z$R"Z��#Z�p���Z��p�Z#��Z���  B ��}  2@/  J HG  U  ] M+5!73!'7!B#Z�㔎c��ѓ�c�}�ZR#Z��R���R��Z    B ��}  1@. J
	H G  U ]  M+7#5!7!'7'7!�c�/��c��Z#��Z���7���R��Z��R��Z��   B ��}  =@:   JHG  U  e ] M+5!53!!#5!B#Z�[�q������ZR#Z�������Z  B ��}  =@:
  J	HG U  e ] M+!5!53!'7'7!#���p�\�Z#��Z����ߤ���Z��R��Z��  B ��}  C@@
   JHG  U  e ] M+53533'7'7##5#B#Z�����Z#��Z�����ZR#Z����Z��R��Z����Z  B ��}  G@D   JHG U 	 e]M
+53533533##5##5#B#Z���t����t���ZR#Z�����������Z    B ��}  G@D  JHGU  e]	M
+#53533533'7'7##5##����t���Z#��Z���t�ߤ�����Z��R��Z����     B ���  7@4 JH G  U ]  M+%7#5!3'7'7!�2�Z��#Z�<�2��Z#��Z���<��Z#R#Z� �Z��R��Z���  B ��}  M@J   JHG U 	 e]M
+53533533'7'7##5##5#B#Z���8���Z#��Z���8���ZR#Z������Z��R��Z������Z    Y�xa 1 vK�PX@  /J@  /JYK�PX@  g W _O@   U   g W _OY@
)*(%+7!!327667667632&&'&#"#"&''#Y:���-:9#81
F802<\ $j2 8C<119]"m':8C!8,c5&=CB$i4(��  Y�xa 0 vK�PX@. J@. JYK�PX@g   W  _  O@  U g   W  _  OY@
%()(#+#"'&&'&&'&#"'6676323267>7!5!#�m$]8gN-#2!jR0,6kM	("92,���:k�+1\3-. %C8e[4#+!:6:�d    B ��} N M@J;($ )  J'&HNM+*G  �  ~  W  _ OLJFD$,)'*+53327667676323276677'7'7#&#"'&'&'&#"#"&'&&#B#Z�&(:#7


1�Z#��Z�/%@-	
. #0�ZR#Z�#Y%)(�Z��R��Z�

)C%'(E%

�Z    B ��}  2@/  J HG  U  ] M+537!!'#B#Z���Z�&�ڠZ���ZR#Z��Z���Z��Z      �M  &@#
	  J   kK iL+'75'3''#�Z��Z$R"Z��Z��&�Z���Z#��Z���Z���  B ��}  1@. J
	H G  U ]  M+7!5!'73'7'7#Ƞ��&�Z���Z#��Z���?���Z��Z��R��Z��    �M  %@"
	 J   kK iL+75'7377#Z��Z���Z��Z��R#Z���Z�&�ڠZ���Z��     B ��}  .@+  J H
	G   U   ]  M+5!7'!B#Z��Z��Z���ZR#Z��Z��Z��Z   B ��}  -@*	 J H
G   U   ]  M+7'7!'7'7!B��Z��Z#��Z����?��Z��Z��R��Z��  B ��}  9@6   JHG  U    e ] M+5!53#5!B#Z�̤��4�ZR#Z���h��Z    �M  &@#	 J kK  ^ iL+%3'3'3!��Z$R"Z���h�̠Z#��Z��4�   B ��}  9@6 	J HG   U  e   ]  M+3!'7'7!#B�̠Z#��Z��4�}��Z��R��Z��      �M  %@"
	 J  ] kK iL+7#5!#7#Z�����Z��R#Z�̤��4�Z��   �M  ,@)
 J kK  ^ iL+%3'7'3'73!��Z��Z$R"Z��Z���h��Z��Z#��Z���Z��   B ��}  9@6 	J H
G   U  e   ]  M+3!!#B�#Z���4�Z�ݤ}��#Z���Z#��   B ��}  5@2 JHG U    e ] M+7!5!'73#n��4̠Z#����?���Z��#�h#��  B  ��   S@P J	
I HG  e    e  e ] iL+3!!#7!5!'73#B�#Z���4�Z�ݤ,��4̠Z#�������#Z���Z#������Z��#�h#��  B ��#  3@0   JG   g   U   ]  M)$+5!267654&'&#52#!B#Z�E 2%%58f/V(-*c!���ZR#Z�%5-%�'.Vu6l-(-�Z   B ��#  2@/ J G  g   U  ]   M(!+7!"&'&&5467663"3!'7���d*2$/&-m45%%2 E�Z#��?�+*1k0?k%,(�%-5%�Z��R��  B ��#  , I@F   JG �   g  W  ] M )', ,)&+5!54676632###5!27654'&&#"B#Z�2(+#j?=g%V(-.d���ΠZ�<&%%/2IR#Z�}7l+#20$Tz8h,.(�ՠZ�%%55#J5}    B ��#  , D@A JG  �  g  W ]  M,+))!+7!#5#"&'&&5476632!'754&#"3��Τ�c.-(V%g=?j#+(2�Z#���pK/0%%&<?���(.,h8zT$02#+l7}�Z��R���}5J#55%%  r  _�  �0+%77��g�z�=��Zõ�J��PJ���V}����Ƅh�     �  e  *@'  JH   ] kK iL+!5!#v��Z��"Z���ǠZ#R#Z���  �  e  *@' J H  ]   kK iL+!'7'7!#���Z$��Z�� �k�Z��R��Z��9   �  e  /@,   J
G  �   U   ^  N+5!3!�"Z���z�Z#R#Z�����Z    �  e  .@+
	 J G �   U  ^   N+%7!3!'7���|��Z$��Z�k�9�Z��R��   �  R  #@ 	 J   ] kK iL+7!5!7#Z��Ac�Z��R#Z�Ѥ���Z��   @  �]  /@,   J
G  �   U   ^  N+5!3!@"Z�Ҥ���Z#R#Z�����Z    QX��  3@0J ~ �   W   _  O%'+77667632#4&'&&#"7#QZ�B9u�X�79?�)"Z=iM,�Z��R{Z�X�9s>69�U8c#/K,g4�Z��   QX��  3@0 J   ~ �   W  _   O#(+754&'&&#"#>327#�Z�(%T9mHK�n�q�u<@�Z��R{Z�GV(%(MOnr�js;�R�Z��    2  �   a@JGK�PX@ o    e U ] M@ �    e U ] MY�+!!#7!#2l��:��ntP����:��t   F  �F   �@	JGK�PX@ p  e  ]   kK iLK�'PX@  ~  e  ]   kK iL@ ~    e  e iLYY@	+!!##7!#FE�Ic:��ntFI�n��:��t  F  �F 	  �@  JHK�PX@   p    f kK ^ iLK�%PX@    ~    f kK ^ iL@ �  �    f ^ iLYY@	+3753!!3!����tn~:�d�v�J��dnt����d:����   Y  x� ' d@JK�PX@ p  e  _  i L@ ~  e  _  i LY@  ''+!"&'&5473276654&''#7!#Og�E��wed-yI�c.58,!:��KI�F�ME��ʚsd��b-6c.}EF�#��:K�dӓEN   Y  x� ' d@! JK�PX@ p  e  _  i L@ ~  e  _  i LY@ 
	 ''+!"&'&&5477#5!#53267654'7�g�FEO���:!+95.c�Iy-dew��E�NEE�kЕ:�d�#�FE}.c6-b��ds��ӔEM   B��}  #@   J H   U   ]  M+!!B#Z�p��Z#Z��  B ���  #@   JG   U   ]  M+5!!BM���Z{��Z      �M  @ J   kK iL+3'#|"Z��M��Z���   �M  @  J   kK iL+'3#�Z$z�p�Z#��  B��}  #@  J H   U   ]  M+!'7!Bp�Z#����Z��{  B ���  "@ J G   U  ]   M+7!5!���M��?��{��    �M  @ J   kK iL+37#��Z��|M���Z�� G  �M  @ J   kK iL+73#GZ��{#Z�p��     B A�!   5@2  J HG    e U ] M+!!7!5!B#Z�p��Р��M���#Z�����{��   B A�!   6@3 J HG    e U ] M+!'7!5!!Bp�Z#��M���Z'�Z��{��{��Z  B  �| 	  >@; 	 
JHG    e U ] M+7!5!'75!!���p�Z#����#Z�p���Z>���Z��R���R#Z���Z   *  �M 	  '@$  J  kKiL+'3'#737#$�Z$R"Z���Z���Z��Rp�Z#��Z���#Z�p���Z��  B  �| 	  >@;  	J HG    e U ] M+5!!7!5!'7B#Z�p���Z����p�Z#��R#Z���Z�v���Z��R��   *  �M  &@#
	 
 J  kKiL+'373'#'#$�Z$R��R"Z�����p�Z#����Z���p����  B  �|  <@9 J
H G  e   U  ]   M+%7!5!'7!5!'7���p����p�Z#����Z������Z��R��R��     *  �M  %@"
	 J  kKiL+73737#'#*Z������Z��R��R#Z�p����p���Z����  B  �|  =@:  J HG    e U ] M+57'5!!!!B��#Z�p����p���Z#R��R#Z������Z   �M  #@ 
 	 J   kKiL+'3'#'#�NZ$R"ZNRSRRNZ#��ZN��pRR��    ���6a  T@
  JGK�PX@   o   U  ]  M@  �   U  ]  MY�+!5#'#5!#5Int��:3n�:��nt��:4:�dp��     B ��}  3@0J
H G  e   U  ]   M+7!5!7'!5!'7N��pRR��NZ#��?NRRRRNZ��R��     �  6�  K@	  JHK�PX@   n  ^ iL@  �  ^ iLY�+%3735753!`p��:nt��:4:�d4:��tn:��n�d:     �M  "@
 J  kK iL+73737#ZNRRSRNZ��R#ZN��RRp��NZ��   �  6�  K@  J
	 HK�PX@   n^ iL@   �^ iLY�+7333!�4:��tn:��n�d:�p5:��tn:��  B ��}  4@1 J HG    e U ] M+5!!!!B#ZN��RRp��NZR#ZNRRRRNZ   ���6a  U@  J	 GK�PX@   o U ]M@   � U ]MY�+#7!##:�n3:��tn:�p�:��:nt��:    B ��}   B@?	 J H
G    eU] M+5!'7'7!%7'!B#ZN�NZ#��ZN�NZMRR�mRRR#ZNNZ��R��ZNNZ�RRRR     �M   )@&
	 J   kK iL+7'3'7#7'ZNNZ$R"ZNNZ��R{SRR#ZN�NZ#��ZN�NZ����RR�mR     B ��}   H@E J HG  eU]M	+5!73!!!'7#%7!B#ZN�Va6���Z��EV`6�NZ$X�>RRR#ZN�;mR�R�:lNZ��RR  B ���   ! W@T J
 HG  e	U	]M!! 
+5373'7'7#'7#77!!7'#B#ZN�.�'�NZ#��ZN��|NZ�#��RR�RR�#R#ZN� �NZ��R��ZN� ~NZ��RRRR�   B ��}   G@DJ
	H Ge  U ]  M	+7#5!7!5!73'7'7!%7'!6�.Z�x�V`6�NZ#��ZN�]VKRR��X mR�R�:lNZ��R��ZN��RR�    B ��}  <@9 I HG    e  e U ] M+5!!!!!!B#Z���w��gw"�0ZR#ZRwRwRZ     B ��}  <@9IH G  e  e   U  ]   M+!5!7!5!'!5!7�0"w�g�w���Z#��?RwRwRZ��R��  B ��}  7@4
  J	 HG  U  ]  M+537773'''#B#Z��:����;!\����[`�ZR#Z�C����C�j����j�Z  B ��}  6@3 JH G  U ]   M+7#'''537773'7�`[����\!;����:��Z#��?�j����j�C����C�Z��R��    B ��} 	   3@0  J H	G  U  ] M+5!!3#%3#B#Z����Z9��6��R#Z���Z����      �M 	   4@1  J  e  ]   kK ] iL+'3'#3#3#�Z$R"Z������p�Z#��Z���}�{�  B ��} 	   2@/ JH	 G  U ]  M+7!5!'73#%3#����Z#���ֻ�6��?���Z��R������    �M    3@0
	J  e  ]   kK ] iL+3#3#737#�����Z���Z��RM�{���Z����Z��  �  �v   ,@)
H  e] iL+##!%3'3��tv���^��\u����F
����     B ���   2@/JH G  e   U  ]   M+!!5	'!!D��t�����
�X�����u�]�]   �  �v   L�GK�.PX@  a ] kL@   e  U  ] MY@	+3!3###��X����^�\�u����&
���      ���   2@/J HG    e U ] M+!!!5!5u��O
����1u�����]��  �  �v 
  :@7H e 	 e
		] iL+3##3!%5#3'3#���tv�����^��\��u�����F�~�����  �  �v 
   O@LH e	 e 
 e] iL+3##3!'5#3'#3#���tv����HGw�^L�J\��u������GG�{�~JJ���     �  �v 
   E@BH	 e  e
] iL+3##3!%3#!5#3'���tv���R�\�^�^��u�����F������~��W    �  �v 
   I@FJH
e 	 e		] iL+#7###!73'3'3����tv�����N^^f��(^��\9�u�����P^^����B����     �  �v    Y@VJH
e
 
e 	 	e] iL+3#7###3!73'5#3'3#�����tv�����^^f����^��\�!�u�������P^^���������J�   B ��� 
  T@QJ HG    e  e  eU] M	+!!55!!75!7'!'#B�t������~��������������F�]��]���   �  �v 	  5@2H	G e  U  ] M+3##3#3'3#���tv�����^^��\\�u�u���t��&*�����     B ��}  * 4 U@R JHG  g
	  eW_ O,+  1/+4,4 * *+##+7##"&&'#53>323'7&&'&&#"27667!��DqPNm@kkBnN=a)��Z#����9&F1
�E5��
,?�+Z>=Z,�-\?+)) �Z��R���
	1�0
/   B��a  M@J
 JH G  e ] kK  ]   i L+7!5!'7!5!'7!5!'7���p����p����p�Z#�����ݥ���������Z��R��R��R��   ���  	 (@% J H	G   U   ]  M+!!u��O��1u�ݤ��8��     B ���  	 (@% JH	 G   U  ]   M+!5!	'C��u���ߤ#����u��z   ��� 	   -@* J
 H	G   U   ]  M+!!%'u�u���KO���1u��#����#��8�����z  ���>�  @ G  t+33��33��*��8��F   T/}�  Q� JK�
PX@ n   o   U  ^   N@ �  �   U  ^   NY�+!5!3#E�����[���5�����   t �]|  �0+%%7�d�^�=к]��d��     T�}  &@# JH G   U  ]   M+5/�%�0~���#�#����     t �]�  �0+%%t���\=���V]�>���d    .���  &@# JH G   U  ]   M+!5!'B���	��(���\��``�  J*�= # jK�PX@  o   f kLK�PX@  �   f kL@ �  � U ^ NYY@ 	 ##+"'&5477!"'&54763!'&547632�'��`%"��&&,��*&'�))�'&��$��     T�}%  &@# JH G   U  ]   M+!5!F��7���8����    .x�  &@# JH G   U  ]   M+!5!5V��(M��r������     6u�  
   5@2 JH G  U ]  M+!!5	3#3#3#R��-I����--iZZ���(,��������,��,��  T�}     5@2 JH G  U ]  M+!!53#3#3#F�������**cUU�����b�]^��U��U��U  1 ���  @ H  � t+##!ک78����8���    � ��5  !� GK�PX�   k L�   tY�+'!'�x�w���x�Gx��     � �F5  @ H   t+77!���x�GV���x�H  1 ���  @ G  �  t+3!31���������  � ��5  @  H   t+!�x���x�G�x���w   T�}�   @ HG   U   ]  M+!!T7���7���  � �F5  !� GK�PX�   k L�   tY�+!gw�x��x�x���  T�}� 	 (@% J H	G   U   ]  M+!55!T7�7���E�7�����ɩ�  1 ��� 	 @H	 G �  t+3##31��87������8���F��     `tq   @ H G  t+	%�����T����R����R��  {�V$   @ H G   t+	!�����%(�m��@����@�     { V�  �0+t���%���2�2   6��=  &@# JH G   U  ]   M' +!"'&53!5R��F8668FhI��!56IhI65�����    6��<  &@# J HG   U   ]  M$#+4763!55!"668FhI����F86�I65������56I P��  &@# JH G   U  ]   M+!!e�������   6n�   &@# JH G   U  ]   M+!!5��T�lM��l��w�cc�    ekl!   m@
 JK�PX@$ n   o  f   U  ]   M@" �  �  f   U  ]   MY@	+!!53#!!_���[���[����d�����["��     e/l�   m@
 JK�PX@$ n   o  f   U  ]   M@" �  �  f   U  ]   MY@	+!!53#!!_���[���������d�����["��     6 ���   r@	   JK�PX@# �   o  e   U  ]   M@" �  �  e   U  ]   MY@	+7!5!73#!!*���UcG���j*zb���VbF�d�������"��  a �p�   r@	 JK�PX@# n  �  f   U  ]   M@" �  �  f   U  ]   MY@	+!5!'53#%!!F�ؽ�cߎA��ZZ�؁(Zi4{{��{��,��Ғ    ~ �SM 
  6@3 J  �  f    e kL+!'!53#!!X�qK�RnK��R#���6�R��w�����2w��w     U �|> 
  �@ JK�PX@   o  e    f kLK�PX@  �  e    f kL@" �  �  e   U  ^   NYY@	+!7!73#!!E�Q�@Z�Q�tZ��������s��s�K��j�    3N�u   �@
   JK�PX@   o  f    e kLK�0PX@  �  f    e kL@" �  �  f   U  ]   MYY@	+5!'7'!53#!!���%pp�Sn%��RH����UUa�,L��w��K���2w��w   * ��1   �@	 JK�PX@   o  f    e kLK�PX@  �  f    e kL@" �  �  f   U  ]   MYY@	+!7'7!573#!!��prr&j&St&��Ss����WWlv��M,L��L��t7y��y  � �@�  {@ JK�
PX@  e   U  _  OK�PX@   c _ sL@  e   U  _  OYY@ 
	 +%"'&'!!667632Jʙ3!�t����Y]də�����3;�tt�9�&&���ɘ� 	 XNy      # ' + / �@� 	J I  
 e	eU] M,,(($$  ,/,/.-(+(+*)$'$'&% # #"!+5'!!55!!'#3'#3'#3'#7#37#37#37#݅��>�F�}�����r+r�r+r�r*rq+r��r+r�r+r�r*r�q*r9���Cq.]��� ��������䫫������  u �\j    M@ J HGK�*PX@   ~ �   k L@   � � tY�#+7'327'%3#�ώ95�p"��������Y���Ϗ"r�7��-��/X���  T�}k    :@7 JHG  e    e U ] M+!5!5!!!!��  n��n�����V���V�8��GG�x�:�  t �]�    3@0 JI  HG   � � t"+53#&#"7'77�Y���Z��p�69��.ώ�����)����"��.Ϗ96�    u �\� & 3@0
&	 JH   ~   � _ sL$#&+%&547#"'3277&'&'327&'&&'�99J$Q9Y/DA2�L786�p":�.�7TM<9X//�!8"p�5;:I	�2@=     +��D !RK�PX@ IH GK�
PX@  JH GK�PX@ IH GK�PX@  JH G@ IH GYYYYK�PX@  o  U   g  ]   MK�
PX@   o  U   U  _  OK�PX@  o  U   g  ]   MK�PX@  �  U   g  ]   MK�PX@   o  U   U  _  O@  �  U   g  ]   MYYYYY�#$+4767!"!47663"&'&5!3!&'&5���?--�56D%%D6�--?Hu���PB-+AO36LA+-BP�MM    O ��� ) -@*&" JH G �  �   t$(!+%&#"6767&&#"6632&5476767�|�:<?M&��@"K1��L*&P==s
 ?�$=#	3s @TW?��=!#!��(Q<=<�    6*��  $ 6 h�0JK�PX@ o W    g _O@� W    g _OY@&%%6&6"!$$*+&&'&'&547632"&'&'&547632"'&54767667���D,!!/+$Z��9
,/;��H�a�A-#!!]�p�\	!�%C)0 !!
��A)-3E*c
�!20	%BX�
    o��  # ,@)
 JH   W  _  O##+&547&547"&'&'&'67667632�====O���6)N650 "'+Z*�F���-Xo>RNBBNR>�\\p'(/ .3,!S>>S    &��� N b�6JK� PX@  W  e  ] M@!   ~   U  e   ] MY@   N LEC+)+"&5477654''&54763!23327654''&&547632#"'&54677654'&##"#F]]
�I
�



	�
�	



�	I���


�

	Q
		�

�		
Q	


�  &e�� N *@'9J U    g ] M52+)7-+"&'&5477654'&##"#!"&5477654''&54763!23327654''&5476632F
G

K
a��u~
i
K

G

E
��
e

�

���


�

�


��

��
    2��    , r�JK�PX@'  no    f U ] M@% ��    f U ] MY@!!!,!,	+!&&'3!67667&'&''3##667!5!2d )O+S��>x*9y=R6k R4g�7R�) ���S+�3_+fd�p�t (t�sk:8�y-]4Gdf    �� �5} 	 )@&  J H	G   U   ]  M+5!!d#Z���D�ZR#Z���Z   �� �5} 	 (@% JH	 G   U  ]   M+7!5!'7���D��Z#��?���Z��R�� �� �5}  /@,	  J H
G   U   ]  M+5!'7'7!d#Z�ߠZ#��Z��!�ZR#Z��Z��R��Z��Z    T�}�  &@# JH G   U  ]   M+!!5F��7��.�����     � ��?  -K�#PX@   ] oL@   U   ]  MY�+!!��/���     � � j  -K�#PX@   ] oL@   U   ]  MY�+5!!��/j��     � ��  -K�#PX@   ] oL@   U   ]  MY�+!!��/��k    � ��  -K�#PX@   ] oL@   U   ]  MY�+!!��/��@    � ��  -K�#PX@   ] oL@   U   ]  MY�+!!��/��    � �  &K�#PX@   � oL@	   � tY�+!!��/��   � �B  :K�PX@   jK oLK�#PX@   � oL@	   � tYY�+!!��/B��   � ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!��/��b   ���  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+!!��/��"   B��  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+!!��/���   �  ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+3#����b     � *�  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!*����b   � ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!��7��b   � h�  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!h����b   � �  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!����b   � ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!��Z��b   � F�  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!F����b i� ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+!!ih����b   F� ��  NK�
PX@   � oLK�PX@   nK oLK�#PX@   � oL@	   � tYYY�+3#F����b   � i�  -K�#PX@   ] oL@   U   ]  MY�+!!i����@  i� ��  -K�#PX@   ] oL@   U   ]  MY�+!!ih����@      �i�  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+!!i����"   � ��  jK�
PX@   � ] oLK�PX@   nK ] oLK�#PX@   � ] oL@   � U ] MYYY�+!!!ii�.��"�@     � ��   yK�
PX@    e ] oLK�PX@  ]   nK ] oLK�#PX@    e ] oL@    e U ] MYYY�+!)!i��ii����"�@   � ��  fK�
PX@    e oLK�PX@  ]   nK oLK�#PX@    e oL@ �   U   ]  MYYY�+!!!�������"�@     � ��  fK�
PX@    e oLK�PX@   ] nK oLK�#PX@    e oL@  �   U  ]   MYYY�+!!!i��������b i���  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+!!ii����"     � ��   yK�
PX@    e ] oLK�PX@  ]   nK ] oLK�#PX@    e ] oL@    e U ] MYYY�+!)!ii����i����"�@     � ��  jK�
PX@  �   ] oLK�PX@ nK   ] oLK�#PX@  �   ] oL@  �   U   ]  MYYY�+!!!ii�.���b     �8m         # ' + / 3 7 ; ? �K�PX@W
		eeeee ]  nK]jK]oL@Ue
		eeeee ]  nK]oLY@:?>=<;:9876543210/.-,+*)('&%$#"!  +3#%3#3#%3#3#%3#3#%3#3#%3#3#%3#3#%3#3#%3#��i���̚�h���c��i���̚�h���c��i���̚�h���c��i���̚�h��m���Y���Z���X���Y���X���Z���Y���    ��l         # ' + / 3 7 ; ? C G K O S W [ _ c g k o s w �@�
	eeee" #!$e(&$)'%*$%e420531601e ]  nK.,**+]/-++iK:8667];977o7Lwvutsrqponmlkjihgfedcba`_^]\[ZYXWVUTSRQPONMLKJIHGFEDCBA@?>=<;:9876543210/.-,+*)('&%$#"! <+3#%3#%3#!3#%3#%3#!3#%3#%3#!3#%3#%3#!3#%3#%3#33#%3#%3##3#%3#%3#!3#%3#%3#!3#%3#%3#!3#%3#%3#����������������������������������������������������e���c�����������������������������������������l�������������������������������������������������� 
  ��m  ! % ) - 1 5 9 = A.K�PX@ae"!e#e%$e('
e]	nK&]iK)   
]

o
L@_e"!e#e%$e& e('
e]	nK)   
]

o
LY@`>>::6622..**&&"">A>A@?:=:=<;696987252543.1.10/*-*-,+&)&)('"%"%$#!! *+35#35#35#35!35!#5#!5#!5#!5#5#5#!5#5#5#!5#5#�������ϚϚ��2���Κ�����������������������������F����������������������������    ���|  @  _ s L  +"&'&5476632iF�M����M�FF�N����N�T++P��R+++,R������R,+    ���|  / *@'  c _ sL %#// +"&'&5476632'2676654&'&&#"iF�M����M�FF�N����N�G9~>x||x>~99~>tt>~T++P��R+++,R������R,+{##Dډ��D####B֏��B##    ������  - PK�%PX@  c _ sL@  g  W _  OY@ #!-- +"&'&5476632'2676654&'&&#"gN�R����R�N��������?�<y��y<�?9�Cv��uC�n+0Z��Z0+[Z����Z[�&"Dᕕ�D"&"&B����B&"     ���|  $ %@"   c _ sL $# +"&'&5476632'2676654&'&&#iF�M����M�FF�N����N�G9~>x||x>~9T++P��R+++,R������R,+{##Dډ��D##    ���|  " %@"   c _ sL "! +"&'&5476632"3iF�M����M�FF�N����N�Gzzy{{yzzT++P��R+++,R������R,+UGFϑ��FG     ���|  ! *@'  c _ sL !! +"&'&5476632'&#"iF�M����M�FF�N����N���zzzzy{T++P��R+++,R������R,+h�GGFϑ     ���|  $ *@'  c _ sL $$ +"&'&5476632'267665!iF�M����M�FF�N����N�G9~>x|�/t>~T++P��R+++,R������R,+{##Dډ��B## 8���|  @   _ s L+"&'&547663�G�L����L�GT++U��U++  8���|  @  _   sL+2#8����KM���|XZ�����ZZ  ���|  + 4@1 ~  c _ sL ! ++ +"&'&5476632'267665!"iF�M����M�FF�N����N�G9~>x|�9~>tt>~T++P��R+++,R������R,+{##Dډ�##B֏��B##     ���|   *@'  c _ sL  +"&'&5476632"iF�M����M�FF�N����N�Gzzy{T++P��R+++,R������R,+h�GFϑ  ���|  ' - ;@8)!J f  c sL(( (-(-#"'' +"&'&5476632'276'&&'!iF�M����M�FF�N����N�Dwz��0[0��j��^]�T++P��R+++,R������R,+{G����w�g/%�6~�   ���|  * 0 4@10 J  �   e _ sL ,+*)%# +"&'&5476632'6676654&'&&#"!!iF�M����M�FF�N����N�-e*n�{y>9?��hr�T�]^T++P��R+++,R������R,+%>ӓ��E##0h�vr�6    ���|  ' - 4@1(' J  �   e _ sL -, +"&'&5476632!.#"36767!iF�M����M�FF�N����N��
j��A7z@��]^r[`��ST++P��R+++,R������R,+�w�g0"%�����66}�    ���|  ) / ;@8.J f  c sL** */*/)) +"&'&5476632'2>7!&'&'iF�M����M�FF�N����N�G>��j��[av}zy>�`[T++P��R+++,R������R,+{/h�v#7Cԍ��E##%�}6�O     ���|  ! - ; @ E =@:EA@<;5.-(" J  c _ sL !! +"&'&5476632'27&#"7676&7&'&&'%654'iF�M����M�FF�N����N�G�%)
��&&*gg��bbT++P��R+++,R������R,+{��.!
*		��	�|��|z��z     ���| 	   # - 5 = G G@D EA:9521-)(#	F@=J c  _   sL?>DB>G?G#!+632&#"667!&&'7&547!654'7&&'7!667"'7327�KKKK?99?�*g7=-Q"("Q-=7g*��w�w�|7g*e"Q-�-L'e1`7��KK?99?Kgw{:U jC00Cj U:�	AUUA5CC55CC5AUUA�� U:G0C@3FAO Xww  ���|  / C ;@8 g  c _ sL10 ;90C1C%#// 	+"&'&5476632'2676654&'&&#"7"'&&5467632iF�M����M�FF�N����N�G9~>x||x>~99~>tt>~9aedbbdea`g\jj\gT++P��R+++,R������R,+{##Dډ��D####B֏��B##]89�nn�9883�vv�38     ���|  / C U L@I  g
g	  c _ sLDD10 DUDUOM;90C1C%#// +"&'&5476632'2676654&'&&#"7"&'&5476632'267654'&&#"iF�M����M�FF�N����N�G9~>x||x>~99~>tt>~9@ yy @@;7CC7;@$CC$ #CC#T++P��R+++,R������R,+{##Dډ��D####B֏��B##�C��C#iKKi#n(LL('MM'  ?��!   1@.  g  W _  O 	 +"&&546632'26654&&#"fR�OO�SS�OP�TBmA@lCc���O�SS�OO�RR�P;@lBBk?�cc�  �����(   &@#  ]   jK] iL+!!26654&&#"��zT�PO�SS�OO�(���P�RR�OO�SS�O   ��� �(   3 �K�PX@!  ]   jK _iK] oLK�#PX@ g  ]   jK] oL@ g a  ]   jLYY@)'33+!!267654'&&#"7"&'&&54676632��}F�N����N�FF�M����M�E9~>tt>~99~>x||x>~(���+,R��R,+++R�ﯭ��P++{##B֏��B####Dډ��D##  ���(   &@# a  ]   jL&%+!#4'&&#"#34676632���N�FF�M����p>~99~>x|(��R,+++R�﯒�?####Dډ ��� �   oK�PX@  _iK ^ oLK�#PX@  g ^ oL@  g W ^ NYY@$+3327$3!"'&!1O�J��2�|zz���z���.*X�`��'G���G  �|  !@�  _   sL    #$+%6632#'&#"1O�J��2z�zzzzy{`�.*X����GGFϑ  ���  )@&�   W  _  O  +"&'$332676653gJ�O��zt>~99~>x|z�ΗT*.�`��B####Dډ���X 7�| 
 @�  _   sL   
 
+%63"71��zzv~`�X{GDΔ   8�|  @ �   _ s L    +'&#52�}vM�E���G{0'Q��� 8��� 
 @  �   W   _  O+%2763#8v}�{����'G��� YZ  7��� 
 @ �   W  _   O+"'$33�����{~vzzTX�`��DG   ���v  �0+	bc��b����    ���v   �0+	bc����Z�[�b����b��Z�Z    ���v   �0+	bc����5b����b��l     ���v   �0+	bc���6�b����,�6�6   ���v   @ H G   t+	!bc����k�b����b�6   ���v   @ H G  t+	bc����5�6b����b��6     ���v    
�	0+	
bc����5�6���nn��b����b��6�6�n����    ,���t     @
	0+			f������o������o����3��������6����   u�#\u   �0+	u�������P%����-1����     ��8  @   U   ]  M+!!:����o8��     ��8   )@&    eU] M+!!%!:����o[��S�8��rd�� D���v  -K�.PX@  ]   kL@   U   ]  MY�+!!DH��v�<      ��8  @   U   ]  M+!!��;8��    ��8   )@&    eU] M+!!%!��;S�8��rd��  D���v   GK�.PX@ a  ]   kL@    eU] MY@+!!%!DH�����v�<r��    ���  6K�PX@    e oL@ �   U   ]  MY�+!!#��Ӡ���   j��  SK�
PX@   � U ^ NK�PX@  b   n L@   � U ^ NYY�+3!!�-�3��x�  �����  6K�PX@    e oL@  �   U  ]   MY�+!5!#��̠j���   ��j��  SK�
PX@  �   U   ^  NK�PX@    b nL@  �   U   ^  NYY�+!3!,��4���  ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!5!3!!#��,�-�Ӡj���x���    �����  9K�PX@   e oL@  �   U  ]  MY�+!5!!#����Ӡj����   ��j��  YK�
PX@  �  U  ^  NK�PX@   b nL@  �  U  ^  NYY�+!3!!,�-���x�   ����  yK�
PX@   �  e oLK�PX@  e   nK oLK�PX@   �  e oL@   � � U ] MYYY�+3!!#�-�Ӡ��x���   ������  yK�
PX@ �    e oLK�PX@    e nK oLK�PX@ �    e oL@ �  �   U  ]   MYYY�+!5!3#��,��j���P   ��j�  @   U   ]  M+!!���   ����  NK�
PX@   � oLK�PX@   nK oLK�PX@   � oL@	   � tYYY�+3#����P ������  �K�
PX@ �  e    e oLK�PX@  e    e nK oLK�PX@ �  e    e oL@" �  �  e   U  ]   MYYY@	+!5!5!5!3#��,��,��������P  ����X�   �K�
PX@�    eoLK�PX@    enKoLK�PX@�    eoL@� �   U  ]   MYYY@	+!5!3#3#x�t���@��j���P	��P  ����X 	 <K�PX@   eoL@ �   U  ]  MY�+!5!###x�tl���j���|��   ������ 	 HK�PX@  e    e oL@  �  e   U  ]   MY�+!5!5!5!#��,��̠�����,   ����X�  	  �K�
PX@ �    f  eoLK�PX@    f  enKoLK�PX@ �    f  eoL@$ ��    f U ] MYYY@+!3!3#!5!#����̠����t,����x��PЬ�� x��X�   XK�
PX@  �oLK�PX@  nKoLK�PX@  �oL@  �tYYY�+3#3#x��@����P	��P ����X�   LK�PX@    e  eoL@�    e U ] MY@	+!5!#!5!#��4l����t,���,Ь�� ���X�   rK�
PX@�   f   U   ^  NK�PX@   f    bnL@�   f   U   ^  NYY@	+!3!!3!̠������j4� ��x    ��jX� 	 ]K�
PX@ �  U  ^  NK�PX@   bnL@ �  U  ^  NYY�+!333!��������x���  ����� 	 mK�
PX@ �   e   U   ^  NK�PX@   e    b nL@ �   e   U   ^  NYY�+!5!5!3!,��,��4j����   ����  �K�
PX@   �  e  e oLK�PX@  e  e   nK oLK�PX@   �  e  e oL@"   � �  e U ] MYYY@	+3!!!!#�-��-�Ӡ��$����0  x����   �K�
PX@  �  eoLK�PX@  e  nKoLK�PX@  �  eoL@  �� U ] MYYY@	+3#3!!#x��@���s���P	��x���  x���   rK�
PX@  �  f U ^ NK�PX@  f  b  n L@  �  f U ^ NYY@	+3!!3!!x����@������̬��$�   x����   LK�PX@    e  eoL@�    e U ] MY@	+!!#!!#xm�3�@-�s�¬��|��0 �����    zK�
PX@  �  f U ] MK�PX@  f  anL@  �  f U ] MYY@+!3!3!!!!����̠����4�����x��$��� ������  	  SK�PX@    eeoL@!�    eU]MY@+!!!5!#!!#����t,�@-�s�¬�����|��0    x����  	  �K�
PX@  �  f  eoLK�PX@  f  e  nKoLK�PX@  �  f  eoL@$  ��  f U ] MYYY@+3#3!!!!#x��@����-�s���P	��$����0    �����   "@    e U ] M+!!!!����¬�� ������     �K�
PX@! �  f	
eoLK�PX@!  f	
enKoLK�PX@! �  f	
eoL@) ��  f	U	]
MYYY@+!3!3!!!5!#!!#����̠������t,�@-�s����x��$������|��0   �����   rK�
PX@  �   f U ] MK�PX@   f  a nL@  �   f U ] MYY@	+!3!!!!,�-������$���  ��j��  dK�
PX@ �  U  ^  NK�PX@   bnL@ �  U  ^  NYY@	+!333!!��������x��x�  ������   LK�PX@    e e oL@ �    e U ]MY@	+!!!5!!#��,����Ӡ¬�����0  �����  @K�PX@   eoL@ �   U  ]  MY@	+!5!!###x�t��s���j����|��  xj�� 	 ]K�
PX@  �U^ NK�PX@ b  n L@  �U^ NYY�+333!!x��������x��x�  ��� 	 mK�
PX@   �  e U ^ NK�PX@  e  b   n L@   �  e U ^ NYY�+3!!!!�-��-�3��$���  ���� 	 HK�PX@    e  e oL@ �    e U ] MY�+!!!!#���-�Ӡ¬���0   x��� 	 <K�PX@   eoL@�   U   ] MY�+!!###xm�s������|��   ������  �K�
PX@�  e	oLK�PX@  enK	oLK�PX@�  e	oL@"�	 �  U ]  MYYY@
+!5!333!!###x�t������s���j���x��x���|��  ������  �K�
PX@ �e 	 e 		o	LK�PX@e 	 e nK 		o	LK�PX@ �e 	 e 		o	L@' � 	 	�e  U ]  MYYY@
+!5!5!5!3!!!!#��,��,�-��-�Ӡ������$����0    ���v  -K�.PX@  ]   kL@   U   ]  MY�+!!��;v�<  ���v   GK�.PX@ a  ]   kL@    eU] MY@+!!%!��;S�v�<r��      ���v   PK�.PX@  a ] kL@  e  U ]  MY@  
+ !! !5254#!"3\��VV��������NVV������r������  ���v    [K�.PX@  e a  ]   kL@"    e  eU] MY@
	+!!%!!!��;S�c��v�<r�� }��  ���v  	      # ) / 3 7hK�PX@B	
pp

eeb ]  kLK�PX@C	
p~

eeb ]  kLK�.PX@D	

~~

eeb ]  kL@M	

~~  e

eeU^NYYY@276543210/.-,+*)('&%$#"! +3##%3#%3#!#53#3#%3#3#%3#33#%353#%3#%3#�Vrb��N���Z�s��rrRss��rrRss��rV��Zs��j��N��vrV�rrrrȚ��������ZrrZ�rrrr   ���v       �K�.PX@7 e e 	e	 
	
e a  ]   kL@>    e e e 	e	 
	
eU] MY@,
	+!!5!5!5!5!5!��;S���������v�<�jj�kk�kk�jj�nn  ���v       �K�.PX@		 a
 ]   kL@.  
 e		U		] MY@,
	+!!7#!#!#!#!#��;�jHlHjFjJnv�<r�� �� �� �� ��    ���v         # ' + / 3 7 ; ? C G K O S W [ _ c g�K�.PX@s87	654	e=<;:9	eBA@?>	(&$" ! eG)F'E%D#C	!20.,*+!*eL3K1J/I-H	+ +a
 ]   kL@�  
 e87	654	e=<;:9	eBA@?>	(&$" ! eG)F'E%D#C	!20.,*+!*eL3K1J/I-H	++UL3K1J/I-H	++] +MY@�dd``\\XXTTPPLLHHDD@@<<884400,,(($$  dgdgfe`c`cba\_\_^]X[X[ZYTWTWVUPSPSRQLOLONMHKHKJIDGDGFE@C@CBA<?<?>=8;8;:9474765030321,/,/.-(+(+*)$'$'&% # #"!
	M+!!5#!5#!5#!5#!5#5#!5#!5#!5#!5#5##5##5##5##5#5#!5#!5#!5#!5#5#!5#!5#!5#!5#��;�jHlHjFjJn��jHlHjFjJnnnrjrjrlrjjjHlHjFjJn��jHlHjFjJnv�<�jjjjjjjjjj�kkkkkkkkkk�kkkkkkkkkk�jjjjjjjjjj�nnnnnnnnnn  ���v  	       �@
JK�.PX@	
 a ]   kL@)   e	
U	
] MY@$		+!!%5####'#'��;S�lM�J�����Њ�����`��B4��v�<rL�J�j�[��/�F�����������͒�  ���v   
      �@
JK�.PX@	
 a ]   kL@'   e	
U	
] MY@+!!##%#5#5%5!5��;,��Ў����J�M�l���,4�B��v�<R�ы��������J�lL_��3��B��    ���v        # ' + 0 5 9 = A F K O S W [ _ d i n s �@Srqpmlkhgfcba_^][ZYWVUSRQONMKJIHGFEDCA@?=<;987543210/.-+*)'&%#"!NJK�.PX@	
 a ]   kL@)   e	
U	
] MY@!oojjee``ososjnjneiei`d`d+!!'#%'#%'#%5#'''%''%'%'%5''%'%''%5'%'%''%'''7'!5'!7'!7'��;�!M"~U!E~!ULTM K�}LKK�FKE�KEK�wLKK�KLL��F"�"EJPKLK��LKL�LKK�xK#�KE��LJK�LKK�xKEK�EKE�LJJ�Z$K#�#K$��KE$y$EKv�<2 J"R!EE!LJ LKLLKLELEELELQLLKKLLKLE"RR"ELPKLKKLKLKKKKPKR""RKEDKJLLJKKPKEKKEKEEJJLn$K#LL#K$KE$$EK     � ���  @   U   ]  M+!!������   � ���   )@&    eU] M+!!%!���������r6��   ���v   GK�.PX@ a  ]   kL@    eU] MY@+!!%!��;R�v�<r��      ���v   GK�.PX@ a  ]   kL@    eU] MY@+!!%!��;b�v�<r��      ���v   E� JK�.PX@ b   k L@   �U^ NY@+!!%��;R� v�<r��     ���v   ?�JK�.PX@ �  ]   kL@ �   U   ]  MY�+!!!��;S�v�<R�    ���v    WK�.PX@ a ]   kL@   eU] MY@
	+!!%!!!��;)�I��Iv�<r�� ��    ���v    eK�.PX@ e a ]   kL@$   e eU] MY@
		+!!!!!��;)�I��I��v�<���H������J    ���v  	  fK�.PX@  e a  ]   kL@&    e  eU] MY@



			+!!%!!#!��;R� )r�Iv�<r��H����J   ���v  	  fK�.PX@  e a  ]   kL@&    e  eU] MY@



			+!!%!!!!��;))� ��Iv�<r(�� ��J  ���v  	  dK�.PX@ e a ]   kL@$   e eU] MY@



			+!!%!!!��;R���I��Iv�<r�*� (��H  a o   #@     e] iL+!!%!a�������r*��     a o  @   ] iL+!!a����    � [!�   )@&    eU] M+!!%!�r�� �r���r��r   � [!�  @   U   ]  M+!!�r�����   ���v  
�   t+!hc�;v�<     ���v  � 0+��;v����    ���v  � GK�.PX�   k L�   tY�+!���v�<  ���v  �0+�b�<  ���v   #@ H  U ]   M+!%hc�;�H�Iv�<rn��    ���v   � 0+	��;���v����b���     ���v   3�GK�.PX@  ]   kL@   U   ]  MY�+!!�������v�<C��  ���v   �0+�r��ob�<�H�H    ���v    4@1H g  U ]   M+!%%"&54632hc�;�H�I�9LN88NOv�<rn���L99LL97N   ���v   #@ H  U ]   M+!%hc�;�Hv�<rn��  ���v   #@ H  U ]   M+!%hc�;b�Iv�<rn��   ���  � 0+��;��s�s     ���  �0+����   ���   � 0+	%��;�����s�s���<      ���   �0+�r��6���o��  � ���  
�   t+!h������     � ���  � 0+�����s�s    � ���  @ G   t+!��s���     � ���  �0+����  � ���   #@ H  U ]   M+!%h���o�����r��<  � ���   � 0+	%���6�<��s�s���<     � ���   @G   U   ]  M+!!��s��<������<  � ���   �0+�r�<����o��  ���v  � GK�.PX�   k L�   tY�+!�v�<    ���v  @  H   t+!��;v�<  ���v  @  H   t+!��;v�<     ���v  � GK�.PX�   k L�   tY�+!��;v�<  ���v   3�GK�.PX@  ]   kL@   U   ]  MY�+!!�r��6v�<R��     ���v   $@! H  U ]   M+!%��;S��v�<r6��   ���v   $@! H  U ]   M+!%��;���v�<r6��  ���v   3�GK�.PX@  ]   kL@   U   ]  MY�+!!��;���v�<R��   ���l  @   U   ]  M+!!��l��  ����  NK�
PX@   � oLK�PX@   nK oLK�PX@   � oL@	   � tYYY�+!!�@����P    <j�    "@  U  ] M+!!%!!%!!<#���#���#�������  <�l    "@  U  ] M+!!!!!!<#���#���#��l��X��X��    �m�    RK�,PX@    e  e ] mL@     e  e U ] MY@	+3#3#3#��������������   ��m    RK�,PX@    e  e ] mL@     e  e U ] MY@	+!!!!!!�@��@��@����������  <j�     '@$  U  ] M+3#%3#%3#%3#<��4��4��4���������   <�l     '@$  U  ] M+3#3#3#3#<��4��4��4��l��X��X��X��   �n�     dK�*PX@#    e  e  e ] mL@(    e  e  e U ] MY@+3#3#3#3#���������^��^��^��^  ��n     dK�*PX@#    e  e  e ] mL@(    e  e  e U ] MY@+!!!!!!!!�@��@��@��@���^��^��^��^  ���l  6K�PX@    e oL@ �   U   ]  MY�+!!#��Ӡl����  ����  6K�PX@    e oL@ �   U   ]  MY�+!!!��#�����  ����l  6K�PX@    e oL@ �   U   ]  MY�+!!!��#��l���� �����l  6K�PX@    e oL@  �   U  ]   MY�+!!#��̠X��  ����  6K�PX@    e oL@  �   U  ]   MY�+!5!!��$��j���  ����l  6K�PX@    e oL@  �   U  ]   MY�+!!!��$��X�� ��  SK�
PX@   � U ^ NK�PX@  b   n L@   � U ^ NYY�+3!!�-�3����� �j��  SK�
PX@   � U ^ NK�PX@  b   n L@   � U ^ NYY�+!!!�@�����x� ���  SK�
PX@   � U ^ NK�PX@  b   n L@   � U ^ NYY�+!!!�@��������    ����  SK�
PX@  �   U   ^  NK�PX@    b nL@  �   U   ^  NYY�+!3!,��4l2�v  ��j�  SK�
PX@  �   U   ^  NK�PX@    b nL@  �   U   ^  NYY�+!!!�@����� ���  SK�
PX@  �   U   ^  NK�PX@    b nL@  �   U   ^  NYY�+!!!�@��l2�v ����  yK�
PX@   �  e oLK�PX@  e   nK oLK�PX@   �  e oL@   � � U ] MYYY�+3!!#�-�Ӡ�������  ����� 	 �K�
PX@  U   e oLK�PX@   U  ] nK oLK�PX@  U   e oL@  �  U   U  ]  MYYY�+#!!!#P@��Ӡj4�x���  ����� 	 �K�
PX@  �  U  ] oLK�PX@  U nK  ] oLK�PX@  �  U  ] oL@  �   e  ]  MYYY�+33!!!�P�-�#����x��� �����  yK�
PX@   �  e oLK�PX@  e   nK oLK�PX@   �  e oL@   � � U ] MYYY�+!!!!�@��#����x��� ����� 	 �K�
PX@  U   e oLK�PX@   U  ] nK oLK�PX@  U   e oL@  �  U   U  ]  MYYY�+#!!!#P@��Ӡ������� ����� 	 �K�
PX@  �  U  ] oLK�PX@  U nK  ] oLK�PX@  �  U  ] oL@  �   e  ]  MYYY�+33!!!�P�-�#��l2������    �����  yK�
PX@   �  e oLK�PX@  e   nK oLK�PX@   �  e oL@   � � U ] MYYY�+!!!!�@��#���������    ������  yK�
PX@ �    e oLK�PX@    e nK oLK�PX@ �    e oL@ �  �   U  ]   MYYY�+!!3#��,��X2�P  ����� 	 ~K�
PX@ �   f oLK�PX@   f nK oLK�PX@ �   f oL@ �  �   U  ^  NYYY�+!5!!##���@P�j������    ����� 	 K�
PX@ �   e oLK�PX@   e nK oLK�PX@ �   e oL@ �  �  U ]   MYYY�+!5!33!��$,�P��j���x��   �����  yK�
PX@ �    e oLK�PX@    e nK oLK�PX@ �    e oL@ �  �   U  ]   MYYY�+!5!!!��$�@��j���P ����� 	 ~K�
PX@ �   f oLK�PX@   f nK oLK�PX@ �   f oL@ �  �   U  ^  NYYY�+!!!##���@P�X2�v��   ����� 	 K�
PX@ �   e oLK�PX@   e nK oLK�PX@ �   e oL@ �  �  U ]   MYYY�+!!33!��$,�P��X2����  �����  yK�
PX@ �    e oLK�PX@    e nK oLK�PX@ �    e oL@ �  �   U  ]   MYYY�+!!!!��$�@��X2�P    �����l 	 HK�PX@   e    e oL@  �  U   e  ]   MY�+!!!!#���-�ӠXV���  �����l 	 HK�PX@    e  e oL@ � U    e ] MY�+!5!5!!#��,��Ӡj�V����  �����l  9K�PX@   e oL@  �   U  ]  MY�+!!!#����ӠX���� �����  9K�PX@   e oL@  �   U  ]  MY�+!5!!!��$��#��j����  �����l 	 HK�PX@   e    e oL@  �  U   e  ]   MY�+!!!!!��$��#��XV��� �����l 	 HK�PX@    e  e oL@ � U    e ] MY�+!5!5!!!��$��#��j�V���� �����l  9K�PX@   e oL@  �   U  ]  MY�+!!!!��$��#��X����    ���� 	 mK�
PX@  �   U  e   ^  NK�PX@  e    b nL@  �   U  e   ^  NYY�+!3!!!,�-���4l2�x�V  ���� 	 mK�
PX@ � U    e ^ NK�PX@    e  b nL@ � U    e ^ NYY�+!5!3!!��,�-�3j������    ����  YK�
PX@  �  U  ^  NK�PX@   b nL@  �  U  ^  NYY�+!3!!,�-�l2����  ��j��  YK�
PX@  �  U  ^  NK�PX@   b nL@  �  U  ^  NYY�+!!!!�@����x�  ���� 	 mK�
PX@  �   U  e   ^  NK�PX@  e    b nL@  �   U  e   ^  NYY�+!!!!!�@��#��l2�x�V ���� 	 mK�
PX@ � U    e ^ NK�PX@    e  b nL@ � U    e ^ NYY�+!5!!!!��$�@���j������   ����  YK�
PX@  �  U  ^  NK�PX@   b nL@  �  U  ^  NYY�+!!!!�@��l2���� ������  �K�
PX@ �   e    e oLK�PX@   e    e nK oLK�PX@ �   e    e oL@" �  �  U   e  ]   MYYY@	+!!3!!#��,�-�ӠX2�x���    ������  �K�
PX@ �    e  e oLK�PX@    e  e nK oLK�PX@ �    e  e oL@" � � U    e ] MYYY@	+!5!3!!#��,�-�Ӡj��������    ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!!3!!#��,�-�ӠX2������  ������  �K�
PX@ �  f oLK�PX@  f nK oLK�PX@ �  f oL@ �  �  U ^  NYYY@	+!5!!!!#���@��Ӡj���x���   ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!5!3!!!��$,�-�#��j���x���   ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!5!!!!!��$�@��#��j���x���  ������  �K�
PX@ �   e   f oLK�PX@   e   f nK oLK�PX@ �   e   f oL@# �  �  U   e  ^  NYYY@
+!!!!!##���@��#P�X2�x�V��  ������  �K�
PX@  U   e   e oLK�PX@  U   e  ] nK oLK�PX@  U   e   e oL@$  �  U  U   e  ]  MYYY@
+#5!5!!!!#P�$�@��ӠV��������    ������  �K�
PX@ �   e   e oLK�PX@   e   e nK oLK�PX@ �   e   e oL@$ �  � U   e ]   MYYY@
+!!33!!!��$,�P��#��X2��V��� ������  �K�
PX@ �    e U] oLK�PX@    e U nK] oLK�PX@ �    e U] oL@! �    e e] MYYY@
+!5!533!!!��$�P�-�#��j�V2������   ������  �K�
PX@ �  f oLK�PX@  f nK oLK�PX@ �  f oL@ �  �  U ^  NYYY@	+!!!!!#���@��ӠX2������ ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!!3!!!��$,�-�#��X2������ ������  �K�
PX@ �   e    e oLK�PX@   e    e nK oLK�PX@ �   e    e oL@" �  �  U   e  ]   MYYY@	+!!!!!!��$�@��#��X2�x���  ������  �K�
PX@ �    e  e oLK�PX@    e  e nK oLK�PX@ �    e  e oL@" � � U    e ] MYYY@	+!5!!!!!��$�@��#��j��������  ������  �K�
PX@ �  e oLK�PX@  e nK oLK�PX@ �  e oL@ �  �  U ]  MYYY@	+!!!!!!��$�@��#��X2������     <j�   @  U  ] M+!!%!!<��i�����     <�l   @  U  ] M+!!!!<��i��l��X�� ����   "@    e U ] M+3#3#����������� ����   "@    e U ] M+!!!!�@��@��������� ���  6K�PX@    e oL@ �   U   ]  MY�!#+4663!!"#K�ry����pn�w���~ �����  6K�PX@    e oL@  �   U  ]   MY�!!+4#!5!2#���xp�M�p��v�p�~ ��j��  SK�
PX@  �   U   ]  MK�PX@    a nL@  �   U   ]  MYY�$ +!253#!x��M�p�����rp�v    j��  ^K�
PX@ �   U  ]  MK�PX@   a nL@ �   U  ]  MYY@ 
 +"&&533!lp�M��yjv�p��r�� ����(�  :K�PX@   nK oLK�PX@  �   n L@	   � tYY�+3#v��3���Z   ����(�  :K�PX@   nK oLK�PX@  �   n L@	   � tYY�+3#W�Ͳ��Z    ����(�  K�	 JK�PX@  nKoLK�PX@ �  n L@  �tYY�+33##������f���������'�,�.&��    ��jh  @   U   ]  M+!!|���   ���  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+3#����" hj�  @   U   ]  M+!!h}���  ����  -K�PX@   ] oL@   U   ]  MY�+3#����.  ��hk  @   U   ] M    +!|W��    ���  FK�
PX@   U   ]  MK�PX@  ]   nL@   U   ]  MYY�+!!�@����"   h�l  @   U   ]  M+!!h}��l�� ����  -K�PX@   ] oL@   U   ]  MY�+!!�@����.    ���l  "@ U    e ] M+!5!5!!|�p�i��j�V�� ����  pK�
PX@  �  ] oLK�PX@ nK  ] oLK�PX@  �  ] oL@  �  U  ]  MYYY�+333!�P�P�����"�.    ���l  "@   U  e   ]  M+!!!!�i���plV�V   ����  kK�
PX@   e oLK�PX@  ] nK oLK�PX@   e oL@  �   U  ]  MYYY�+#!##P@P����"�. ��  @   jK oL+3#���     ����   "@    e U ] M+3#3#������
���
  ���s < K �K�PX@%67 J@%67 JYK�PX@+  g  g
g   W  _	  O@2 ~  g  g
 g   W  _	  OY@>= EC=K>K53+)"  <<+"$'&5476$32#5#"'&&5467663254'&#"3272654'&#"���kel]^` ����&@@S�j09457�IQDC$WV�p�I��N߉pm0"<:k�@@liAAAA��rvp>̼:svq�����o?""x6�c[�=?:#">?�]^_`������]e)�C���LLMM��MM  8���� = P6K�
PX@HG5'8 JK�PX@HG5'8JK�PX@HG5'8 J@HG5'8JYYYK�
PX@$ _ pK  _  qK _  q LK�PX@! _ pK ] iK _  q LK�PX@$ _ pK  _  qK _  q L@! _ pK ] iK _  q LYYY@?> >P?P760. ==+"&'&&546767&'&5467632&'&#"67654&''3#''276767667(k�B@N##D�440c�AB7P:@>Bd882*�'�%%K��N(V3*f-.5%�T^+.c/�I?=�gC�;teKBEHOs*W
�(--O8BR8��4HKd3#'�vzX�m"4�DLNR^�c/5     j�;�  !@ J�  ]   hL(+&'&&54763!###-�u9=��������o6�`�tt�f��      }�N ! C a e�dD@ZO_P`J  g  g 
g	  W	 _  OED#" ^\VTLJDaEa42"C#C !!+� D%"'&'&5476767632'2767667654'&'&'&#"7"&547632&'&&#"327h��W0..0XVqm~~n9d*1C.-E-*f9kf]^I"=%&&KKZYmmW\JL%''<K\[~��hi�8=49:799`#D��q^i}�Wqk�kpYY.--E+2g0k��j4h-*F.f&)H"X.Wli][LK%%%&JL[]hi[9QK'&�Ȭ�fd
l#&J���3h-     }�N ! C \ h i�dD@^MJ~  g  		g g  W _
  O^]#" ge]h^h\[ZXTSFD42"C#C !!+� D%"'&'&5476767632'2767667654'&'&'&#"32#'&'&###27654&'&##h��W0..0XVqm~~n9d*1C.-E-*f9kf]^I"=%&&KKZYmmW\JL%''<K\[��FH,,P)r�k2/7��Z%%&Yf}�Wqk�kpYY.--E+2g0k��j4h-*F.f&)H"X.Wli][LK%%%&JL[]hi[9QK'&i11cH//"7��Q��z>/�   ��=� F Y 7@4(P>) J   c _ pL ,*$"
 FF+"&'&&'5327654&''&&'&54767&'&5476632&#"67654&'&'S'P $U,�we88jsd�*@//Z=d4�K&Q GU�x3H_m)x| B-/\<ff?' I�?H'���N**F<hC:Z1LgXJG1,89C�N)%�N91e>B]%MfXGG446;&�TT]/+-/)JE�/+,KC%\     �f�   ;@8
 J   ~  ]hK]hL	+#5!##33###����rh��}�r�7�qw^^�B�  �����-�  +u��  , 9�dD@.  g  W _  O &$,,	 +� D"&'&&547632'2676654'&&#"d?t-(1[Z�A6#	\+wB)H8F*P6877u--(rF�]]'89?�Y*1F#O8 68RO75  H���  !�dD@ J   �t+� D3##�Ȳ����������u     ��;/�  CK�PX@  � hK  ]k L@  �  e hLY@	+!5!3!!#��n�n�������\���   ��;/�  \K�PX@! 	 	� 	 e hK]kL@ 	 	�e 	 e hLY@
+%!5!!5!3!!!!#��n��n�n��n���ߚ���\����\     ���	{ # F@C J  e _ _K  _  ] L 
 ##
+"&''53267!5!&&#"566763  �4n/OJ&h3���[�ý6h+!)oa7������������������  �
���f  �dD@   �t    +� D3�
����x��   �0�c���/  &�dD@   U   ] M    +� D53�0��c��  �F��%f  �dD@   � t+� D3#�F��f��    ����g�  `�dD@ 
JK�PX@ o  W  _  O@ �  W  _  OY@ 	 +� D2#567654#"56�y�N4�C1xWCUƪ?i Xl06^ � �N��7  .�dD@#   g W `P"#""+� D'&#"#6632327673#"��9(&|f[HD9)'}f[HZ7'%%Q��=7'%&P��   ���f  �dD@  �   t+� D#3u���x    /)�H  Q�dDK�PX@  n   W   `  P@ �   W   `  PY@    ##+� D327673# �0.YW.0wOP���HL%%%%L�HH   )��f  '�dD@ J  � t    +� D73#�������f����x ��u)    Z�dD@
 JK�
PX@n   W  `   P@�   W  `   PY@    %)+� D!#"'&'53254'&'�6<X>,+.*ER|,<73U.� \ ++>  )��f  !�dD@ J  �  t+� D#'#3����������x ?F�   5�dD@*  W  _ O  
+� D2##"5543!2##"5543�������    D�  (�dD@  W  _  O  
+� D2##"5543����    ��f  �dD@   �t    +� D3\����x��   X�f   %�dD@  U ]  M+� D#3#3ቿ�^�̳�x��x   =b��   �dD@   U  ]   M+� D!5!���Vb�  ��u    Z�dD@
  JK�
PX@  n   W   `  P@ �   W   `  PY@    ''+� D!32767#"'&54767�-4$!%#&|7:6>++ /�++^/57<    V�{   *�dD@  g   W  _   O%%&#+� D#"'&5476324&#"326{OPtrPPPOsuOO{XA?+,X?@X�tOPPPssPOOOt?X+,@@XX    �7 $ .�dD@#   g W `P#(##+� D&'&#"#67632327673#"'&'+&|33[%" %9'}33[%" %�	%%Q�KJ 7

%&P�KJ   ���  1�dD@& ~   |  X  _   O+� D"&&54663"3�N|HH|N?YY?�J}LL|J{X??Y  %  ��  
 +@(	 J f   hKiL

+3#!#����n��l�����+��{'��  ?��   %@" _  hL  
+2##"5543!2##"5543��������    ��Z�  :K�PX@   � hLK�!PX@   � jL@	  �   tYY�+#3u�ź�    �� %  @ d   _p L#"'##$+&&'&#"#47632326553#"'&'+$}43U!" /9(}33T" 2Z
,f:;4(f9<  y���  CK�PX@ �   h LK�!PX@ �   j L@
   �tYY@
    +3\����� 7���  0� JK�%PX@  � jL@
  �  tY�+#'#3�����ӽ
  7���  8� JK�%PX@  �  j L@  � tY@    +73#å��ӽ������
     �Zj  � 0+'?��jl��l ��� 
  Q� JK�PX@ o  f hL@ �  f hLY@+3##5!53tt��}k�����o��y����c   /��  @K�%PX@    cjL@ �   W   _  OY@    #!+327673#"'&'��S10w
PP��OO�o8v>>==x  ��  @  _  hL  
+2##"5543�����  ��Y�  ! $@! J   �� t+34767766765###��F4a�(:"��H.D4B�����/�dJ>WBDu$/����Q�3/J.$EbP�V  ����   >@;J   � fU]M  
  +3!##353���������#������|�X����Ҭ     b��p�    / I@F-!J 	g g   U  ^  N /.(&  
 
+"5434676322#"!4&654'&#"3��:1f��f1:����U62ziV,1@@1/W����q��^�6nn6�^�z����]B>o�z�l��o,aD-//1B`+�a   ����z  @ JnK   o L    +#P���z�@�Z	f ������  � 0+'7qc��q���q��q��   �!z  @ J   nK oL+3#����z���   ��B�  � 0+	��/�n��c��1q�@�Z   %  ��  
 L�	 JK�(PX@ f   TKUL@� f   T LY@


+3#!#����n��l�����+��{'��  �  q�    e�JK�(PX@ e  ]   TK] UL@ e a  ]   TLY@( 
+!2!!2654&##2654&##�����������F�����ﰖ����ƹ��(Τ�imozte�>�9{�����  �  s�  3K�(PX@  ]   TK UL@ �  ]   TLY�
+!!#���/�ժ��    �  N�  NK�(PX@  e  ]   TK ] UL@  e  a  ]   TLY@	
+!!!!!!�v�T��r��wժ�F���    n  c� 	 G@
  JK�(PX@   ] TK ] UL@  a   ] T LY�
+7!5!!!n�����"������o�  �  H�  AK�(PX@  e  TKUL@  e ]  TLY@	
+3!3#!#��)��������d�+��9  &���t  # ' '@$    g  e _ ]L&'($
+&666'&&%4&&#"3266%!!(Y��}|јS\��vzћU�M����OR�}~�R����-���pp��������jo� �����  �  �  BK�(PX@] TK  ] UL@   a] TLY@	
+7!!5!!!!�9��=��9�ê�����     �  ��  9@		 JK�(PX@  TKUL@ ]  TLY�
+33##��w���V������h��������  %  ��  2� JK�(PX@   TKUL@ �   T LY�
+3##�����������+#��    W  z�  H�
 JK�(PX@   ~  TKUL@   ~ ]  TLY�
+!!###W�����������+'����   �  F� 	 6� JK�(PX@  TKUL@ ]  TLY�
+!3!#� ��� ����3��+��3     �  H�    NK�(PX@  e  ]   TK ] UL@  e  a  ]   TLY@	
+!!!!!!���A�)�����Aժ�F���  u��\� 
  MK�PX@ _ VK _  ] L@  g _  ] LY@  


+"32%2676654&'&#"g�������Sk  #%E��CDD!k}������y���JDBߵ��C��������FH   �  H�  6K�(PX@  ]   TKUL@�  ]   TLY�
+!#!#��������++��   �  \�   NK�(PX@ e  ]   TK UL@ � e  ]   TLY@
		
" 
+! !##2654&##��������������A�B���������  x  m�  L@J IK�(PX@  ]   TK ] UL@  a  ]   TLY�
+75!!!!x��:�����9"��A@�������   /  ��  6K�(PX@  ] TK UL@  �  ] T LY�
+!5!!#�+s�-�+����   "  �� - z@ & JK�%PX@   _TK _TK ULK�(PX@   W g UL@ �   g_ OYY�'9#7
+4.'&&#"56326676632#"&'#�$AU0\()!5M!��(<�n
Oz72[9W;��Z̼������^U4&HD'���R�v   v  [�  & 0 Q@0'&
 JK�(PX@] TK  ] UL@   a] TLY@	
+%35.546675#5!#3!3667654'&'p�v�de�u��v�ed�v���M)DD(N�*<CC*M�ta��bv��vb��at�)D��D)	 C��C*      ��  7�	 JK�(PX@  TKUL@ ]  TLY�
+33##�P�HN��A�����u����3�B����}     u  Z�   E@	 JK�(PX@TK  ^ UL@   bTLY@	
+%35&'&3367633!o��b{�($-I�I.K�{b��������W����FW"��[!X�DW���x��֪    J  �� + I�) IK�(PX@ _ TK  ]UL@  a _ TLY@	*'
+73&'&576323!567654&'&&#"!J�{77���}�F�79z��1xCC+.+|NRy)YCEv�1�����5��^Y���������L���t�D?EH<��դ�K� ��  ��    q� JK�(PX@   ~	 f  TKUL@   ~�	 f  T LY@  
	  

+33#!<���9����n��lG��]x������+��{'��    �  ��   bK�(PX@& ~  e  ]  TK ] UL@# ~  e  a  ]  TLY@
+3#!!!!!!7����*v�T��r��w���x��F���   ��  ��   UK�(PX@   ~  e  TKUL@   ~  e ]  TLY@
+3#3!3#!#����*�)��������x��d�+��9 �!  ��   VK�(PX@  ~ ]  TK] UL@ ~ a ]  TLY@
+3#!!5!!!!:����*9��=��9������M�����   �N���� 
   �K�PX@  ~ _VK _  ] LK�PX@$ ~ TK _ VK _  ] L@" ~  g TK _  ] LYY@  


+"323#276'&#"�������������V�DCCD��DDDD~������y������*��LL����������    �+  �� - 1 �K�,PX@ & J@& JIYK�%PX@& ~   _TK _TK ULK�(PX@ ~   W g ULK�,PX@" ~ �   g_ O@! ~ �   W g TLYYY@
'9#7
+4.'&&#"56326676632#"&'#3#$AU0[))!5M!��(<�n
Oz72[9W;��=�����Z̼������^U4&HD'���R�v���   �A  ��  & ]�$IK�(PX@  ~  _  TK^UL@ ~b  _  TLY@&&
+3#3&546323!5654#"!Z����6�xq��pz��1t�����;qR�1����p� ��2����Ҹ�߅��HL�������2�   �  <   # �K�
PX@#
  g] TK	] 		U	LK�PX@%
  _ZK] TK	] 		U	LK�(PX@#
  g] TK	] 		U	L@ 
  g 		a] TLYYY@ #"!  

+"554332#3"554332#!!5!!!!]����W9��=��9��q�����9�����    "  �<   E@$>5#,JK�
PX@(
	  g _TK _TK ULK�PX@*
	  _ZK _TK _TK ULK�%PX@(
	  g _TK _TK ULK�(PX@!
	  g W g UL@% �
	  g g_ OYYYY@ ED<:30'%" 

+"554332#3"554332#4.'&&#"56326676632#"&'#]�����$AU0\()!5M!��(<�n
Oz72[9W;�q�����Z̼������^U4&HD'���R�v  F���y  * �@	
JK�PX@ __K `  U LK�PX@% __K  `  UK _  U LK�(PX@& WK _ _K ` UK _  U L@$   h WK _ _K _  U LYYY@ " ** 	
+"4632333#"&''277'&&#"���}�x��c��(M Xn^|.���G=,uB1Z#&'Go0���%���1Y�~Xl��յ�m79?�a��^  ��Vc#  3 =@:J  g  _   ^K _ UK YL%4$.#
+46632"&'#32665!"5654&&#"�z�jK��OVVV�E~یJ�[��k�BFwJ�x"��Nq4?tIY��`/b�lk�.u�[~�r&4� .K+6t\��|Vd)8ya     B�V�`  #@ 	  J   _WK YL!"
+!&##5323#,��-^1F�A�F��[�D~���S]���V    ���H! ) 1 I@FJ _ ^K _ _K _  ] L+* /-*1+1&$ ))
+"46767&&'&&54632&&' ! i��A:-""��&N�B�Q #A!')e�������+!��F$##J,��$� / +�����՜���P�P    ���({ & J@G#$ J  e _ _K  _  U L "  &&
+"$5467&&54632&&#"33#"327���헁x��Ҟ�i�H����������Ɵa���w��`��0�UEDV�lZ[iE�     ��R& $ '@$  J I   ] VK YL$#
+654&'.547!5! #�4[:?$���d}����f����[|�:������=D0B2m���9 u����z���L�|v�   ��V{  o� JK�PX@   _WK UK YLK�(PX@ WK   _ _K UK YL@   _ _K ] WK YLYY�""
+4&#"#363 #biq����b�T��������`���;��     ���H�    gK�*PX@  e _ TK _  ] L@  g e _  ] LY@  	
+"32.#"2667!h�������1?z^]z?^z?��>z�uu��x�����yY�脄��E�镕�  6���`  (@% ] WK  _  U L 
	 
+"&'&&5#5!33`^�&))��MHY3-1�gC��#ag'�     �  �`  9@		 JK�(PX@  WKUL@ ]  WLY�
+33##�����G���b��`�/��Z�FB��?  D  �  =� JK�(PX@   _ VKUL@ �   _ V LY�!#
+'&&##5##/JdL1F�� ����~�2�C;�RW��<��    t  B`  2� JK�(PX@  WK UL@  �  W LY�
+3>54&'&&'3#t�!S�P9=�,G*X��>�`�TUƽEP-:vJ;��>\���9     ��R8 . 6@3  J   ~] VK   ` YL.-
+654&'.5467&&5467#5! #�?P:?"���j����kq����������^��7������E:.H	$P�s��6�xj�+����nd��{N]1�o�    ���H{   -@* _ _K _  ] L  
+"32' ! h������������+ /�������Ӝ���P�P   P���L  g� JK�(PX@] WK UK  _  ] L@    ~] WK  _  ] LY@ 
	 
+"'&&5!##5!#32767q/�T��1�3*&'B t]��H����@I �     ��VJ{   2@/J  _   _K_ ]K YL$"
+32#"'# ! ��������[������<#�������ɪ��)���P�P     ��R{ $ 2@/J   ~ _ _K   ` YL'$-
+654&'.5 32&&#"#�>Q6C ���\#���E�]��7WcZ������D<,G6wը9V�>=��y�\,
�su�     w��Y`   0@-] WK _  ] L 	 
+"3!#'26654'&'"M������vܒ`�A�<<��+(����놜c�h�.���O     �  2^  JK�(PX@] WK  _  U L@   c] WLY@ 	 
+!"&5!5!!33`�������"$lY������.0�   3  i`  JK�(PX@ ]WK  _  U L@   c ]WLY@ 
 
+!"&5#5!326676654&'3S����<^r�IB\�IT?����;��+~q�݀[�r^�s�q    L�V�h  * 3@0JH _ WK _  UK YL(#
+"466734632##26654&'&&#"��k�fA1L�e}qb�sù��>uL*#B;3 ��u�Ks������x�������n6U��p�2,.�     Y�Vx`  +@(	 J   _WK `YL!#!"
+&##53 333#"&'#�/�1FB�
����/�1F~�"����_�~����,���~�VZz��     ��VN`  &@# JWK  UK YL
+"&&5336676653##`�u�+)8E�C)+�u�`������Yx,=��,
, ,xY��x����o  F���` 2 :@70J ~WK `  ] L .,&% 22
+"4667332676653326766553#"&'q��90�-8}%A�
8",>~�09��g{|+t��ff��z�;6,�΍�j 5=Z5jz  f��t����iJJi   6���p   4@1   � � ] WK _UL
+3#"&'&&5#5!33������^�&))��MHYp��� 3-1�gC��#ag'�   6����   ) sK� PX@$	  _VK ] WK _
UL@"	  g ] WK _
ULY@ (&"! )) 

+"554332#3"554332#"&'&&5#5!33]���^�&))��MHY)������3-1�gC��#ag'�   ����d    + �K� PX@1 ~   ZK
_VK ] WK 		_UL@/ ~
h   ZK ] WK 		_ULY@!*($#"!++
+3#"554332#!"554332#"'&5#5!33�������N��RR��MHYd���������`b�C��#ag'�  3  ip  ! `K�(PX@!   � � ]WK _UL@   � � c ]WLY@
	!!
+3#"&5#5!326676654&'3�����x����<^r�IB\�IT?��p�����;��+~q�݀[�r^�s�q     3  i�   5 �K� PX@%
	  _VK ]WK _ULK�(PX@#
	  g ]WK _UL@ 
	  g c ]WLYY@! .-$"55 

+"554332#3"554332#"&5#5!326676654&'3]����ধ��<^r�IB\�IT?��*��������;��+~q�݀[�r^�s�q     3��if    : ��,	JK�%PX@2 ~   ZK_VK ]
WK 		_UL@0 ~h   ZK ]
WK 		_ULY@#32)'#"! ::
+3#"554332#!"554332#"&5#5!326676654&'3�������N��崦��MHd�H
B\�FWA��f�����������;��+ag'��|_�rZ�p�q     ���H�    9@6   � � _ _K_]L	
+3#"32' ! �����������������������+ /�������Ӝ���P�P   F���p  6 F@C4J   � � ~WK`	]L20*)!66

+3#"4667332676653326766553#"&'�����j��90�-8}%A�
8",>~�09��g{|p����+t��ff��z�;6,�΍�j 5=Z5jz  f��t����iJJi    F����   . �@	!JK�PX@$   � � __K
`	ULK�PX@/   � � __K `	UK
_	ULK�(PX@0   � � WK _ _K ` UK
_	UL@.   � �  h WK _ _K
_	ULYYY@&$..

+3#"4632333#"&''277'&&#"�����!��}�x��c��(M Xn^|.���G=,uB1Z#&'Go�����0���%���1Y�~Xl��յ�m79?�a��^    ���(�  * V@S
'(J   � �  f _ _K _UL&$ **	
+3#"$5467&&54632&&#"33#"327��������헁x��Ҟ�i�H����������Ɵa�����׹�w��`��0�UEDV�lZ[iE�     ��V�   ��JK�PX@    � � _WK UK YLK�(PX@$   � � WK _ _K UK YL@$   � � _ _K ] WK YLYY@
"#
+3#4&#"#363 #������iq����b�T������������`���;��   =�O��    gK�PX@   g _qK _  m L@  g g _  m LY@	 	 	+ ! %24&#""'&54632h��+-�ӯWXXV�#/"%/1�O���N�OYX������  -- !)   X�p�� 
 E� JK�'PX@  �  ^ mL@  �  U  ^  NY�+35733!j��������c)t'�+n    B�f}�  +@( 
  J    g ] mL$'+767654&#"56632!!B�f((dRc~Bw<��%&v�������b<=3=LH}�k::<u�r  F�H�� ! J@G J  g _ qK  _  u L 	 !!+"'532654##53254&#"56632-ny�\fu�BJ�_X^yEt3������H)y5PE�l{9>/yvc�&+�}�   �V�� 
  .@+J �  f mL+!533##��}k�tt����y��o�)��c   ?�a}�  A@> J  e  g  _  m L 
 +"'532654&#"!!6323�`l|iotgc[���39����a$r7b[Zc)�_�����    I�k��   u@	JK�0PX@  g  g _  m L@#  g  g  W _  OY@ 
 +"&54632&#"632'254#"�����[ZQ^�@�������Q[[�k����!h*��u����X��g]]g    =�y��  =� JK�PX@    e mL@  �   U  ]   MY�+!5!#��DH���]_0��    ;�Z��   ( E@BJ  g_ iK _  m L %#((
 	+"&547&&54632254#"2654&#"h���QY����YQ�������U[\T�]�Zp�&dHcuucHd&�q������cUNNT�NU    0�b��   E@B J  g g  _  m L 
 +"'532#"&546322654&#"'ZZR]�<���������QZZQ��b!h*?t���������g^]g��    ��Z{ 
  ( f@c  !	J  �   f  	e 	 	g W _
O$" ((+35733!"'532654&#"!!632h������M$��ɔ`l|iotgc[���39����c)t'�+n�l����$r7b[Zc)�_�����   ��Z�   7 k@h 
  0	+! J    g  e  	e 	 	g W _
O31/.-,*($"77$'+767654&#"56632!!"'532654&#"!!632@�f((dRc~Bw<��%&v����%$��ɔ`l|iotgc[���39�����b<=3=LH}�k::<u�r�l����$r7b[Zc)�_�����  ��Z� ! % ? �@�# %
	83)(	J  g  g  	 g 	 
	
e  g W _O'& ;9765420,*&?'?	 !!+"'532654##53254&#"56632"'532654&#"!!632+ny�\fu�BJ�_X^yEt3������>$��ɔ`l|iotgc[���39���))y5PE�l{9>/yvc�&+�}��l����$r7b[Zc)�_�����   
��Z{ 
   + p@m 
	$J �  	 	~ 	 
	
e  g c  ]k L'%#"! +++!533##"'532654&#"!!632��}k�tt���`$��ɔ`l|iotgc[���39����y��o�)��c�l����$r7b[Zc)�_�����  ��j{ 
  # - h@e  	J  �   f  g  		gW_
O%$)'$-%-##+35733!"&54632&#"632'254#"h������M$������[ZQ^�A�������Q[[�c)t'�+n�l��������!h*��u����X��g]]g     ��j{   2 < �@� &'	+
J  e  g   g  	g 	 
	g

W

_
O43 863<4<.,*(%#22
 +"'532654&#"!!632"&54632&#"632'254#"1�`l|iotgc[���39����Q$������[ZQ^�A�������Q[[)$r7b[Zc)�_������l��������!h*��u����X��g]]g    ��Z{ 
   A@>  J  � �   f U ] M+35733!!5!#h������M$����DH����c)t'�+n�l��"_0��     ��Z{ 
  # - �@  	J	IK�,PX@*  �   f  		g 
c_ iL@0  �   f  		g g W _
OY@%$+)$-%-##+35733!"'532#"&546322654&#"h������M$���ZZR]�<���������QZZQ��c)t'�+n�l����!h*?t���������g^]g�� =`��    gK�1PX@  g _ �K _   L@  g g _   LY@	 	 	+ ! %24&#""'&54632h��+-�ӯWXXV�#/"%/1`���N�OYX������  -- !)   `�� 
  P�JK�1PX@  f ~K L@ �  f LY@+!533##��}k�tt���y��o�)��c    ?<}�  �@ JK�PX@  g ] ~K  _   LK�0PX@  g   c ] ~L@!  e  g   W  _  OYY@ 
 +"'532654&#"!!6323�`l|iotgc[���39���<$r7b[Zc)�_�����    IN��   q@	JK�1PX@  g _ ~K _   L@  g  g _   LY@ 
 +"&54632&#"632'254#"�����[ZQ^�@�������Q[[N����!h*��u����X��g]]g    =`��  8� JK�1PX@   ] ~K L@    e LY�+!5!#��DH���D_0�� ;T��   ( o�JK�1PX@  g _ �K _   L@  g g _   LY@ %#((
 	+"&547&&54632254#"2654&#"h���QY����YQ�������U[\T�]Tp�&dHcuucHd&�q������cUNNT�NU  0Y��   q@ JK�1PX@ g _ �K  _   L@  g g  _   LY@ 
 +"'532#"&546322654&#"'ZZR]�<���������QZZQ�Y!h*?t���������g^]g��    O ��#   �	0+55O���-���-/R��������R�������    � ��#   �
0+5%5�-����+�-����+L��^R�^���^R�^  ��T�` ' rK�1PX@ %J@ %JYK�1PX@  kK_qK mL@   ~  kK _qK mLY@
&(%+332765332767#"'&'#"'#�� <q~@@�
&"&>%&.BB[�V�`�HNh#LUU����;�()MQ&'���   ��  ��   %@" J   �^ iL+3!% ��!�������q���   ���f  �dD@   � t
+� D3#�����f��     �.�f    B�dD@7   � ~W`P
+� D3#"554332#!"554332#�������N�f������� �@
�  @   W  _  O  +"&54632hD^^DD^^@^KK^^KK^  � �QJ  &K�PX@  �   n L@	   � tY�+3#����J�m    %  �@    e�JK�PX@"   ~ f   nK hKiL@   � � f hKiLY@+3#3#!#������n��l���@��c�+��{'��     ���1<   �@ JK�PX@!   n� _ pK _ qLK�
PX@    �� _ pK _ qLK�PX@#  ~   nK _ pK _ qL@    �� _ pK _ qLYYY@
$"#&+3#'#&76!2&# !27# F�ӌ���J��������y���P�\��<�����|�lp��R�}����}�*(  ����  " @@= J   �� _ sK _ qL&$%%+3#'#& 32&&#"327667# B�������'�Y�SK�[����_I)A#����������n�8(.�B9����+!�V     f��P<  ( �@ #JK�PX@)   n�  e _ pK _ qLK�
PX@(   ��  e _ pK _ qLK�PX@+  ~  e   nK _ pK _ qL@(   ��  e _ pK _ qLYYY@"(%$	+3#'#76!2&'&#"327#5!#"$F�ӌ�������LZU`�dcK�~�M�������<������n��k�I)$���˝pX�a@���}��Z   ��H.�  # ./@ 	JK�PX@/   �� kK _ sK 		_ iK _ uLK�
PX@+   �� _sK 		_ iK _ uLK�PX@/   �� kK _ sK 		_ iK _ uLK�PX@+   �� _sK 		_ iK _ uL@/   �� kK _ sK 		_ iK _ uLYYYY@-+"#'%#
+3#'#5327655#"'&5763273#"!"326=������3���EDVځbbjuy��^������������������n�ZRP���GH�����������������  �  H<   �� JK�
PX@    ��  fhKiLK�PX@#  ~  f   nKhKiL@    ��  fhKiLYY@	+3#'#3!3#!#
�ӌ�����)�����<����]��d�+��9    �  <   �@
 	JK�
PX@!   �� jK _ sKiLK�PX@$  ~   nK jK _ sKiL@!   �� jK _ sKiLYY@#"+3#'#3632#4&#"#��ӌ�����e�UT�jr���<�������pq��J�������   m���<   �@ JK�
PX@    �� ] hK _ qLK�PX@#  ~   nK ] hK _ qL@    �� ] hK _ qLYY@
$#+3#'#532665!5!#"&��ӌ����G��ao/��Gjl�d�<������?��D����vv,     ��V(p   3@0 J   �� ] kK ] mL#!+3#'#325!5!##���������������p������������     ���J<  1 �@ JK�PX@!   n� _ pK _ qLK�
PX@    �� _ pK _ qLK�PX@#  ~   nK _ pK _ qL@    �� _ pK _ qLYYY@
-#/#+3#'#532654'&&''&'&546632&#"#"&�ӌ�����Ț�:_Ol�^^{ݔ�ʹ��RR79�j�����n�<�����׍��k: */_^���lN�wBBw[67!/Ӵ��+     ����  3 @@= J   �� _ sK _ qL/#-%+3#'#5327654&/&&54632&#"#"&$������YlYbPyDCvE���ͫ����/43eJ�DF��X��������521SEX ����B�\�$%LL���#    �6�� F U g �K�#PX@&'  eUSJgDA>J@&' eUSJgDA>JYK�#PX@(
	�  g _ pK _qL@/   ~
	�g _ pK _qLY@`^PNFE@?=<;:98*(%#""+363263267654'&&''&&'&&547632&#"#7&'#7&&'#?4'&#"7677654'&#"�N.EQ/O.5
�Zg,RGe^{('#�����'���eg11�y�����XDBX"@$X"	
&<?�
(	@E�2@JJ92%'5GNX�O2(!=('^D֍�N�wRR|K++)'5���}����
��,* J'(#"E>.    	  �� 	  + / >@;		J  	g 	  	e ]hK  i L/.'&'#
+3#33##"&'&5476323267654'&#"!5!�������@q;V BBCnr?B��'A:=
&%CB&&i�G���T��+[Mp:5m��rpqq��LbF1N�QNMR���	{      ��   5@2   ~ e  ] hK iL%4+"#54763!2###2654&##h��?S���������������/�r�@qp������������  h�V�   > E@B-*J   h _jK	kK ^
mL! /.,+$" >!>&"&"+#6632327673#"&''&'&#"#53276766733�|eZ'?'9&}eZ'?'9&��mP/ "�O�LG���*/" 3 J|'O��"7
%$R��"7	���/=R8N��l�8l5A�L)=35&     %  �< ! * ��*'$JK�
PX@  g   hhK iLK�PX@    h _nKhK iL@  g   hhK iLYY@'""%# 	+#47632326553#"'&''&'&#"#33�}43V(19( (}iT%39"'��#�lk��!ge;;4(cx!	�m�7�m���   |��Y  6 > U@R01	J   h e _jK 

_ sK 	_ 		q	L777>7><:64$'####+#47632327673#"''&#"&76632!327# &'&#"�|32^GD9*$}23^GD9($Ǔ�H�s�|{��`^���k_Ze��GH���a'O�LK=7'%$R�LL=7'����PP���Z�edq�+��RT��     �  N< ! - �K�
PX@/  g   h 	 
	
e ] hK ] iLK�PX@1   h 	 
	
e _nK ] hK ] iL@/  g   h 	 
	
e ] hK ] iLYY@-,+*)('""%# +#47632326553#"'&''&'&#"!!!!!!�}43V(19( (}iT%39"��wv�T��r�ge;;4(cx!	�mժ�F���     �  K�   -@* ]hK ]hK   ] iL% +7!27665!5%#!3#�.8./6��67�n�����^6����n]^m���   ��V+    ( 8@5 _  jK ]kK iK 	] 		m	L(&!3332
+54332##"%54332##"3#!25!5!#!�������[���C���ñ���I���������������    �  s�   #@   g   hK ^ iL33+3!!54332##"����d�����ժ:��   ���   )@&  g   ] jK ] iL33!"+%&5!5!33#"54332##"6[��ߴ�颾��bj����z��B��    /�u��  Y@
JK�!PX@  ] hKiK _ mL@  c  ] hKiLY@
$++!##"'53254&'#!5!��-H	<>u[T&D-|%5�+s+��!9/U.-�\(U7+�     ���� ' �@J&%HK�PX@  c  ]kK ] iLK�PX@"  ]kK ] iK _ mL@  c  ]kK ] iLYY@   ' '$'%	+!33##"'53254'&&5!5!7�^)-,Q��&<=v[T&D-|Ure��+�`���T_�,29/T/-�\4{��d�%P��   �  �`   @	 J  kKiL+33##�����G���b��`�/��Z�FB��?   6��� # %@"
 J    c hL! +4&'&'&'#"&&5467632653��
),[379�x_�a^RQ`Y�1������=Fs.[r{����=?8DrFDs"!93<@�{��      �   �K�PX@  J@  JYK�PX@ ]   jK_kKiLK�PX@" ]   jK kK_ sKiL@  kK _ sK  ]   jKiLYY@
#"+53#%3632#4&#"#b�řt�d�UT�jr���F�������pq��J�������     ���=' 	 + cK�PX@!n    hhK _ qL@ �    hhK _ qLY@  %$ 	 	!!	+! '3327#"'&'&'&533267653�����w��WkcZ^<?!�788Ue��|'��oo��"69h[���v+5NYe/k��h��AEp     ���1 	  �K�PX@!    h	jKkK `qLK�#PX@%    h	jKkK iK ` qL@%	�    hkK iK ` qLYY@   	 	!!
+! 3327# 332653#�����w��0e����65p����1�����w����J�FG��y��       �  	   �    	   �  	   �  	  2 �  	    	 ,  	  H  	  `  	 	 ,|  	  B�  	  L�  	 .6  	  z d C o p y r i g h t   ( c )   2 0 1 8   S o u r c e   F o u n d r y   A u t h o r s   /   C o p y r i g h t   ( c )   2 0 0 3   b y   B i t s t r e a m ,   I n c .   A l l   R i g h t s   R e s e r v e d . H a c k R e g u l a r S o u r c e F o u n d r y :   H a c k :   2 0 1 8 H a c k   R e g u l a r V e r s i o n   3 . 0 0 3 ; [ 3 1 1 4 f 1 2 5 6 ] - r e l e a s e ;   t t f a u t o h i n t   ( v 1 . 7 )   - l   6   - r   5 0   - G   2 0 0   - x   1 0   - H   1 8 1   - D   l a t n   - f   l a t n   - m   " H a c k - R e g u l a r - T A . t x t "   - w   G   - W   - t   - X   " " H a c k - R e g u l a r S o u r c e   F o u n d r y S o u r c e   F o u n d r y   A u t h o r s h t t p s : / / g i t h u b . c o m / s o u r c e - f o u n d r y h t t p s : / / g i t h u b . c o m / s o u r c e - f o u n d r y / H a c k T h e   w o r k   i n   t h e   H a c k   p r o j e c t   i s   C o p y r i g h t   2 0 1 8   S o u r c e   F o u n d r y   A u t h o r s   a n d   l i c e n s e d   u n d e r   t h e   M I T   L i c e n s e 
 
 T h e   w o r k   i n   t h e   D e j a V u   p r o j e c t   w a s   c o m m i t t e d   t o   t h e   p u b l i c   d o m a i n . 
 
 B i t s t r e a m   V e r a   S a n s   M o n o   C o p y r i g h t   2 0 0 3   B i t s t r e a m   I n c .   a n d   l i c e n s e d   u n d e r   t h e   B i t s t r e a m   V e r a   L i c e n s e   w i t h   R e s e r v e d   F o n t   N a m e s   " B i t s t r e a m "   a n d   " V e r a " 
 
 M I T   L i c e n s e 
 
 C o p y r i g h t   ( c )   2 0 1 8   S o u r c e   F o u n d r y   A u t h o r s 
 
 P e r m i s s i o n   i s   h e r e b y   g r a n t e d ,   f r e e   o f   c h a r g e ,   t o   a n y   p e r s o n   o b t a i n i n g   a   c o p y 
 o f   t h i s   s o f t w a r e   a n d   a s s o c i a t e d   d o c u m e n t a t i o n   f i l e s   ( t h e   " S o f t w a r e " ) ,   t o   d e a l 
 i n   t h e   S o f t w a r e   w i t h o u t   r e s t r i c t i o n ,   i n c l u d i n g   w i t h o u t   l i m i t a t i o n   t h e   r i g h t s 
 t o   u s e ,   c o p y ,   m o d i f y ,   m e r g e ,   p u b l i s h ,   d i s t r i b u t e ,   s u b l i c e n s e ,   a n d / o r   s e l l 
 c o p i e s   o f   t h e   S o f t w a r e ,   a n d   t o   p e r m i t   p e r s o n s   t o   w h o m   t h e   S o f t w a r e   i s 
 f u r n i s h e d   t o   d o   s o ,   s u b j e c t   t o   t h e   f o l l o w i n g   c o n d i t i o n s : 
 
 T h e   a b o v e   c o p y r i g h t   n o t i c e   a n d   t h i s   p e r m i s s i o n   n o t i c e   s h a l l   b e   i n c l u d e d   i n   a l l 
 c o p i e s   o r   s u b s t a n t i a l   p o r t i o n s   o f   t h e   S o f t w a r e . 
 
 T H E   S O F T W A R E   I S   P R O V I D E D   " A S   I S " ,   W I T H O U T   W A R R A N T Y   O F   A N Y   K I N D ,   E X P R E S S   O R 
 I M P L I E D ,   I N C L U D I N G   B U T   N O T   L I M I T E D   T O   T H E   W A R R A N T I E S   O F   M E R C H A N T A B I L I T Y , 
 F I T N E S S   F O R   A   P A R T I C U L A R   P U R P O S E   A N D   N O N I N F R I N G E M E N T .   I N   N O   E V E N T   S H A L L   T H E 
 A U T H O R S   O R   C O P Y R I G H T   H O L D E R S   B E   L I A B L E   F O R   A N Y   C L A I M ,   D A M A G E S   O R   O T H E R 
 L I A B I L I T Y ,   W H E T H E R   I N   A N   A C T I O N   O F   C O N T R A C T ,   T O R T   O R   O T H E R W I S E ,   A R I S I N G   F R O M , 
 O U T   O F   O R   I N   C O N N E C T I O N   W I T H   T H E   S O F T W A R E   O R   T H E   U S E   O R   O T H E R   D E A L I N G S   I N   T H E 
 S O F T W A R E . 
 
 B I T S T R E A M   V E R A   L I C E N S E 
 
 C o p y r i g h t   ( c )   2 0 0 3   b y   B i t s t r e a m ,   I n c .   A l l   R i g h t s   R e s e r v e d .   B i t s t r e a m   V e r a   i s   a   t r a d e m a r k   o f   B i t s t r e a m ,   I n c . 
 
 P e r m i s s i o n   i s   h e r e b y   g r a n t e d ,   f r e e   o f   c h a r g e ,   t o   a n y   p e r s o n   o b t a i n i n g   a   c o p y   o f   t h e   f o n t s   a c c o m p a n y i n g   t h i s   l i c e n s e   ( " F o n t s " )   a n d   a s s o c i a t e d   d o c u m e n t a t i o n   f i l e s   ( t h e   " F o n t   S o f t w a r e " ) ,   t o   r e p r o d u c e   a n d   d i s t r i b u t e   t h e   F o n t   S o f t w a r e ,   i n c l u d i n g   w i t h o u t   l i m i t a t i o n   t h e   r i g h t s   t o   u s e ,   c o p y ,   m e r g e ,   p u b l i s h ,   d i s t r i b u t e ,   a n d / o r   s e l l   c o p i e s   o f   t h e   F o n t   S o f t w a r e ,   a n d   t o   p e r m i t   p e r s o n s   t o   w h o m   t h e   F o n t   S o f t w a r e   i s   f u r n i s h e d   t o   d o   s o ,   s u b j e c t   t o   t h e   f o l l o w i n g   c o n d i t i o n s : 
 
 T h e   a b o v e   c o p y r i g h t   a n d   t r a d e m a r k   n o t i c e s   a n d   t h i s   p e r m i s s i o n   n o t i c e   s h a l l   b e   i n c l u d e d   i n   a l l   c o p i e s   o f   o n e   o r   m o r e   o f   t h e   F o n t   S o f t w a r e   t y p e f a c e s . 
 
 T h e   F o n t   S o f t w a r e   m a y   b e   m o d i f i e d ,   a l t e r e d ,   o r   a d d e d   t o ,   a n d   i n   p a r t i c u l a r   t h e   d e s i g n s   o f   g l y p h s   o r   c h a r a c t e r s   i n   t h e   F o n t s   m a y   b e   m o d i f i e d   a n d   a d d i t i o n a l   g l y p h s   o r   c h a r a c t e r s   m a y   b e   a d d e d   t o   t h e   F o n t s ,   o n l y   i f   t h e   f o n t s   a r e   r e n a m e d   t o   n a m e s   n o t   c o n t a i n i n g   e i t h e r   t h e   w o r d s   " B i t s t r e a m "   o r   t h e   w o r d   " V e r a " . 
 
 T h i s   L i c e n s e   b e c o m e s   n u l l   a n d   v o i d   t o   t h e   e x t e n t   a p p l i c a b l e   t o   F o n t s   o r   F o n t   S o f t w a r e   t h a t   h a s   b e e n   m o d i f i e d   a n d   i s   d i s t r i b u t e d   u n d e r   t h e   " B i t s t r e a m   V e r a "   n a m e s . 
 
 T h e   F o n t   S o f t w a r e   m a y   b e   s o l d   a s   p a r t   o f   a   l a r g e r   s o f t w a r e   p a c k a g e   b u t   n o   c o p y   o f   o n e   o r   m o r e   o f   t h e   F o n t   S o f t w a r e   t y p e f a c e s   m a y   b e   s o l d   b y   i t s e l f . 
 
 T H E   F O N T   S O F T W A R E   I S   P R O V I D E D   " A S   I S " ,   W I T H O U T   W A R R A N T Y   O F   A N Y   K I N D ,   E X P R E S S   O R   I M P L I E D ,   I N C L U D I N G   B U T   N O T   L I M I T E D   T O   A N Y   W A R R A N T I E S   O F   M E R C H A N T A B I L I T Y ,   F I T N E S S   F O R   A   P A R T I C U L A R   P U R P O S E   A N D   N O N I N F R I N G E M E N T   O F   C O P Y R I G H T ,   P A T E N T ,   T R A D E M A R K ,   O R   O T H E R   R I G H T .   I N   N O   E V E N T   S H A L L   B I T S T R E A M   O R   T H E   G N O M E   F O U N D A T I O N   B E   L I A B L E   F O R   A N Y   C L A I M ,   D A M A G E S   O R   O T H E R   L I A B I L I T Y ,   I N C L U D I N G   A N Y   G E N E R A L ,   S P E C I A L ,   I N D I R E C T ,   I N C I D E N T A L ,   O R   C O N S E Q U E N T I A L   D A M A G E S ,   W H E T H E R   I N   A N   A C T I O N   O F   C O N T R A C T ,   T O R T   O R   O T H E R W I S E ,   A R I S I N G   F R O M ,   O U T   O F   T H E   U S E   O R   I N A B I L I T Y   T O   U S E   T H E   F O N T   S O F T W A R E   O R   F R O M   O T H E R   D E A L I N G S   I N   T H E   F O N T   S O F T W A R E . 
 
 E x c e p t   a s   c o n t a i n e d   i n   t h i s   n o t i c e ,   t h e   n a m e s   o f   G n o m e ,   t h e   G n o m e   F o u n d a t i o n ,   a n d   B i t s t r e a m   I n c . ,   s h a l l   n o t   b e   u s e d   i n   a d v e r t i s i n g   o r   o t h e r w i s e   t o   p r o m o t e   t h e   s a l e ,   u s e   o r   o t h e r   d e a l i n g s   i n   t h i s   F o n t   S o f t w a r e   w i t h o u t   p r i o r   w r i t t e n   a u t h o r i z a t i o n   f r o m   t h e   G n o m e   F o u n d a t i o n   o r   B i t s t r e a m   I n c . ,   r e s p e c t i v e l y .   F o r   f u r t h e r   i n f o r m a t i o n ,   c o n t a c t :   f o n t s   a t   g n o m e   d o t   o r g . h t t p s : / / g i t h u b . c o m / s o u r c e - f o u n d r y / H a c k / b l o b / m a s t e r / L I C E N S E . m d       �$ Z                   %  123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|"}~�$���'���������������������������������������������������������������B����������������J���M�����P����������������������Z����\����_������� 	
opqrstuvwxyz{|}~�������������������������������������������������������������������������������������������������������������������������������� 	
 !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~������������������������������������� ��!��"#$%&'���()�*+,-./012345�6789:;<��=�����������>�?��@ABC����DE����������������������FGHI����JKLMNOPQR�STU������������������� 	
VWXYZ[\]^_`a !"#$%&bcdefghijklmnopqrstuvwxyz{|}~������:���������������DEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~���������������������������������������������������������������������������������������������������������������������������������	
� !"#$%�'()*+,-./0123456789:;<=>�@�B�D�F�HIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~��������������������������������������������������������������������������������������������������������������������������������� 	
� !"#$%�'�)*+,-./0��3456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~�������������������������������������������������������������������������������������������������������������������������� �	
 !	
"#$%&'()*+,-./012 !"#$%3456*+789:;NULLCRAmacronAogonek
CdotaccentDcaronDcroatEcaron
EdotaccentEmacronEogonekGcaronuni0122
GdotaccentHbarImacronIogonekItildeuni0136LacuteLcaronuni013BNacuteNcaronuni0145EngOhornOhungarumlautOmacronOslashacuteRacuteRcaronuni0156Sacuteuni0218TbarTcaronuni021AUhornUhungarumlautUmacronUogonekUringUtildeWacuteWcircumflex	WdieresisWgraveYcircumflexYgraveZacute
Zdotaccentabreveamacronaogonek
cdotaccentdcaronecaron
edotaccentemacronEbreveebreveeogonekgcaronuni0123
gdotaccenthbarimacronIbreveibreveiogonekitildeuni0137lacutelcaronuni013Cnacutencaronuni0146engohornohungarumlautomacronObreveobreveoslashacuteracutercaronuni0157sacuteuni0219tbartcaronuni021Buhornuhungarumlautumacronuogonekuringutildewacutewcircumflex	wdieresiswgraveycircumflexygravezacutelongs
zdotaccentuni0410uni0411uni0412uni0413uni0403uni0490uni0414uni0415uni0400uni0401uni0416uni0417uni0418uni0419uni040Duni041Auni040Cuni041Buni041Cuni041Duni041Euni041Funi0420uni0421uni0422uni0423uni040Euni0424uni0425uni0427uni0426uni0428uni0429uni040Funi042Funi042Cuni042Auni042Buni0409uni040Auni0405uni0404uni042Duni0406uni0407uni0408uni040Buni042Euni0402uni0462uni0472uni0492uni0494uni0496uni0498uni049Auni04A2uni04AAuni04ACuni04AEuni04B0uni04B2uni04BAuni04C0uni04C1uni04C3uni04C7uni04CBuni04D0uni04D2uni04D6uni04D8uni04DAuni04DCuni04DEuni04E0uni04E2uni04E4uni04E6uni04E8uni04EAuni04ECuni04EEuni04F0uni04F2uni04F4uni04F6uni04F8uni0510uni051Auni051Cuni0430uni0431uni0432uni0433uni0453uni0491uni0434uni0435uni0450uni0451uni0436uni0437uni0438uni0439uni045Duni043Auni045Cuni043Buni043Cuni043Duni043Euni043Funi0440uni0441uni0442uni0443uni045Euni0444uni0445uni0447uni0446uni0448uni0449uni045Funi044Funi044Cuni044Auni044Buni0459uni045Auni0455uni0454uni044Duni0456uni0457uni0458uni045Buni044Euni0452uni0463uni0473uni0493uni0495uni0497uni0499uni049Buni04A3uni04ABuni04ADuni04AFuni04B1uni04B3uni04BBuni04CFuni04C2uni04C4uni04C8uni04CCuni04D1uni04D3uni04D7uni04D9uni04DBuni04DDuni04DFuni04E1uni04E3uni04E5uni04E7uni04E9uni04EBuni04EDuni04EFuni04F1uni04F3uni04F5uni04F7uni04F9uni0511uni051Buni051Duni04A4uni04A5uni04D4uni04D5uni0394uni03F4uni03BCuni0531uni0532uni0533uni0534uni0535uni0536uni0537uni0538uni0539uni053Auni053Buni053Cuni053Duni053Euni053Funi0540uni0541uni0542uni0543uni0544uni0545uni0546uni0547uni0548uni0549uni054Auni054Buni054Cuni054Duni054Euni054Funi0550uni0551uni0552uni0553uni0554uni0555uni0556uni0561uni0562uni0563uni0564uni0565uni0566uni0567uni0568uni0569uni056Auni056Buni056Cuni056Duni056Euni056Funi0570uni0571uni0572uni0573uni0574uni0575uni0576uni0577uni0578uni0579uni057Auni057Buni057Cuni057Duni057Euni057Funi0580uni0581uni0582uni0583uni0584uni0585uni0586uni0587uni10D0uni10D1uni10D2uni10D3uni10D4uni10D5uni10D6uni10D7uni10D8uni10D9uni10DAuni10DBuni10DCuni10DDuni10DEuni10DFuni10E0uni10E1uni10E2uni10E3uni10E4uni10E5uni10E6uni10E7uni10E8uni10E9uni10EAuni10EBuni10ECuni10EDuni10EEuni10EFuni10F0uni10F1uni10F2uni10F3uni10F4uni10F5uni10F6uni10F7uni10F8uni10F9uni10FAuni10FCuni2215uni215Funi2153uni2154	oneeighththreeeighthsfiveeighthsseveneighthsuni00B9uni00B2uni00B3uni2219onedotenleadertwodotenleader	exclamdbluni2047underscoredbluni2016uni2023hyphenationpointuni203Duni203Euni203Funi2045uni2046uni2048uni2049uni204Buni2E18uni2E1Funi2E2Eexclamdown.caseuni2E18.casequestiondown.caseuni208Duni208Euni2E24uni2E25uni2E22uni2E23uni207Duni207Euni2768uni2769uni276Auni276Buni276Cuni276Duni276Euni276Funi2770uni2771uni2772uni2773uni2774uni2775uni27C5uni27C6uni2987uni2988uni2997uni2998
figuredashuni00ADuni2010uni2011uni2015quotereverseduni201Fminutesecondmilliseconduni2035uni2036uni2037uni27E6uni27E7uni27E8uni27E9uni27EAuni27EBuni10FBuni055Auni055Buni055Cuni055Duni055Euni055Funi0589uni058Auni205Funi00A0uni2000uni2001uni2002uni2003uni2004uni2005uni2006uni2007uni2008uni2009uni200Auni202FAbreveuniFEFFcolonmonetarydongEurolirapesetauni0E3Funi20A0uni20A2uni20A5uni20A6uni20A8uni20A9uni20AAuni20ADuni20AEuni20AFuni20B0uni20B1uni20B2uni20B3uni20B4uni20B5uni20B8uni20B9angleasteriskmathcirclemultiply
circleplus	congruentdotmathelementemptysetequivalenceexistentialgradient
integralbt
integraltpintersection
logicaland	logicalor
notelement	notsubset
orthogonaluni27C2propersubsetpropersupersetproportionalreflexsubsetreflexsupersetrevlogicalnotsimilarsuchthat	thereforeuni2031uni207Auni207Buni207Cuni208Auni208Buni208Cuni2126uni2201uni2204uni220Auni220Cuni220Duni220Euni2210uni2213uni2218uni221Buni221Cuni2223uni222Cuni222Duni2235uni2236uni2237uni2238uni2239uni223Auni223Buni223Duni2241uni2242uni2243uni2244uni2246uni2247uni2249uni224Auni224Buni224Cuni224Duni224Euni224Funi2250uni2251uni2252uni2253uni2254uni2255uni2256uni2257uni2258uni2259uni225Auni225Buni225Cuni225Duni225Euni225Funi2262uni2263uni2266uni2267uni2268uni2269uni226Duni226Euni226Funi2270uni2271uni2272uni2273uni2274uni2275uni2276uni2277uni2278uni2279uni227Auni227Buni227Cuni227Duni227Euni227Funi2280uni2281uni2285uni2288uni2289uni228Auni228Buni228Duni228Euni228Funi2290uni2291uni2292uni2293uni2294uni2296uni2298uni2299uni229Auni229Buni229Cuni229Duni229Euni229Funi22A0uni22A1uni22A2uni22A3uni22A4uni22B2uni22B3uni22B4uni22B5uni22B8uni22C2uni22C3uni22C4uni22C6uni22CDuni22CEuni22CFuni22D0uni22D1uni22DAuni22DBuni22DCuni22DDuni22DEuni22DFuni22E0uni22E1uni22E2uni22E3uni22E4uni22E5uni22E6uni22E7uni22E8uni22E9uni22EFuni2308uni2309uni230Auni230Buni239Buni239Cuni239Duni239Euni239Funi23A0uni23A1uni23A2uni23A3uni23A4uni23A5uni23A6uni23A7uni23A8uni23A9uni23AAuni23ABuni23ACuni23ADuni23AEuni27DCuni27E0uni29EBuni29FAuni29FBuni2A00uni2A2Funi2A6Auni2A6Bunion	universalarrowupuni2197
arrowrightuni2198	arrowdownuni2199	arrowleftuni2196	arrowboth	arrowupdnuni21F5uni219Auni219Buni21F7uni21F8uni21F9uni21FAuni21FBuni21AEuni21FCuni219Cuni219Duni21ADuni219Euni219Funi21A0uni21A1uni21A2uni21A3uni21A4uni21A5uni21A6uni21A7arrowupdnbseuni21E4uni21E5uni21B9uni21A9uni21AAuni21ABuni21ACuni21AFuni21B0uni21B1uni21B2uni21B3uni21B4carriagereturnuni21B6uni21B7uni21B8uni21F1uni21F2uni21BAuni21BBuni21BCuni21BDuni21BEuni21BFuni21C0uni21C1uni21C2uni21C3uni21CBuni21CCuni21C4uni21C5uni21C6uni21C8uni21C9uni21CAuni21C7
arrowdblupuni21D7arrowdblrightuni21D8arrowdbldownuni21D9arrowdblleftuni21D6arrowdblbothuni21D5uni21CDuni21CEuni21CFuni21DAuni21DBuni21DCuni21DDuni21E0uni21E1uni21E2uni21E3uni21E7uni21E8uni21E9uni21E6uni21EBuni21ECuni21EDuni21EEuni21EFuni21F0uni21F3uni21F4uni21F6uni21FDuni21FEuni21FFuni2304uni2794uni2798uni2799uni279Auni279Buni279Cuni279Duni279Euni279Funi27A0uni2B06uni2B08uni2B0Auni2B07uni2B0Buni2B05uni2B09uni2B0Cuni2B0Duni27A2uni27A3uni27A4uni27A5uni27A6uni27A7uni27A8uni27A9uni27AAuni27ABuni27ACuni27ADuni27AEuni27AFuni27B1uni27B2uni27B3uni27B6uni27B5uni27B4uni27B9uni27B8uni27B7uni27BAuni27BBuni27BCuni27BDuni27BEuni27F5uni27F6uni27F7uni27A1uni2581uni2582uni2583dnblockuni2585uni2586uni2587blockupblockuni2594uni258Funi258Euni258Dlfblockuni258Buni258Auni2589rtblockuni2595uni2596uni2597uni2598uni2599uni259Auni259Buni259Cuni259Duni259Euni259Fltshadeshadedkshadeuni25CFcircleuni25EFuni25D0uni25D1uni25D2uni25D3uni25D6uni25D7uni25D4uni25D5uni25F4uni25F5uni25F6uni25F7uni25CDuni25CCuni25C9uni25CE
openbullet	invbullet	invcircleuni25DAuni25DBuni25E0uni25E1uni25DCuni25DDuni25DEuni25DFuni25C6uni25C7uni2B16uni2B17uni2B18uni2B19uni25C8uni2756uni25B0uni25B1uni25AE
filledrectuni25ADuni25AFuni250Cuni2514uni2510uni2518uni253Cuni252Cuni2534uni251Cuni2524uni2500uni2502uni2561uni2562uni2556uni2555uni2563uni2551uni2557uni255Duni255Cuni255Buni255Euni255Funi255Auni2554uni2569uni2566uni2560uni2550uni256Cuni2567uni2568uni2564uni2565uni2559uni2558uni2552uni2553uni256Buni256A	filledboxuni25A1uni25A2uni25A3uni2B1Auni25A4uni25A5uni25A6uni25A7uni25A8uni25A9uni25AAuni25ABuni25E7uni25E8uni25E9uni25EAuni25EBuni25F0uni25F1uni25F2uni25F3uni25FBuni25FCuni25FDuni25FEtriagupuni25B6triagdnuni25C0uni25B3uni25B7uni25BDuni25C1uni25ECuni25EDuni25EEtriagrttriaglfuni25BBuni25C5uni25B4uni25B8uni25BEuni25C2uni25B5uni25B9uni25BFuni25C3uni25E5uni25E2uni25E3uni25E4uni25F9uni25FFuni25FAuni25F8uni2501uni2503uni2504uni2505uni2506uni2507uni2508uni2509uni250Auni250Buni250Duni250Euni250Funi2511uni2512uni2513uni2515uni2516uni2517uni2519uni251Auni251Buni251Duni251Euni251Funi2520uni2521uni2522uni2523uni2525uni2526uni2527uni2528uni2529uni252Auni252Buni252Duni252Euni252Funi2530uni2531uni2532uni2533uni2535uni2536uni2537uni2538uni2539uni253Auni253Buni253Duni253Euni253Funi2540uni2541uni2542uni2543uni2544uni2545uni2546uni2547uni2548uni2549uni254Auni254Buni254Cuni254Duni254Euni254Funi256Duni256Euni256Funi2570uni2571uni2572uni2573uni2574uni2575uni2576uni2577uni2578uni2579uni257Auni257Buni257Cuni257Duni257Euni257Funi03F6	acutecombdotbelowcomb	gravecombhookabovecomb	tildecombuni0559c6459c6460c6461c6468c6470c6472c6477c6478c6475c6476uniE0A0uniE0A1uniE0A2uniE0B0uniE0B1uniE0B2uniE0B3AlphaBetaGammaEpsilonZetaEtaThetaIotaKappaLambdaMuNuXiOmicronPiRhoSigmaTauUpsilonPhiChiPsiuni03A9
AlphatonosEpsilontonosEtatonos	IotatonosOmicrontonosUpsilontonos
OmegatonosIotadieresisUpsilondieresisalphabetagammadeltaepsilonzetaetathetaiotakappalambdanuxiomicronrhouni03C2sigmatauupsilonphichipsiomega	iotatonosiotadieresisiotadieresistonosupsilontonosupsilondieresisupsilondieresistonosomicrontonos
omegatonos
alphatonosepsilontonosetatonos	zero.subsone.substwo.subs
three.subs	four.subs	five.subssix.subs
seven.subs
eight.subs	nine.subsuni2155uni2156uni2157uni2158uni2159uni215Auni2150uni2151uni2070uni2074uni2075uni2076uni2077uni2078uni2079uni00B5uni2206tonosdieresistonos_1531CcircumflexccircumflexGcircumflexgcircumflexHcircumflexhcircumflexJcircumflexjcircumflexScircumflexscircumflexuni20B7uni2116uni01A4uni1EF9uni1EF8uni1EBDuni1EBCIJijLdotldotuni0162uni0163kgreenlandicmusicalnotenapostropheUbreveubreveuni0000uni000Duni0020uni00C2uni00C4uni00C0uni0100uni0104uni00C5uni00C3uni00C6uni0042uni0043uni0106uni010Cuni00C7uni010Auni0044uni00D0uni010Euni0110uni0045uni00C9uni011Auni00CAuni00CBuni0116uni00C8uni0112uni0118uni0046uni0047uni011Euni01E6uni0120uni0048uni0126uni0049uni00CDuni00CEuni00CFuni0130uni00CCuni012Auni012Euni0128uni004Auni004Buni004Cuni0139uni013Duni0141uni004Duni004Euni0143uni0147uni014Auni00D1uni004Funi00D3uni00D4uni00D6uni00D2uni01A0uni0150uni014Cuni00D8uni01FEuni00D5uni0152uni0050uni00DEuni0051uni0052uni0154uni0158uni0053uni015Auni0160uni015Euni0054uni0166uni0164uni0055uni00DAuni00DBuni00DCuni00D9uni01AFuni0170uni016Auni0172uni016Euni0168uni0056uni0057uni1E82uni0174uni1E84uni1E80uni0058uni0059uni00DDuni0176uni0178uni1EF2uni005Auni0179uni017Duni017Buni0061uni00E1uni0103uni00E2uni00E4uni00E0uni0101uni0105uni00E5uni00E3uni00E6uni0062uni0063uni0107uni010Duni00E7uni010Buni0064uni00F0uni010Funi0111uni0065uni00E9uni011Buni00EAuni00EBuni0117uni00E8uni0113uni0114uni0115uni0119uni0066uni0067uni011Funi01E7uni0121uni0068uni0127uni0069uni0131uni00EDuni00EEuni00EFuni00ECuni012Buni012Cuni012Duni012Funi0129uni006Auni006Buni006Cuni013Auni013Euni0142uni006Duni006Euni0144uni0148uni014Buni00F1uni006Funi00F3uni00F4uni00F6uni00F2uni01A1uni0151uni014Duni014Euni014Funi00F8uni01FFuni00F5uni0153uni0070uni00FEuni0071uni0072uni0155uni0159uni0073uni015Buni0161uni015Funi00DFuni0074uni0167uni0165uni0075uni00FAuni00FBuni00FCuni00F9uni01B0uni0171uni016Buni0173uni016Funi0169uni0076uni0077uni1E83uni0175uni1E85uni1E81uni0078uni0079uni00FDuni0177uni00FFuni1EF3uni007Auni017Auni017Euni017Funi017Cuni00AAuni00BAuni0030uni0031uni0032uni0033uni0034uni0035uni0036uni0037uni0038uni0039uni00BDuni00BCuni00BEuni215Buni215Cuni215Duni215Euni002Auni005Cuni2022uni003Auni002Cuni2024uni2025uni2026uni0021uni203Cuni00A1uni0023uni002Euni003Funi00BFuni0022uni0027uni003Buni002Funi005Funi2017uni2027uni00A1.caseuni00BF.caseuni007Buni007Duni005Buni005Duni0028uni0029uni2014uni2013uni2012uni002Duni2039uni203Auni201Euni201Cuni201Duni2018uni201Buni2019uni201Auni2032uni2033uni2034uni0102uni00A2uni20A1uni00A4uni0024uni20ABuni20ACuni0192uni20A3uni20A4uni20A7uni00A3uni00A5uni2220uni2248uni2217uni007Euni2297uni2295uni2245uni00F7uni22C5uni2208uni2205uni003Duni2261uni2203uni2207uni003Euni2265uni221Euni222Buni2321uni2320uni2229uni003Cuni2264uni2227uni00ACuni2228uni2212uni00D7uni2209uni2260uni2284uni221Funi2202uni0025uni2030uni002Buni00B1uni220Funi2282uni2283uni221Duni221Auni2286uni2287uni2310uni223Cuni220Buni2211uni2234uni222Auni2200uni2191uni2192uni2193uni2190uni2194uni2195uni21A8uni21B5uni21D1uni21D2uni21D3uni21D0uni21D4uni2584uni2588uni2580uni258Cuni2590uni2591uni2592uni2593uni25CBuni25E6uni25D8uni25D9uni25CAuni25ACuni25A0uni25B2uni25BCuni25BAuni25C4uni007Cuni00A6uni0040uni0026uni00B6uni00A9uni00AEuni00A7uni2122uni00B0uni005Euni2020uni2021uni0301uni0323uni0300uni0309uni0303uni00B4uni02D8uni02C7uni00B8uni02C6uni00A8uni02D9uni0060uni02DDuni00AFuni02DBuni02DAuni02DCuni0041uni0391uni0392uni0393uni0395uni0396uni0397uni0398uni0399uni039Auni039Buni039Cuni039Duni039Euni039Funi03A0uni03A1uni03A3uni03A4uni03A5uni03A6uni03A7uni03A8uni0386uni0388uni0389uni038Auni038Cuni038Euni038Funi03AAuni03ABuni03B1uni03B2uni03B3uni03B4uni03B5uni03B6uni03B7uni03B8uni03B9uni03BAuni03BBuni03BDuni03BEuni03BFuni03C0uni03C1uni03C3uni03C4uni03C5uni03C6uni03C7uni03C8uni03C9uni03AFuni03CAuni0390uni03CDuni03CBuni03B0uni03CCuni03CEuni03ACuni03ADuni03AEuni0030.subsuni0031.subsuni0032.subsuni0033.subsuni0034.subsuni0035.subsuni0036.subsuni0037.subsuni0038.subsuni0039.subsuni00ABuni00BBuni0384uni0385uni00B7uni2044uni00C1uni0108uni0109uni011Cuni011Duni0124uni0125uni0134uni0135uni015Cuni015Duni0132uni0133uni013Funi0140uni0138uni266Auni0149uni016Cuni016D    ��     
 x" DFLT latn $     ��       
   MOL  "ROM  6  ��       	   ��        	   ��        	  aalt Pfrac Xfrac `locl flocl lordn rordn zsinf �sinf �subs �subs �sups �sups �          
     
                                        	      " L � � � � � � � � � ��2�2         � V � � � �   ? U v � ��      � 
    & , 2 8 > D J P �� @� A� B� �� �� �� �� �� ��           U �      X�      J 
�@AB������       �   P f � � �     & . 6< W3� W0: W/� W18 W.7 W-   � W09 W.    = W3� W0; W/  � W0   > W3� W1  ? W3  ,-./02     
    Z  @         H  R           
 $   ,           v�             +4     ? �         � � � �   ? v ��  
ttfautohint version = 1.7

adjust-subglyphs = 0
default-script = latn
dw-cleartype-strong-stem-width = 0
fallback-scaling = 0
fallback-script = latn
fallback-stem-width = 181
gdi-cleartype-strong-stem-width = 1
gray-strong-stem-width = 0
hinting-limit = 200
hinting-range-max = 50
hinting-range-min = 6
hint-composites = 0
ignore-restrictions = 0
increase-x-height = 10
reference = 
reference-index = 0
symbol = 0
TTFA-info = 1
windows-compatibility = 1
x-height-snapping-exceptions = 
control-instructions = \
   0 uni0023 touch -3, 18-28, 31 xshift 0.25 yshift 0 @ 13; \
   0 uni0025 touch -1, 21-23, 39 xshift 0 yshift 0.5 @ 10; \
   0 uni0025 touch 40 xshift 0 yshift 0.75 @ 10; \
   0 uni0025 touch 41-43 xshift 0 yshift 0.5 @ 10; \
   0 uni0025 touch 51-53, 70-72 xshift 0 yshift 0.5 @ 10; \
   0 uni0025 touch 40, 43 xshift 0 yshift -0.75 @ 11; \
   0 uni0025 touch 41-42 xshift 0 yshift 0.75 @ 11; \
   0 uni0025 touch -1, 21-23, 39 xshift 0 yshift -0.25 @ 14; \
   0 uni0025 touch 8-10, 30-32 xshift 0 yshift 0.25 @ 14; \
   0 uni0025 touch 51-53, 70-72 xshift 0 yshift -0.5 @ 14; \
   0 uni0025 touch 40-43 xshift 0 yshift -0.25 @ 14; \
   0 uni002B touch 4-5, 10-11 xshift 0 yshift 0.5 @ 12; \
   0 uni002B touch 4-5 xshift 0 yshift 1 @ 13; \
   0 uni0030 touch 35-36, 45-47, 56 xshift 0 yshift -0.5 @ 8; \
   0 uni0030 touch 35-36, 56 xshift 0 yshift -1 @ 12-14

       GDST
   
             *   WEBPRIFF   WEBPVP8L   /	@ ���������            [remap]

importer="texture"
type="StreamTexture"
path="res://.import/Pixel.png-72ed007d271547e4302ff7b4f772f12a.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Random/Pixel.png"
dest_files=[ "res://.import/Pixel.png-72ed007d271547e4302ff7b4f772f12a.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
            GDST                  *   WEBPRIFF   WEBPVP8L   /� P�.4�����            [remap]

importer="texture"
type="StreamTexture"
path="res://.import/green_pic.png-b67d3bacde5f2ddbe3fd1e3ef7a115ec.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Random/green_pic.png"
dest_files=[ "res://.import/green_pic.png-b67d3bacde5f2ddbe3fd1e3ef7a115ec.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
GDST                  *   WEBPRIFF   WEBPVP8L   /� Ѕ"w�����            [remap]

importer="texture"
type="StreamTexture"
path="res://.import/red_pic.png-f1d915e9cd6cda28ba65ddb614a11952.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Random/red_pic.png"
dest_files=[ "res://.import/red_pic.png-f1d915e9cd6cda28ba65ddb614a11952.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
      GDST                  *   WEBPRIFF   WEBPVP8L   /� ���������            [remap]

importer="texture"
type="StreamTexture"
path="res://.import/white_pic.png-a09d9a27b4b42898047bd6cfc92e5526.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Random/white_pic.png"
dest_files=[ "res://.import/white_pic.png-a09d9a27b4b42898047bd6cfc92e5526.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
GDST�                 �  WEBPRIFFt  WEBPVP8Lh  /��7⪶m�:ww� �	��W��^�q$�Juq�5�pI�������H�U�~ww�����x��!wA���  ���_�|E.Ce�*CD@	$�;��	�N+��E�T"/�iC�&��|���ư����g8��n�|���H��D_���lt��ӏ2b7|�ڹ��٥dl���8�G���䬿^���Ӹ�e����� qm��:9�s�K�Jk����s!% �`,'��_�ڶ�m��ܪ̉�9)3��w��4I�����WD�!���Hru��ҽ��_,�w8e8�׾@IU�)� ȩ+�u�������͍�oԁ������f�ѐ�B��.h�]A�/�ޖ��D2���͓_�e����������������n��}�I��{L}@S|\i�iA��}�e�X�)�v���F8��s��X�i����#��#Q���(VX~t�b������X��Z�b�����$�Y�%X�v�s�*9rj�fB0�nYgO���/a|rDU�B�K�%�=��v�8�+�%S��玢���P^���l�1&�ԹH�H���}zxx|z�J�<��P8gwJ��������ó>9:�$�(H�J�KĶ;'�k�V$=ژ�6t9?GXT]M	��<9�˲q���cM�Cb[�2��_������[��ׁDaa�+c�s�\�z�>m��8y	[�-W)���"��"���`�c�\*W7q.�>�!N����V�\�|)T���xf�_B�E33��L��h��3� ���j����>e��j,y.���pv{m�9���3c'��l��l�Z,}.��kB������)�	����c=��R,}.<o�:��α����\    [remap]

importer="texture"
type="StreamTexture"
path="res://.import/Villagers-Sheet.png-f88969992cad568e327ee4a198c385bc.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://assets/Villagers-Sheet.png"
dest_files=[ "res://.import/Villagers-Sheet.png-f88969992cad568e327ee4a198c385bc.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
     [gd_resource type="DynamicFont" load_steps=2 format=2]

[sub_resource type="DynamicFontData" id=1]
font_path = "res://assets/Font/Hack-Regular.ttf"

[resource]
font_data = SubResource( 1 )
   [gd_resource type="StyleBoxFlat" format=2]

[resource]
         [gd_resource type="Theme" load_steps=2 format=2]

[sub_resource type="StyleBoxFlat" id=1]

[resource]
Button/colors/font_color = Color( 1, 1, 1, 1 )
Button/colors/font_color_disabled = Color( 0.9, 0.9, 0.9, 0.2 )
Button/colors/font_color_focus = Color( 0.94, 0.94, 0.94, 1 )
Button/colors/font_color_hover = Color( 0.760784, 0.760784, 0.760784, 1 )
Button/colors/font_color_pressed = Color( 0.439216, 0.439216, 0.439216, 1 )
Button/constants/hseparation = 2
Button/styles/disabled = null
Button/styles/focus = null
Button/styles/hover = null
Button/styles/normal = SubResource( 1 )
Button/styles/pressed = null
             [gd_scene load_steps=11 format=2]

[ext_resource path="res://assets/Villagers-Sheet.png" type="Texture" id=1]
[ext_resource path="res://assets/villager_0.gd" type="Script" id=2]

[sub_resource type="AtlasTexture" id=1]
atlas = ExtResource( 1 )
region = Rect2( 0, 0, 32, 32 )

[sub_resource type="AtlasTexture" id=2]
atlas = ExtResource( 1 )
region = Rect2( 32, 0, 32, 32 )

[sub_resource type="AtlasTexture" id=3]
atlas = ExtResource( 1 )
region = Rect2( 64, 0, 32, 32 )

[sub_resource type="AtlasTexture" id=4]
atlas = ExtResource( 1 )
region = Rect2( 96, 0, 32, 32 )

[sub_resource type="AtlasTexture" id=7]
atlas = ExtResource( 1 )
region = Rect2( 160, 0, 32, 32 )

[sub_resource type="AtlasTexture" id=8]
atlas = ExtResource( 1 )
region = Rect2( 128, 0, 32, 32 )

[sub_resource type="SpriteFrames" id=5]
animations = [ {
"frames": [ SubResource( 1 ) ],
"loop": true,
"name": "1",
"speed": 5.0
}, {
"frames": [ SubResource( 2 ) ],
"loop": true,
"name": "2",
"speed": 5.0
}, {
"frames": [ SubResource( 3 ) ],
"loop": true,
"name": "3",
"speed": 5.0
}, {
"frames": [ SubResource( 4 ) ],
"loop": true,
"name": "4",
"speed": 5.0
}, {
"frames": [ SubResource( 7 ) ],
"loop": true,
"name": "5",
"speed": 5.0
}, {
"frames": [ SubResource( 8 ) ],
"loop": true,
"name": "6",
"speed": 5.0
}, {
"frames": [  ],
"loop": true,
"name": "default",
"speed": 5.0
} ]

[sub_resource type="RectangleShape2D" id=6]
extents = Vector2( 6.5, 14 )

[node name="Node" type="Node"]

[node name="Villagers" type="KinematicBody2D" parent="."]
position = Vector2( 312, 80 )
script = ExtResource( 2 )

[node name="frames" type="AnimatedSprite" parent="Villagers"]
frames = SubResource( 5 )
animation = "6"

[node name="CollisionShape2D" type="CollisionShape2D" parent="Villagers"]
position = Vector2( 0.5, 2 )
shape = SubResource( 6 )
one_way_collision = true
one_way_collision_margin = 37.1
       extends KinematicBody2D

onready var animation = get_node("frames")

var rand = RandomNumberGenerator.new()
export(int) var speed = 40.0
var motion = Vector2()
var UP = Vector2(0,-1)
var move
var autostart = false

var timer_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	var timer := Timer.new()
	self.add_child(timer)
	timer.wait_time = 2
	timer.one_shot = true
	timer.start()
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.autostart = true
	timer_ref = timer
	rand.randomize()
	move = rand.randf_range(-100, 100)
	
	if(move < 0):
		animation.flip_h = false
	else:
		animation.flip_h = true
	
	var char_selector = rand.randf_range(1,6)
#	print(char_selector)
	animation.animation = str(int(char_selector))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_floor() == true:
		motion.y = 400
	if is_on_floor() == false:
		if motion.y <= 390:
			motion.y += 98
	
#	print(timer_ref.is_stopped())
	
	motion.x = move
#	print(motion.x)
	move_and_slide(motion, UP)
	
func _on_timer_timeout():
	move = rand.randf_range(-100, 100)
	if(move < 0):
		animation.flip_h = false
	else:
		animation.flip_h = true
	timer_ref.start()
           [gd_resource type="Environment" load_steps=2 format=2]

[sub_resource type="ProceduralSky" id=1]

[resource]
background_mode = 2
background_sky = SubResource( 1 )
             GDST@   @            �  WEBPRIFF�  WEBPVP8L�  /?����m��������_"�0@��^�"�v��s�}� �W��<f��Yn#I������wO���M`ҋ���N��m:�
��{-�4b7DԧQ��A �B�P��*B��v��
Q�-����^R�D���!(����T�B�*�*���%E["��M�\͆B�@�U$R�l)���{�B���@%P����g*Ųs�TP��a��dD
�6�9�UR�s����1ʲ�X�!�Ha�ߛ�$��N����i�a΁}c Rm��1��Q�c���fdB�5������J˚>>���s1��}����>����Y��?�TEDױ���s���\�T���4D����]ׯ�(aD��Ѓ!�a'\�G(��$+c$�|'�>����/B��c�v��_oH���9(l�fH������8��vV�m�^�|�m۶m�����q���k2�='���:_>��������á����-wӷU�x�˹�fa���������ӭ�M���SƷ7������|��v��v���m�d���ŝ,��L��Y��ݛ�X�\֣� ���{�#3���
�6������t`�
��t�4O��ǎ%����u[B�����O̲H��o߾��$���f���� �H��\��� �kߡ}�~$�f���N\�[�=�'��Nr:a���si����(9Lΰ���=����q-��W��LL%ɩ	��V����R)�=jM����d`�ԙHT�c���'ʦI��DD�R��C׶�&����|t Sw�|WV&�^��bt5WW,v�Ş�qf���+���Jf�t�s�-BG�t�"&�Ɗ����׵�Ջ�KL�2)gD� ���� NEƋ�R;k?.{L�$�y���{'��`��ٟ��i��{z�5��i������c���Z^�
h�+U�mC��b��J��uE�c�����h��}{�����i�'�9r�����ߨ򅿿��hR�Mt�Rb���C�DI��iZ�6i"�DN�3���J�zڷ#oL����Q �W��D@!'��;�� D*�K�J�%"�0�����pZԉO�A��b%�l�#��$A�W�A�*^i�$�%a��rvU5A�ɺ�'a<��&�DQ��r6ƈZC_B)�N�N(�����(z��y�&H�ض^��1Z4*,RQjԫ׶c����yq��4���?�R�����0�6f2Il9j��ZK�4���է�0؍è�ӈ�Uq�3�=[vQ�d$���±eϘA�����R�^��=%:�G�v��)�ǖ/��RcO���z .�ߺ��S&Q����o,X�`�����|��s�<3Z��lns'���vw���Y��>V����G�nuk:��5�U.�v��|����W���Z���4�@U3U�������|�r�?;�
         [remap]

importer="texture"
type="StreamTexture"
path="res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://icon.png"
dest_files=[ "res://.import/icon.png-487276ed1e3a0c39cad0279d744ee560.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=true
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
              �PNG

   IHDR   @   @   �iq�   sRGB ���  �IDATx��ytTU��?�ի%���@ȞY1JZ �iA�i�[P��e��c;�.`Ow+4�>�(}z�EF�Dm�:�h��IHHB�BR!{%�Zߛ?��	U�T�
���:��]~�������-�	Ì�{q*�h$e-
�)��'�d�b(��.�B�6��J�ĩ=;���Cv�j��E~Z��+��CQ�AA�����;�.�	�^P	���ARkUjQ�b�,#;�8�6��P~,� �0�h%*QzE� �"��T��
�=1p:lX�Pd�Y���(:g����kZx ��A���띊3G�Di� !�6����A҆ @�$JkD�$��/�nYE��< Q���<]V�5O!���>2<��f��8�I��8��f:a�|+�/�l9�DEp�-�t]9)C�o��M~�k��tw�r������w��|r�Ξ�	�S�)^� ��c�eg$�vE17ϟ�(�|���Ѧ*����
����^���uD�̴D����h�����R��O�bv�Y����j^�SN֝
������PP���������Y>����&�P��.3+�$��ݷ�����{n����_5c�99�fbסF&�k�mv���bN�T���F���A�9�
(.�'*"��[��c�{ԛmNު8���3�~V� az
�沵�f�sD��&+[���ke3o>r��������T�]����* ���f�~nX�Ȉ���w+�G���F�,U�� D�Դ0赍�!�B�q�c�(
ܱ��f�yT�:��1�� +����C|��-�T��D�M��\|�K�j��<yJ, ����n��1.FZ�d$I0݀8]��Jn_� ���j~����ցV���������1@M�)`F�BM����^x�>
����`��I�˿��wΛ	����W[�����v��E�����u��~��{R�(����3���������y����C��!��nHe�T�Z�����K�P`ǁF´�nH啝���=>id,�>�GW-糓F������m<P8�{o[D����w�Q��=N}�!+�����-�<{[���������w�u�L�����4�����Uc�s��F�륟��c�g�u�s��N��lu���}ן($D��ת8m�Q�V	l�;��(��ڌ���k�
s\��JDIͦOzp��مh����T���IDI���W�Iǧ�X���g��O��a�\:���>����g���%|����i)	�v��]u.�^�:Gk��i)	>��T@k{'	=�������@a�$zZ�;}�󩀒��T�6�Xq&1aWO�,&L�cřT�4P���g[�
p�2��~;� ��Ҭ�29�xri� ��?��)��_��@s[��^�ܴhnɝ4&'
��NanZ4��^Js[ǘ��2���x?Oܷ�$��3�$r����Q��1@�����~��Y�Qܑ�Hjl(}�v�4vSr�iT�1���f������(���A�ᥕ�$� X,�3'�0s����×ƺk~2~'�[�ё�&F�8{2O�y�n�-`^/FPB�?.�N�AO]]�� �n]β[�SR�kN%;>�k��5������]8������=p����Ցh������`}�
�J�8-��ʺ����� �fl˫[8�?E9q�2&������p��<�r�8x� [^݂��2�X��z�V+7N����V@j�A����hl��/+/'5�3�?;9
�(�Ef'Gyҍ���̣�h4RSS� ����������j�Z��jI��x��dE-y�a�X�/�����:��� +k�� �"˖/���+`��],[��UVV4u��P �˻�AA`��)*ZB\\��9lܸ�]{N��礑]6�Hnnqqq-a��Qxy�7�`=8A�Sm&�Q�����u�0hsPz����yJt�[�>�/ޫ�il�����.��ǳ���9��
_
��<s���wT�S������;F����-{k�����T�Z^���z�!t�۰؝^�^*���؝c
���;��7]h^
��PA��+@��gA*+�K��ˌ�)S�1��(Ե��ǯ�h����õ�M�`��p�cC�T")�z�j�w��V��@��D��N�^M\����m�zY��C�Ҙ�I����N�Ϭ��{�9�)����o���C���h�����ʆ.��׏(�ҫ���@�Tf%yZt���wg�4s�]f�q뗣�ǆi�l�⵲3t��I���O��v;Z�g��l��l��kAJѩU^wj�(��������{���)�9�T���KrE�V!�D���aw���x[�I��tZ�0Y �%E�͹���n�G�P�"5FӨ��M�K�!>R���$�.x����h=gϝ�K&@-F��=}�=�����5���s �CFwa���8��u?_����D#���x:R!5&��_�]���*�O��;�)Ȉ�@�g�����ou�Q�v���J�G�6�P�������7��-���	պ^#�C�S��[]3��1���IY��.Ȉ!6\K�:��?9�Ev��S]�l;��?/� ��5�p�X��f�1�;5�S�ye��Ƅ���,Da�>�� O.�AJL(���pL�C5ij޿hBƾ���ڎ�)s��9$D�p���I��e�,ə�+;?�t��v�p�-��&����	V���x���yuo-G&8->�xt�t������Rv��Y�4ZnT�4P]�HA�4�a�T�ǅ1`u\�,���hZ����S������o翿���{�릨ZRq��Y��fat�[����[z9��4�U�V��Anb$Kg������]������8�M0(WeU�H�\n_��¹�C�F�F�}����8d�N��.��]���u�,%Z�F-���E�'����q�L�\������=H�W'�L{�BP0Z���Y�̞���DE��I�N7���c��S���7�Xm�/`�	�+`����X_��KI��^��F\�aD�����~�+M����ㅤ��	SY��/�.�`���:�9Q�c �38K�j�0Y�D�8����W;ܲ�pTt��6P,� Nǵ��Æ�:(���&�N�/ X��i%�?�_P	�n�F�.^�G�E���鬫>?���"@v�2���A~�aԹ_[P, n��N������_rƢ��    IEND�B`�       ECFG      application/config/name         save_da_village    application/run/main_scene         res://Start.tscn   application/config/icon         res://icon.png     display/window/size/resizable             global/Windows          +   gui/common/drop_mouse_on_gui_input_disabled         )   physics/common/enable_pause_aware_picking         )   rendering/environment/default_environment          res://default_env.tres  