extends CharacterBody3D

const GRAVITY: float = 0.15
#region Variables
var velocidad: float = 1.7
var stamina: float = 100
var lost_stamina: float = 8.0
var gain_stamina: float = 28.5
var min_stamina: float = 0.0
var max_stamina:float = 58.0
var is_walking: bool = false
var is_sitting: bool = false
var can_walk: bool = true
var can_sit: bool = true
var remaining_cintra_time: float = 100.0
var speed: float = 1.0
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var professor_collision: CollisionShape3D = $ProfessorCollision
@onready var professor_sit_collision: CollisionShape3D = $ProfessorSitCollision

var tiempo_animacion: float = 0.0
var esta_caminando: bool = false

var target_rotation_y: float = 0.0
var current_rotation_y: float = 0.0
var is_rotating: bool = false
#endregion

func _ready():
	anim_player.play("Start_Walk")
	anim_player.stop()

func _physics_process(delta):
	if not is_on_floor():
		position.y -= GRAVITY
		can_sit = false
	else:
		can_sit = true
	
	#region stamina and cintra
	stamina = clamp(stamina, min_stamina, max_stamina)
	lost_stamina = 4.6 if stamina > 20 else 2.3
	if is_walking and can_walk and  not GM.checking:
		if !GM.cintra_driked:
			stamina -= lost_stamina * delta
		else:
			stamina += 0.7
	else:
		stamina += gain_stamina * delta
	
	if stamina <= 0 and can_walk:
		can_walk = false
	if not can_walk and stamina >= max_stamina:
		can_walk = true
		
	remaining_cintra_time = clamp(remaining_cintra_time, 0, 100)
	if remaining_cintra_time <= 0:
		GM.cintra_driked = false
	
	if GM.cintra_driked:
		remaining_cintra_time -= 10 * delta
	else:
		remaining_cintra_time += 5
	#endregion
	
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")\
	or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		is_walking = true
		GM.can_check = false
	else:
		is_walking = false
		GM.can_check = true
		
	if is_sitting or GM.checking:
		return

	var direction = Vector3.ZERO
	if GM.cintra_driked:
		speed = 2.0
		anim_player.speed_scale = 2
	elif !GM.cintra_driked and stamina >= 20:
		speed = 1.0
		anim_player.speed_scale = 1.315
	elif !GM.cintra_driked and stamina < 20:
		speed = 0.5
		anim_player.speed_scale = 0.9
	
	if can_walk:
		if Input.is_action_pressed("move_up"):
			direction.z -= speed
		if Input.is_action_pressed("move_down"):
			direction.z += speed
		if Input.is_action_pressed("move_left"):
			direction.x -= speed
		if Input.is_action_pressed("move_right"):
			direction.x += speed
	
	if direction.x != 0 and direction.z != 0:
		direction.z = 0
	
	velocity = direction * velocidad
	
	if Input.is_action_just_released("item"):
		if !GM.cintra_driked and GM.cintra >0:
			GM.cintra -= 1
			GM.cintra_driked = true
			can_walk = true
		else:
			pass
	
	var nueva_caminando = direction.length() > 0.1

	if nueva_caminando != esta_caminando:
		esta_caminando = nueva_caminando
		if direction.length() > 0.1:
			actualizar_animacion()
		else:
			anim_player.play("End_Walk")
	
	if direction.length() > 0.1:
		var angle_target = atan2(direction.x, direction.z)

		if angle_target < 0:
			angle_target += 2 * PI
		
		target_rotation_y = angle_target
		current_rotation_y = lerp_angle(current_rotation_y, target_rotation_y, 0.2)
		rotation.y = current_rotation_y
	else:
		pass
	
	move_and_slide()

func actualizar_animacion():
	if is_walking and not GM.checking and stamina > 20:
		#anim_player.play("Start_Walk")
		#await anim_player.animation_finished
		#if is_walking:
			#anim_player.play("Walk")
		#else:
			#anim_player.play("Start_Walk")
			#anim_player.stop()
		anim_player.play("Walk")
	elif stamina <= 20:
		anim_player.play("Walk_Tire")
	else:
		anim_player.play("End_Walk")
		#anim_player.stop()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("sit"):
		if is_walking:
			return
		if not can_sit:
			return
		is_sitting = not is_sitting
		if is_sitting:
			anim_player.play("Sit")
			is_sitting = true
			await anim_player.animation_finished
			professor_collision.disabled = true
			professor_sit_collision.disabled = false
		else:
			anim_player.play_backwards("Sit")
			professor_collision.disabled = false
			professor_sit_collision.disabled = true
			await anim_player.animation_finished
			is_sitting = false
