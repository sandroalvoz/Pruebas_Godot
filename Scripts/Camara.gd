extends RemoteTransform2D

const DeadZone = 300

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("moverCamara"):
			var target = event.position - get_viewport().size *0.5
			if target.length() > DeadZone:
				self.position = target.normalized() * (target.length() - DeadZone) * 2
				return
		else:
			self.position = Vector2.ZERO
