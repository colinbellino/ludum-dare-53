@tool
class_name Bullet extends ShapeCast2D

@export var damage : int = 10
@export var speed : int = 100
@export var explosion_radius : int = 0
@export var explosion_knockback : float = 20.0
@export var pierce : int = 0:
	set(val):
		pierce = val
		max_results = maxi(pierce, 4)
@export var knockback : float = 2.5
@export var sprite : Texture:
	set(val):
		sprite = val
		if is_inside_tree() and val:
			sprite.texture = val
@export var is_beam : bool = false
@export var rotate_projectile : bool = true
# Set these before adding to scene
@export_category("Initialization")
@export var monster_bullet : bool = false:
	set(val):
		monster_bullet = val
		collision_mask = (GameData.PHYSICS_LAYER_BLOCKER | GameData.PHYSICS_LAYER_SHIP_HURTABLE) if monster_bullet else (GameData.PHYSICS_LAYER_BLOCKER | GameData.PHYSICS_LAYER_MONSTER_HURTABLE)
@export var direction : Vector2 = Vector2(1.0, 0.0)
@export var expiration_time : float = 9999.999
@export var bullet_hit_sfx : Array[AudioStream]

var frames_alive : int = 0
var time_alive : float = 0.0
var num_targets_pierced : int = 0
var sprite2d : Sprite2D

func _ready() -> void:
	sprite2d = get_node("%Sprite")
	if rotate_projectile:
		sprite2d.rotation = Vector2.RIGHT.angle_to(direction)
	if is_beam:
		sprite2d.position.x -= speed * 0.5
		sprite2d.scale.x = speed / sprite.get_width()

func _physics_process(delta: float) -> void:
	var velocity = direction * speed * delta
	if is_beam:
		velocity = direction * speed
	time_alive += delta
	if frames_alive > 0 and not Engine.is_editor_hint():
		force_shapecast_update()
		for i in get_collision_count():
			var target_hit:CollisionObject2D = get_collider(i)
			if target_hit.collision_layer & GameData.PHYSICS_LAYER_HURTABLE:
				AudioPlayer.play_sound_random(bullet_hit_sfx, position)
				if explosion_radius <= 1:
					target_hit.take_hit(damage)
				else:
					spawn_explosion(get_collision_point(i))
				if target_hit is RigidBody2D and knockback >= 0.01:
					target_hit.apply_impulse(direction * knockback, get_collision_point(i) - target_hit.global_position)
				add_exception(target_hit)
				num_targets_pierced += 1
				if num_targets_pierced > pierce:
					queue_free()
					return
			# Target is a general obstacle we can't hurt.
			else:
				queue_free()
				return
		if not is_beam:
			position += velocity
	target_position = velocity
	frames_alive += 1
	if time_alive >= expiration_time:
		if explosion_radius >= 1:
			spawn_explosion(global_position)
		queue_free()

func spawn_explosion(pos: Vector2) -> void:
	var explosion = Res.VFX_EXPLOSION_DAMAGING.instantiate()
	explosion.radius = explosion_radius
	explosion.knockback = explosion_knockback
	explosion.damage = damage
	explosion.collision_mask = collision_mask
	add_sibling(explosion)
	explosion.global_position = pos

func on_exit_screen() -> void:
	if not Engine.is_editor_hint():
		queue_free()
