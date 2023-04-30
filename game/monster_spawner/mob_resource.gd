extends Resource
class_name Mob


enum ENEMIES {Poo}
enum START {UP, DOWN, LEFT, RIGHT}
enum SECTION {A, B, C}

const EnemyScenesLookup: Dictionary = {ENEMIES.Poo: preload("res://game/monster_spawner/monster.tscn")}

@export var monster : ENEMIES
@export var start_direction : START
@export var start_section : SECTION

func spawn_position(screen_rect: Rect2) -> Vector2:
  return Vector2()
