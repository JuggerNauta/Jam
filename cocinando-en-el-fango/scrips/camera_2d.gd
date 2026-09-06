extends Camera2D

@export var player : CharacterBody2D

var max_speed: float = 10
var release_falloff = 35
var acceleration = 100
var velocity: Vector2 = Vector2.ZERO
@export var tilemap: TileMapLayer
var current_cell: Vector2i
var viewport_size: Vector2i
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchor_mode(Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var input_vector = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	var old_cell = current_cell
	calculate_velocity(input_vector)
	update_global_position()
	#apply_camera_limits()
	if old_cell != current_cell:
		player.clamp_to_limits(global_position, viewport_size)
	

func apply_camera_limits():
	var tilemap_info = get_tilemap_info()
	var _level_size = Vector2i(tilemap_info.tile_size * tilemap_info.size)
	#set_limit(SIDE_LEFT, 0)
	#set_limit(SIDE_TOP, -level_size.y/2)
	#set_limit(SIDE_RIGHT, level_size.x)
	#set_limit(SIDE_BOTTOM, level_size.y/2)
	#
func update_global_position():
	var _delta = get_process_delta_time()
	viewport_size  = get_viewport_rect().size
	current_cell = Vector2i(player.global_position) / viewport_size
	
	global_position = current_cell * viewport_size
	#global_position += lerp(
		#velocity,
		#Vector2.ZERO,
		#pow(2, -32 * delta)
	#)
	
	#var limit_left = get_limit(SIDE_LEFT)
	#var limit_top = get_limit(SIDE_TOP)
	#var limit_right = get_limit(SIDE_RIGHT)
	#var limit_bot = get_limit(SIDE_BOTTOM)
	#global_position.x = clamp(global_position.x, limit_left, limit_right)
	#global_position.y = clamp(global_position.y, limit_top, limit_bot)
	
func calculate_velocity(direction):
	var delta = get_process_delta_time()

	velocity += direction * acceleration * delta	
	if direction.x == 0:
		velocity.x = lerp(0.0, velocity.x, pow(2, -release_falloff * delta))
	if direction.y == 0:
		velocity.y = lerp(0.0, velocity.y, pow(2, -release_falloff * delta))
	velocity.x = clamp(
		velocity.x,
		-max_speed,
		max_speed
	)
	velocity.y = clamp(
		velocity.y,
		-max_speed,
		max_speed
	)
	
func get_tilemap_info():
	var tile_size = tilemap.tile_set.tile_size
	var tilemap_rect = tilemap.get_used_rect()
	var tilemap_size = Vector2i(
		tilemap_rect.end.x - tilemap_rect.position.x,
		tilemap_rect.end.y - tilemap_rect.position.y
	)
	return {"size": tilemap_size, "tile_size": tile_size}
