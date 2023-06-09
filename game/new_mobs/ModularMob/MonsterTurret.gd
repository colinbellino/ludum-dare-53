@tool
class_name MonsterTurret
extends Node2D

@export var fire_rate = 1.0
@export var turn_speed = 1.0
@export var damage = 5.0

@export var pierce = 0
@export var explosion_radius = 0.0
@export var explosion_knockback = 20.0
@export var knockback = 2.5

@export var projectile_sprite : Texture
@export var projectile_is_beam := false
@export var projectile_speed = 200.0
@export var projectile_lifetime = 1.5
@export var projectile_rotate := true
@export var max_range : float:
	get:
		if projectile_is_beam:
			return projectile_speed
		return projectile_speed*projectile_lifetime+18+explosion_radius 

@export var animation_bullet_spawn_offset = 0.0

var current_target = null
var shot_cooldown = 0.0
var target_rotation = 0.0
var current_rotation = 0.0

func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	if not is_valid_target(current_target):
		current_target = null

	if not current_target:
		aquire_target()

	if current_target:
		var aim = current_target.global_position
		var barrel_orientation = Vector2.ZERO.direction_to(%BulletSpawnPosition.position)
		target_rotation = barrel_orientation.angle_to(aim - global_position)
		current_rotation = Utils.move_towards_angle(rotation, target_rotation, delta * turn_speed * TAU)
		rotation = current_rotation

		if shot_cooldown > 0.0:
			shot_cooldown -= delta
		if shot_cooldown <= 0.0 and abs(Utils.angle_difference(target_rotation, current_rotation)) < PI/6:
			$AnimationPlayer.play("Fire")
			if animation_bullet_spawn_offset <= 0.01:
				spawn_bullet()
			else:
				get_tree().create_timer(animation_bullet_spawn_offset, false, true).timeout.connect(self.spawn_bullet)
			shot_cooldown = 1.0 / fire_rate

func spawn_bullet():
	var level = GameData.level
	var bullet = preload("res://game/bullet/Bullet.tscn").instantiate()
	bullet.sprite = projectile_sprite
	bullet.speed = projectile_speed
	bullet.damage = damage
	bullet.pierce = pierce
	bullet.explosion_radius = explosion_radius
	bullet.explosion_knockback = explosion_knockback
	bullet.knockback = knockback
	bullet.direction = Vector2.ZERO.direction_to(%BulletSpawnPosition.position).rotated(current_rotation)
	bullet.expiration_time = projectile_lifetime
	bullet.is_beam = projectile_is_beam
	bullet.rotate_projectile = projectile_rotate
	bullet.monster_bullet = true
	if bullet.is_beam:
		bullet.direction = Vector2.ZERO.direction_to(%BulletSpawnPosition.position)
		add_child(bullet)
	else:
		level.add_child(bullet)
	bullet.global_position = %BulletSpawnPosition.global_position

func aquire_target():
	var targets = get_tree().get_nodes_in_group("ShipParts")
	targets = targets.filter(is_valid_target)
	targets.sort_custom(
		func(a,b):
			return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)

	if targets.size() > 0:
		if targets[0].global_position.distance_to(global_position) < max_range:
			current_target = targets[0]

func is_valid_target(target):
	return (
		is_instance_valid(target)
		&& target.hitpoints > 0
		&& global_position.distance_to(target.global_position) < max_range
	)

