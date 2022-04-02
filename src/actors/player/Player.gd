class_name Player
extends Node2D

# Emitted when the player dropped a trash object
signal trash_dropped

# Constants
const TRASH_SPEED = 80

# State variables
var current_trash: Trash = null


func _process(delta):
    if current_trash:
        if Input.is_action_just_pressed("ui_up"):
            drop_trash()
        else:
            process_movement_input()

func process_movement_input():
    # Process player movement
    var trash_direction = Vector2(0, 1)
    if Input.is_action_pressed("ui_left"):
        trash_direction.x -= 1
    if Input.is_action_pressed("ui_right"):
        trash_direction.x += 1
    if Input.is_action_pressed("ui_down"):
        # Accelerate downwards motion
        trash_direction.y += 1
    
    # Set movement vector (exact movement is processed by the trash object)
    current_trash.move_by_player(trash_direction * TRASH_SPEED)


# Start controlling a piece of trash
func take_trash(trash):
    # If the player is still controlling an object, drop it
    if current_trash:
        drop_trash()
        
    print("[Player] Take trash")
    
    # Take control of the trash
    trash.start_control()
    trash.connect("dropped", self, "_on_Trash_dropped")
    current_trash = trash
    
# Drop the trash the player is controlling
func drop_trash():
    if not current_trash:
        return
    
    print("[Player] Drop trash")
    
    # Change physics mode and remove object from player control
    current_trash.stop_control()
    current_trash = null
    
    # Emit a signal to the main game for score keeping and spawning new trash
    emit_signal("trash_dropped")


# Called when the player controlled trash was dropped because it collided with something
func _on_Trash_dropped():
    # Control was already stopped by the trash itself
    print("[Player] Trash was dropped!")
    current_trash = null
    
    # Emit a signal to the main game for score keeping and spawning new trash
    emit_signal("trash_dropped")
