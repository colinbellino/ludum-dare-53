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

func _ready():
	sync_to_physics = false

func _process(delta):
	if fire_rate <= 0.0:
		return

	if not is_instance_valid(current_target):
		current_target = null

	if shot_cooldown > 0.0:
		shot_cooldown -= delta

	if current_target && is_valid_target(current_target):
		var direction : Vector2 = current_target.get_global_transform_with_canvas().origin - get_global_transform_with_canvas().origin
		%Turret.look_at(global_position + direction)
	else:
		aquire_target()

func aquire_target():
	var all_mobs = get_tree().get_nodes_in_group("Monsters")

	var valid_mobs = all_mobs.filter(is_valid_target)

	if valid_mobs.size() > 0:
		var random_index = randi() % valid_mobs.size()
		current_target = valid_mobs[random_index]
		print("Target aquired: ", current_target.name)

func take_hit(hit_damage: float):
	hitpoints -= hit_damage
	print("%s taking hit_damage: %s (hp: %s)" % [self.name, hit_damage, hitpoints])
	if hitpoints <= 0:
		destroyed()

func destroyed():
	get_parent().clear()

func is_valid_target(mob):
	return (
		get_viewport().get_visible_rect().has_point(mob.position) &&
		mob.hitpoints > 0
	)
