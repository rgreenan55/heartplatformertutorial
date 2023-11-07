extends Node2D

@export var next_level : PackedScene

@onready var level_completed = $CanvasLayer/LevelCompleted

@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer

@onready var level_time_label = %LevelTimeLabel
var start_time_msec = 0.0
var level_time_msec = 0.0


func _ready():
	Events.level_completed.connect(show_level_completed)

	if not next_level is PackedScene:
		level_completed.go_next_level.text = "Victory Screen"
		next_level = load("res://victory_screen.tscn")

	get_tree().paused = true
	start_in.visible = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	start_in.visible = false
	get_tree().paused = false

	start_time_msec = Time.get_ticks_msec()

func _process(delta):
	level_time_msec = Time.get_ticks_msec() - start_time_msec
	level_time_label.text = "%.3f" % (level_time_msec / 1000.0)

func show_level_completed():
	level_completed.show()
	level_completed.retry.grab_focus()
	get_tree().paused = true

func retry_level():
	await LevelTransition.fade_to_black()
	var current_level = load(scene_file_path)
	get_tree().paused = false
	get_tree().change_scene_to_packed(current_level)

func go_next_level():
	if not next_level is PackedScene: return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
