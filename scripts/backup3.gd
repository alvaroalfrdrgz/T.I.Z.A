extends CharacterBody3D

@export var waypoints: Array[Marker3D]
@export var speed: float = 4.0
@export var rotation_speed: float = 10.0

var is_moving: bool = false
var current_path: Array[int] = []  # Índices de waypoints a seguir
var current_path_index: int = 0
var graph: Dictionary = {}  # Grafo de conexiones entre waypoints

func _ready():
	build_waypoint_graph()

func _physics_process(delta: float) -> void:
	if not is_moving or current_path.is_empty():
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var min_distance := 0.3
	var target_waypoint_index = current_path[current_path_index]
	var target_position = waypoints[target_waypoint_index].global_position
	
	var direction = (target_position - global_position)
	direction.y = 0  # Mantener movimiento en plano horizontal
	var distance = direction.length()
	
	if distance < min_distance:
		# Llegó al waypoint actual, pasar al siguiente
		current_path_index += 1
		
		if current_path_index >= current_path.size():
			# Llegó al destino final
			is_moving = false
			global_position = target_position  # Ajustar posición exacta
			velocity = Vector3.ZERO
			move_and_slide()
			print("✓ Llegó al destino final")
			return
	else:
		# Moverse hacia el waypoint
		direction = direction.normalized()
		
		# Rotar hacia la dirección de movimiento
		if direction.length() > 0.1:
			var target_rotation = atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
		
		velocity = direction * speed
		move_and_slide()

func build_waypoint_graph():
	# Construir un grafo de conexiones entre waypoints
	# Solo conecta waypoints que estén alineados horizontal o verticalmente
	
	graph.clear()
	
	var max_connection_distance = 4.0  # Solo conectar waypoints cercanos
	var alignment_tolerance = 0.3  # Tolerancia para considerar alineación
	
	for i in range(waypoints.size()):
		graph[i] = []
		
		var pos_i = waypoints[i].global_position
		
		for j in range(waypoints.size()):
			if i == j:
				continue
			
			var pos_j = waypoints[j].global_position
			
			# Calcular distancia total
			var distance = pos_i.distance_to(pos_j)
			
			# Solo considerar waypoints cercanos
			if distance > max_connection_distance:
				continue
			
			# Calcular diferencias en cada eje
			var delta_x = abs(pos_i.x - pos_j.x)
			var delta_z = abs(pos_i.z - pos_j.z)
			
			# Verificar alineación horizontal (misma fila, eje Z similar)
			var is_horizontal = delta_z < alignment_tolerance
			
			# Verificar alineación vertical (misma columna, eje X similar)
			var is_vertical = delta_x < alignment_tolerance
			
			# Si está alineado en alguna dirección, crear conexión
			if is_horizontal or is_vertical:
				graph[i].append(j)
	
	# Debug: imprimir el grafo
	print("\n=== GRAFO DE WAYPOINTS CONSTRUIDO ===")
	var isolated = []
	for i in graph.keys():
		if graph[i].size() > 0:
			print("Waypoint [", i, "] ", waypoints[i].name, " → conectado con: ", graph[i])
		else:
			isolated.append(i)
	
	if not isolated.is_empty():
		print("⚠️ ADVERTENCIA: Waypoints aislados (sin conexiones): ", isolated)

func move_to_waypoint(target_waypoint_index: int):
	# Encuentra el waypoint más cercano a la posición actual del profesor
	var start_waypoint = find_nearest_waypoint()
	
	if start_waypoint == -1 or target_waypoint_index < 0 or target_waypoint_index >= waypoints.size():
		print("ERROR: Waypoint inválido")
		return
	
	print("\n--- CALCULANDO RUTA ---")
	print("Desde: Waypoint [", start_waypoint, "] ", waypoints[start_waypoint].name)
	print("Hasta: Waypoint [", target_waypoint_index, "] ", waypoints[target_waypoint_index].name)
	
	# Calcular la ruta usando BFS (Breadth-First Search)
	var path = find_path_bfs(start_waypoint, target_waypoint_index)
	
	if path.is_empty():
		print("✗ No se encontró ruta al waypoint destino")
		return
	
	print("✓ Ruta encontrada: ", path)
	print("Total de waypoints en la ruta: ", path.size())
	
	current_path = path
	current_path_index = 0
	is_moving = true

func find_nearest_waypoint() -> int:
	# Encuentra el waypoint más cercano a la posición actual
	var nearest_index = -1
	var min_distance = INF
	
	for i in range(waypoints.size()):
		var distance = global_position.distance_to(waypoints[i].global_position)
		if distance < min_distance:
			min_distance = distance
			nearest_index = i
	
	return nearest_index

func find_path_bfs(start: int, goal: int) -> Array[int]:
	# Algoritmo BFS para encontrar el camino más corto
	if start == goal:
		var result: Array[int] = [start]
		return result
	
	var queue: Array = [[start]]  # Cola de caminos
	var visited: Array = [start]
	
	while not queue.is_empty():
		var path = queue.pop_front()
		var node = path[-1]  # Último nodo del camino actual
		
		# Explorar vecinos
		if graph.has(node):
			for neighbor in graph[node]:
				if neighbor in visited:
					continue
				
				var new_path: Array[int] = []  # CAMBIO AQUÍ: declarar como Array[int]
				new_path.assign(path)  # Copiar el camino anterior
				new_path.append(neighbor)
				
				if neighbor == goal:
					# Encontramos el destino
					return new_path
				
				visited.append(neighbor)
				queue.append(new_path)
	
	# No se encontró camino
	var empty_result: Array[int] = []
	return empty_result

# Función para llamar desde el sistema de clicks (cámara)
func handle_click_on_waypoint(waypoint_marker: Marker3D):
	# Encuentra el índice del waypoint clickeado
	var target_index = waypoints.find(waypoint_marker)
	
	if target_index != -1:
		print("\n🎯 CLICK EN WAYPOINT: ", waypoint_marker.name, " (índice: ", target_index, ")")
		move_to_waypoint(target_index)
	else:
		print("ERROR: Waypoint '", waypoint_marker.name, "' no encontrado en el array")
		print("Asegúrate de que esté agregado en la propiedad 'waypoints' del inspector")

# Función alternativa si recibes el índice directamente
func move_to_waypoint_by_index(index: int):
	if index >= 0 and index < waypoints.size():
		print("\n🎯 MOVERSE AL ÍNDICE: ", index)
		move_to_waypoint(index)
	else:
		print("ERROR: Índice ", index, " fuera de rango (0-", waypoints.size()-1, ")")
