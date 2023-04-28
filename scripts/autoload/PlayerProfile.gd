extends Node

# PlayerProfile
# Contains everything gameplay relevant that should persist
# between scenes and game loads/unloads

# For example:
# PlayerProfile.gold += 25

# Mark everything that should be saved to a savegame with @export
#@export var gold:int = 0

func _ready():
	load_all()

func save_all():
	# TODO: Dump all properties with @export into a save file.
	pass
	
func load_all():
	# TODO: Set all properties to the values found in the save file.
	pass
