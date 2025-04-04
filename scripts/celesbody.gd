extends Resource
class_name CelesBody

#Constantes importantes
const UA = 149.6 * 10 ** 9
const SCALE_FACTOR = 250 / UA
const GRAVITATORY = 6.6743 * 10 ** -1.1
const SUN_MASS = 1.9890 * 10 ** 3.0
const EARTH_MASS = 5.9722 * 10 ** 2.4

#Parámetros del cuerpo celeste (Discretos)
@export var name : String
@export var modulate : Color
@export var visual : CompressedTexture2D

#Parámetros del cuerpo celeste (Numéricos)
@export var radius : float
@export var position : Vector2 = Vector2(1 * UA * SCALE_FACTOR, 0)
@export var distance : float
@export var velocity : Vector2 = Vector2(0, 1.991 * 10 ** -4 * SCALE_FACTOR)
@export var acceleration : Vector2
@export var mass : float
@export var force : Vector2


#=================== ECUACIONES FUNDAMENTALES ============================

func calc_orbital_acceleration(mass, position: Vector2) -> Vector2:
#	print("MMGV: ", Vector2(GRAVITATORY * mass / Vector2(self.position).distance_squared_to(position) / SCALE_FACTOR * Vector2(self.position).direction_to(position)))
	return Vector2(GRAVITATORY * mass / Vector2(self.position).distance_squared_to(position) / SCALE_FACTOR * Vector2(self.position).direction_to(position))

func calc_orbital_accelerations(array: Array):
	for em in array:
		em.acceleration = Vector2(GRAVITATORY * SUN_MASS / Vector2(self.position).distance_squared_to(position) / SCALE_FACTOR * Vector2(self.position).direction_to(position))
