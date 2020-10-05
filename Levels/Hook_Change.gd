extends Area2D

func _ready():
	pass


func _on_HookChange_body_entered(body):
	Events.emit_signal("ChangeHook")
