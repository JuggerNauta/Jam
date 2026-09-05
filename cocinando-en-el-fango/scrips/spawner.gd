
extends Node2D

@onready var enemy = preload("res://escenas/enemigo.tscn")
@export var generation_area: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	print("INSTANCIANDO...")
	var enemy_handler: Node = get_parent().get_node("EnemyHandler")
	var enemy_handler2: Node = get_parent().get_node("EnemyHandler2")
	if !is_instance_valid(enemy_handler):
		push_error("En la escena debe existir un nodo EnemyHandler")
		return
	var random_position = enemy_handler.get_random_position()
	var random_position2 = enemy_handler2.get_random_position()
	
	var local_enemy: Node = enemy.instantiate()
	var local_enemy2: Node = enemy.instantiate()
	local_enemy.global_position = random_position
	enemy_handler.add_child(local_enemy)
	local_enemy2.global_position = random_position2
	enemy_handler2.add_child(local_enemy2)
