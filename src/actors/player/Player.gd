class_name Player
extends Node2D

# Emitted when the player dropped a trash object (i.e. let go of it)
signal trash_dropped
# Emitted when the player controlled trash collided with something and the player lost control
signal trash_landed
# Emitted when the spawn retry timer expired
signal retry_spawn

# Constants
const TRASH_SPEED_PLAYER = 200
const TRASH_SPEED_DOWN = 100
const TRASH_SPEED_DROP = 400
const TRASH_ROT_SPEED = 5

# State variables
var current_trash: Trash = null


func _process(delta):
    if current_trash:
        if Input.is_action_just_pressed("player1_drop"):
            drop_trash()
        else:
            process_movement_input()

func process_movement_input():
    # Process player movement
    var trash_direction = Vector2(0, 0)
    var trash_rotation = 0

    if Input.is_action_pressed("player1_left"):
        trash_direction.x -= 1
    if Input.is_action_pressed("player1_right"):
        trash_direction.x += 1

    # Accelerate downwards motion
    if Input.is_action_pressed("player1_down"):
        trash_direction.y += 1

    # Rotation
    if Input.is_action_pressed("player1_turn_cw"):
        trash_rotation += 1
    if Input.is_action_pressed("player1_turn_ccw"):
        trash_rotation -= 1

    var trash_velocity = trash_direction * TRASH_SPEED_PLAYER + Vector2(0, 1) * TRASH_SPEED_DOWN

    # Set movement vector (exact movement is processed by the trash object)
    current_trash.move_by_player(trash_velocity, trash_rotation * TRASH_ROT_SPEED)


# Start controlling a piece of trash
func take_trash(trash):
    # If the player is still controlling an object, drop it
    if current_trash:
        drop_trash()

    print("[Player] Take trash")

    # Take control of the trash
    current_trash = trash
    current_trash.start_control()
    current_trash.connect("touched_world", self, "_on_Trash_touched_world", [trash])

# Drop the trash the player is controlling (voluntary drop)
func drop_trash():
    if not current_trash:
        return

    print("[Player] Drop trash")

    # Remove object from player control and speed up the fall a bit
    current_trash.stop_control()
    current_trash.apply_impulse(Vector2(), Vector2(0, TRASH_SPEED_DROP))
    current_trash = null

    # Emit a signal to the main game
    emit_signal("trash_dropped")

# Return true if the player controls a trash object right now
func is_controlling_trash():
    return current_trash != null

# Returns true unless there are objects inside the spawn area (making it unsafe to spawn new objects)
func is_spawn_area_clear():
    var overlapping_bodies = $SpawnArea.get_overlapping_bodies()
    return len(overlapping_bodies) == 0

# Called when the player controlled trash was dropped because it collided with something
func _on_Trash_touched_world(trash):
    # Control was already stopped by the trash itself
    print("[Player] Trash landed!")

    # Stop controlling the trash
    if current_trash == trash:
        current_trash = null

    # Emit a signal to the main game for score keeping and spawning new trash
    emit_signal("trash_landed")

# Called when the retry timer expires
func _on_SpawnRetryTimer_timeout():
    # Ignore timer when already controlling an object
    if not current_trash:
        emit_signal("retry_spawn")
