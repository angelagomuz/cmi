extends Node2D

@export var vitamina_scene: PackedScene
@export var garrapata_scene: PackedScene
@export var contenedor: NodePath
@export var tiempo_spawn: float = 1.5

func _ready():
	spawn()

func spawn():
	await get_tree().create_timer(tiempo_spawn).timeout

	var objeto: Node2D
	if randi() % 2 == 0:
		objeto = vitamina_scene.instantiate()
	else:
		objeto = garrapata_scene.instantiate()

	var contenedor_nodo = get_node(contenedor)
	contenedor_nodo.add_child(objeto)

	objeto.global_position = Vector2(
		randf_range(50, 750),  # posición X aleatoria
		0                      # empieza arriba
	)

	spawn()  # vuelve a llamar
