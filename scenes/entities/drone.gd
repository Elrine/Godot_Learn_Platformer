extends CharacterBody2D

var dir : Vector2 = Vector2.ZERO
@export var speed := 25
@export var hp := 3

var player : CharacterBody2D = null


func _physics_process(_delta: float) -> void:
	if player and !$ExplosionArea2D.overlaps_body(player):
		velocity = position.direction_to(player.position) * speed
	else:
		velocity /= 2
	move_and_slide()


func take_hit():
	print("took a hit")
	hp -= 1
	if hp == 0:
		$AnimationPlayer.play("explosion")


func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	player = body as CharacterBody2D


func _on_detection_area_2d_body_exited(_body: Node2D) -> void:
	player = null


func _on_explosion_area_2d_body_entered(_body: Node2D) -> void:
	$AnimationPlayer.play("explosion")
