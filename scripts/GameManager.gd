class_name GameManager
extends Node

var cintra : int = 2
var cintra_driked: bool = false
var table: int = 0

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	table = 0
