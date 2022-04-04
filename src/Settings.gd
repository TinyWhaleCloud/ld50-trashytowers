extends Node

# Constants
const CONFIG_FILENAME = "user://settings.json"

# General settings (persistent)
var sfx_enabled := true
var music_enabled := true

# Game mode (not persistent)
enum GameMode {
    MODE_SOLO = 0,
    MODE_MULTI_CHAOS = 1,
    MODE_MULTI_HOTSEAT = 2,
}
var game_mode: int = GameMode.MODE_SOLO


func _ready() -> void:
    # Load settings from filesystem
    load_settings()


func from_dict(data: Dictionary) -> void:
    sfx_enabled = data.get("sfx_enabled", true)
    music_enabled = data.get("music_enabled", true)


func to_dict() -> Dictionary:
    return {
        "sfx_enabled": sfx_enabled,
        "music_enabled": music_enabled,
    }


func load_settings() -> void:
    # Try to load the config file
    var config_file := File.new()
    if not config_file.file_exists(CONFIG_FILENAME):
        prints(self, "Config file does not exist yet.")
        return

    var err = config_file.open(CONFIG_FILENAME, File.READ)
    if err != OK:
        printerr("Error opening config file to read: ", err)
        return

    # Parse config file as JSON
    var config_json = config_file.get_as_text()
    from_dict(parse_json(config_json))


func save_settings() -> void:
    prints(self, "Saving settings to filesystem...")

    # Try to save the config file
    var config_file := File.new()

    var err = config_file.open(CONFIG_FILENAME, File.WRITE)
    if err != OK:
        printerr("Error opening config file to write: ", err)
        return

    # Dump config to JSON
    var config_json = to_json(to_dict())
    config_file.store_line(config_json)
