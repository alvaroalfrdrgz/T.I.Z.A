class_name GameManager
extends Node

#region variables guardables
var reputation : int = 50
var cintra : int = 3
var money : float = 0
var day : int = 1
#endregion

var game_ended: bool = false
var visible_reputation : bool = false

var cintra_driked: bool = false
var student_name_global: String = ""
var time_start: float = 200
var cam_position: String = "RIGHT"

var in_revision_area: bool = false
var in_near_area: bool = false
var checking: bool = false
var can_check: bool = true

var active_camera: String = ""

var text_active: bool = false
var text: String = ""

#region strikes
var student1_strikes: int = 0
var student2_strikes: int = 0
var student3_strikes: int = 0
var student4_strikes: int = 0
var student5_strikes: int = 0
var student6_strikes: int = 0
var student7_strikes: int = 0
var student8_strikes: int = 0
var student9_strikes: int = 0
#endregion

#region revision areas
var revision_area1: bool = false
var revision_area2: bool = false
var revision_area3: bool = false
var revision_area4: bool = false
var revision_area5: bool = false
var revision_area6: bool = false
var revision_area7: bool = false
var revision_area8: bool = false
var revision_area9: bool = false
#endregion

const save_path = "user://"
var textureRect_actual: String = "";

func _ready() -> void:
	print(day)

func save_game() -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(day)
	save_file.store_var(reputation)
	save_file.store_var(cintra)
	save_file.store_var(money)
	save_file = null

func load_game() -> void:
	if FileAccess.file_exists(save_path):
		var save_file = FileAccess.open(save_path, FileAccess.READ)
		day = save_file.get_var()
		reputation = save_file.get_var()
		cintra = save_file.get_var()
		money = save_file.get_var()
		save_file = null
