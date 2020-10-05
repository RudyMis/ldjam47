extends Area2D

var used = false

func _ready():
	pass


func _on_HookChange_body_entered(body):
	if !used:
		Events.emit_signal("ChangeHook")
		used = true
