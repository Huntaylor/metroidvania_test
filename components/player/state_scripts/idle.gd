extends PlayerState


#func enter(previous_state_path: String, data := {}) -> void:
	#player.velocity.x =0.0
	#player.animation_player.play('Idle')
	#
#func physics_update(_delta:float) -> void:
	#player.velocity.y += player.gravity * _delta
	#player.move_and_slide()
	#if not player.is_on_floor():
		#finished.emit(fall)
	#elif Input.is_action_just_pressed("jump"):
		#finished.emit(jump)
	#elif Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		#finished.emit(run)
#
