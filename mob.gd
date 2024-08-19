extends CharacterBody3D

@export var min_speed: int = 10
@export var max_speed: int = 20

signal squashed

func _physics_process(_delta) -> void:
  move_and_slide()

func initialize(start_position: Vector3, player_position: Vector3) -> void:
  # Place the mob at `start_position` and rotate it
  # towards `player_position`
  look_at_from_position(start_position, player_position, Vector3.UP)

  # Randomly rotate the mob so that it doesn't
  # look directly at the player
  rotate_y(randf_range(-PI / 4, PI / 4))

  # Calculate a random range
  var random_speed: int = randi_range(min_speed, max_speed)

  # Calculate a forward velocity thet represents the speed
  velocity = Vector3.FORWARD * random_speed

  # We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
  velocity = velocity.rotated(Vector3.UP, rotation.y)

  @warning_ignore('integer_division')
  $AnimationPlayer.speed_scale = random_speed / min_speed


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
  queue_free()

func squash() -> void:
  squashed.emit()
  queue_free()
