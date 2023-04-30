class_name BaseTurret
extends Node2D

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
@export var max_range = 500.0

@export var animation_bullet_spawn_offset = 0.0
