extends Node

@export var spawnerDisabled: bool = false
@export var player: Player
@export var minSpawnTime: int = 5
@export var maxSpawnTime: int = 10

@export_node_path("Room") var entrance
@export_node_path("Room") var main_hall
@export_node_path("Room") var hall
@export_node_path("Room") var hall_b
@export_node_path("Room") var hall_c
@onready var excludedRooms: Array[Room] = [
	get_node(entrance),
	get_node(main_hall),
	get_node(hall),
	get_node(hall_b),
	get_node(hall_c),
]

#@export var excludedRooms: Array[Room] = []
@export var anticipation_time: float = 5.0 # Time between music start and slasher spawn

@onready var sceneToSpawn: PackedScene = preload("res://scenes/slasher/slasher.tscn")
@onready var randomGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var timer: Timer = $SpawnTimer
@onready var anticipation_timer: Timer = $AnticipationTimer

var slasher: Slasher
@onready var spawn_pending: bool = false

@onready var slasher_spawn_count: int = 0

@onready var last_room: Room
@export_node_path("Room") var current_room_path
@onready var current_room: Room = get_node(current_room_path)

@onready var first_time_in_library: bool = false

func reset_params() -> void:
	slasher_spawn_count = 0
	spawn_pending = false
	last_room = null
	spawnerDisabled = false
	timer.stop()
	anticipation_timer.stop()

func _ready():
	reset_params()
	Events.room_entered.connect(_on_room_entered)
	Events.puzzle1_hint_displayed.connect(_on_reading_ui)
	Events.puzzle1_hint_removed.connect(_on_closing_ui)
	Dialogic.timeline_started.connect(_on_reading_ui)
	Dialogic.timeline_ended.connect(_on_closing_ui)
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.connect("timeout", _on_spawn_timer_timeout)
	
	# Setup anticipation timers
	anticipation_timer.wait_time = anticipation_time
	anticipation_timer.connect("timeout", _on_anticipation_timer_timeout)

func _on_spawn_timer_timeout():
	# Start anticipation phase instead of spawning immediately
	Events.emit_signal("slasher_approaching") # Signal for audio manager
	anticipation_timer.start()
	spawn_pending = true


func _on_anticipation_timer_timeout():
	if spawn_pending:
		slasherSpawner()
		spawn_pending = false


func _on_room_entered(room: Room) -> void:
	current_room = room
	if Events.last_room != null:
		if Events.last_room.label_name == room.label_name:
			return
		if Events.current_room.name == "Library" and !first_time_in_library:
			first_time_in_library = true
			excludedRooms = excludedRooms.slice(0,1)

	kill_slasher()
	timer.stop()
	anticipation_timer.stop()
	spawn_pending = false
	
	if spawnerDisabled or room in excludedRooms:
		return
	
	resetTimer()
	

func resetTimer():
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.start()

func slasherSpawner():
	var room = current_room
	if slasher != null:
		remove_child.call_deferred(slasher)
	slasher = sceneToSpawn.instantiate()
	slasher.player = player
	spawnSlasher(room)
	slasher_spawn_count += 1
	if slasher_spawn_count == 1:
		pass


func spawnSlasher(room: Room):
	slasher.position = (room.positions.pick_random() as Marker2D).position
	add_child.call_deferred(slasher)
	Events.slasher_spawned.emit(room)


func kill_slasher():
	if slasher != null:
		remove_child.call_deferred(slasher)
		Events.slasher_gone.emit()

func _on_reading_ui():
	if current_room in excludedRooms:
		return
	spawnerDisabled = true
	timer.stop()
	anticipation_timer.stop()


func _on_closing_ui():
	if current_room in excludedRooms:
		return
	spawnerDisabled = false
	resetTimer()
	anticipation_timer.start()
