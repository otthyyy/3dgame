extends Node

var sprint_time: float = 0.0
var distance_traveled: float = 0.0
var jumps: int = 0
var session_start: float = 0.0

func _ready() -> void:
    session_start = Time.get_unix_time_from_system()
    GameState.quit_requested.connect(_on_quit_requested)

func register_sprint_time(delta: float) -> void:
    sprint_time += delta

func register_distance(distance: float) -> void:
    distance_traveled += distance

func register_jump() -> void:
    jumps += 1

func flush_to_file() -> void:
    var dir := DirAccess.open("user://")
    if dir and not dir.dir_exists("telemetry"):
        dir.make_dir("telemetry")
    
    var timestamp := Time.get_datetime_string_from_system(true, true)
    var safe_timestamp := timestamp.replace(":", "-").replace("T", "_")
    var path := "user://telemetry/telemetry_%s.json" % safe_timestamp
    var file := FileAccess.open(path, FileAccess.WRITE)
    if file:
        var payload := {
            "sprint_time": sprint_time,
            "distance_traveled": distance_traveled,
            "jumps": jumps,
            "session_duration": Time.get_unix_time_from_system() - session_start,
            "timestamp": timestamp
        }
        file.store_string(JSON.stringify(payload, "\t"))
        file.close()
        print("Telemetry saved to: ", path)
    else:
        push_error("Failed to save telemetry to: " + path)

func _on_quit_requested() -> void:
    flush_to_file()
