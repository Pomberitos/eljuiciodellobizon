extends Node

@export var spawnerDisabled: bool = false
@export var player: Player
@export var minSpawnTime: int = 5
@export var maxSpawnTime: int = 10
@export var excludedRooms: Array[Room] = []
@export var anticipation_time: float = 5.0 # Time between music start and slasher spawn

@onready var sceneToSpawn: PackedScene = preload("res://scenes/slasher/slasher.tscn")
@onready var randomGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var timer: Timer = $SpawnTimer
@onready var anticipation_timer: Timer = $AnticipationTimer

var slasher: Slasher
var spawn_pending: bool = false

@export var hint_read_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.room_entered.connect(_on_room_entered)
	Events.slasher_gone.connect(_on_slasher_gone)
	Events.puzzle1_hint_displayed.connect(_on_reading_ui)
	Events.puzzle1_hint_removed.connect(_on_closing_ui)
	
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.connect("timeout", _on_spawn_timer_timeout)
	
	# Setup anticipation timers
	anticipation_timer = Timer.new()
	anticipation_timer.one_shot = true
	anticipation_timer.wait_time = anticipation_time
	anticipation_timer.connect("timeout", _on_anticipation_timer_timeout)
	add_child(anticipation_timer)


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
	Events.slasher_gone.emit()
	timer.stop()
	anticipation_timer.stop()
	spawn_pending = false
	
	if spawnerDisabled or room in excludedRooms:
		return
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.start()


func slasherSpawner():
	var room = Events.current_room
	if slasher:
		remove_child(slasher)
	slasher = sceneToSpawn.instantiate()
	slasher.player = player
	spawnSlasher(room)


func spawnSlasher(room: Room):
	slasher.position = (room.positions.pick_random() as Marker2D).position
	add_child(slasher)
	Events.slasher_spawned.emit(room)


func _on_slasher_gone():
	if slasher:
		remove_child(slasher)
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.start()


func _on_reading_ui():
	spawnerDisabled = true
	timer.stop()


func _on_closing_ui():
	#	hint_read_count += 1
	#	if hint_read_count == 1:
	#		_on_room_entered(Events.current_room)
	spawnerDisabled = false
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.start()
