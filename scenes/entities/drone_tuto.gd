extends CharacterBody2D

var direction : Vector2
var speed := 50
var player: CharacterBody2D
var health := 3

@export var explosion_radius := 30

func _on_detection_area_body_entered(player_body: CharacterBody2D) -> void:
	player = player_body


func _physics_process(_delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null


func _on_collision_area_body_entered(_body: Node2D) -> void:
	explosion()

func take_hit() -> void:
	health -= 1
	if health <= 0:
		explosion()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D.material, "shader_parameter/Progress", 0, 0.3)
	tween.tween_property($AnimatedSprite2D.material, "shader_parameter/Progress", 1, 0.5)

func explosion():
	speed = 0
	$AnimatedSprite2D.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()

func chain_reaction():
	for drone in get_tree().get_nodes_in_group("Drones"):
		if position.distance_to(drone.position) < explosion_radius:
			drone.explosion()
