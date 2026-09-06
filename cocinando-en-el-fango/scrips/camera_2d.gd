extends Camera2D

@export var player : CharacterBody2D
@onready var screen_size: Vector2 = get_viewport_rect().size
@export var tilemap_layer: TileMapLayer

var viewport_size: Vector2i
var current_cell: Vector2i
var zoom_factor: Vector2
var room_size: Vector2i = Vector2i(736, 448)

func _ready() -> void:
	
	set_anchor_mode(Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT)
	set_screen_position()
	
	await get_tree().process_frame
	
	position_smoothing_enabled = true
	position_smoothing_speed = 7.0
	zoom_factor = screen_size/ Vector2(room_size.x, room_size.y)
	set_zoom(zoom_factor)

func _process(_delta: float) -> void:

	set_screen_position()

func set_screen_position():

	var player_pos = player.global_position
	var current_x_cell: int = floor(player_pos.x / screen_size.x * zoom_factor.x )
	var current_y_cell: int = floor(player_pos.y / screen_size.y * zoom_factor.y)

	current_cell = Vector2i(current_x_cell, current_y_cell)

	var x =  current_x_cell * room_size.x 
	var y = current_y_cell * room_size.y

	global_position = Vector2(x, y) 
	#set_zoom(zoom)
