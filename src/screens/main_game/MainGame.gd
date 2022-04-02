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

func _input(event):
    # TODO: Only for testing. Spawning trash should be automatic
    if event.is_action_pressed("ui_accept"):
        spawn_player_trash()

# Spawn new trash controlled by the player
func spawn_player_trash():
    # Create new trash object
    var new_trash = trash_kinds[randomizer.randi_range(0, trash_kinds.size() -1)].instance()
    new_trash.position = $SpawnPosition.position
    
    # Let the player control the trash
    $Player.take_trash(new_trash)
    
    # Add trash to the scene
    add_child(new_trash)

# Drop the trash the player is controlling
func drop_player_trash():
    $Player.drop_trash()

# Called when the player dropped a trash object
func _on_Player_trash_dropped():
    # TODO: Check WHERE the trash was dropped
    print("[MainGame] Player dropped the trash!")
    
    # TODO: Spawn new trash
    #spawn_player_trash()
