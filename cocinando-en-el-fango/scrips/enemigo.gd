extends CharacterBody2D

var vida: float = 3.0

func _ready() -> void:
	add_to_group("enemigo")

func recibir_daño(daño_arma: float):
	$Sprite2D/AnimationPlayer.play("tomando_daño")
	vida -= daño_arma
	
	if vida <= 0.0:
		queue_free()
