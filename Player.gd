extends Area2D
signal hit


export var speed = 300  # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	
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
	position.x = clamp(position.x, 0, screen_size.x) # offset muss noch rein (clamp verhindert dass man den screen verlassen kann) 
	position.y = clamp(position.y, 0, screen_size.y) # offset muss noch rein 
	
	
	


func _on_Player_body_entered(body):
	emit_signal("hit")
	print("hit")
	$CollisionShape2D.set_deferred("disabled", true) # wenn man getroffen wird ist man kurz unverwundbar -> kollision aus
	$InvincibilityFrames.start()
	


func _on_InvincibilityFrames_timeout(): # kollision wieder an nach timer -> einfach wait time ändern
	$CollisionShape2D.set_deferred("disabled", false)
