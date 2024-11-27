extends CharacterBody2D

const SPEED = 55.0
const JUMP_VELOCITY = -400.0
var direction = 1
var isStopped = false
var directionSpeed = 5


@onready var sight: RayCast2D = $Sight

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if sight.is_colliding():
		velocity.x = direction
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	velocity.x = direction * SPEED


	move_and_slide()
