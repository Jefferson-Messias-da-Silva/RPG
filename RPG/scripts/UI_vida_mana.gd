extends Control

onready var life=PlayerStats.health setget set_life
onready var max_life=PlayerStats.max_health setget set_max_life
onready var current_life=life
var percent =0
onready var labelvida= $Health
onready var life_UIFull=$Vida

func set_life(value):
	life =clamp(value,0,max_life)
	
	if labelvida!=null and life_UIFull!=null:
		if max_life>=1000 and life>=1000:
			labelvida.text= str(life/1000)+"k/"+str(max_life/1000)+"k"
		elif max_life>=1000:
			labelvida.text= str(life)+"/"+str(max_life/1000)+"k"
		
			
		else:
			labelvida.text= str(life)+"/"+str(max_life)
			
		if (current_life-life)>=max_life/100:
			percent= (current_life-life)/(max_life/100)
			current_life=current_life-(current_life-life)
			
			life_UIFull.rect_size.x = life_UIFull.rect_size.x-percent




func set_max_life(value):
	max_life=max(value,1)
	if life_UIFull!=null and labelvida!=null:
		
		life_UIFull.rect_size.x=100



func _ready():
	self.max_life=PlayerStats.max_health
	self.life=PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_life")
