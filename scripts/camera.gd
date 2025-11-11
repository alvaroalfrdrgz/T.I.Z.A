extends Camera3D

@onready var cam_animation: AnimationPlayer = $AnimationPlayer
var is_on_top: bool = false
var is_on_left: bool = false
var can_top: bool = true
var can_side: bool = true

@onready var wall_mesh: MeshInstance3D = $"../Walls/MainWall/WallMesh"
@onready var back_wall_mesh: MeshInstance3D = $"../Walls/BackWall/BackWallMesh"
@onready var window_wall_mesh: MeshInstance3D = $"../Walls/WindowWall/WindowWallMesh"
@onready var door_wall_mesh: MeshInstance3D = $"../Walls/DoorWall/DoorWallMesh"

@onready var column_tl: StaticBody3D = $"../Collumns/ColumnTL"
@onready var column_tr: StaticBody3D = $"../Collumns/ColumnTR"
@onready var column_bl: StaticBody3D = $"../Collumns/ColumnBL"
@onready var column_br: StaticBody3D = $"../Collumns/ColumnBR"

@onready var curtains: StaticBody3D = $"../Walls/WindowWall/Curtains"
@onready var curtains_mesh: MeshInstance3D = $"../Walls/WindowWall/Curtains/CurtainsMesh"
@onready var window_view: Sprite3D = $"../Walls/WindowWall/Curtains/WindowView"

@onready var ceiling: MeshInstance3D = $"../Ceiling/FloorMesh"

func _ready() -> void:
	#await get_tree().create_timer(2).timeout
	cam_animation.play("camera_intro")

func _unhandled_input(event):
	
	if event.is_action_pressed("mouse_middle") or \
	   event.is_action_pressed("ui_focus_next"):
		if not can_top:
			return
			
		is_on_top = not is_on_top
		
		if not is_on_left:
			
			if is_on_top:
				can_side = false
				cam_animation.play("top_camera_from_right")
				await cam_animation.animation_finished
				GM.cam_position = "TOP"
			else:
				cam_animation.play_backwards("top_camera_from_right")
				await cam_animation.animation_finished
				GM.cam_position = "RIGHT"
				can_side = true
				
		else:
			
			if is_on_top:
				can_side = false
				cam_animation.play("top_camera_from_left")
				await cam_animation.animation_finished
				GM.cam_position = "TOP"
			else:
				cam_animation.play_backwards("top_camera_from_left")
				await cam_animation.animation_finished
				GM.cam_position = "LEFT"
				can_side = true
				
	if can_side:
		if event.is_action_pressed("left"):
			if not is_on_left:
				can_top = false
				cam_animation.play("alt_side")
				await cam_animation.animation_finished
				is_on_left = true
				GM.cam_position = "LEFT"
				can_top = true
		if event.is_action_pressed("right"):
			if is_on_left:
				can_top = false
				cam_animation.play_backwards("alt_side")
				await cam_animation.animation_finished
				is_on_left = false
				GM.cam_position = "RIGHT"
				can_top = true

func _process(_delta: float) -> void:
	if GM.cam_position == "LEFT":
		wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		back_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		window_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		door_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		column_bl.visible = false
		column_br.visible = false
		column_tl.visible = false
		column_tr.visible = true
		curtains_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		window_view.visible = false
		ceiling.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	if GM.cam_position == "RIGHT":
		wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		back_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		window_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		door_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
		column_bl.visible = false
		column_br.visible = false
		column_tl.visible = true
		column_tr.visible = false
		curtains_mesh.cast_shadow =GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		window_view.visible = true
		ceiling.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	if GM.cam_position == "TOP":
		wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		back_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		window_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		door_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		column_bl.visible = true
		column_br.visible = true
		column_tl.visible = true
		column_tr.visible = true
		curtains_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		window_view.visible = true
		ceiling.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	if GM.cam_position == "PROFESSOR":
		wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		back_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		window_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		door_wall_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		column_bl.visible = true
		column_br.visible = true
		column_tl.visible = true
		column_tr.visible = true
		curtains_mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		window_view.visible = true
		ceiling.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
