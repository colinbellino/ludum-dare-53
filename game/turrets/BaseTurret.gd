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

	if not is_valid_target(current_target):
		current_target = null

	if shot_cooldown > 0.0:
		shot_cooldown -= delta

	if current_target:
		var aim = current_target.global_position
		var barrel_orientation = Vector2.ZERO.direction_to(%BulletSpawnPosition.position)
		var target_rotation = barrel_orientation.angle_to(aim - %Turret.global_position)
		%Turret.rotation = Utils.move_towards_angle(%Turret.rotation, target_rotation, delta * turn_speed * TAU)
	else:
		aquire_target()

func aquire_target():
	var mobs = get_tree().get_nodes_in_group("Monsters")
	mobs = mobs.filter(is_valid_target)
	mobs.sort_custom(
		func(a,b):
			return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)

	if mobs.size() > 0:
		current_target = mobs[0]
		print("Target aquired: ", current_target.name)

func take_hit(damage: float):
	hitpoints -= damage
	if hitpoints <= 0:
		get_parent().clear()

func is_valid_target(mob):
	return (
		is_instance_valid(mob)
		&& get_viewport().get_visible_rect().has_point(mob.position)
		&& mob.hitpoints > 0
	)
