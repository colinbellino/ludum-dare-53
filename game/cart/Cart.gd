class_name Cart extends Node2D

@export var money := 100
@export var movement_speed := Vector2(0, -100)

func _ready():
	for child in get_children():
		if child is CartSlot:
			child.connect("selected", self.on_slot_selected.bind(child))

func on_slot_selected(slot:CartSlot):
	slot.build_structure(preload("res://game/cart/LightMGTurret.tscn"))
