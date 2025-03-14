class_name Minimap extends MarginContainer

@export var player: Player
@export var slasher: Slasher
@export var zoom = 1.5

@onready var grid = $Grid
@onready var player_marker = $MarginContainer/Grid/PlayerMarker
@onready var slasher_marker = $MarginContainer/Grid/SlasherMarker

@onready var icons = {
	"alert": player_marker,
	"slasher": slasher_marker
}

var grid_scale
var markers = {}

func _ready():
	await get_tree().process_frame
	player_marker.position = grid.size / 2
	grid_scale = grid.size / (get_viewport_rect().size * zoom)
	var map_objects = get_tree().get_nodes_in_group("minimap_object")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child.call_deferred(new_marker)
		new_marker.show()
		markers[item] = new_marker

func _process(_delta):
	if !player:
		return
	player_marker.rotation = player.rotation + PI / 2
	for item in markers:
		var obj_pos = (item.position - player.position) * grid_scale + grid.size / 2
		if grid.get_rect().has_point(obj_pos + grid.position):
			markers[item].scale = Vector2(1, 1)
		else:
			markers[item].scale = Vector2(0.75, 0.75)
		obj_pos = obj_pos.clamp(Vector2.ZERO, grid.size)
		markers[item].position = obj_pos
		
func _on_object_removed(object):
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)

func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.size / (get_viewport_rect().size * zoom)


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= 0.1
