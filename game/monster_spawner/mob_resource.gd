extends Resource
class_name Mob

enum ENEMIES {Poo}
enum START {TOP, BOTTOM, LEFT, RIGHT}
enum SECTION {A, B, C}

const EnemyScenesLookup: Dictionary = {ENEMIES.Poo: preload("res://game/monster_spawner/monster.tscn")}

@export var monster : ENEMIES
@export var start_side : START
@export var start_section : SECTION

func spawn_position(screen_rect: Rect2) -> Vector2:
  var topleft = screen_rect.position
  var bottomright = screen_rect.end
  var position : Vector2 = Vector2.ZERO
  
  # set first axis
  match start_side:
    START.TOP:
      position.y = topleft.y
    START.BOTTOM:
      position.y = bottomright.y
    START.LEFT:
      position.x = topleft.x
    START.RIGHT:
      position.x = bottomright.x

  # set second axis
  if start_side in [START.TOP, START.BOTTOM]:
    var section_length = (bottomright.x + topleft.x) / 3
    match start_section:
      SECTION.A:
        position.x = section_length / 2
      SECTION.B:
        position.x = (section_length / 2) + section_length
      SECTION.C:
        position.x = (section_length / 2) + (section_length * 2)
  elif start_side in [START.LEFT, START.RIGHT]:
    var section_length = (bottomright.y + topleft.y) / 3
    match start_section:
      SECTION.A:
        position.y = section_length / 2
      SECTION.B:
        position.y = (section_length / 2) + section_length
      SECTION.C:
        position.y = (section_length / 2) + (section_length * 2)
  return position
