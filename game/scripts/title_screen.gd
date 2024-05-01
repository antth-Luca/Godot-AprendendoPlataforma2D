extends Control

@onready var start_btn = $MarginContainer/HBoxContainer/VBoxContainer/start_btn

# Called when the node enters the scene tree for the first time.
func _ready():
	start_btn.grab_focus()
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://levels/world_01.tscn")


func _on_credits_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
