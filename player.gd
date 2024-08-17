extends CharacterBody3D

# How fast the player moves in meters per second
@export var speed: float = 14
# Downward acceleration when in the air, in meters per second squared
@export var fall_acceleration: float = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
  var direction = Vector3.ZERO

  if Input.is_action_pressed("move_right"):
    direction.x += 1
  if Input.is_action_pressed("move_left"):
    direction.x -= 1
  if Input.is_action_pressed("move_forward"):
    direction.z -= 1
  if Input.is_action_pressed("move_back"):
    direction.z += 1

  if direction != Vector3.ZERO:
    direction = direction.normalized()
    # Setting the basis property will affect the rotation on the node
    $Pivot.basis = Basis.looking_at(direction)

  # Ground velocity
  target_velocity.x = direction.x * speed
  target_velocity.z = direction.z * speed

  # Vertical velocity
  if not is_on_floor():
    target_velocity.y = target_velocity.y - fall_acceleration * delta

  # Moving the character
  velocity = target_velocity
  move_and_slide()
