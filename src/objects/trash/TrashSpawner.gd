class_name TrashSpawner
extends Node

# Packed scenes
var trash_kinds := [
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

var randomizer := RandomNumberGenerator.new()

func _ready() -> void:
    randomizer.randomize()

# Generates a new random trash instance
func generate_trash(position: Vector2) -> Trash:
    var new_trash = trash_kinds[randomizer.randi_range(0, trash_kinds.size() - 1)].instance()
    new_trash.position = position
    return new_trash
