extends Node

var PATH_VERSION           := "res://version.txt"
var PATH_CREDITS           := "res://credits.txt"
var SCENE_BOOTSTRAP        := load("res://game/Bootstrap.tscn")
var SCENE_LEVEL            := load("res://game/level/Level.tscn")
var SCENE_TITLE            := load("res://game/main_menu/TitleUI.tscn")
var SCENE_PAUSE            := load("res://game/main_menu/PauseUI.tscn")
var SCENE_GAME_OVER        := load("res://game/main_menu/GameOverUI.tscn")
var SCENE_SETTINGS         := load("res://game/main_menu/SettingsUI.tscn")
var SCENE_CREDITS          := load("res://game/main_menu/CreditsUI.tscn")
var SCENE_WORLD_MAP        := load("res://game/world_map/WorldMapUI.tscn")

var MUSIC_TITLE            := preload("res://assets/audio/ludum_title.ogg")
var MUSIC_VICTORY          := preload("res://assets/audio/victory.ogg")
var MUSIC_INTERMISSION     := preload("res://assets/audio/Ludum_intermission02.ogg")
var MUSIC_ENCOUNTER        := preload("res://assets/audio/ludum1_3.ogg")
var MUSIC_GAME_OVER        := preload("res://assets/audio/gameover.ogg")

var SFX_WELCOME            := preload("res://assets/audio/voice_welcome_to_space_haulers.wav")
var SFX_DEFEND_CARGO       := preload("res://assets/audio/voice_defend_the_cargo_captain.wav")
var SFX_EXPLOSION_0        := preload("res://assets/audio/player_explode02.wav")
var SFX_EXPLOSION_1        := preload("res://assets/audio/explosion01.wav")
var SFX_TOTAL_DESTRUCTION  := preload("res://assets/audio/voice_total_destruction.wav")
var SFX_PLACE_CARGO        := preload("res://assets/audio/place_crate.wav")
var SFX_PLACE_TURRET       := preload("res://assets/audio/place_turret.wav")
var SFX_PLAYER_HIT         := preload("res://assets/audio/player_hit.wav")
var SFX_COMPONENT_HIT      := preload("res://assets/audio/component_destroyed.wav")
var SFX_HOVER              := preload("res://assets/audio/button_hover.wav")
var SFX_CLICK              := preload("res://assets/audio/button_click.wav")
var SFX_ERROR              := preload("res://assets/audio/error.wav")
var SFX_MONEY              := preload("res://assets/audio/money.wav")
var SFX_REPAIR             := preload("res://assets/audio/repair.wav")

var VFX_SHIP_EXPLOSION     := preload("res://game/vfx/ShipExplosion.tscn")
var VFX_EXPLOSION_DAMAGING := preload("res://game/vfx/DamagingExplosion.tscn")

var TURRET_PLASMA          := load("res://game/turrets/PlasmaTurret.tscn")
var TURRET_DISRUPTOR       := load("res://game/turrets/DisruptorTurret.tscn")
var TURRET_RAILBEAM        := load("res://game/turrets/RailbeamTurret.tscn")
var TURRET_PLATING         := load("res://game/turrets/Plating.tscn")
var TURRET_CARGO           := load("res://game/turrets/Cargo.tscn")
var TURRET_CARGO_DANGEROUS := load("res://game/turrets/DangerousCargo.tscn")

var BULLET                 := preload("res://game/bullet/Bullet.tscn")
