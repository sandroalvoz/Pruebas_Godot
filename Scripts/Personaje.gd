extends CharacterBody2D

@export var escena: Node2D

var velocidadActual
const velocidadMinima: float = 300
const velocidadMaxima: float = 5000
const aceleracion: float = 100
const deceleracion: float = 5000

const gravedad: float = 1960
const fuerzaSalto: float = -700
const coyoteTime: float = 0.1
var coyoteTimeCounter:float = 0

@export var alturaSalto: float
@export var timeToPeakSalto: float
@export var timeToDescentSalto: float

@onready var velocidadSalto: float = (-2.0 * alturaSalto) / timeToPeakSalto
@onready var gravedadSalto: float = (2.0 * alturaSalto) / (timeToPeakSalto*timeToPeakSalto)
@onready var gravedadCaida: float = (2.0 * alturaSalto) / (timeToDescentSalto*timeToDescentSalto)

var saltando: bool = false
var grindeo : bool = false

func _process(delta):
	movimiento(delta)

func movimiento(delta):
	if !is_on_floor():
		#velocity.y += gravedad*delta
		velocity.y += Gravedad()*delta
		print("VelocityY: ", velocity.y)
	var direccion = Input.get_vector("izquierda","derecha","arriba","abajo")
	velocidadActual = calcularVelocidad(direccion, delta)
	velocity.x = direccion.x * velocidadActual
	grindeo = Input.is_action_pressed("accion")
	if Input.is_action_pressed("salto"):
		if (is_on_floor() or coyoteTimeCounter>0) and saltando == false:
			velocity.y = fuerzaSalto
			#jump()
			saltando = true
			coyoteTimeCounter = 0
	if Input.is_action_just_released("salto"):
		velocity.y = 0
	if is_on_floor():
		saltando = false
		coyoteTimeCounter = coyoteTime
	elif coyoteTimeCounter >0:
		coyoteTimeCounter-=delta
	#print("contador: ", coyoteTimeCounter, " - coyote:", coyoteTime)
	move_and_slide()

func calcularVelocidad(direccion, delta):
	#aceleracion inicial
	#cambio de marchas?
	var velocidadResultado = velocidadActual
	if velocidadResultado == null:
		velocidadResultado = velocidadMinima
	if direccion != Vector2.ZERO :
		velocidadResultado += aceleracion * delta
	else:
		velocidadResultado -= deceleracion * delta
	velocidadResultado= clampf(velocidadResultado, velocidadMinima, velocidadMaxima)
	return velocidadResultado
	
func Gravedad()->float:
	#esto falla
	#print("VelocityY: ", velocity.y)
	print("GravedadSalto: ", gravedadSalto)
	print("GravedadCaida: ", gravedadCaida)
	return gravedadSalto if velocity.y <0.0 else gravedadCaida
	
func jump():
	velocity.y = velocidadSalto
