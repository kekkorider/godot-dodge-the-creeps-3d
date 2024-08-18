extends CharacterBody3D

# How fast the player moves in meters per second
@export var speed: float = 14
# Downward acceleration when in the air, in meters per second squared
@export var fall_acceleration: float = 75
# Vertical impulse when jumping, in meters per second
@export var jump_impulse: float = 20
# Vertical impulse when bouncing over an enemy, in meters per second
@export var bounce_impulse: float = 16

signal hit

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

  # Jumping
  if is_on_floor() and Input.is_action_just_pressed("jump"):
    target_velocity.y = jump_impulse

  # Iterate through all collisions
  for index in range(get_slide_collision_count()):
    # Get a single collision
    var collision = get_slide_collision(index)

    # Do nothing if it's colliding with the ground
    if collision.get_collider() == null:
      continue

    # If colliding with a mob
    if collision.get_collider().is_in_group("mobs"):
      var mob = collision.get_collider()

      # If hitting from above
      if Vector3.UP.dot(collision.get_normal()) > 0.1:
        mob.squash()

      # Bounce
      target_velocity.y = jump_impulse

      # Prevent duplicate calls
      break

  move_and_slide()

func die() -> void:
  hit.emit()
  queue_free()

func _on_mob_detector_body_entered(_body: Node3D) -> void:
  die()
