extends KinematicBody2D

onready var player :KinematicBody2D= get_parent().get_node("Player")
onready var hit_area :Area2D= get_parent().get_node("Player/hit_area")
onready var light :Area2D= get_parent().get_node("Player/FlashLight/FlashArea")
onready var flash := get_parent().get_node("Player/FlashLight")

const THROTTLE := 7

var is_player_entered := false
var velocity := Vector2()
var player_attack := false
var is_flipped := false
var is_stopped := true
var is_on_flash := false
var flash_stat := true
var see_light := false

func _ready() -> void:
	$Player_cast.add_exception(self)
	$Player_cast.add_exception(light)
	$Player_cast.add_exception($player_hit_area)


	
func _physics_process(delta: float) -> void:
	movement(delta)
		
func _process(delta: float) -> void:
	raycast_rotation()
	animation_flip()
	animations()
	flash_stat = flash.is_on_flash
# rotacion raycast to rotate correctly
func raycast_rotation() -> void:
	
	if is_player_entered == true:
		$Player_cast.look_at(player.position)
		$Player_cast.rotation += 4.72

# moving if player found
func movement(delta: float) -> void:
	if is_on_flash and flash_stat == true and $Player_cast.get_collider() == hit_area:
		velocity = lerp(velocity, Vector2.ZERO, THROTTLE * delta)
	
	elif is_player_entered == true and $Player_cast.get_collider() == hit_area:
		velocity = lerp(velocity, position.direction_to(player.position) * 100, THROTTLE * delta)
	
	else:
		velocity = lerp(velocity, Vector2.ZERO, THROTTLE * delta)
	velocity.normalized()
	velocity = move_and_slide(velocity)
	
# chceck animation flipped
func animation_flip() -> void:
	
	if velocity.x > 20 and is_flipped and !is_stopped:
		is_flipped = false
		$AnimatedSprite.set_flip_h(false)
	elif velocity.x < -20 and !is_flipped and !is_stopped:
		is_flipped = true
		$AnimatedSprite.set_flip_h(true)
		
	# check if don't move
	if velocity.x > -20 and velocity.x < 20 and velocity.y > -20 and velocity.y < 20:
		is_stopped = true 
	else:
		is_stopped = false

# chceck what animation is playing
func animations() -> void:
	if player_attack == true and !is_flipped:
		$AnimatedSprite.play("attack")
	elif player_attack == true and is_flipped:
		$AnimatedSprite.play("attack")
	elif !is_flipped and !is_stopped:
		$AnimatedSprite.play("walk")
	elif is_flipped and !is_stopped:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")
	

func _Player_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_entered = true


func _Player_exited(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_entered = false
	

func _player_entered(area: Area2D) -> void:
	if area == hit_area:
		player_attack = true
	if area == light:
		is_on_flash = true
		

func _on_anim_finished() -> void:
	if $AnimatedSprite.animation == "attack":
		player_attack = false


func _flash_exited(area: Area2D) -> void:
	if area == light:
		is_on_flash = false

	if area == hit_area:
		see_light = true
