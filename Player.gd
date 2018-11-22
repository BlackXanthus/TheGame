extends KinematicBody2D

signal Debug
signal Messages

var speed = 300
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
		#print(collision.collider.name)
		#print(collision.collider.get_parent().name)
		emit_signal("Debug",collision.collider.name)
		if collision.collider.is_in_group("ItemBase"):
			print("Item Base")
		if collision.collider.owner.has_method("get_item_id"):
			emit_signal("Debug", "Has Method get_item_id"+str(collision.collider.owner.ItemID))
			#print( "Has Method get_item_id "+str(collision.collider.owner.ItemID))
			if(HintShown == false):
				if InteractionObject == null:
					pass
				else:
					#var Hint = get_hints(InteractionObject.get_type(), InteractionObject.get_id())
					var Hint = get_hints(collision.collider.owner.get_type(),collision.collider.owner.get_id())
					#emit_signal("Messages", "Press T to Talk with "+collision.collider.owner.ItemName)
					if Hint == "":
						pass
					else:
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
	#print("Owner:"+area.owner())
	pass

func process_messages(Type, ID):

	var MyMessage=ItemMessages.get_message(Type,ID)
	
	var FirstNode = MyMessage["Data"]["FirstNode"]
	
	Message_ID = ID
	Message_Type = Type
	
	display_message(FirstNode)
	
	

#MyMessage: The part of the dictionary in question.
#FirstNode: The Node of the part of the dictionary with a choice.
func process_choice(MyMessage, FirstNode):
	
	#var PopupWindow = WindowDialog.new()
	#self.get_parent().add_child(PopupWindow)
	var parent = self.get_parent()
	var ui = parent.get_node("UI")
	var PopupWindow= ui.get_dialogue_box()

	emit_signal("Messages",MyMessage[FirstNode]["Message"])

	if MyMessage[FirstNode].has('HasChoice'):
		if MyMessage[FirstNode]["HasChoice"] == "Yes":

			emit_signal("Messages", MyMessage[FirstNode]["Choice"]["Message"])

			#this whole popup thing needs to be encapsulated somewhere. 
			var question = Label.new()
			question.text=MyMessage[FirstNode]["Choice"]["Message"]
			#self.get_parent().add_child(PopupWindow)
			#var parent=self.get_parent()
			
			#var ui = parent.get_node("UI")
			
			ui.get_vbox().add_child(PopupWindow)
			var MyHboxContainer = HBoxContainer.new()
			MyHboxContainer.add_child(question)
			
			for myKey in MyMessage[FirstNode]["Choice"]["Choices"]:
				print("Key:"+myKey)
				if typeof(MyMessage[FirstNode]["Choice"]["Choices"][myKey]) == TYPE_STRING:
					pass
				else:
					var button = Button.new()
					print(MyMessage[FirstNode]["Choice"]["Choices"][myKey]["ButtonText"])
					button.text=MyMessage[FirstNode]["Choice"]["Choices"][myKey]["ButtonText"]
					button.connect("pressed",self,"display_message",[button])
					MyHboxContainer.add_child(button)
					
			#b.connect("pressed", self, "bt_pressed")
		#PopupWindow.popup_exclusive(true)

		#Popup Window must be a child of something!
			PopupWindow.add_child(MyHboxContainer)
			#PopupWindow.window_title=question.text
			#PopupWindow.popup()
			Message_Popup = PopupWindow
			
			Message_Popup.margin_left = 50.00
			Message_Popup.margin_top = 100.00
			#Message_Popup.anchor_bottom = ui.ANCHOR_BOTTOM
			Message_Popup.anchor_top=50.00
			
			#Message_Popup.rect_size=OS.get_real_window_size()
			#PopupWindow.popup_centered(Vector2(0.5,0.5))
			#PopupWindow.set_anchor(MARGIN_BOTTOM,0.5)
			#PopupWindow.set_anchor(MARGIN_RIGHT,0.5)
			PopupWindow.show()
			
			#PopupWindow.popup_exclusive=true
			#PopupWindow.popup_centered(Vector2(0,0))

	#Message_ID = null
	#Message_Type = null
	#emit_signal("Messages",MyMessage)

