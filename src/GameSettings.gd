class_name GameSettings extends Resource

@export var window_fullscreen : bool
@export var resolution : Vector2 = Vector2(1920, 1080)
@export var volume_main : float = 0.7
@export var volume_music : float = 0.7
@export var volume_sound : float = 0.7
@export var locale : String = "en"
@export var level : int

# Debug stuff
# Skip the title and start a new game with the first level.
@export var debug_skip_title : bool
# Display the full entity names in the editor and logs.
@export var debug_entity_fullname : bool
# Skip all in game cooldowns (pet, feed, etc).
@export var debug_skip_cooldowns : bool
# Draws debug UI like pathfinding, etc.
@export var debug_draw : bool
