extends KinematicBody2D


export var MAX_SPEED=50
export var FRICTION=200
export var ACCELERATION=500
export var knockbackstregth=200
var player=null
var velocity=Vector2.ZERO
var knockback=Vector2.ZERO

var state=CHASE
enum{
	IDLE,
	WANDER,
	CHASE,
	DIE
}
onready var hurtbox=$Hurtbox/CollisionShape2D
onready var sprite=$ElementCrystal1
onready var stats=$Stats
onready var detectTarget=$DetectTarget
onready var softCollision=$softCollision
onready var attackhitbox=$attackhitbox/CollisionShape2D
onready var wandercontroler=$wanderController

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	wandercontroler.start_wander_timer(rand_range(1,3))
	state = pick_random_state([IDLE,WANDER])
	$Timerattack.start(rand_range(0.5,1))
	pass

func _physics_process(delta):
	
	hit(delta)
	
	match state:
		IDLE:
			velocity= velocity.move_toward(Vector2.ZERO,FRICTION*delta)
			seek_player()
			
			if wandercontroler.get_time_left()==0:
				
				state = pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
			
		WANDER:
			seek_player()
			
			accelerate_move_toward(wandercontroler.target_position,delta)
			
			if wandercontroler.get_time_left()==0:
				state = pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
			if global_position.distance_to(wandercontroler.target_position)<=MAX_SPEED*delta:
				state=pick_random_state([IDLE,WANDER])
				wandercontroler.start_wander_timer(rand_range(1,3))
		CHASE:
			
			player =detectTarget.player
			
			if player !=null:
				accelerate_move_toward(player.global_position,delta)
				
			else:
				accelerate_move_toward(wandercontroler.start_position,delta)
				
				if global_position<=wandercontroler.start_position:
					state=pick_random_state([IDLE,WANDER])
					wandercontroler.start_wander_timer(rand_range(1,3))
			
		DIE:
			hurtbox.disabled=true
			velocity= velocity.move_toward(Vector2.ZERO,FRICTION*delta)
		
	sprite.flip_h=velocity.x<0
	if softCollision.is_colliding():
		velocity+=softCollision.get_push_vector()*delta*400
	velocity=move_and_slide(velocity)
func seek_player():
	if detectTarget.can_see_player():
		state=CHASE

func accelerate_move_toward(point,delta):
	var direction = global_position.direction_to(point)
	velocity=velocity.move_toward(direction*MAX_SPEED,ACCELERATION*delta)


func hit(delta):
	
	knockback= knockback.move_toward(Vector2.ZERO,FRICTION*delta)
	knockback=move_and_slide(knockback)
	



func pick_random_state(state_list):
	
	state_list.shuffle()
	return state_list.pop_front()


func _on_Timer_timeout():

	if state==DIE:
		queue_free()
	 # Replace with function body.


func _on_Stats_no_health():
	
	$AnimationPlayer.play("morto")
	
	state=DIE
	


func _on_attackhitbox_area_entered(area):
	var distance =Vector2.ZERO
	
	
	if player !=null:
		distance =(player.global_position-global_position).normalized()
	
	if distance.y>0 and area.knockback_vector.y>0 or distance.y<0 and area.knockback_vector.y<0 or distance.x>0 and area.knockback_vector.x>0 or distance.x<0 and area.knockback_vector.x<0:
		area.knockback_vector*=-1
	knockback=(area.knockback_vector*(knockbackstregth*0.6))
	


func _on_Hurtbox_area_entered(area):
	var distance =Vector2.ZERO
	
	if player !=null:
		distance =(player.global_position-global_position).normalized()
	
	if distance.y>0 and area.knockback_vector.y>0 or distance.y<0 and area.knockback_vector.y<0 or distance.x>0 and area.knockback_vector.x>0 or distance.x<0 and area.knockback_vector.x<0:
		area.knockback_vector*=-1
	if area.knockback_vector:
		stats.health-= area.damage
		knockback=area.knockback_vector*knockbackstregth


func _on_Timerattack_timeout():
	if attackhitbox.disabled:
		attackhitbox.disabled=false
	else:
		attackhitbox.disabled=true
	pass # Replace with function body.
