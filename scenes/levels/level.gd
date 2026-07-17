extends Node2D

var bullet : PackedScene = preload("res://scenes/entities/bullet.tscn")

func _ready() -> void:
	var light_tween = create_tween()
	light_tween.set_loops()
	light_tween.tween_property($PointLight2D as PointLight2D, "energy", 1.5, 0.3)
	light_tween.tween_property($PointLight2D as PointLight2D, "energy", 0.5, 0.3)

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet_inst = bullet.instantiate() as Area2D
	bullet_inst.setup(pos, dir)
	$Entities.add_child(bullet_inst)
	
