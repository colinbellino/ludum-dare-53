extends Node2D

@export var mob_scene: PackedScene # Scene for spawned mob
@export var active = false # Enables or Disables mob spawning
@onready var wave_timer = $WaveTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state()
	wave_timer.start()
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mob_timer_timeout():
	if active:
		$MobTimer.wait_time = randi_range(1,2) # Defines a time until next spawn
		var mob_spawn_location = $MobPath/MobSpawnLocation # A point in the MobPath Curve around the screen
		if randi() % 2 == 1: mob_spawn_location.progress = randi_range(0,540) # Determines which side of the screen to spawn
		else: mob_spawn_location.progress = randi_range(1500,2040)
		var mob = mob_scene.instantiate() # Instances a new mob
		add_child(mob) # Adds it to the scene
		
		mob.position = mob_spawn_location.position # Changes it's position to the spawn location
		var direction = mob_spawn_location.rotation - PI/2 # Determines if the direction is right or left
		if mob.position.x > 480: # Checks if mob spawned on the right side
			mob.set_scale(Vector2(-1,1)) # Flips the mob to face the left side
		var velocity = Vector2(mob.speed, 0) # Determines starting horizontal speed
		mob.linear_velocity = velocity.rotated(direction) # Applies speed according to side

func change_state(): # Stops or Starts the spawning of enemies
	active = not active;

func _on_wave_timer_timeout(): # Wave countdown timer
	change_state()
