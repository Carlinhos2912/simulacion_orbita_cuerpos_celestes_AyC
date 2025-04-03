extends Node2D

#Instancia de sprites y CelesBody
@onready var sun_selector = $sun_sprite
@onready var earth_selector = $earth_sprite

@export var sun = CelesBody.new()
@export var earth = CelesBody.new()


func _ready():
	#Inicialización de sol (0,0)
	sun.position = Vector2(get_viewport_rect().size / Vector2(2,2))
	
	sun_selector.texture = sun.visual
	sun_selector.self_modulate = sun.modulate
	sun_selector.scale = Vector2(sun.radius * 0.001, sun.radius * 0.001)
	sun_selector.position = sun.position
	
	earth_selector.texture = earth.visual
	earth_selector.self_modulate = earth.modulate
	earth_selector.scale = Vector2(earth.radius * 0.001,  earth.radius * 0.001)
	
	earth.position = sun.position +  earth.position
	earth_selector.position = earth.position
	
	print(earth.modulate)
	print("Ola ya cargué")

func _process(delta):	
	earth.distance = Vector2(earth.position).distance_to(sun.position)
	print("Distance ", earth.distance)
	earth.acceleration = earth.calc_orbital_acceleration(sun.SUN_MASS, sun.position)
	print("Aceleracion ", earth.acceleration)
	earth.velocity.y += earth.acceleration.y * 0.001 * delta
	earth.velocity.x += earth.acceleration.x * 0.001 * delta
	print("velocidad ", earth.velocity)
	print("sun posicion ", sun.position)
	print("earth posicion ", earth.position)
	earth.position.y += earth.velocity.y * 0.001 * delta
	earth.position.x += earth.velocity.x * 0.001 * delta
	print("posicion ", earth.position)
	earth_selector.position = earth.position
