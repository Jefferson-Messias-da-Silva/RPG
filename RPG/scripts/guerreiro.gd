extends KinematicBody2D
export var acceleration=100
export var MAX_SPEED=100
var vel=Vector2.ZERO
var block_vector=Vector2.ZERO
var stats=PlayerStats
var cooldown_attack=0
var block_cooldown=0

onready var animationPlayer= $Anim
onready var animationTree=$AnimationTree
onready var animationState=animationTree.get("parameters/playback")
onready var hitbox=$hitboxlr
onready var hitboxd=$hitboxd
onready var hitboxup=$hitboxup
onready var escudo=$escudo
onready var colisaoescudo=$escudo/CollisionShape2D
onready var hurtbox=$hurtbox


signal cooldown_skils(value)

enum{
	MOVE,
	BLOCK,
	ATTACK
}
var state =MOVE



func _ready():
	randomize()
	stats.connect("no_health",self,"queue_free")
	pass



func _physics_process(delta):
	match state:
		
		MOVE:
			
			move_state(delta)
		ATTACK:
			attack_state(delta)
		BLOCK:
			block_state(delta)
	
func move_state(delta):
	var input_vector=Vector2.ZERO
	input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	input_vector.y=Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	input_vector=input_vector.normalized()
	if input_vector!=Vector2.ZERO:
		block_vector=input_vector
		hitbox.knockback_vector=input_vector
		hitboxup.knockback_vector=input_vector
		hitboxd.knockback_vector=input_vector
		escudo.knockback_vector=block_vector
		hurtbox.knockback_vector=input_vector
		animationTree.set("parameters/idle/blend_position", input_vector)
		animationTree.set("parameters/walk/blend_position", input_vector)
		animationTree.set("parameters/attack/blend_position", input_vector)
		animationTree.set("parameters/block/blend_position", input_vector)
		animationState.travel("walk")
		vel=input_vector*delta*MAX_SPEED
		
	else:
		animationState.travel("idle")
		vel=Vector2.ZERO
	move_and_slide(vel*acceleration)
	
	if Input.is_action_just_pressed("atack") and cooldown_attack==0:
		state=ATTACK
	if Input.is_action_just_pressed("block") and block_cooldown==0:
		colisaoescudo.disabled=false
		state=BLOCK
		
	
		
	
	
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func attack_state(delta):
	emit_signal("cooldown_skils",0)
	animationState.travel("attack")
	cooldown_attack=1
func attack_animation_finished():
	state=MOVE




func block_state(delta):
	
	animationState.travel("block")
	block_cooldown=1
	if Input.is_action_just_released("block"):
		emit_signal("cooldown_skils",1)
		colisaoescudo.disabled=true
		block_animation_finished()



func block_animation_finished():
	animationState.travel("idle")
	state=MOVE


func _on_hurtbox_area_entered(area):
	
	stats.health-=area.damage
	
	hurtbox.start_invincibility(0.5)
	





func _on_Skills_UI_cooldown_ended(value):
	match value:
		0:
			cooldown_attack=0
		1:
			block_cooldown=0
	
	pass # Replace with function body.
