extends Node3D

var professor_is_in_range: bool = false
var associated_pc: Node3D = null 

func _ready():
	var pc_name = name.replace("Table", "Pc")
	
	var parent_node = get_parent()
	if parent_node:
		associated_pc = parent_node.get_node(pc_name)
	if associated_pc == null:
		print("Error: No se pudo encontrar el nodo PC hermano: " + pc_name)
		set_process(false)
		return
	
	#print("Mesa " + name + " conectada con PC " + pc_name)
