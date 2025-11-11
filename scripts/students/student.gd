class_name Student
extends CharacterBody3D

var student_name: String
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var student_coll: CollisionShape3D = $StudentCollision

func _ready() -> void:
	await get_tree().create_timer(randf_range(3, 7)).timeout
	anim.play("Sit")
	student_coll.disabled = true
