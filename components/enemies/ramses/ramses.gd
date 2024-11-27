extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 55.0
const JUMP_VELOCITY = -400.0
var direction = 1
var isStopped = false
var directionSpeed = 5

@onready var ground_control: RayCast2D = $GroundControl
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var back_view: RayCast2D = $BackView
@onready var forward_view: RayCast2D = $ForwardView
@onready var base_enemies: CollisionShape2D = $BaseEnemies





func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	if !ground_control.is_colliding() or back_view.is_colliding() or forward_view.is_colliding():
		direction = direction * -1
	position.x += direction * directionSpeed * delta
	
	
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
		
	if direction < 0: 
		animated_sprite.flip_h = true
		$ForwardView.set_rotation_degrees(0)
		$BackView.set_rotation_degrees(0)
		$GroundControl.set_position(Vector2(-18, 0))
	if direction > 0:
		animated_sprite.flip_h = false
		$ForwardView.set_rotation_degrees(180)
		$BackView.set_rotation_degrees(180)
		$GroundControl.set_position(Vector2(18, 0))
	
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#var direction := true
	#if direction:
	velocity.x = direction * SPEED
	#else:
	#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_ready() -> void:
	animated_sprite_2d.play('walk')
	
		
	pass # Replace with function body.
