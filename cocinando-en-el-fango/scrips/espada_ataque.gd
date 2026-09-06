extends Node2D

var daño_arma: float = 1.0

func _ready():

	look_at(get_global_mouse_position())

	$Sprite2D/AnimationPlayer.play("ataque")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:

	if anim_name == "ataque":

		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("enemigo"):
		body.recibir_daño(daño_arma)
