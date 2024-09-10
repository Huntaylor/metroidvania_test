class_name PlayerState extends State

const idle = 'Idle'
const run = 'Run'
const fall = 'Fall'
const jump = 'Jump'
const attack = 'Attack'

var player:Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState type must be used only in the player scene. It needs the owner to the a Player node.")
