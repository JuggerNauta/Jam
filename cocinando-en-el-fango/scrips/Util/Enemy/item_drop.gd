class_name ItemDrop
extends Node2D


@onready var item_sprite: Sprite2D = $ItemSprite
@onready var hitbox: Area2D = $Hitbox
@onready var count_label: Label = $CountLabel

var stack : ItemStack
var velocity : Vector2

var velocity_tween : Tween


func _ready():
	hitbox.body_entered.connect(on_body_entered)
	item_sprite.texture = stack.item.sprite
	count_label.text = str(stack.count)
	
	var speed = randf_range(75, 100)
	velocity = Vector2.RIGHT.rotated(deg_to_rad(randf_range(0.0, 360.0))) * speed
	
	velocity_tween = create_tween()
	
	velocity_tween.tween_property(self, "velocity", Vector2.ZERO, 0.75)
	velocity_tween.set_trans(Tween.TRANS_BOUNCE)
	velocity_tween.set_ease(Tween.EASE_OUT)


func update_display():
	item_sprite.texture = stack.item.sprite
	count_label.text = str(stack.count)


func on_body_entered(body: Node2D) -> void:
	if body is Player:
		#stack = body.inventory.agregar(stack)
		Inventario.agregar_objeto(stack.item)
		if stack.is_empty():
			queue_free()
		else:
			update_display()


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
