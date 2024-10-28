extends Node

@export var spawnerDisabled: bool = false
@export var player: Player
@export var minSpawnTime: int = 5
@export var maxSpawnTime: int = 10
@export var excludedRooms: Array[Room] = []

@onready var sceneToSpawn: PackedScene = preload("res://scenes/slasher/slasher.tscn")
@onready var randomGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var timer: Timer

var slasher: Slasher

@export var hint_read_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.room_entered.connect(_on_room_entered)
	Events.slasher_gone.connect(_on_slasher_gone)
	Events.puzzle1_hint_displayed.connect(_on_reading_ui)
	Events.puzzle1_hint_removed.connect(_on_closing_ui)
	timer = $SpawnTimer
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.connect("timeout", _on_spawn_timer_timeout)


func _on_spawn_timer_timeout():
	slasherSpawner()


func _on_room_entered(room: Room):
	Events.slasher_gone.emit()
	timer.stop()
	if spawnerDisabled or room in excludedRooms:
		return
	timer.wait_time = randomGenerator.randi_range(minSpawnTime, maxSpawnTime)
	timer.start()


func slasherSpawner():
	var room = Events.current_room
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
