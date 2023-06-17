extends Node

const PATH_VERSION           := "res://version.txt"
const PATH_CREDITS           := "res://credits.txt"
var SCENE_TITLE              := load("res://game/main_menu/TitleUI.tscn")
var SCENE_PAUSE              := load("res://game/main_menu/PauseUI.tscn")
var SCENE_GAME_OVER          := load("res://game/main_menu/GameOverUI.tscn")
var SCENE_SETTINGS           := load("res://game/main_menu/SettingsUI.tscn")
var SCENE_CREDITS            := load("res://game/main_menu/CreditsUI.tscn")
var SCENE_WORLD_MAP          := load("res://game/world_map/WorldMapScene.tscn")
var SCENE_LEVEL              := load("res://game/level/Level.tscn")

const MUSIC_TITLE            := preload("res://assets/audio/ludum_title.ogg")
const MUSIC_VICTORY          := preload("res://assets/audio/victory.ogg")
const MUSIC_INTERMISSION     := preload("res://assets/audio/Ludum_intermission02.ogg")
const MUSIC_ENCOUNTER        := preload("res://assets/audio/ludum1_3.ogg")
const MUSIC_GAME_OVER        := preload("res://assets/audio/gameover.ogg")

const SFX_WELCOME            := preload("res://assets/audio/voice_welcome_to_space_haulers.wav")
const SFX_DEFEND_CARGO       := preload("res://assets/audio/voice_defend_the_cargo_captain.wav")
const SFX_EXPLOSION_0        := preload("res://assets/audio/player_explode02.wav")
const SFX_EXPLOSION_1        := preload("res://assets/audio/explosion01.wav")
const SFX_TOTAL_DESTRUCTION  := preload("res://assets/audio/voice_total_destruction.wav")
const SFX_PLACE_CARGO        := preload("res://assets/audio/place_crate.wav")
const SFX_PLACE_TURRET       := preload("res://assets/audio/place_turret.wav")
const SFX_PLAYER_HIT         := preload("res://assets/audio/player_hit.wav")
const SFX_COMPONENT_HIT      := preload("res://assets/audio/component_destroyed.wav")
const SFX_HOVER              := preload("res://assets/audio/button_hover.wav")
const SFX_CLICK              := preload("res://assets/audio/button_click.wav")
const SFX_ERROR              := preload("res://assets/audio/error.wav")
const SFX_MONEY              := preload("res://assets/audio/money.wav")
const SFX_REPAIR             := preload("res://assets/audio/repair.wav")

const VFX_SHIP_EXPLOSION     := preload("res://game/vfx/ShipExplosion.tscn")
const VFX_EXPLOSION_DAMAGING := preload("res://game/vfx/DamagingExplosion.tscn")

var TURRET_PLASMA            := load("res://game/turrets/PlasmaTurret.tscn")
var TURRET_DISRUPTOR         := load("res://game/turrets/DisruptorTurret.tscn")
var TURRET_RAILBEAM          := load("res://game/turrets/RailbeamTurret.tscn")
var TURRET_PLATING           := load("res://game/turrets/Plating.tscn")
var TURRET_CARGO             := load("res://game/turrets/Cargo.tscn")
var TURRET_CARGO_DANGEROUS   := load("res://game/turrets/DangerousCargo.tscn")

const BULLET                 := preload("res://game/bullet/Bullet.tscn")
const WORLD_MAP_NODE_BUTTON  := preload("res://game/world_map/WorldMapNodeButton.tscn")

const WAVE_CHECKPOINT_0      := preload("res://game/waves/wave_checkpoint_0.tres")
const WAVE_CHECKPOINT_1      := preload("res://game/waves/wave_checkpoint_1.tres")

const WAVE_TEMPLATE_0        := preload("res://game/waves/wave_template_asteroids_0.tres")
const WAVE_TEMPLATE_1        := preload("res://game/waves/wave_template_chompers_0.tres")
const WAVE_TEMPLATE_2        := preload("res://game/waves/wave_template_grabbers_0.tres")
const WAVE_TEMPLATE_3        := preload("res://game/waves/wave_template_menage_a_trois_0.tres")
const WAVE_TEMPLATE_4        := preload("res://game/waves/wave_template_watchers_0.tres")
