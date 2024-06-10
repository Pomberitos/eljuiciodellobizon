class_name Room
extends Node2D

@export_enum("Room 1:1", "Room 2:2", "Room 3:3", "Room 4:4") var number: int

@onready var slasherScene: PackedScene = preload("res://scenes/slasher/slasher.tscn")
var slasher: Slasher
@export var player: Player

var positions: Array

func _ready():
	positions = $SlasherPositions.get_children()ds

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Player Entered Room: " + str(self.name))
		Events.room_entered.emit(self)
		slasherSpawner()

func slasherSpawner():
	var rng = RandomNumberGenerator.new()
	if slasher != null:
		slasher.queue_free()
	await get_tree().create_timer(rng.randi_range(5, 10)).timeout
	print("spawning slasher ")
	slasher = slasherScene.instantiate()
	slasher.player = player
	slasher.position = (positions.pick_random() as Marker2D).position
	add_child(slasher)

