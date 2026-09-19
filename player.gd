extends CharacterBody2D

const SPEED := 250.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * SPEED * delta


func _on_touch_zone_body_entered(body: Node2D) -> void:
	print("Something entered the area: ", body.name)
