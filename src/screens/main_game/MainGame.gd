extends Node2D

# Packed scenes
var trash_scene = preload("res://objects/trash/Trash.tscn")

func _input(event):
    # TODO: Only for testing. Spawning trash should be automatic
    if event.is_action_pressed("ui_accept"):
        spawn_player_trash()

# Spawn new trash controlled by the player
func spawn_player_trash():
    # Create new trash object
    var new_trash = trash_scene.instance()
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
