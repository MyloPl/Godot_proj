extends KinematicBody2D

const SPEED := 120
const THROTTLE := 6
const MAX_SPEED := 5000

var velocity := Vector2()
var player_pos = Vector2()


func _physics_process(delta: float) -> void:
	inputs(delta)
	animations()
	
	player_pos = position
	
	
func inputs(delta) -> void:
	velocity.x = lerp(velocity.x, (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * SPEED, THROTTLE * delta)
	velocity.y = lerp(velocity.y, (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * SPEED, THROTTLE * delta)
	velocity.normalized()
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
func animations() -> void:
	if velocity.y < -20:
		$Character_animation.play("walk_up")
	elif velocity.y > 20:
		$Character_animation.play("walk_down")
	elif velocity.x > 20:
		$Character_animation.play("walk_side_right")
	elif velocity.x < -20:
		$Character_animation.play("walk_side_left")
	else:
		$Character_animation.play("idle")


func _on_FlashArea_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
