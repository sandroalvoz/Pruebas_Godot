extends Path2D

@export var target: CharacterBody2D
@onready var remoteTransform: RemoteTransform2D
@onready var pathFollow : PathFollow2D
var grinding: bool = false

func _ready():
	remoteTransform = $PathFollow2D/RemoteTransform2D
	pathFollow = $PathFollow2D
	pass
	
func _process(delta):
	if grinding and target.grindeo:
		pathFollow.progress += target.velocity.x * delta
	if grinding and ((pathFollow.progress_ratio==0 and target.velocity.x<0) or (pathFollow.progress_ratio==1 and target.velocity.x>0)):
		grinding =false

func _on_area_grindeable_body_entered(body):
	if body.grindeo:
		grinding = true
		remoteTransform.remote_path = body.get_path()

func _on_area_grindeable_body_exited(_body):
	grinding = false
	remoteTransform.remote_path = ""
