extends Node

@export var player: Player
@onready var slasherScene: PackedScene = preload ("res://scenes/slasher/slasher.tscn")
var slasher: Slasher

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room):
	slasherSpawner(room.positions)

func slasherSpawner(positions: Array):
	var rng = RandomNumberGenerator.new()
	if slasher != null:
		slasher.queue_free()
	await get_tree().create_timer(rng.randi_range(5, 10)).timeout
	print("spawning slasher ")
	slasher = slasherScene.instantiate()
	slasher.player = player
	slasher.position = (positions.pick_random() as Marker2D).position
	add_child(slasher)
