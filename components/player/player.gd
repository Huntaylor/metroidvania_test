class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $Marker2D/AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D

@export var falling_offset := 0.0
const speed = 300.0
const jump_vel = -400.0
var fall_height := 0.0

var main_sm = LimboHSM.new()

var dir

func _ready() -> void:
	initiate_state_machine()


func _physics_process(delta: float) -> void:
	dir = Input.get_axis("move_left", "move_right")
	if dir:
		velocity.x = dir * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	flip_sprite()
		
		
	move_and_slide()

func flip_sprite() -> void:
	if dir == 1:
		marker_2d.scale.x = 1
	elif dir == -1:
		marker_2d.scale.x = -1
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		main_sm.dispatch(&"to_jump")
	elif event.is_action_pressed("attack"):
		main_sm.dispatch(&"to_attack")
		

func initiate_state_machine():
	add_child(main_sm)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var run_state = LimboState.new().named("run").call_on_enter(run_start).call_on_update(run_update)
	var jump_state = LimboState.new().named("jump").call_on_enter(jump_start).call_on_update(jump_update)
	var attack_state = LimboState.new().named("attack").call_on_enter(attack_start).call_on_update(attack_update)
	var fall_state = LimboState.new().named("fall").call_on_enter(fall_start).call_on_update(fall_update)
	
	main_sm.add_child(idle_state)
	main_sm.add_child(run_state)
	main_sm.add_child(jump_state)
	main_sm.add_child(attack_state)
	main_sm.add_child(fall_state)
	
	main_sm.initial_state = idle_state
	
	main_sm.add_transition(idle_state, run_state, &"to_run")
	main_sm.add_transition(idle_state, jump_state, &"to_jump")
	main_sm.add_transition(run_state, jump_state, &"to_jump")
	main_sm.add_transition(main_sm.ANYSTATE, fall_state, &"to_fall")
	main_sm.add_transition(main_sm.ANYSTATE, attack_state, &"to_attack")
	main_sm.add_transition(main_sm.ANYSTATE, idle_state, &"state_ended")
	
	main_sm.initialize(self)
	main_sm.set_active(true)

func idle_start():
	animated_sprite.play('Idle')

func idle_update(delta: float):
	fall_height = global_position.y + falling_offset
	if velocity.x != 0 :
		main_sm.dispatch(&"to_run")
	if global_position.y > fall_height:
		main_sm.dispatch(&"to_fall")

func run_start():
	animated_sprite.play('Run')

func run_update(delta: float):
	if velocity.x == 0 :
		main_sm.dispatch(&"state_ended")
	if global_position.y > fall_height:
		main_sm.dispatch(&"to_fall")

func jump_start():
	animated_sprite.play("Jump")
	velocity.y = jump_vel
	

func jump_update(delta: float):
	print
	if velocity.y > 0 or global_position.y > fall_height:
		print('to fall')
		main_sm.dispatch(&"to_fall")
	if is_on_floor():
		main_sm.dispatch(&"state_ended")
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = jump_vel / 4
		main_sm.dispatch(&"to_fall")

func attack_start():
	animated_sprite.play("Attack")

func attack_update(delta: float):
	if !animated_sprite.is_playing():
		if velocity.y == 0:
			main_sm.dispatch(&"state_ended")
		else :
			main_sm.dispatch(&"to_fall")

func fall_start():
	animated_sprite.play("Fall")

func fall_update(delta: float):
	print("at fall")
	
	if is_on_floor():
		main_sm.dispatch(&"state_ended")






const playerState = {Idle = 'Idle', Run = 'Run', Jump = 'Jump', Attack = 'Attack', Damage = 'Damage', Fall = 'Fall'}
var currentPlayerState := playerState.Idle

func _physics_process(delta: float) -> void:
	if is_on_floor():
		print(is_on_floor())
		fall_height = global_position.y + falling_offset
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if global_position.y > fall_height:
			_set_playerState(playerState.Fall)
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_set_playerState(playerState.Jump)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		_set_playerState(playerState.Run)
		velocity.x = direction * SPEED
		print(velocity.x)

	else:
		_set_playerState(playerState.Idle)
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
func _move_player() :
	match currentPlayerState:
		playerState.Idle:
			if is_on_floor():
				animated_sprite_2d.play(currentPlayerState)
				velocity.x = move_toward(velocity.x, 0, SPEED)
		playerState.Run:
			if is_on_floor():
				animated_sprite_2d.play(currentPlayerState)
				if velocity.x < 0:
					marker_2d.scale.x = -1
				else :
					marker_2d.scale.x = 1
		playerState.Jump:
			animated_sprite_2d.play(currentPlayerState)
			velocity.y = JUMP_VELOCITY
		playerState.Attack:
			animated_sprite_2d.play(currentPlayerState)
		playerState.Damage:
			animated_sprite_2d.play(currentPlayerState)
		playerState.Fall:
			animated_sprite_2d.play(currentPlayerState)
			if Input.is_action_just_released("ui_accept") and velocity.y < 0:
				velocity.y = JUMP_VELOCITY / 4
			
	

func _set_playerState(_playerState) :
	currentPlayerState = _playerState
	_move_player()
