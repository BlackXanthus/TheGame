extends Node2D


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var player = get_node("Player")
	#$CanvasLayer/WorldDebug.text = "Hello World"
	player.connect("Debug",self,"update_debug")
	player.connect("Messages",self,"update_gui_messages")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	

func update_debug(Text):
	var input = Text
	var MyText = $CanvasLayer/WorldDebug.text
	$CanvasLayer/WorldDebug.text = str(input)

func update_gui_messages(text):
	var input=text
	var MyText = $UI/Messages.text
	$UI/Messages.text = input + "\n"+ MyText
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
