extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		animated_sprite_2d.play('run')
		velocity.x = direction * SPEED
		print(velocity.x)
		if velocity.x < 0:
			marker_2d.scale.x = -1
		else :
			marker_2d.scale.x = 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play('default')

	move_and_slide()
