extends Node2D

# Emitted to start the next turn
signal next_turn

# Packed scenes
var basketball_scene = preload("res://objects/trash/kinds/basketball/Basketball.tscn")
var bodyspray_scene = preload("res://objects/trash/kinds/bodyspray/Bodyspray.tscn")
var crowbar_scene = preload("res://objects/trash/kinds/crowbar/Crowbar.tscn")
var energydrink_scene = preload("res://objects/trash/kinds/energydrink/Energydrink.tscn")
var ugly_mokey_picture_scene = preload("res://objects/trash/kinds/ugly_monkey_picture/UglyMonkeyPicture.tscn")
var minidisk_scene = preload("res://objects/trash/kinds/minidisk/Minidisk.tscn")
var nondescriptpackaging_scene = preload("res://objects/trash/kinds/nondescriptpackaging/Nondescriptpackaging.tscn")
var phone_scene = preload("res://objects/trash/kinds/phone/Phone.tscn")
var shampoo_scene = preload("res://objects/trash/kinds/shampoobottle/ShampooBottle.tscn")
var water_scene = preload("res://objects/trash/kinds/waterbottle/WaterBottle.tscn")
onready var settings = get_node("/root/Settings")

var randomizer = RandomNumberGenerator.new()

var trash_kinds = [
    preload("res://objects/trash/kinds/basketball/Basketball.tscn"),
    preload("res://objects/trash/kinds/bodyspray/Bodyspray.tscn"),
    preload("res://objects/trash/kinds/crowbar/Crowbar.tscn"),
    preload("res://objects/trash/kinds/energydrink/Energydrink.tscn"),
    preload("res://objects/trash/kinds/ugly_monkey_picture/UglyMonkeyPicture.tscn"),
    preload("res://objects/trash/kinds/minidisk/Minidisk.tscn"),
    preload("res://objects/trash/kinds/nondescriptpackaging/Nondescriptpackaging.tscn"),
    preload("res://objects/trash/kinds/phone/Phone.tscn"),
    preload("res://objects/trash/kinds/shampoobottle/ShampooBottle.tscn"),
    preload("res://objects/trash/kinds/waterbottle/WaterBottle.tscn"),
]

func _ready():
    randomizer.randomize()
    spawn_player_trash()

func _input(event):
    # Exit the game with Escape
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

    # TODO: These are only debug shortcuts.
    if event.is_action_pressed("debug_spawn_player"):
        spawn_player_trash()

# Generates a new random trash instance
func generate_trash() -> Trash:
    return trash_kinds[randomizer.randi_range(0, trash_kinds.size() -1)].instance()

# Spawn new trash controlled by the player
func spawn_player_trash():
    # Don't spawn new objects if the player has already lost the game
    if $Player.game_over:
        prints(self, "Cannot spawn: Player has already lost!")
        return

    # Don't spawn new object if player is still controlling one
    if $Player.is_controlling_trash():
        prints(self, "Player is already controlling an object.")
        return

    # Ensure that spawning is safe (i.e. the spawn area is clear)
    if not $Player.is_spawn_area_clear():
        # Retry spawning after a second using a timer
        prints(self, "Spawn area of player is not clear! Delaying spawn...")
        $Player/SpawnRetryTimer.start(1)
        return

    # Create new trash object
    var new_trash := generate_trash()
    new_trash.position = $Player/SpawnPosition.global_position
    new_trash.connect("touched_anything", self, "_on_Trash_touched_anything")
    new_trash.connect("touched_trash_bin", self, "_on_Trash_touched_trash_bin")
    new_trash.connect("touched_floor", self, "_on_Trash_touched_floor")

    # Let the player control the trash
    $Player.take_trash(new_trash)

    # Add trash to the scene
    add_child(new_trash)

# Stop player from controlling objects and show game over screen
func player_game_over():
    if $Player.game_over:
        return

    # Stop control, drop any trash
    $Player.game_over = true
    $Player.drop_trash()
    $HUD.show_game_over()
    if settings.sfx_enabled:
        $GameOverPlayer.play()

# Called when a trash object touches anything for the first time
func _on_Trash_touched_anything(trash: Trash):
    prints(self, "Trash touched something!")

    # If the trash is controlled by the player, the player should lose control now
    if $Player.current_trash == trash:
        $Player.drop_trash()

    # Next turn!
    emit_signal("next_turn")

# Called when a trash object touches the trash bin
func _on_Trash_touched_trash_bin(trash: Trash):
    prints(self, "Trash landed in the trash bin!")

    # Add a point to the player's score
    if not $Player.game_over:
        $Player.add_score(1)

# Called when a trash object touches the floor (or anything on the floor)
func _on_Trash_touched_floor(trash: Trash):
    prints(self, "Trash landed on the floor!")

    # Player lost the game
    player_game_over()

# Called when the player's spawn retry timer expired
func _on_Player_retry_spawn():
    prints(self, "Retry spawning...")
    spawn_player_trash()

# Called when the player's score has changed
func _on_Player_score_changed(new_score):
    $HUD.set_player_score(new_score)

# Called when the turn ended (trash landed) and the next turn should begin
func _on_MainGame_next_turn():
    if not $Player.game_over:
        spawn_player_trash()
