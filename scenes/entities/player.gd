extends CharacterBody2D


var direction_x : float
var speed := 100

@export var jump_strength := 425
@export var gravity := 1000

signal shoot(pos: Vector2, dir: Vector2)

const GUN_DIRECTIONS := {
	Vector2i(1, 0): 0,
	Vector2i(1, 1): 1,
	Vector2i(0, 1): 2,
	Vector2i(-1, 1): 3,
	Vector2i(-1, 0): 4,
	Vector2i(-1, -1): 5,
	Vector2i(0, -1): 6,
	Vector2i(1, -1): 7,
}


func get_input() -> void:
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strength
	if Input.is_action_just_pressed("shoot") and $Shoot_cooldown.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$LaserSound.play()
		$Shoot_cooldown.start(0.5)
		var tween = get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.1)
		tween.tween_property($Marker, "scale", Vector2(0.5, 0.5), 0.4)


func apply_gravity(delta : float):
	velocity.y += gravity * delta


func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()
	animation()
	update_marker()


func animation() -> void:
	$Legs.flip_h = direction_x < 0 if velocity.x else $Legs.flip_h
	$AnimationPlayer.current_animation = "run" if velocity.x else "idle"
	if !is_on_floor():
		$AnimationPlayer.current_animation = "jump"
	var raw_dir = get_local_mouse_position().normalized()
	var adjusted_dir = Vector2i(round(raw_dir.x), round(raw_dir.y))
	$Torso.frame = GUN_DIRECTIONS[adjusted_dir]
	
	# Math solution to torso animation but not as accurate
	# var half_angle = get_local_mouse_position().angle() / PI * 180 + 22.5
	# var angle = half_angle if half_angle >= 0 else 360 + half_angle
	# $Torso.frame = int(angle / 45)


func update_marker() -> void:
	$Marker.position = get_local_mouse_position().normalized() * 40
