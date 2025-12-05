class_name Student
extends CharacterBody3D

const GRAVITY: float = 0.15
var student_name: String
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var student_coll: CollisionShape3D = $StudentCollision

func _ready() -> void:
	await get_tree().create_timer(randf_range(3, 7)).timeout
	anim.play("Sit")
	student_coll.disabled = true

#func _physics_process(_delta):
	#if not is_on_floor():
		#position.y -= GRAVITY

func walk_outside():
	anim.play_backwards("Sit")
	 
