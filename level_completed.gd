extends ColorRect

signal retry_level()
signal next_level()

@onready var retry = %Retry
@onready var go_next_level = %NextLevel

func _on_retry_pressed():
	retry_level.emit()

func _on_next_level_pressed():
	next_level.emit()
