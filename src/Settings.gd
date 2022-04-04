extends Node

# General settings
var sfx_enabled := true
var music_enabled := true

# Game mode
enum GameMode {
    MODE_SOLO = 0,
    MODE_MULTI_CHAOS = 1,
    MODE_MULTI_HOTSEAT = 2,
}
var game_mode: int = GameMode.MODE_SOLO
