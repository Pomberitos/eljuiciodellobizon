extends StaticBody2D

class_name Door

@export var closedDoorTexture: Texture2D = load("res://scenes/rooms/doors/door_closed.png")
@export var openDoorTexture: Texture2D = load("res://scenes/rooms/doors/door_open.png")

var isPlayerNearby = false
var isDoorClosed = true;

func open():
	$DoorSprite.texture = openDoorTexture
	$CollisionShape.disabled = true
	isDoorClosed = false

func close():
	$DoorSprite.texture = closedDoorTexture
	$CollisionShape.disabled = false
	isDoorClosed = true
