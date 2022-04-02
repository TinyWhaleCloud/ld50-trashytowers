extends Node2D

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
    # TODO: These are only debug shortcuts.
    if event.is_action_pressed("debug_spawn_player"):
        spawn_player_trash()

# Spawn new trash controlled by the player
func spawn_player_trash():
    # Don't spawn new object if player is still controlling one
    if $Player.is_controlling_trash():
        print("[MainGame] Player is already controlling an object.")
        return

    # Ensure that spawning is safe (i.e. the spawn area is clear)
    if not $Player.is_spawn_area_clear():
        print("[MainGame] Spawn area of player is not clear! Delaying spawn...")
        # TODO: retry
        return

    # Create new trash object
    var new_trash = trash_kinds[randomizer.randi_range(0, trash_kinds.size() -1)].instance()
    new_trash.position = $Player/SpawnPosition.global_position

    # Let the player control the trash
    $Player.take_trash(new_trash)

    # Add trash to the scene
    add_child(new_trash)

# Drop the trash the player is controlling
func drop_player_trash():
    $Player.drop_trash()

# Called when the player (voluntarily) dropped a trash object
func _on_Player_trash_dropped():
    # TODO: Check WHERE the trash was dropped
    print("[MainGame] Player dropped the trash!")

    # TODO: Spawn new trash
    #spawn_player_trash()

# Called when the player controlled trash landed (i.e. collided with the world)
func _on_Player_trash_landed():
    # TODO: Check WHERE the trash landed
    print("[MainGame] Trash has landed!")

    # TODO: Spawn new trash
    spawn_player_trash()

# Called when a body entered the area above the floor
func _on_FloorArea_body_entered(body):
    if body is Trash:
        # TODO: Implement game over
        print("[MainGame] Trash landed on the floor! GAME OVER.")
