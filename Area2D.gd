extends KinematicBody2D

signal Debug
signal Messages

var speed = 400
var InteractionObject = null
var MessageShown = false
var HintShown = false

#Global variables
#These are to get around the limitations of the
#button 'connect' signal. 
var Message_ID = null
var Message_Type= null
var Message_Popup = null

var active_key_t = false
var active_key_e = false


var LoadItemMessages = load("ItemMessages.gd")

var ItemMessages = LoadItemMessages.new()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#connect("body_enter",self,"_collided_with_something")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	InteractionObject = null

func _physics_process(delta):
	var velocity = Vector2() # The player's movement vector.
	
	if Input.is_key_pressed(KEY_T):
		if active_key_t:
			if not (InteractionObject == null):
				if MessageShown==false:
					if InteractionObject.has_method("get_id"):
						process_messages(InteractionObject.get_type(), InteractionObject.get_id())
						MessageShown=true
			else:
				emit_signal("Debug"," ")
				
	if Input.is_key_pressed(KEY_E):
		if active_key_e:
			if not (InteractionObject == null):
				if MessageShown==false:
					if InteractionObject.has_method("get_id"):
						process_messages(InteractionObject.get_type(), InteractionObject.get_id())
						MessageShown=true
			else:
				emit_signal("Debug"," ")
	
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
    #position += velocity * delta
	move_and_slide(velocity,Vector2(0,-1))
	var collision = move_and_collide(velocity * delta)
	if collision:
		print(collision.collider.name)
		print(collision.collider.get_parent().name)
		emit_signal("Debug",collision.collider.name)
		if collision.collider.is_in_group("ItemBase"):
			print("Item Base")
		if collision.collider.owner.has_method("get_item_id"):
			emit_signal("Debug", collision.collider.owner.ItemID)
			if(HintShown == false):
				var Hint = get_hints(InteractionObject.get_type(), InteractionObject.get_id())
				#emit_signal("Messages", "Press T to Talk with "+collision.collider.owner.ItemName)
				emit_signal("Messages", Hint)
				HintShown = true
	#position.x = clamp(position.x, 0, screensize.x)
    #position.y = clamp(position.y, 0, screensize.y)

func _collided_with_something(otherbody):
	print("Collided with ", otherbody)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Area2D_area_entered(area):
	print("Owner:"+area.owner())

func process_messages(Type, ID):
	
	var MyMessage=ItemMessages.get_message(Type,ID)
	var PopupWindow = WindowDialog.new()
	var FirstNode = MyMessage["Data"]["FirstNode"]
	
	Message_ID = ID
	Message_Type = Type
	
	emit_signal("Messages",MyMessage[FirstNode]["Message"])
	
	if MyMessage[FirstNode].has('HasChoice'):
		if MyMessage[FirstNode]["HasChoice"] == "Yes":
	
			emit_signal("Messages", MyMessage[FirstNode]["Choice"]["Message"])
		
		#The below needs to be done progmatically. 
		#We also need to get the result and do something with it.
		
		#This now needs to be done dynamically!
		
			var question = Label.new()
			question.text=MyMessage[FirstNode]["Choice"]["Message"]
			var button1 = Button.new()
			button1.text="Yes"
			button1.connect("pressed",self,"display_message",[button1])
			var button2 = Button.new()
			button2.connect("pressed",self,"display_message",[button2])
			button2.text="No"
			#b.connect("pressed", self, "bt_pressed")
		#PopupWindow.popup_exclusive(true)
		
		#Popup Window must be a child of something!
			self.add_child(PopupWindow)
			var MyHboxContainer = HBoxContainer.new()

			MyHboxContainer.add_child(question)
			MyHboxContainer.add_child(button1)
			MyHboxContainer.add_child(button2)
			PopupWindow.add_child(MyHboxContainer)
			PopupWindow.window_title="A Test Popup Window"
			#PopupWindow.popup()
			Message_Popup = PopupWindow
			PopupWindow.show()
		
	#Message_ID = null
	#Message_Type = null
	#emit_signal("Messages",MyMessage)
	
func display_message(NodeID):
	
	print("Testing")
	#emit_signal("Messages", "You answered:"+NodeID.text)
	Message_Popup.queue_free()
	
	var FirstNode=""
	
	if typeof(NodeID) == TYPE_STRING:
		FirstNode = NodeID
	else:
		FirstNode=NodeID.text
	
	
	var MyMessage=ItemMessages.get_message(Message_Type,Message_ID)
	
	emit_signal("Messages",MyMessage[FirstNode]["Message"])
	
	if MyMessage[FirstNode].has('HasChoice'):
		pass
		
	if MyMessage[FirstNode].has('FirstNode'):
		MyMessage["Data"]["FirstNode"] = MyMessage[FirstNode]["FirstNode"]
		
	if MyMessage[FirstNode].has('Keys'):
		MyMessage["Data"]["Keys"] = MyMessage[FirstNode]["Keys"]
	
	if MyMessage[FirstNode].has('Hints'):
		MyMessage["Data"]["Hints"] = MyMessage[FirstNode]["Hints"]
	
	if MyMessage[FirstNode].has("GoTo"):
		if MyMessage[FirstNode]["GoTo"] == "TheEnd":
			pass
		else:
			display_message(MyMessage[FirstNode]["GoTo"])
	
	

func _on_Area2D_body_entered(body):
	print("Physics Body Entered")
	print("Physics Owner"+body.owner.name)
	InteractionObject=body.owner

func get_hints(Type,ID):
	var MyMessage=ItemMessages.get_message(Type,ID)
	
	var Messages = MyMessage["Data"]["Hints"]
	
	var Keys = MyMessage["Data"]["Keys"]
	
	#This can likely be improved. 
	if Keys == "T":
		active_key_t=true
	
	if Keys == "E":
		active_key_e=true
		
	
	return Messages
	

func _on_Area2D_body_exited(body):
	InteractionObject=null
	MessageShown=false
	HintShown=false
	active_key_e =false
	active_key_t = false
	Message_ID = null
	Message_Type = null
