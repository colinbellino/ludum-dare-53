@tool
class_name BaseTurret
extends AnimatableBody2D

@export var cost = 100.0
@export var upgrade_cost_mult = 4.0
@export var upgrade_fire_rate_mult = 1.5
@export var upgrade_health_mult = 1.5
@export var upgrade_damage_mult = 1.5

@export var fire_rate = 1.0
@export var hitpoints = 10.0
var max_hitpoints : float = 10.0
@export var turn_speed = 1.0
@export var aim_lookahead = 1.0
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
@export var fire_sfx : Array[AudioStream]
@export var bullet_hit_sfx : Array[AudioStream]

@export var max_range : float:
	get:
		if projectile_is_beam:
			return projectile_speed
		return projectile_speed*projectile_lifetime+18+explosion_radius

@export var animation_bullet_spawn_offset = 0.0

@export var debris_sprite : Texture

var current_target = null
var shot_cooldown = 0.0
var target_rotation = 0.0
var current_rotation = 0.0

signal damaged(damage)

func _init():
	max_hitpoints = hitpoints

func _ready():
	max_hitpoints = hitpoints
	sync_to_physics = false
	add_to_group("ShipParts")

func _physics_process(delta):
	if Engine.is_editor_hint():
		return

	if fire_rate <= 0.0:
		return

	if not is_valid_target(current_target):
		current_target = null

	if not current_target:
		aquire_target()

	if current_target:
		var distance = global_position.distance_to(current_target.global_position)
		var aim = current_target.global_position
		if not projectile_is_beam:
			aim += current_target.linear_velocity * (distance / projectile_speed)
		var barrel_orientation = Vector2.ZERO.direction_to(%BulletSpawnPosition.position)
		target_rotation = barrel_orientation.angle_to(aim - %Turret.global_position)
		current_rotation = Utils.move_towards_angle(%Turret.rotation, target_rotation, delta * turn_speed * TAU)
		%Turret.rotation = current_rotation

		if shot_cooldown > 0.0:
			shot_cooldown -= delta
		if shot_cooldown <= 0.0 and abs(Utils.angle_difference(target_rotation, current_rotation)) < PI/6:
			$AnimationPlayer.play("Fire")
			AudioPlayer.play_sound_random(fire_sfx, position)
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
	bullet.bullet_hit_sfx = bullet_hit_sfx
	if bullet.is_beam:
		bullet.direction = Vector2.ZERO.direction_to(%BulletSpawnPosition.position)
		%Turret.add_child(bullet)
	else:
		level.add_child(bullet)
	bullet.global_position = %BulletSpawnPosition.global_position

func aquire_target():
	var mobs = get_tree().get_nodes_in_group("Monsters")
	mobs = mobs.filter(is_valid_target)
	mobs.sort_custom(
		func(a,b):
			return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)

	if mobs.size() > 0:
		if mobs[0].global_position.distance_to(global_position) < max_range:
			current_target = mobs[0]

func take_hit(hit_damage: float):
	hitpoints -= hit_damage
	emit_signal("damaged", hit_damage)
	print("%s taking hit_damage: %s (hp: %s)" % [self.name, hit_damage, hitpoints])
	if hitpoints <= 0:
		AudioPlayer.play_sound_random([preload("res://assets/audio/player_hit.wav")], position)
		destroyed()
	else:
		AudioPlayer.play_sound_random([preload("res://assets/audio/component_destroyed.wav")], position)

func destroyed():
	get_parent().destroy()

func is_valid_target(mob):
	return (
		is_instance_valid(mob)
		&& mob.hitpoints > 0
		&& global_position.distance_to(mob.global_position) < max_range
	)

func calculate_cost(mode: String):
	if mode == "build":
		return cost
	if mode == "sell":
		if GameData.level.is_at_checkpoint():
			return int(cost * (hitpoints / max_hitpoints))
		else:
			return int(cost * (hitpoints / max_hitpoints) * 0.5)
	if mode == "repair":
		return int(cost * ((max_hitpoints - hitpoints) / max_hitpoints))
	if mode == "upgrade":
		return 1000
	return 9999
