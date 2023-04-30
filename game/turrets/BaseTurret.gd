class_name BaseTurret
extends AnimatableBody2D

@export var cost = 100.0
@export var upgrade_cost_mult = 4.0
@export var upgrade_fire_rate_mult = 1.5
@export var upgrade_health_mult = 1.5
@export var upgrade_damage_mult = 1.5

@export var fire_rate = 1.0
@export var hitpoints = 10.0
@export var turn_speed = 1.0
@export var spin_up_time = 0.0
@export var damage = 5.0

@export var projectile_sprite : Texture
@export var projectile_speed = 200.0

@export var animation_bullet_spawn_offset = 0.0

var current_target = null
var shot_cooldown = 0.0
var target_rotation = 0.0

func aquire_target():
	pass

func _process(delta):
	if fire_rate <= 0.0:
		return
	if not is_instance_valid(current_target):
		current_target = null
	if shot_cooldown > 0.0:
		shot_cooldown -= delta
		
	if not current_target:
		aquire_target()
		
	if current_target:
		target_rotation = 0.0
		
	
