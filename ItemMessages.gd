extends Object

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ItemMessage = {}
var Item = {}

func _init():
	#This will eventually stored as JSON file. 
	#Inlikngs might be able to speed up writing a lot of 
	#this by hand
	ItemMessage= {
		1: {
			"Data": { #This is a special node. Should not be referenced
					FirstNode="Greeting",
					Interaction=0,
					Choice="None",
					Hints="Press T to talk to the plant",
					Keys="T",
				}, #Data Closing
			"Yes":{
				Message="You Talk to the Plant",
				FirstNode="Interaction",
				Hints="Press E to exaimine the plant",
				Keys="E",
				GoTo="Interaction",
				},
			"No":{
				Message="The Plant looks forlorn",
				GoTo= "TheEnd",
				},
			"Lick":{
				Message="You lick the plant. It seems unimpressed",
				GoTo="TheEnd",
				},
				
			"Greeting": { 
					Message = "Just a Happy Plant",
					HasChoice = "Yes",
					"Choice":{
							Message="Talk to the Plant?",
							"Choices":{ 
								"Yes": {
										Message="Yes",
										ButtonText="Yes",
									}, #Yes Closing
								"No":{
										Message="No",
										ButtonText="No",
									}, #No Closing
								"Lick":{
										Message="Lick The Plant",
										ButtonText="Lick",
									}
							},#Choices Closing
						},#Choice Closing
					GoTo= "TheEnd",
					}, #Greeting Closing
			"Interaction": {
					Message ="It feels happier now",
					HasChoice="No",
					GoTo = "TheEnd",
					} #Interaction Closing
			}, #1 Closing
		2:{
			"Data": { #This is a special node. Should not be referenced
					FirstNode="Description",
					Interaction=0,
					Choice="None",
					Hints="Press E to examine",
					Keys="E",
				}, #Data Closing
			"Description": {
					Message = "A Simple Wooden Door",
					HasChoice = "Yes",
					"Choice":{
							Message="Open The Door?",
							"Choices":{ 
								"Yes": {
										Message="Yes",
										ButtonText="Yes",
									}, #Yes Closing
								"No":{
										Message="No",
										ButtonText="No",
									}, #No Closing
								"Lick":{
										Message="Lick The Door",
										ButtonText="Lick",
									}
							},#Choices Closing
						},#Choice Closing
					GoTo= "TheEnd",
					}, #Greeting Closing
			"Yes":{
				Message="You Push Open The Door",
				FirstNode="Open",
				Hints="",
				Keys="",
				Active="Yes",
				GoTo="DoorOpen",
				},
			"No":{
				Message="The door looks at you woodenly",
				GoTo= "TheEnd",
				},
			"Lick":{
				Message="You lick the door. It tastes of varnish",
				GoTo="TheEnd",
				},
			"DoorOpen": {
					
					Message ="The Door Swings Open, there is a slight draft.",
					HasChoice="No",
					GoTo = "TheEnd",
					} #Interaction Closing
					
			},
		}#Item Closing

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func get_message(Type, ItemID):
	var MessageType="Greeting"
	#return ItemMessage[ItemID][MessageType]["Message"]
	return ItemMessage[ItemID]
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

