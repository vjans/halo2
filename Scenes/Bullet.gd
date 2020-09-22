extends Area2D



var velocity = Vector2(1, 0)
var speed = 200
var bulletposition 


var look_once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

func _physics_process(delta):
	if look_once:
		look_at(get_global_mouse_position())
		look_once = false
	position += velocity.rotated(rotation) * speed * delta
	



func _on_Bullet_body_entered(body):
	if body.is_in_group("Mob"):
		body.queue_free()
	queue_free()
