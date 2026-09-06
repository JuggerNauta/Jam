
extends Node2D

@onready var spawn_area: CollisionShape2D = $SpawnArea

@export var enemy = preload("res://escenas/mosca.tscn")
@export var generation_area: Vector2i
var total_enemigos = 0
@export var max_enemigos: int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	var enemy_handler: Node = get_parent().get_node("EnemyHandler")
	if !is_instance_valid(enemy_handler):
		push_error("En la escena debe existir un nodo EnemyHandler")
		return
	var random_position = get_random_position()
	if total_enemigos < max_enemigos:
		var local_enemy: CharacterBody2D = enemy.instantiate()
		print("INSTANCIANDO EN ", random_position)
		
		local_enemy.enemigo_murio.connect(_on_enemigo_enemigo_murio)
		local_enemy.global_position = random_position - enemy_handler.global_position
		enemy_handler.add_child(local_enemy)
		total_enemigos += 1


func _on_enemigo_enemigo_murio(_enemigo: Variant) -> void:
	total_enemigos -= 1

func get_random_position():
	var rect = spawn_area.shape as RectangleShape2D
	var size = rect.size / 2.0 
	var x = randf_range(-size.x, size.x)
	var y = randf_range(-size.y, size.y)
	return spawn_area.global_position + Vector2(x, y)
