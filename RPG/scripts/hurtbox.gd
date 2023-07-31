extends Area2D

onready var timer=$Timer
onready var collisionshape=$CollisionShape2D
var knockback_vector=Vector2.ZERO
var invincible=false setget set_invencible

signal invincibility_Started
signal invincibility_Ended

func set_invencible(value):
	invincible=value
	if invincible==true:
		emit_signal("invincibility_Started")
	else:
		emit_signal("invincibility_Ended")
func start_invincibility(duration):
	self.invincible=true

	timer.start(duration)


func _on_Timer_timeout():
	self.invincible=false # Replace with function body.


func _on_Hurtbox_invincibility_Started():
	collisionshape.set_deferred("disable",true)
	

func _on_Hurtbox_invincibility_Ended():
	collisionshape.disabled=false
