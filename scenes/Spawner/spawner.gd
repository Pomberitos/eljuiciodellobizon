extends Node

@export var player: Player
@export var minSpawnTime: int = 5
@export var maxSpawnTime: int = 10
@onready var sceneToSpawn: PackedScene = preload("res://scenes/slasher/slasher.tscn")
@onready var randomGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
var slasher: Slasher

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.room_entered.connect(_on_room_entered)
	Events.slasher_gone.connect(_on_slahser_gone)

func _on_room_entered(room: Room):
	slasherSpawner(room)

func slasherSpawner(room: Room):
	remove_child(slasher)
	slasher = sceneToSpawn.instantiate()
	slasher.player = player
	await get_tree().create_timer(randomGenerator.randi_range(minSpawnTime, maxSpawnTime)).timeout
	slasher.position = (room.positions.pick_random() as Marker2D).position
	add_child(slasher)
	Events.slasher_spawned.emit(room)

func _on_slahser_gone():
	remove_child(slasher)
	slasherSpawner(Events.current_room)