func display_message(NodeID):

	print("Debug: Display_message")
	#emit_signal("Messages", "You answered:"+NodeID.text)
	if not Message_Popup==null:
		var ref= weakref(Message_Popup)
		if (ref.get_ref()):
			print("<DEBUG>:" +str(Message_Popup))
			if not Message_Popup.is_queued_for_deletion():
				Message_Popup.queue_free()
				Message_Popup==null

	var FirstNode=""

	if typeof(NodeID) == TYPE_STRING:
		FirstNode = NodeID
	else:
		FirstNode=NodeID.text


	var MyMessage=ItemMessages.get_message(Message_Type,Message_ID)

	if MyMessage[FirstNode]["Message"]=="":
		pass
	else:
		emit_signal("Messages",MyMessage[FirstNode]["Message"])

	if MyMessage[FirstNode].has('HasChoice'):
		if MyMessage[FirstNode]["HasChoice"] == "Yes":

			emit_signal("Messages", MyMessage[FirstNode]["Choice"]["Message"])

			process_choice(MyMessage, FirstNode)
	
	

	if MyMessage[FirstNode].has('FirstNode'):
		MyMessage["Data"]["FirstNode"] = MyMessage[FirstNode]["FirstNode"]

	if MyMessage[FirstNode].has('Keys'):
		MyMessage["Data"]["Keys"] = MyMessage[FirstNode]["Keys"]

	if MyMessage[FirstNode].has('Hints'):
		MyMessage["Data"]["Hints"] = MyMessage[FirstNode]["Hints"]

	if MyMessage[FirstNode].has('Active'):
		print("In Active...")
		if InteractionObject == null:
			print("Debug:No Object")
			pass
		else:
			if InteractionObject.has_method('active'):
				InteractionObject.active()
		
	if MyMessage[FirstNode].has("GoTo"):
		if MyMessage[FirstNode]["GoTo"] == "TheEnd":
			pass
		else:
			display_message(MyMessage[FirstNode]["GoTo"])



func _on_Area2D_body_entered(body):
	print("Debug: Physics Body Entered")
	print("Debug: Physics Owner"+body.owner.name)
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
	if not InteractionObject == null:
		if InteractionObject.has_method("get_name"):
			var myObjectName = InteractionObject.get_name()
			var myMessage = "You have moved too far from "+myObjectName+" to interact with it"
			emit_signal("Messages", myMessage)
	if(!Message_Popup==null):
		var ref= weakref(Message_Popup)
		if (!ref.get_ref()):
			pass
		else:
			print("DEBUG: Freeing Message Popup")
			Message_Popup=null
	InteractionObject=null
	MessageShown=false
	HintShown=false
	active_key_e =false
	active_key_t = false
	Message_ID = null
	Message_Type = null
	
func _removed_choice_code():
	
	var MyMessage=""
	var FirstNode=""
	
	if false:
		#The below needs to be done progmatically.
		#We also need to get the result and do something with it.

		#This now needs to be done dynamically!
			var PopupWindow = Popup.new()

			var question = Label.new()
			question.text=MyMessage[FirstNode]["Choice"]["Message"]
			self.add_child(PopupWindow)
			var MyHboxContainer = HBoxContainer.new()
			MyHboxContainer.add_child(question)
			
			for myKey in MyMessage[FirstNode]["Choice"]:
				if MyMessage[FirstNode]["Choice"][myKey] == "Message":
					pass
				else:
					
					var button =  Button.new()
					button.text=MyMessage[FirstNode]["Choice"][myKey]
					button.connect("pressed",self,"display_message",[button])
					MyHboxContainer.add_child(button)
					
			#b.connect("pressed", self, "bt_pressed")
		#PopupWindow.popup_exclusive(true)

		#Popup Window must be a child of something!
			
			PopupWindow.add_child(MyHboxContainer)
			PopupWindow.window_title=question.text
			#PopupWindow.popup()
			Message_Popup = PopupWindow
			PopupWindow.show()
