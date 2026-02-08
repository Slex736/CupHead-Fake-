extends Node

var completed_levels := {}  # Dictionary<String, bool>

func mark_level_completed(level_id: String) -> void:
	completed_levels[level_id] = true

func is_level_completed(level_id: String) -> bool:
	return completed_levels.get(level_id, false)
