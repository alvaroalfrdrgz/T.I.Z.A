class_name professor
extends CharacterBody3D

var velocidad: float = 2.0
var stamina: float = 100
var lost_stamina: float = 8.0
var gain_stamina: float = 50.0
var min_stamina: float = 0.0
var max_stamina:float = 100.0
var is_walking: bool = false
var can_walk: bool = true
var remaining_cintra_time: float = 100.0
var speed: float = 1.0

func _physics_process(delta):
	var direccion = Vector3.ZERO
	
	if GM.cintra_driked:
		speed = 2.0
	elif !GM.cintra_driked and stamina >= 20:
		speed = 1.0
	elif !GM.cintra_driked and stamina < 20:
		speed = 0.5
	
	if can_walk:
		if Input.is_action_pressed("move_up"):
			direccion.z -= speed
		if Input.is_action_pressed("move_down"):
			direccion.z += speed
		if Input.is_action_pressed("move_left"):
			direccion.x -= speed
		if Input.is_action_pressed("move_right"):
			direccion.x += speed
	
	if direccion.x != 0 and direccion.z != 0:
		direccion.z = 0
	
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad
	
	if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or \
	Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		is_walking = true
	else:
		is_walking = false
	
	stamina = clamp(stamina, min_stamina, max_stamina)
	lost_stamina = 8.0 if stamina > 20 else 4.0
	if is_walking and can_walk:
		if !GM.cintra_driked:
			stamina -= lost_stamina * delta
		else:
			stamina += 0.7
	else:
		stamina += gain_stamina * delta
	
	if stamina <= 0 and can_walk:
		can_walk = false
	if !can_walk and stamina >=max_stamina:
		can_walk = true
	
	if Input.is_action_just_released("item"):
		if !GM.cintra_driked and GM.cintra >0:
			GM.cintra -= 1
			GM.cintra_driked = true
			can_walk = true
		else:
			pass
	
	remaining_cintra_time = clamp(remaining_cintra_time, 0, 100)
	if remaining_cintra_time <= 0:
		GM.cintra_driked = false
	
	if GM.cintra_driked:
		remaining_cintra_time -= 10 * delta
	else:
		remaining_cintra_time += 5
	
	move_and_slide()
