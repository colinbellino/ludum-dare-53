# Concept of "Screens"

You start the game. A splash screen shows up. Now you are in the Main Menu. You press Start, you end up in Level 1. You press Escape and the inventory screen pops up.

These are all screens. Small chunks of interactive media that are almost completely independent of each other.

Using this as a basic structure for your game means that multiple people can work on their own part of the game without worries of conflicts.

To change from one screen to another, use Overlay.transition("res://path_to_new_screen.tscn").

```swift
# In SplashScreen.gd
func splash_screen_animation_ended():
	Overlay.transition("res://game/main_menu/TitleUI.tscn")
```

To display a screen in front of the current one (and pausing the rest of the game while it is open) use Overlay.show_modal(preload("res://path_to_new_screen.tscn")).

```swift
# In Level1.gd
func inventory_button_pressed():
	Overlay.show_modal(preload("res://game/inventory/Inventory.tscn")
```

# Folder structure

```
assets/ <- Resources that might be used at many places (note: A Scene is not a resource)
	sounds/
	fonts/
	music/
	shaders/
	sprites/
game/ <- Here all the different screens go, for example:
	main_menu/
	level1/
	level2/
	inventory/
	splash_screen/
	common/ <- Nodes that can be reused by multiple screens can be put into a common folder.
	hud/ <- Larger subscenes can be put into their own folder.
	etc.

	Feel free to use whatever organization you want inside these subfolders, Resources, scripts, scenes. Whatever you need to make it work.

scripts/ <- 
	autoload/ <-
		GameData.gd <- Data storage for global game data, like creature definitions, spell definitions, card definitions, whatever you might need
		Overlay.gd/tscn <- Handles transitions between scenes
		PlayerProfile.gd <- Game Data that stores the progress of the player and other data that multiple scenes might need access to
		Settings.gd <- Global settings, used by the menu to store like volume or screen resolution preferences
		... <- Sometimes it is good to implement a feature as an autoload, for example audio cues for buttons can be implemented well this way without adding a bunch of glue code
	classes/ <- Global classes, usable by any script
		Utils.gd <- Static class with static helper functions
		... <- Feel free to add your own
	snippets/ <- Small unspecific snippets of code you might or might not want to attach to a node
```
