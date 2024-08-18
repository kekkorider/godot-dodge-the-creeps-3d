extends Node

@export var mob_scene: PackedScene

func _ready() -> void:
  $UserInterface/Retry.hide()

func _on_mob_timer_timeout() -> void:
  var mob = mob_scene.instantiate()

  var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
  mob_spawn_location.progress_ratio = randf()

  mob.initialize(mob_spawn_location.position, $Player.position)

  mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

  add_child(mob)


func _on_player_hit() -> void:
  $UserInterface/Retry.show()
  $MobTimer.stop()

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("ui_accept") && $UserInterface/Retry.visible:
    get_tree().reload_current_scene()
