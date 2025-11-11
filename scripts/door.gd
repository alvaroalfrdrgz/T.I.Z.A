extends AnimatableBody3D

@onready var door_anim: AnimationPlayer = $AnimationPlayer
@onready var door_closed_collision: CollisionShape3D = $DoorClosedCollision
@onready var door_open_collision_2: CollisionShape3D = $DoorOpenCollision2
@onready var door_open_collision_1: CollisionShape3D = $DoorOpenCollision1

func _ready() -> void:
		door_closed_collision.disabled = false
		door_open_collision_1.disabled = true
		door_open_collision_2.disabled = true

func _on_open_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("professor"):
		door_anim.play("open_door")
		door_closed_collision.disabled = true
		door_open_collision_1.disabled = false
		door_open_collision_2.disabled = false
		
func _on_open_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("professor"):
		door_anim.play_backwards("open_door")
		door_closed_collision.disabled = false
		door_open_collision_1.disabled = true
		door_open_collision_2.disabled = true
