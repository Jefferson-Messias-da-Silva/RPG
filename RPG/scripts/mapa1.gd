extends Node2D

onready var skills_attack_UI=$CanvasLayer/Skills_UI/AtackUi
onready var skills_block_UI=$CanvasLayer/Skills_UI/BlockUi


# Called when the node enters the scene tree for the first time.
func _ready():
	skills_attack_UI.frame=6
	skills_block_UI.frame=5
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



