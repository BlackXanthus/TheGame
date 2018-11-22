extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func get_gui_text():
	return $MarginContainer/VBoxContainer/HBoxContainer/Messages.text
	
func set_gui_text(text):
	$MarginContainer/VBoxContainer/HBoxContainer/Messages.text = text

func get_vbox():
	return $MarginContainer/VBoxContainer
	
func get_dialogue_box():
	return $MarginContainer/VBoxContainer/HBoxContainer/Dialogue
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
