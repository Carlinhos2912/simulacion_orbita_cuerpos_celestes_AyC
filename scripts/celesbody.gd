extends Resource
class_name CelesBody

#Parámetros del cuerpo celeste (Discretos)
@export var modulate : Color
@export var visual : CompressedTexture2D

#Parámetros del cuerpo celeste (Numéricas Intrínsecas)
@export var raw_radius : String
@export var raw_mass : String
var radius : float
var mass : float

#Parámetros del cuerpo celeste (Numéricas Dinámicas)
@export var position : Vector2
@export var velocity : Vector2
@export var acceleration : Vector2
	

# ============================ * ECUACIONES FUNDAMENTALES * ============================
# ♻️ Metodo que actualiza un selector especificado en base a los parametros del CelesBody
func upload( selector : Sprite2D, size_relative_to : Sprite2D = null ):
	radius = float(self.raw_radius) if self.raw_radius.is_valid_float() else 0.0
	mass = float(self.raw_mass) if self.raw_mass.is_valid_float() else 0.0
	
	selector.texture = self.visual
	selector.self_modulate = self.modulate
	selector.position = self.position * Global.GAME_UNIT
	
	if size_relative_to:
		selector.scale = (Vector2(log(radius + 1), log(radius + 1)) * Global.GAME_UNIT)/size_relative_to.scale
	else:
		selector.scale = Vector2(log(radius + 1), log(radius + 1)) * Global.GAME_UNIT


# 🐊 Metodo que moviliza un selector segun calculos matematicos
func dinamize( selector : Sprite2D, respect = null, scale : float = 1.0, verlet = false):
	if respect:
		self.acceleration = self.calc_orbital_acceleration(respect)
		
	if verlet:
		var new_pos = Vector2(self.position + self.velocity * scale + 0.5 * self.acceleration * scale ** 2)
		var new_acceleration = Vector2(0,0)
		if respect:
			self.position = new_pos
			new_acceleration = self.calc_orbital_acceleration(respect)
		self.velocity = Vector2(self.velocity + 0.5 * (self.acceleration + new_acceleration) * scale)
		self.position = new_pos
	else:
		self.velocity += self.acceleration * scale
		self.position += self.velocity * scale
		
	selector.position = self.position * Global.GAME_UNIT

# 💫 Método recursivo para calcular la aceleración orbital en base a uno o varios objetivos
func calc_orbital_acceleration(objective = null) -> Vector2:
	if objective == null:
		return Vector2(0,0)

	if objective is CelesBody:
		var r_vec = objective.position - self.position
		var acc_magnitude = Global.GRAVITATORY * objective.mass / r_vec.length_squared()
		return r_vec.normalized() * acc_magnitude * Global.VELOCITY_UNIT

	elif objective is Array:
		if objective.is_empty():
			return Vector2(0,0)
		
		return calc_orbital_acceleration(objective[0]) + calc_orbital_acceleration(objective.slice(1, objective.size() - 1))

	return Vector2(0,0)


# 💫 Metodo que calcula la aceleracion orbital en base un objetivo
func _DEPRECATED_calc_orbital_acceleration( objective:CelesBody=null, objectives:Array[CelesBody] = []) -> Vector2:
	var r_vec = objective.position - self.position
	var acceleration_magnitude = Global.GRAVITATORY * objective.mass / r_vec.length_squared()
	return r_vec.normalized() * acceleration_magnitude * Global.VELOCITY_UNIT
