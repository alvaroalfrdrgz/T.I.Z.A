extends CharacterBody3D

var velocidad: float = 1.7
var stamina: float = 100
var lost_stamina: float = 8.0
var gain_stamina: float = 50.0
var min_stamina: float = 0.0
var max_stamina:float = 100.0
var is_walking: bool = false
var can_walk: bool = true
var remaining_cintra_time: float = 100.0
var speed: float = 1.0
@onready var anim_player: AnimationPlayer = $AnimationPlayer
var tiempo_animacion: float = 0.0
var esta_caminando: bool = false

var objetivo_posicion: Vector3 = Vector3.ZERO
var esta_yendo_a_objetivo: bool = false

func _ready():
	anim_player.play("rig_002Action_001")
	anim_player.stop()

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
	
	var nueva_caminando = direccion.length() > 0.1

	if nueva_caminando != esta_caminando:
		esta_caminando = nueva_caminando
		actualizar_animacion()
	
	if direccion.length() > 0.1:
		var look_direction = Vector3(-direccion.x, 0, -direccion.z).normalized()
		
		look_at(global_position + look_direction, Vector3.UP)
	
	move_and_slide()

func actualizar_animacion():
	if esta_caminando:
		anim_player.play("rig_002Action_001")
		anim_player.seek(tiempo_animacion, true)
	else:
		tiempo_animacion = anim_player.current_animation_position
		anim_player.stop()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camara = get_viewport().get_camera_3d()
		if not camara:
			return
		
		# Lanzar rayo
		var origen = camara.project_ray_origin(event.position)
		print(origen)
		var direccion = camara.project_ray_normal(event.position)
		var fin = origen + direccion * 1000
		
		# Configurar y lanzar rayo (Godot 4.5)
		var parametros = PhysicsRayQueryParameters3D.create(origen, fin)
		var resultado = get_world_3d().direct_space_state.intersect_ray(parametros)
		
		# Verificar si es un estudiante
		if resultado and resultado.collider.is_in_group("students"):
			_on_student_clicked(resultado.collider)

func _on_student_clicked(student_node):
	print("Clic en estudiante: ", student_node.name)
	
	# Aquí puedes:
	# - Hacer que el profesor camine hacia el estudiante
	# - Mostrar un diálogo
	# - Inspeccionar trampas
	# Ejemplo básico: caminar hacia él
	_walk_to_student(student_node)

func _walk_to_student(student_node):
	# Obtener la posición del estudiante (ligeramente frente a él)
	var student_pos = student_node.global_position
	var direction_to_student = (student_pos - global_position).normalized()
	
	# Punto objetivo: 0.8m frente al estudiante (para no entrar en su colisión)
	var target_pos = student_pos - direction_to_student * 0.8
	
	# Aquí activas tu sistema de movimiento hacia target_pos
	# (ajusta según tu lógica actual de click-to-move)
	#esta_yendo_a_mesa = true
	#objetivo_posicion = target_pos
