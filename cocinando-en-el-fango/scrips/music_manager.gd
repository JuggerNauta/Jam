extends AudioStreamPlayer

var canciones = [
	"res://assets/audios/when ill awake to find you.wav",
	"res://assets/audios/moscas xD.mp3",
	"res://assets/audios/litlesong.mp3",
	"res://assets/audios/flowers attack 2.wav",
	"res://assets/audios/salon.mp3",
	"res://assets/audios/bad song.wav",
]

func _ready() -> void:
	stream = load(canciones.pick_random())
	play()
