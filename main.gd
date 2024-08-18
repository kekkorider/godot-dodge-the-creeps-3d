extends Node

@export var mob_scene: PackedScene

func _on_mob_timer_timeout() -> void:
  var mob = mob_scene.instantiate()

  var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
  mob_spawn_location.progress_ratio = randf()

  mob.initialize(mob_spawn_location.position, $Player.position)

  add_child(mob)


func _on_player_hit() -> void:
  $MobTimer.stop()
