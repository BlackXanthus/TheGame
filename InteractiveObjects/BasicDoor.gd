extends Node2D

#The Interactive Item Base Class
#
#In Theory we can extend from this, and ensure that
#the functions and variables we need in the game
#are available. I have no idea if this is a sensible
#way to play with the Duck-typing of Godot

export (int) var ItemID
export (String) var ItemName
export (String) var Type = "Item"
export (String) var SceneChange = "DeadEnd"
signal SceneChange

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("SceneChange",Program,"goto_scene")
	pass

func get_item_id():
	return ItemID

func get_type():
	return Type

func get_id():
	return ItemID

func active():
	$StaticBody2D/CollisionShape2D.hide()
	$Sprite.animation="Open"
	print("Door Open")
	$StaticBody2D/CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled=true
	emit_signal("SceneChange",SceneChange)
	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass