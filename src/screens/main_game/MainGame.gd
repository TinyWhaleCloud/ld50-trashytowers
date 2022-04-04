extends Node2D

# Emitted when the current turn ends
signal end_turn(player_number)
# Emitted to start the next turn
signal next_turn(player_number)

# Constants
const SCREEN_WIDTH = 1280
const PLAYER_DISTANCE = 200

# Packed scenes
const PlayerScene = preload("res://actors/player/Player.tscn")

# Node references
onready var hud := $HUD as HUD
onready var trash_spawner := $TrashSpawner as TrashSpawner
onready var floating_text_spawner := $FloatingTextSpawner as FloatingTextSpawner

# Game mode settings
var game_mode: int = Settings.GameMode.MODE_SOLO
var total_player_count := 1

# Game state / players
var players := []
var current_player := 1
var last_drop_by_player := 0
var game_over := false


func _ready() -> void:
    # Start music :)
    if Settings.music_enabled:
        $MusicPlayer.play()

    ($Floor as Floor).trash_bin = $TrashBin as TrashBin

    # Setup game and HUD
    setup_game()
    hud.init_hud(total_player_count)

    # Start the game!
    start_game()


func _input(event: InputEvent) -> void:
    # Return to the title screen with Escape
    if event.is_action_pressed("ui_cancel"):
        get_tree().change_scene_to(load("res://screens/title_screen/TitleScreen.tscn"))


# Setup the game (set game mode, create players etc.)
func setup_game() -> void:
    game_mode = Settings.game_mode

    match game_mode:
        Settings.GameMode.MODE_SOLO:
            prints(self, "Game mode: Singleplayer")
            total_player_count = 1

        Settings.GameMode.MODE_MULTI_CHAOS:
            prints(self, "Game mode: Multiplayer Chaos")
            total_player_count = 2

        Settings.GameMode.MODE_MULTI_HOTSEAT:
            prints(self, "Game mode: Multiplayer Hotseat")
            total_player_count = 2

    # Create players
    players = []
    for i in range(total_player_count):
        # Array indices start with 0, player numbers start with 1
        players.insert(i, create_player(i + 1))

    # Set first player
    current_player = 1


# True if singleplayer mode
func is_singleplayer_mode() -> bool:
    return game_mode == Settings.GameMode.MODE_SOLO

# True if multiplayer chaos mode
func is_multiplayer_chaos_mode() -> bool:
    return game_mode == Settings.GameMode.MODE_MULTI_CHAOS

# True if multiplayer hotseat mode
func is_multiplayer_hotseat_mode() -> bool:
    return game_mode == Settings.GameMode.MODE_MULTI_HOTSEAT


# Start the game
func start_game() -> void:
    # Start the first turn
    if is_multiplayer_chaos_mode():
        # Chaos mode: All players are playing at once. In other words: It's everyone's turn!
        for i in range(1, total_player_count + 1):
            emit_signal("next_turn", i)
    else:
        # Singleplayer and multiplayer hot seat mode: Players take turns, one player at a time (even if it's just one)
        emit_signal("next_turn", current_player)


# Create a new player
func create_player(player_number: int) -> Player:
    # Determine player position
    var player_position_x = (SCREEN_WIDTH + (2 * player_number - total_player_count - 1) * PLAYER_DISTANCE) / 2.0

    # Create player instance
    var new_player := PlayerScene.instance() as Player
    new_player.player_number = player_number
    new_player.position = Vector2(player_position_x, 0)

    # Connect signals
    new_player.connect("trash_dropped", self, "_on_Player_trash_dropped", [player_number])
    new_player.connect("score_changed", self, "_on_Player_score_changed", [player_number])
    new_player.connect("retry_spawn", self, "_on_Player_retry_spawn", [player_number])

    # Add player to the scene
    add_child(new_player)
    return new_player


# Get a player by number (starting with 1)
func get_player(player_number: int) -> Player:
    return players[player_number - 1] as Player


# Spawn new trash controlled by the player
func spawn_player_trash(player_number: int) -> void:
    var player := get_player(player_number)

    # Don't spawn new objects if the player has already lost the game
    if game_over:
        prints(self, "spawn_player_trash: Player %d has already lost!" % [player_number])
        return

    # Don't spawn new object if player is still controlling one
    if player.is_controlling_trash():
        prints(self, "spawn_player_trash: Player %d is already controlling an object." % [player_number])
        return

    # Ensure that spawning is safe (i.e. the spawn area is clear)
    if not player.is_spawn_area_clear():
        # Retry spawning after a second using a timer
        prints(self, "spawn_player_trash: Spawn area of player %d is not clear! Delaying spawn..." % [player_number])
        player.start_spawn_retry_timer()
        return

    prints(self, "spawn_player_trash: Spawning new trash for player %d" % [player_number])

    # Create new trash object
    var new_trash := trash_spawner.generate_trash(player.position)
    new_trash.player_owner = player_number
    new_trash.connect("touched_anything", self, "_on_Trash_touched_anything")
    new_trash.connect("touched_trash_bin", self, "_on_Trash_touched_trash_bin")
    new_trash.connect("touched_floor", self, "_on_Trash_touched_floor")

    # Add trash to the scene
    add_child(new_trash)

    # Let the player control the trash
    player.take_trash(new_trash)


# Stop player from controlling objects and show game over screen
func player_game_over(player_number: int) -> void:
    var player := get_player(player_number)
    if player.game_over:
        return

    prints(self, "Player %d: Game over!" % [player_number])

    # Stop control, drop any trash
    $MusicPlayer.stop()
    player.game_over = true
    player.drop_trash()

    if not game_over:
        # Show game over screen
        hud.show_game_over(is_singleplayer_mode(), player_number)
        if Settings.sfx_enabled:
            $GameOverPlayer.play()
    game_over = true


# Called when a trash object touches anything for the first time
func _on_Trash_touched_anything(trash: Trash) -> void:
    prints(self, "Trash touched something!")

    # Get player who "owns" the trash
    var player := get_player(trash.player_owner)

    # If the trash is still controlled by the player, the player should lose control now
    if player.current_trash == trash:
        player.drop_trash()

    # End the current player's turn
    emit_signal("end_turn", player.player_number)


# Called when a trash object touches the trash bin
func _on_Trash_touched_trash_bin(trash: Trash) -> void:
    prints(self, "Trash landed in the trash bin!")

    # Get player who "owns" the trash
    var player := get_player(trash.player_owner)

    # Add a point to the player's score
    if not game_over:
        if trash.score_value == 0:
            floating_text_spawner.spawn_text("worthless", trash.position, Color(0.5, 0.5, 0.5))
        else:
            floating_text_spawner.spawn_text(str(trash.score_value), trash.position)

        player.add_score(trash.score_value)


# Called when a trash object touches the floor (or anything on the floor)
func _on_Trash_touched_floor(_trash: Trash) -> void:
    prints(self, "Trash landed on the floor!")

    # Player who dropped the last trash has lost the game
    if last_drop_by_player > 0:
        player_game_over(last_drop_by_player)


# Called when the player dropped trash (voluntarily or by touching something)
func _on_Player_trash_dropped(player_number: int) -> void:
    # Remember who dropped the last trash
    prints(self, "Player %d dropped the trash" % [player_number])
    last_drop_by_player = player_number


# Called when the player's spawn retry timer expired
func _on_Player_retry_spawn(player_number: int) -> void:
    # Only if it's the player's turn
    if is_multiplayer_chaos_mode() or current_player == player_number:
        prints(self, "Retry spawning for player %d" % [player_number])
        spawn_player_trash(player_number)


# Called when the player's score has changed
func _on_Player_score_changed(new_score: int, player_number: int) -> void:
    prints(self, "Player %d has new score: %d" % [player_number, new_score])
    hud.set_player_score(new_score, player_number)


# Called when the current turn ended (trash landed)
func _on_MainGame_end_turn(player_number: int) -> void:
    var next_player

    if is_multiplayer_chaos_mode():
        # In multiplayer chaos mode: All players have turns simultaneously. Just start the next turn.
        next_player = player_number
    else:
        # In singleplayer and multiplayer hotseat mode: Switch to next player (if there is one)
        next_player = player_number + 1 if player_number < total_player_count else 1

    if not game_over:
        emit_signal("next_turn", next_player)


# Called to start the next turn for a player
func _on_MainGame_next_turn(player_number: int) -> void:
    # Spawn the trash
    if not get_player(player_number).game_over:
        spawn_player_trash(player_number)
