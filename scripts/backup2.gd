extends CharacterBody3D

@export var velocidad: float = 3.0
@export var distancia_parada: float = 0.8

var objetivo_posicion: Vector3 = Vector3.ZERO
var esta_yendo_a_objetivo: bool = false

@onready var anim_player = $AnimationPlayer
@onready var nav_agent = $NavAgent
var tiempo_animacion: float = 0.0

func _ready():
	anim_player.play("rig_002Action_001")
	anim_player.stop()
	nav_agent.velocity = Vector3.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var camara = get_viewport().get_camera_3d()
		if not camara: return
		
		var origen = camara.project_ray_origin(event.position)
		var fin = origen + camara.project_ray_normal(event.position) * 1000
		var resultado = get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(origen, fin))
		
		if resultado and resultado.collider.is_in_group("student"):
			GM.student_name_global = resultado.collider.student_name
			var pos_estudiante = resultado.collider.global_position
			objetivo_posicion = pos_estudiante - (pos_estudiante - global_position).normalized() * distancia_parada
			esta_yendo_a_objetivo = true
			nav_agent.target_position = objetivo_posicion

func _physics_process(_delta):
	if esta_yendo_a_objetivo:
		var path = nav_agent.get_next_path_position()
		if path == Vector3.ZERO:
			velocity = Vector3.ZERO
			esta_yendo_a_objetivo = false
			anim_player.stop()
			return
		
		var dir = path - global_position
		var distancia = dir.length()
		
		if distancia <= 0.5:
			# Llegó al punto actual en la ruta
			pass
		else:
			# Forzar a 4 direcciones
			dir = _direccion_a_4_vias(dir)
			
			# Aplicar movimiento
			velocity.x = dir.x * velocidad
			velocity.z = dir.z * velocidad
			
			# Rotar
			var look_dir = Vector3(-dir.x, 0, -dir.z).normalized()
			look_at(global_position + look_dir, Vector3.UP)
			
			# Reproducir animación
			anim_player.play("rig_002Action_001")
	
	move_and_slide()

# --- FUNCIÓN: Convertir dirección a 4 vías ---
func _direccion_a_4_vias(dir: Vector3) -> Vector3:
	var dx = dir.x
	var dz = dir.z
	
	if abs(dx) > abs(dz):
		if dx > 0:
			return Vector3(1, 0, 0)   # Derecha
		else:
			return Vector3(-1, 0, 0)  # Izquierda
	else:
		if dz > 0:
			return Vector3(0, 0, 1)   # Abajo
		else:
			return Vector3(0, 0, -1)  # Arriba
