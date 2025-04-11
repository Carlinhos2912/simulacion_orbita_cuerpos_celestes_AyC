extends Node2D

@export var pm = ParticleManager.new()

# ⬅️ Precargar selectores 
@onready var sun_selector := $sun_sprite
@onready var camera_selector : Camera2D = $sun_sprite/CameraController.camera

# ☀️ Instanciar objetos
@export var sun = CelesBody.new()

# 🆘 Auxiliares
var SCALED_DELTA = 0.1
var frame_counter = 0
var verlet: bool = false

func _ready():
	# ⚠️ Limitar los FPS
	Engine.max_fps = 60
	
	# ☀️ Inicializar los sprites en base a la instancia
	sun.upload(sun_selector)
	pm.create_particles(200, sun)
	
		
func _process(delta):
	# 🔢 Contador de frames
	frame_counter += 1
	
	# ➡️ Mover los sprites tras calcular la dinamica de la instancia
	sun.dinamize(null, SCALED_DELTA)
	
	
	for particle in pm.particles:
		particle.dinamize( pm.particles, SCALED_DELTA, true)

	# 📍 Renderizar la trayectoria
	queue_redraw()

func _draw():	
	for particle in pm.particles:
		draw_circle( particle.position * Global.GAME_UNIT , particle.radius, Color(255,0,0), true )
		print("Adiooo")




func _on_camera_controller_attach_request() -> void:
	camera_selector.global_position = sun_selector.position

func _on_verlet_checkbtn_toggled(toggled_on):
	verlet = toggled_on

func _on_h_slider_drag_ended(value_changed):
	if value_changed:
		SCALED_DELTA = $UI/HSlider.value
		$UI/Label.text = "Delta Scale: %s" % SCALED_DELTA 
