extends CharacterBody2D


const SPEED = 55.0
const JUMP_VELOCITY = -400.0
var direction = 1
var isStopped = false
var directionSpeed = 5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var forward_view: RayCast2D = $ForwardView
@onready var back_view: RayCast2D = $BackView
@onready var ground_control: RayCast2D = $GroundControl


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if !ground_control.is_colliding() or forward_view.is_colliding():
		direction = direction * -1
	position.x += direction * directionSpeed * delta
	
	
	if direction < 0: 
		animated_sprite.flip_h = true
		$ForwardView.set_rotation_degrees(180)
		$BackView.set_rotation_degrees(180)
		$GroundControl.set_position(Vector2(-19, 29))
	if direction > 0:
		animated_sprite.flip_h = false
		$ForwardView.set_rotation_degrees(0)
		$BackView.set_rotation_degrees(0)
		$GroundControl.set_position(Vector2(19, 29))
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
	velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
