extends CharacterBody2D


var direction_x : float
var speed := 50
var can_shoot : bool = true

@export var jump_strength := 200
@export var gravity := 1000


func get_input() -> void:
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength
	if Input.is_action_just_pressed("shoot") and can_shoot:
		print("shoot")
		can_shoot = false
		$Shoot_cooldown.start(0.5)


func apply_gravity(delta : float):
	velocity.y += gravity * delta


func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
