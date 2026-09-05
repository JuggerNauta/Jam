
extends Area2D

@export var max_enemies: int = 5
@onready var spawn_area: CollisionShape2D = $CollisionShape2D

var current_enemies: int = 0

	
func get_random_position():
	var rect = spawn_area.shape as RectangleShape2D
	var size = rect.size / 2.0 
	var x = randf_range(-size.x, size.x)
	var y = randf_range(-size.y, size.y)
	return Vector2(x, y)	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
