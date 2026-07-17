extends Area2D

@export var position_offset := 16

var direction : Vector2 = Vector2.ZERO
@export var speed := 200


func setup(pos : Vector2, dir : Vector2):
	position = pos + dir * position_offset
	direction = dir

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)


func _process(delta: float) -> void:
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "take_hit" in body:
		body.take_hit()
	queue_free()
