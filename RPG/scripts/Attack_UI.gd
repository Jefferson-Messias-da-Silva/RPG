extends Control

signal cooldown_ended(value)


	
enum{
	ATTACK,
	BLOCK,
	SPECIAL,
	LONGATTACK
}
var cooldown =ATTACK


func cooldown_atack():

	
	emit_signal("cooldown_ended",ATTACK)
	$AtackUi.frame=6

func cooldown_block():
	
	emit_signal("cooldown_ended",BLOCK)
	$BlockUi.frame=5







func _on_player_cooldown_skils(value):
	match value:
		ATTACK:
		
			$AtackUi/AnimationPlayer.play("cooldown")
		BLOCK:
			
			$BlockUi/AnimationPlayer.play("Block_cooldown")
		
