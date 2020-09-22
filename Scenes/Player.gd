extends KinematicBody2D
signal hit


export var speed = 300  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func start(pos):
	position = pos
	show()
	$Area2D/CollisionShape2D.disabled = false
	
	
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed # normalisiert diagonal laufen damit man nicht diagonal schneller läuft als geradeaus
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	position += velocity * delta
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y == 0 && velocity.x == 0:
		$AnimatedSprite.animation = "idle"
		
	
	
	




func _on_Area2D_body_entered(body):
	emit_signal("hit")
	print("hit")
	$Area2D/CollisionShape2D.set_deferred("disabled", true) # wenn man getroffen wird ist man kurz unverwundbar -> kollision aus
	$InvincibilityFrames.start()
	
	
	
func _on_InvincibilityFrames_timeout(): # kollision wieder an nach timer -> einfach wait time ändern
	$Area2D/CollisionShape2D.set_deferred("disabled", false)

