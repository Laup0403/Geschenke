extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@export var SPEED: int
var speed = SPEED
var animSpeed = 1.0

var canMove = true
var canAnim = true
var animation = "normal"

func _physics_process(delta: float) -> void:
	
	move(delta)
	animate()
	
	move_and_slide()

func move(delta:float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("Left", "Right")
	
	if canMove and (
			Input.is_action_pressed("Down") or 
			(speed == SPEED * 2 and direction != 0)
		):
		speed = SPEED * 2
		animSpeed = 2
	else:
		speed = SPEED
		animSpeed = 1.0
	
	if direction and canMove:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func animate() -> void:
	if canAnim:
		if not canMove or Input.is_action_pressed("Left") and Input.is_action_pressed("Right"):
			anim.play(animation+"_idle")
			anim.flip_h = false
		elif Input.is_action_pressed("Left"):
			anim.play(animation+"_walk",animSpeed)
			anim.flip_h = true
		elif Input.is_action_pressed("Right"):
			anim.play(animation+"_walk",animSpeed)
			anim.flip_h = false
		else:
			anim.play(animation+"_idle")
			anim.flip_h = false


func interact() -> void:
	$Interact.show()
func notInteract() -> void:
	$Interact.hide()
